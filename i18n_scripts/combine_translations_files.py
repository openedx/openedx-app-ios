import os
import re
import localizable
from collections import OrderedDict

"""
Translations are pulled from https://github.com/openedx/openedx-translations to the I18N directory.
This script splits the translations from the I18N directory to all modules in the repository.
"""


def get_translation_file_path(modules_dir, module):
    """
    Retrieves the path of the translation file from the module name

    Parameters:
        modules_dir (str): The path to the directory containing all the modules.
        module (str): The module's name that we want its translation.

    Returns:
        file_path (str): The module's translation path.
    """
    translation_file = os.path.join(modules_dir, module, module, 'en.lproj', 'Localizable.strings')
    return translation_file


def get_modules_to_translate(modules_dir):
    """
    Retrieve the names of modules that have translation files for a specified language.

    Parameters:
        modules_dir (str): The path to the directory containing all the modules.

    Returns:
        list of str: A list of module names that have translation files for the specified language.
    """
    dirs = [
        directory for directory in os.listdir(modules_dir)
        if os.path.isdir(os.path.join(modules_dir, directory))
    ]

    modules_list = []
    for module in dirs:
        translation_file = get_translation_file_path(modules_dir, module)
        if os.path.isfile(translation_file):
            modules_list.append(module)
    return modules_list


def get_translations(modules_dir):
    """
    Retrieve the translations from all specified modules as OrderedDict.

    Parameters:
        modules_dir (str): The directory containing the modules.

    Returns:
        OrderedDict of dict: An ordered dict of dictionaries containing the 'key', 'value', and 'comment' for each
        translation line. The key of the outer OrderedDict consists of the value of the translation key combined with
        the name of the module containing the translation.
    """
    ordered_dict_of_translations = OrderedDict()
    modules = get_modules_to_translate(modules_dir)
    for module in modules:
        translation_file = get_translation_file_path(modules_dir, module)
        module_translations = localizable.parse_strings(filename=translation_file)

        for entry in module_translations:
            key_with_module = f"{module}.{entry['key']}"
            ordered_dict_of_translations[key_with_module] = entry

    return ordered_dict_of_translations


def _escape(s):
    """
    Reverse the replacements performed by _unescape() in the localizable library
    """
    replacements = {'\n': r'\n', '\r': r'\r', '"': r'\"'}

    result = re.sub(r'([\n\r"])', lambda match: replacements[match.group(0)], s)

    return result


def write_translation_file(content_ordered_dict, modules_dir):
    """
    Write the contents of an ordered dictionary to a Localizable.strings file.

    This function takes an ordered dictionary containing translation data and writes it to a Localizable.strings
    file located in the 'I18N/en.lproj' directory within the specified modules directory. It creates the directory
    if it doesn't exist.
    
    Parameters:
       content_ordered_dict (OrderedDict): An ordered dictionary containing translation data. The keys
       are the translation keys, and the values are dictionaries with 'value' and 'comment' keys representing the
       translation value and optional comments, respectively.
       modules_dir (str): The path to the modules directory
       where the I18N directory will be written.
    """
    combined_translation_dir = os.path.join(modules_dir, 'I18N', 'en.lproj')
    os.makedirs(combined_translation_dir, exist_ok=True)
    with open(os.path.join(combined_translation_dir, 'Localizable.strings'), 'w') as f:
        for key, value in content_ordered_dict.items():
            comment = value.get('comment')  # Retrieve the comment, if present
            if comment:
                f.write(f"/* {comment} */\n")
            f.write(f'"{key}" = "{_escape(value["value"])}";\n')


def combine_translation_files(modules_dir=None):
    """
    Combine translation files from different modules into a single file.
    """
    if not modules_dir:
        modules_dir = os.path.dirname(os.path.dirname(__file__))
    combined_translation_dict = get_translations(modules_dir)
    write_translation_file(combined_translation_dict, modules_dir)


if __name__ == "__main__":
    combine_translation_files()
