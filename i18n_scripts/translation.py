#!/usr/bin/env python3
"""
This script performs two jobs:
 1- Combine the English translations from all modules in the repository to the I18N directory. After the English
    translation is combined, it will be pushed to the openedx-translations repository as described in OEP-58.
 2- Split the pulled translation files from the openedx-translations repository into the iOS app modules 
    and merge/overwrite them with CustomLocalizable.strings if it exists.

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
MAIN_MODULE_NAME = 'OpenEdX'
I18N_MODULE_NAME = 'I18N'


def parse_arguments():
    """
    This function is the argument parser for this script.
    The script takes only one of the three main arguments: --split, --combine, or --clean.
    Additionally, the --replace-underscore and --add-xcode-files arguments can only be used with --split.
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
    Context manager to execute `os.chdir`.

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
    Gets the modules directory (repository root directory).
    """
    if override:
        return override

    return Path(__file__).absolute().parent.parent


def get_translation_file_path(modules_dir: Path, module_name, lang_dir, create_dirs=False):
    """
    Retrieves the path of the translation file for a specified module and language directory.

    Parameters:
        modules_dir (Path): The path to the base directory containing all the modules.
        module_name (str): The name of the module for which the translation path is being retrieved.
        lang_dir (str): The name of the language directory within the module's directory.
        create_dirs (bool): If True, creates the parent directories if they do not exist. Defaults to False.

    Returns:
        Path: The path to the module's translation file (Localizable.strings).
    """
    try:
        if module_name == MAIN_MODULE_NAME:
            # The main project structure is located into `OpenEdX` rather than `OpenEdX/OpenEdX`
            module_path = modules_dir / module_name
        else:
            # Rest of modules such as Core, Course, Dashboard, etc follow the `Dashboard/Dashboard` structure
            module_path = modules_dir / module_name / module_name

        lang_dir_path = module_path / lang_dir
        if create_dirs:
            lang_dir_path.mkdir(parents=True, exist_ok=True)
        return lang_dir_path / 'Localizable.strings'
    except Exception as e:
        print(f"Error creating directory path: {e}", file=sys.stderr)
        raise


def get_modules_to_translate(modules_dir: Path):
    """
    Retrieve the names of modules that have translation files for the English language.

    Parameters:
        modules_dir (Path): The path to the directory containing all the modules.

    Returns:
        list of str: A list of module names that have English translation files.
    """
    try:
        modules_list = [
            module_dir for module_dir in os.listdir(modules_dir)
            if (
                (modules_dir / module_dir).is_dir()
                and os.path.isfile(get_translation_file_path(modules_dir, module_dir, 'en.lproj'))
                and module_dir != I18N_MODULE_NAME
                and module_dir != MAIN_MODULE_NAME
            )
        ]
        return modules_list
    except (FileNotFoundError, PermissionError) as e:
        print(f"Error accessing modules directory: {e}", file=sys.stderr)
        raise


def get_translations(modules_dir: Path):
    """
    Retrieve the translations from all modules in the modules_dir and prefix keys with module name.

    Parameters:
        modules_dir (Path): The directory containing the modules.

    Returns:
        dict: A dict containing a list of dictionaries containing the 'key', 'value', and 'comment'.
        The key of the outer dict is I18N_MODULE_NAME as it's intended for the combined file.
    """
    translations = []
    try:
        modules = get_modules_to_translate(modules_dir)
        for module in modules:
            translation_file = get_translation_file_path(modules_dir, module, lang_dir='en.lproj')
            module_translation = localizable.parse_strings(filename=str(translation_file))

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

    return {I18N_MODULE_NAME: translations}


def combine_translation_files(modules_dir=None):
    """
    Combine English translation files from different modules into a single master file in the I18N directory.
    """
    try:
        modules_dir = get_modules_dir(override=modules_dir)
        translation = get_translations(modules_dir)
        # We explicitly write to en.lproj for the combined file
        write_translations_to_modules(modules_dir, 'en.lproj', translation, is_combine=True)
    except Exception as e:
        print(f"Error combining translation files: {e}", file=sys.stderr)
        raise


def get_languages_dirs(modules_dir: Path, include_english=False):
    """
    Retrieve directories containing language files from the I18N module.

    Args:
        modules_dir (Path): The directory containing all the modules.
        include_english (bool): Whether to include the 'en.lproj' directory. Defaults to False.

    Returns:
        list: A list of directories ending with '.lproj'.
    """
    try:
        lang_parent_dir = modules_dir / I18N_MODULE_NAME / I18N_MODULE_NAME
        if not lang_parent_dir.exists():
            return []

        languages_dirs = [
            directory for directory in os.listdir(lang_parent_dir)
            if directory.endswith('.lproj')
        ]

        if not include_english and "en.lproj" in languages_dirs:
            languages_dirs.remove("en.lproj")

        return languages_dirs
    except Exception as e:
        print(f"Error retrieving language directories: {e}", file=sys.stderr)
        raise


def ensure_utf8(file_path: Path):
    """
    Ensures that a file is encoded in UTF-8. If UTF-16 is detected via BOM, it converts it.
    """
    raw = file_path.read_bytes()
    if raw[:2] in (b'\xff\xfe', b'\xfe\xff'):
        text = raw.decode('utf-16')
        file_path.write_text(text, encoding='utf-8')


def get_translations_from_file(modules_dir, lang_dir):
    """
    Get translations from the master translation file in the 'I18N' directory and group them by module.

    Args:
        modules_dir (str): The directory containing all the modules.
        lang_dir (str): The directory containing the translation file being split.

    Returns:
        dict: A dictionary where keys are module names and values are lists of translation entries.
    """
    translations = defaultdict(list)
    try:
        translations_file_path = get_translation_file_path(modules_dir, I18N_MODULE_NAME, lang_dir)
        if not translations_file_path.exists():
            return translations

        ensure_utf8(translations_file_path)
        lang_list = localizable.parse_strings(filename=str(translations_file_path))
        for translation_entry in lang_list:
            if '.' in translation_entry['key']:
                module_name, key_remainder = translation_entry['key'].split('.', maxsplit=1)
                split_entry = {
                    'key': key_remainder,
                    'value': translation_entry['value'],
                    'comment': translation_entry['comment']
                }
                translations[module_name].append(split_entry)
    except Exception as e:
        print(f"Error extracting translations from master file: {e}", file=sys.stderr)
        raise
    return translations


def write_translations_to_modules(modules_dir: Path, lang_dir, modules_translations, is_combine=False):
    """
    Write translations to language files for each module.
    
    If is_combine is True: writes the master combined file to the I18N module.
    If is_combine is False: splits strings into modules and merges with CustomLocalizable.strings if present.

    Args:
        modules_dir (Path): The directory containing all the modules.
        lang_dir (str): The directory of the translation file being written (e.g., 'es.lproj').
        modules_translations (dict): A dictionary containing translations for each module.
        is_combine (bool): Flag indicating if we are combining into I18N or splitting into modules.
    """
    if is_combine:
        targets = [I18N_MODULE_NAME]
    else:
        # During split, ensure we check all known modules plus the Main module
        targets = set(get_modules_to_translate(modules_dir))
        targets.add(MAIN_MODULE_NAME)
        targets.update(modules_translations.keys())

    for module in targets:
        # Skip I18N if we are in split mode
        if not is_combine and module == I18N_MODULE_NAME:
            continue

        community_list = modules_translations.get(module, [])
        custom_list = []

        try:
            target_file_path = get_translation_file_path(modules_dir, module, lang_dir, create_dirs=True)
            
            # Logic for merging Custom Overrides during the Split phase
            if not is_combine:
                custom_file_path = target_file_path.parent / 'CustomLocalizable.strings'
                if custom_file_path.exists():
                    print(f"  - [{lang_dir}] Merging custom overrides for: {module}")
                    custom_list = localizable.parse_strings(filename=str(custom_file_path))

            custom_keys = {item['key'] for item in custom_list}

            with open(target_file_path, 'w') as f:
                if is_combine:
                    f.write(f"/* Combined English Source for Open edX iOS */\n")
                else:
                    f.write(f"/* Community Translations for {module} ({lang_dir}) */\n")
                
                written_count = 0
                for entry in community_list:
                    # Overwrite community strings if a custom key exists
                    if entry['key'] not in custom_keys:
                        write_line_and_comment(f, entry)
                        written_count += 1
                
                if written_count == 0 and not custom_list:
                    f.write(f"/* Empty {lang_dir}/Localizable.strings: Created by i18n_scripts/translation.py */\n")

                if custom_list:
                    f.write(f"\n/* --- Custom Overrides for {module} --- */\n")
                    for entry in custom_list:
                        write_line_and_comment(f, entry)

        except Exception as e:
            print(f"Error writing translations to module {module}: {e}", file=sys.stderr)
            raise


def _escape(s):
    """
    Reverse the replacements performed by _unescape() in the localizable library.
    Escapes newlines and quotes for .strings format.
    """
    s = s.replace('\n', r'\n').replace('\r', r'\r').replace('"', r'\"')
    return s


def write_line_and_comment(f, entry):
    """
    Write a translation line with an optional comment to a file.

    Args:
        f (file object): The file object to write to.
        entry (dict): A dictionary containing 'key', 'value', and optional 'comment'.
    """
    comment = entry.get('comment')
    if comment:
        f.write(f"/* {comment} */\n")
    f.write(f'"{entry["key"]}" = "{_escape(entry["value"])}";\n')


def split_translation_files(modules_dir=None):
    """
    Split translation files from the I18N directory into separate files for each module and language.
    """
    try:
        modules_dir = get_modules_dir(override=modules_dir)
        languages_dirs = get_languages_dirs(modules_dir)
        for lang_dir in languages_dirs:
            print(f"Processing Language: {lang_dir}")
            translations = get_translations_from_file(modules_dir, lang_dir)
            write_translations_to_modules(modules_dir, lang_dir, translations, is_combine=False)
    except Exception as e:
        print(f"Error splitting translation files: {e}", file=sys.stderr)
        raise


def get_project_path(modules_dir: Path, module_name: str) -> Path:
    """
    Using a module_name return the pbxproj path.
    """
    if module_name == MAIN_MODULE_NAME:
        return modules_dir / f'{module_name}.xcodeproj/project.pbxproj'
    return modules_dir / module_name / f'{module_name}.xcodeproj/project.pbxproj'


def get_xcode_project(modules_dir: Path, module_name: str) -> XcodeProject:
    """
    Initialize an XCode project instance for a given module.
    """
    path = get_project_path(modules_dir, module_name)
    return XcodeProject.load(path) if path.exists() else None


def list_translation_files(module_path: Path):
    """
    List translation files in a given path.
    Does not return the `en.lproj` source strings or `CustomLocalizable.strings`.
    """
    for path in module_path.rglob('**/Localizable.strings'):
        if path.parent.name != 'en.lproj' and "CustomLocalizable" not in path.name:
            yield path


def get_xcode_projects(modules_dir: Path):
    """
    Return a list of module_name, xcode_project pairs for all modules to translate.
    """
    for module_name in get_modules_to_translate(modules_dir):
        project = get_xcode_project(modules_dir, module_name)
        if project:
            yield module_name, project


def add_localizable(xcode_project: XcodeProject, localizable_relative_path: Path):
    """
    Add localizable file properly to the PBXVariantGroup.

    This function depends on the https://github.com/kronenthaler/mod-pbxproj/pull/356 implementation.

    TODO: Refactor to use the `master` version once either of the following issues is closed:
          - Issue by st3fan: https://github.com/kronenthaler/mod-pbxproj/issues/113
          - Proposal by OmarIthawi for Axim: https://github.com/kronenthaler/mod-pbxproj/pull/356
    """
    language = str(localizable_relative_path).split('.lproj')[0]
    print(f'  - Adding "{localizable_relative_path}" for the "{language}" language.')
    
    localizable_groups = xcode_project.get_groups_by_name(name='Localizable.strings',
                                                         section='PBXVariantGroup')
    if not localizable_groups:
        return

    xcode_project.add_file(
        str(localizable_relative_path),
        name=language,
        parent=localizable_groups[0],
        force=False,
        tree=LOCALIZABLE_FILES_TREE,
        file_options=FileOptions(create_build_files=False),
    )


def add_translation_files_to_xcode(modules_dir: Path = None):
    """
    Add Localizable.strings files pulled from Transifex (or split from I18N) to XCode projects.
    """
    try:
        modules_dir = get_modules_dir(override=modules_dir)
        for module_name, xcode_project in get_xcode_projects(modules_dir):
            print(f'## Entering project: {module_name}')
            module_path = modules_dir / module_name
            project_files_path = module_path / module_name

            with change_directory(project_files_path):
                for localizable_abs_path in list_translation_files(module_path):
                    add_localizable(
                        xcode_project=xcode_project,
                        localizable_relative_path=localizable_abs_path.relative_to(project_files_path),
                    )
            xcode_project.save()

        # Handle Main Project
        print(f'## Entering project: {MAIN_MODULE_NAME}')
        main_project = get_xcode_project(modules_dir, MAIN_MODULE_NAME)
        if main_project:
            main_path = modules_dir / MAIN_MODULE_NAME
            with change_directory(main_path):
                for localizable_abs_path in list_translation_files(main_path):
                    add_localizable(
                        xcode_project=main_project,
                        localizable_relative_path=localizable_abs_path.relative_to(main_path),
                    )
            main_project.save()
    except Exception as e:
        print(f"Error updating Xcode projects: {e}", file=sys.stderr)
        raise


def remove_xcode_localizable_variants(xcode_project: XcodeProject) -> None:
    """
    Remove all non-English localizable files from the XCode project metadata.
    """
    for file_ref in xcode_project.objects.get_objects_in_section('PBXFileReference'):
        if (
                not file_ref.path.startswith('en.lproj')
                and re.match(r'\w+.lproj', file_ref.path)
                and file_ref.sourceTree == LOCALIZABLE_FILES_TREE
                and getattr(file_ref, 'lastKnownFileType', None) == 'text.plist.strings'
        ):
            path = file_ref.path
            language = str(path).split('.lproj')[0]
            print(f'  - Removing "{path}" from project resources for the "{language}" language.')
            xcode_project.remove_files_by_path(file_ref.path, tree=LOCALIZABLE_FILES_TREE, target_name=language)


def clean_translation_files(modules_dir: Path = None):
    """
    Remove translation files from both the file system and XCode project files.
    """
    try:
        modules_dir = get_modules_dir(override=modules_dir)
        all_modules = get_modules_to_translate(modules_dir) + [MAIN_MODULE_NAME]
        
        for module_name in all_modules:
            print(f'## Cleaning project: {module_name}')
            xcode_project = get_xcode_project(modules_dir, module_name)
            module_path = modules_dir / module_name
            
            # Delete physical files
            for path in list_translation_files(module_path):
                print(f'  - Deleting: {path.relative_to(modules_dir)}')
                path.unlink()
            
            # Remove from Xcode
            if xcode_project:
                remove_xcode_localizable_variants(xcode_project)
                xcode_project.save()
                
    except Exception as e:
        print(f"Error cleaning files: {e}", file=sys.stderr)
        raise


def replace_underscores(modules_dir=None):
    """
    Rename Transifex style locale folders (e.g., ar_IQ.lproj) to iOS compatible 
    naming (ar-IQ.lproj) within the I18N directory.
    """
    try:
        modules_dir = get_modules_dir(override=modules_dir)
        parent = modules_dir / I18N_MODULE_NAME / I18N_MODULE_NAME
        if not parent.exists():
            return

        for lang_dir in os.listdir(parent):
            if '_' in lang_dir and lang_dir.endswith('.lproj'):
                old_path = parent / lang_dir
                new_name = lang_dir.replace('_', '-')
                new_path = parent / new_name
                os.rename(old_path, new_path)
                print(f"Renamed locale folder: {lang_dir} -> {new_name}")
    except Exception as e:
        print(f"Error replacing underscores: {e}", file=sys.stderr)
        raise


def main():
    """
    Main entry point for the script.
    """
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
