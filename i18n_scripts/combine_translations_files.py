import os, localizable
from collections import OrderedDict


def get_modules_to_translate(modules_dir, lang='en'):
    """
    Retrieve the names of modules that have translation files for a specified language.

    Parameters:
        modules_dir (str): The path to the directory containing all the modules.
        lang (str): The language code for which translations are sought. Defaults to 'en'.

    Returns:
        list of str: A list of module names that have translation files for the specified language.

    Logic:
        1. List all directories in the modules directory, excluding the 'I18N' directory.
        2. Return the list of module names.
    """
    dirs = [directory for directory in os.listdir(modules_dir) if
            os.path.isdir(os.path.join(modules_dir, directory)) and directory != 'I18N']

    modules_list = []
    for module in dirs:
        translation_path = os.path.join(modules_dir, module, module, f'{lang}.lproj', 'Localizable.strings')
        if os.path.exists(translation_path) and os.path.isfile(translation_path):
            modules_list.append(module)
    return modules_list


def get_translations_ordereddict(modules_dir, lang='en'):
    """
    Retrieve the list of translations from all specified modules.

    Parameters:
        modules_dir (str): The directory containing the modules.
        modules (list of str): The list of modules to iterate over.
        lang (str): The language code for which translations are sought. Defaults to 'en'.

    Returns:
        OrderedDict of dict: An ordered dict of dictionaries containing the 'key', 'value', and 'comment' for each
        translation line. The key of the OrderedDict is the value of the key in the contained dict in addition to the
        name of the module containing the translation

    Logic:
        1. Iterate over each module in the list of modules:
            a. Construct the path to the Localizable.strings file for the module in the specified language.
            b. Parse the Localizable.strings file to retrieve translations.
            c. Add the module's name to ordered dict's key to distinguish it from other modules.
        2. Return the translations' ordered dict.
    """
    ordered_dict_of_translations = OrderedDict()
    modules = get_modules_to_translate(modules_dir, lang=lang)
    # Step 1: Iterate over each module in the list of modules
    for module in modules:
        # Step 1a: Construct the path to the Localizable.strings file
        path = os.path.join(modules_dir, module, module, f'{lang}.lproj', 'Localizable.strings')

        # Step 1b: Parse the Localizable.strings file to retrieve translations
        module_translations = localizable.parse_strings(filename=path)

        # Step 1c: Add the module's name to each translation key
        for line in module_translations:
            ordered_dict_of_translations[f"{module}.{line['key']}"] = line

    # Step 2: Return the translations' ordered dict
    return ordered_dict_of_translations


def _escape(s):
    # Reverse the replacements performed by _unescape() in the localizable library
    s = s.replace('\n', r'\n').replace('\r', r'\r').replace('"', r'\"')
    return s


def write_dict_to_file(content_ordered_dict, modules_dir, lang='en'):
    translation_file = os.path.join(modules_dir, 'I18N', 'I18N', f'{lang}.lproj')
    os.makedirs(translation_file, exist_ok=True)
    with open(os.path.join(translation_file, 'Localizable.strings'), 'w') as f:
        for key, value in content_ordered_dict.items():
            comment = value.get('comment', '')  # Retrieve the comment, if present
            if comment:
                f.write(f"/* {comment} */\n")
            f.write(f'"{key}" = "{_escape(value["value"])}";\n')


def get_languages(module_dir):
    languages = set()
    modules = [module for module in os.listdir(module_dir) if os.path.exists(os.path.join(module_dir, module, module))]
    for module in modules:
        if os.path.isdir(os.path.join(module_dir, module, module)):
            lang_list = [elem.strip('.lproj') for elem in os.listdir(os.path.join(module_dir, module, module)) if elem.endswith('.lproj')]
            languages.update(lang_list)
    return languages


if __name__ == "__main__":
    modules_dir = os.path.dirname(os.path.dirname(__file__))
    langs = get_languages(modules_dir)
    langs.discard('en')
    en_translation_ordered_dict = get_translations_ordereddict(modules_dir, lang='en')
    write_dict_to_file(en_translation_ordered_dict, modules_dir, lang='en')
    for lang in langs:
        lang_translation_ordered_dict = get_translations_ordereddict(modules_dir, lang=lang)
        in_en_not_in_lang = OrderedDict([(key, value) for key, value in en_translation_ordered_dict.items()
                                         if key not in lang_translation_ordered_dict])
        lang_translation_ordered_dict.update(in_en_not_in_lang)
        write_dict_to_file(lang_translation_ordered_dict, modules_dir, lang=lang)


def make_test_dirs_and_files():
    modules_path = 'test_dir'
    test_modules = ['Test_module_1', 'Test_module_2', 'Test_module_3']
    test_contents = {
                     'Test_module_1': '''"TEST_MOD_1_STRING.EXTENSION_KEY" =  "extension_value_1";\n''',
                     'Test_module_2': '''"TEST_MOD_2_STRING.EXTENSION_KEY" =  "extension_value_2";\n''',
                     'Test_module_3': '''"TEST_MOD_3_STRING.EXTENSION_KEY" =  "extension_value_3";\n''',
                     }
    for test_module in test_modules:
        translation_path = os.path.join(modules_path, test_module, test_module, 'en.lproj', 'Localizable.strings')
        os.makedirs(os.path.dirname(translation_path), exist_ok=True)
        with open(translation_path, 'w') as f:
            f.write(test_contents[test_module])
