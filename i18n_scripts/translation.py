#!/usr/bin/env python3
"""
This script performs two jobs:
 1- Combine the English translations from all modules in the repository to the I18N directory. After the English
    translation is combined, it will be pushed to the openedx-translations repository as described in OEP-58.
2- Split the pulled translation files from the openedx-translations repository into the iOS app modules.

More detailed specifications are described in the docs/0002-atlas-translations-management.rst design doc.
"""

import argparse
import os
import re
import sys
from collections import defaultdict
from contextlib import contextmanager
from pathlib import Path

import localizable
from pbxproj import XcodeProject
from pbxproj.pbxextensions import FileOptions

LOCALIZABLE_FILES_TREE = '<group>'


def parse_arguments():
    """
    This function is the argument parser for this script.
    The script takes only one of the two arguments --split or --combine.
    Additionally, the --replace-underscore argument can only be used with --split.
    """
    parser = argparse.ArgumentParser(description='Split or Combine translations.')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--split', action='store_true',
                       help='Split translations into separate files for each module and language.')
    group.add_argument('--combine', action='store_true',
                       help='Combine the English translations from all modules into a single file.')
    group.add_argument('--clean', action='store_true',
                       help='Remove translation files and clean XCode projects.')
    parser.add_argument('--replace-underscore', action='store_true',
                        help='Replace Transifex underscore "ar_IQ" language code with '
                             'iOS-compatible "ar-rIQ" codes (only with --split).')
    parser.add_argument('--add-xcode-files', action='store_true',
                        help='Add the language files to the XCode project (only with --split).')
    return parser.parse_args()


@contextmanager
def change_directory(new_dir: Path):
    """
    Context manager to execute `os.chidir`.

    Usage:

    with change_directory('/some/path'):
      do_stuff_here()

    :param new_dir: Path
    """
    original_dir = os.getcwd()
    try:
        os.chdir(new_dir)
        yield
    finally:
        os.chdir(original_dir)


def get_modules_dir(override: Path = None) -> Path:
    """
    Gets the modeles directory (repository root directory).
    """
    if override:
        return override

    return Path(__file__).absolute().parent.parent


def get_translation_file_path(modules_dir, module_name, lang_dir, create_dirs=False):
    """
    Retrieves the path of the translation file for a specified module and language directory.

    Parameters:
        modules_dir (str): The path to the base directory containing all the modules.
        module_name (str): The name of the module for which the translation path is being retrieved.
        lang_dir (str): The name of the language directory within the module's directory.
        create_dirs (bool): If True, creates the parent directories if they do not exist. Defaults to False.

    Returns:
        str: The path to the module's translation file (Localizable.strings).
    """
    try:
        lang_dir_path = os.path.join(modules_dir, module_name, module_name, lang_dir, 'Localizable.strings')
        if create_dirs:
            os.makedirs(os.path.dirname(lang_dir_path), exist_ok=True)
        return lang_dir_path
    except Exception as e:
        print(f"Error creating directory path: {e}", file=sys.stderr)
        raise


def get_modules_to_translate(modules_dir):
    """
    Retrieve the names of modules that have translation files for a specified language.

    Parameters:
        modules_dir (str): The path to the directory containing all the modules.

    Returns:
        list of str: A list of module names that have translation files for the specified language.
    """
    try:
        modules_list = [
            directory for directory in os.listdir(modules_dir)
            if (
                os.path.isdir(os.path.join(modules_dir, directory))
                and os.path.isfile(get_translation_file_path(modules_dir, directory, 'en.lproj'))
                and directory != 'I18N'
            )
        ]
        return modules_list
    except FileNotFoundError as e:
        print(f"Directory not found: {e}", file=sys.stderr)
        raise
    except PermissionError as e:
        print(f"Permission denied: {e}", file=sys.stderr)
        raise


def get_translations(modules_dir):
    """
    Retrieve the translations from all modules in the modules_dir.

    Parameters:
        modules_dir (str): The directory containing the modules.

    Returns:
        dict: A dict containing a list of dictionaries containing the 'key', 'value', and 'comment' for each
        translation line. The key of the outer dict is the name of the module where the translations are going
        to be saved.
    """
    translations = []
    try:
        modules = get_modules_to_translate(modules_dir)
        for module in modules:
            translation_file = get_translation_file_path(modules_dir, module, lang_dir='en.lproj')
            module_translation = localizable.parse_strings(filename=translation_file)

            translations += [
                {
                    'key': f"{module}.{translation_entry['key']}",
                    'value': translation_entry['value'],
                    'comment': translation_entry['comment']
                } for translation_entry in module_translation
            ]
    except Exception as e:
        print(f"Error retrieving translations: {e}", file=sys.stderr)
        raise

    return {'I18N': translations}


def combine_translation_files(modules_dir=None):
    """
    Combine translation files from different modules into a single file.
    """
    try:
        if not modules_dir:
            modules_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        translation = get_translations(modules_dir)
        write_translations_to_modules(modules_dir, 'en.lproj', translation)
    except Exception as e:
        print(f"Error combining translation files: {e}", file=sys.stderr)
        raise


def get_languages_dirs(modules_dir):
    """
    Retrieve directories containing language files for translation.

    Args:
        modules_dir (str): The directory containing all the modules.

    Returns:
        list: A list of directories containing language files for translation. Each directory represents
              a specific language and ends with the '.lproj' extension.
    """
    try:
        lang_parent_dir = os.path.join(modules_dir, 'I18N', 'I18N')
        languages_dirs = [
            directory for directory in os.listdir(lang_parent_dir)
            if directory.endswith('.lproj') and directory != "en.lproj"
        ]
        return languages_dirs
    except FileNotFoundError as e:
        print(f"Directory not found: {e}", file=sys.stderr)
        raise
    except PermissionError as e:
        print(f"Permission denied: {e}", file=sys.stderr)
        raise


def get_translations_from_file(modules_dir, lang_dir):
    """
    Get translations from the translation file in the 'I18N' directory and distribute them into the appropriate
    modules' directories.

    Args:
        modules_dir (str): The directory containing all the modules.
        lang_dir (str): The directory containing the translation file being split.

    Returns:
        dict: A dictionary containing translations split by module. The keys are module names,
              and the values are lists of dictionaries, each containing the 'key', 'value', and 'comment'
              for each translation entry within the module.
    """
    translations = defaultdict(list)
    try:
        translations_file_path = get_translation_file_path(modules_dir, 'I18N', lang_dir)
        lang_list = localizable.parse_strings(filename=translations_file_path)
        for translation_entry in lang_list:
            module_name, key_remainder = translation_entry['key'].split('.', maxsplit=1)
            split_entry = {
                'key': key_remainder,
                'value': translation_entry['value'],
                'comment': translation_entry['comment']
            }
            translations[module_name].append(split_entry)
    except Exception as e:
        print(f"Error extracting translations from file: {e}", file=sys.stderr)
        raise
    return translations


def write_translations_to_modules(modules_dir, lang_dir, modules_translations):
    """
    Write translations to language files for each module.

    Args:
        modules_dir (str): The directory containing all the modules.
        lang_dir (str): The directory of the translation file being written.
        modules_translations (dict): A dictionary containing translations for each module.

    Returns:
        None
    """
    for module, translation_list in modules_translations.items():
        try:
            translation_file_path = get_translation_file_path(modules_dir, module, lang_dir, create_dirs=True)
            with open(translation_file_path, 'w') as f:
                for translation_entry in translation_list:
                    write_line_and_comment(f, translation_entry)
        except Exception as e:
            print(f"Error writing translations to file.\n Module: {module}\n Error: {e}", file=sys.stderr)
            raise


def _escape(s):
    """
    Reverse the replacements performed by _unescape() in the localizable library
    """
    s = s.replace('\n', r'\n').replace('\r', r'\r').replace('"', r'\"')
    return s


def write_line_and_comment(f, entry):
    """
    Write a translation line with an optional comment to a file.

    Args:
        file (file object): The file object to write to.
        entry (dict): A dictionary containing the translation entry with 'key', 'value', and optional 'comment'.

    Returns:
        None
    """
    comment = entry.get('comment')  # Retrieve the comment, if present
    if comment:
        f.write(f"/* {comment} */\n")
    f.write(f'"{entry["key"]}" = "{_escape(entry["value"])}";\n')


def split_translation_files(modules_dir=None):
    """
    Split translation files into separate files for each module and language.

    Args:
        modules_dir (str, optional): The directory containing all the modules. If not provided,
            it defaults to the parent directory of the directory containing this script.

    Returns:
        None
    """
    try:
        if not modules_dir:
            modules_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        languages_dirs = get_languages_dirs(modules_dir)
        for lang_dir in languages_dirs:
            translations = get_translations_from_file(modules_dir, lang_dir)
            write_translations_to_modules(modules_dir, lang_dir, translations)
    except Exception as e:
        print(f"Error splitting translation files: {e}", file=sys.stderr)
        raise


def get_xcode_project(modules_dir: Path, module_name: str) -> XcodeProject:
    """
    Initialize an XCode project instance for a given module.
    """
    module_path = modules_dir / module_name
    xcode_project = XcodeProject.load(module_path / f'{module_name}.xcodeproj/project.pbxproj')
    return xcode_project


def list_translation_files(module_path: Path) -> [Path]:
    """
    List translaiton files in a given path.

    This method doesn't return the `en.lproj` translation source strings.
    """
    for localizable_abs_path in module_path.rglob('**/Localizable.strings'):
        if localizable_abs_path.parent.name != 'en.lproj':
            yield localizable_abs_path


def get_xcode_projects(modules_dir: Path) -> [{Path, XcodeProject}]:
    """
    Return a list of module_name, xcode_project pairs.
    """
    for module_name in get_modules_to_translate(str(modules_dir)):
        print(f'## Entering project: {module_name}')
        xcode_project = get_xcode_project(modules_dir, module_name)
        yield module_name, xcode_project


def add_translation_files_to_xcode(modules_dir: Path = None):
    """
    Add Localizable.strings files pulled from Transifex to XCode.
    """
    try:
        modules_dir = get_modules_dir(override=modules_dir)

        for module_name, xcode_project in get_xcode_projects(modules_dir):
            module_path = modules_dir / module_name
            project_files_path = module_path / module_name  # e.g. openedx-app-ios/Authorization/Authorization

            with change_directory(project_files_path):
                for localizable_abs_path in list_translation_files(module_path):
                    localizable_relative_path = localizable_abs_path.relative_to(module_path / module_name)
                    language, _rest = str(localizable_relative_path).split('.lproj')  # e.g. `ar` or `fr-ca`
                    print(f'  - Adding "{localizable_relative_path}" for the "{language}" language.')
                    localizable_groups = xcode_project.get_groups_by_name(name='Localizable.strings',
                                                                          section='PBXVariantGroup')
                    if len(localizable_groups) != 1:
                        # We need a single group. If many are found then, it's a problem.
                        raise Exception(f'Error: Cannot find the Localizable.strings group, please add the English '
                                        f'source translation strings with the name Localizable.strings. '
                                        f'Results: "{localizable_groups}"')
                    localizable_group = localizable_groups[0]

                    xcode_project.add_file(
                        str(localizable_relative_path),
                        name=language,
                        parent=localizable_group,
                        force=False,
                        tree=LOCALIZABLE_FILES_TREE,
                        file_options=FileOptions(
                            create_build_files=False,
                        ),
                    )
            xcode_project.save()

    except Exception as e:
        print(f"Error: An unexpected error occurred in add_translation_files_to_xcode: {e}", file=sys.stderr)
        raise


def clean_translation_files(modules_dir: Path = None):
    """
    Remove translation files from both file system and XCode project files.
    """
    try:
        modules_dir = get_modules_dir(override=modules_dir)

        for module_name, xcode_project in get_xcode_projects(modules_dir):
            module_path = modules_dir / module_name
            for localizable_abs_path in list_translation_files(module_path):
                localizable_relative_path = localizable_abs_path.relative_to(module_path / module_name)
                print(f'  - Removing "{localizable_relative_path}" file from file system')
                localizable_abs_path.unlink()

            for file_ref in xcode_project.objects.get_objects_in_section('PBXFileReference'):
                if (
                        not file_ref.path.startswith('en.lproj')
                        and re.match(r'\w+.lproj', file_ref.path)
                        and file_ref.sourceTree == LOCALIZABLE_FILES_TREE
                        and getattr(file_ref, 'lastKnownFileType', None) == 'text.plist.strings'
                ):
                    path = file_ref.path
                    language, _rest = str(path).split('.lproj')  # e.g. `ar` or `fr-ca`
                    print(f'  - Removing "{path}" from project resources for the "{language}" language.')
                    xcode_project.remove_files_by_path(file_ref.path, tree=LOCALIZABLE_FILES_TREE, target_name=language)

            xcode_project.save()
    except Exception as e:
        print(f"Error: An unexpected error occurred in clean_translation_files: {e}", file=sys.stderr)
        raise


def replace_underscores(modules_dir=None):
    try:
        if not modules_dir:
            modules_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

        languages_dirs = get_languages_dirs(modules_dir)

        for lang_dir in languages_dirs:
            try:
                pattern = r'_(\w\w.lproj$)'
                if re.search(pattern, lang_dir):
                    replacement = r'-\1'
                    new_name = re.sub(pattern, replacement, lang_dir)
                    lang_old_path = os.path.dirname(get_translation_file_path(modules_dir, 'I18N', lang_dir))
                    lang_new_path = os.path.dirname(get_translation_file_path(modules_dir, 'I18N', new_name))

                    os.rename(lang_old_path, lang_new_path)
                    print(f"Renamed {lang_old_path} to {lang_new_path}")

            except FileNotFoundError as e:
                print(f"Error: The file or directory {lang_old_path} does not exist: {e}", file=sys.stderr)
                raise
            except PermissionError as e:
                print(f"Error: Permission denied while renaming {lang_old_path}: {e}", file=sys.stderr)
                raise
            except Exception as e:
                print(f"Error: An unexpected error occurred while renaming {lang_old_path} to {lang_new_path}: {e}",
                      file=sys.stderr)
                raise

    except Exception as e:
        print(f"Error: An unexpected error occurred in rename_translations_files: {e}", file=sys.stderr)
        raise


def main():
    args = parse_arguments()
    if args.split:
        if args.replace_underscore:
            replace_underscores()
        split_translation_files()
        if args.add_xcode_files:
            add_translation_files_to_xcode()
    elif args.combine:
        combine_translation_files()
    elif args.clean:
        clean_translation_files()


if __name__ == "__main__":
    main()
