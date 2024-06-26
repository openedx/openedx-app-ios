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
import localizable


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
    parser.add_argument('--replace-underscore', action='store_true',
                        help='Replace underscores with "-r" in language directories (only with --split).')
    return parser.parse_args()


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
    elif args.combine:
        combine_translation_files()


if __name__ == "__main__":
    main()
