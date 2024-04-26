"""
Translations are pulled from https://github.com/openedx/openedx-translations to the I18N directory.
This script splits the translations from the I18N directory to all modules in the repository.
"""

import os
import localizable


def separate_translation_to_modules(modules_dir, lang_dir):
    """
    Separate translations from a translation file into modules.

    Args:
        modules_dir (str): The directory containing all the modules.
        lang_dir (str): The directory containing the translation file being split.

    Returns:
        dict: A dictionary containing translations split by module. The keys are module names,
              and the values are lists of dictionaries, each containing the 'key', 'value', and 'comment'
              for each translation entry within the module.

    Example:
        Input:
            separate_translation_to_modules('/path/to/modules', 'uk.lproj')
        Output:
            {
                'module1': [
                    {'key': 'translation_key', 'value': 'translation_value', 'comment': 'translation_comment'},
                    ...
                ],
                'module2': [
                    ...
                ],
                ...
            }
    """
    translations = {}
    file_path = os.path.join(modules_dir, 'I18N', lang_dir, 'Localizable.strings')
    lang_list = localizable.parse_strings(filename=file_path)
    for translation_entry in lang_list:
        module_name, key_remainder = translation_entry['key'].split('.', maxsplit=1)
        split_entry = {
            'key': key_remainder,
            'value': _escape(translation_entry['value']),
            'comment': translation_entry['comment']
        }
        translations.setdefault(module_name, []).append(split_entry)
    return translations


def _escape(s):
    """
    Reverse the replacements performed by _unescape() in the localizable library
    """
    s = s.replace('\n', r'\n').replace('\r', r'\r').replace('"', r'\"')
    return s


def get_languages_dirs(modules_dir):
    """
    Retrieve directories containing language files for translation.

    Args:
        modules_dir (str): The directory containing all the modules.

    Returns:
        list: A list of directories containing language files for translation. Each directory represents
              a specific language and ends with the '.lproj' extension.

    Example:
        Input:
            get_languages_dirs('/path/to/modules')
        Output:
            ['ar.lproj', 'uk.lproj', ...]
    """
    lang_parent_dir = os.path.join(modules_dir, 'I18N')
    languages_dirs = [
        directory for directory in os.listdir(lang_parent_dir)
        if directory.endswith('.lproj') and directory != "en.lproj"
    ]
    return languages_dirs


def write_translations(modules_dir, lang_dir, modules_translations):
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
        with open(os.path.join(modules_dir, module, module, lang_dir, 'Localizable.strings'), 'w') as f:
            for translation_entry in translation_list:
                comment = translation_entry.get('comment', '')  # Retrieve the comment, if present
                if comment:
                    f.write(f"/* {comment} */\n")
                f.write(f'"{translation_entry["key"]}" = "{(translation_entry["value"])}";\n')


def split_translation_files(modules_dir=None):
    """
    Split translation files into separate files for each module and language.

    Args:
        modules_dir (str, optional): The directory containing all the modules. If not provided,
            it defaults to the parent directory of the directory containing this script.

    Returns:
        None

    Example:
        split_translation_files('/path/to/modules')
    """
    if not modules_dir:
        modules_dir = os.path.dirname(os.path.dirname(__file__))
    languages_dirs = get_languages_dirs(modules_dir)
    for lang_dir in languages_dirs:
        translations = separate_translation_to_modules(modules_dir, lang_dir)
        write_translations(modules_dir, lang_dir, translations)


if __name__ == "__main__":
    split_translation_files()