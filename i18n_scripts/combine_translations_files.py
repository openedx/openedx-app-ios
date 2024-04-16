import os, localizable


def get_modules_to_translate(modules_dir, lang='en'):
    '''
    Retrieve the names of modules that have translation files for a specified language.

    Parameters:
        modules_dir (str): The path to the directory containing all the modules.
        lang (str): The language code for which translations are sought. Defaults to 'en'.

    Returns:
        list of str: A list of module names that have translation files for the specified language.

    Logic:
        1. List all directories in the modules directory, excluding the 'I18N' directory.
        2. Iterate over each directory in the list:
            a. Check if the directory contains a subdirectory with the same name.
            b. Check if the subdirectory contains a subdirectory for the specified language.
            c. Check if the language directory contains a file named 'Localizable.strings'.
            d. If all conditions are met, add the module name to the list of modules to translate.
        3. Return the list of module names.
    '''
    # Step 1: List all directories in modules_dir excluding 'I18N'
    dirs = [file for file in os.listdir(modules_dir) if
            os.path.isdir(os.path.join(modules_dir, file)) and file != 'I18N']

    modules_list = []
    # Step 2: Iterate over each directory in the list
    for module in dirs:
        module_path = os.path.join(modules_dir, module)
        # Step 2a: Check if the directory contains a subdirectory with the same name
        if module in os.listdir(module_path):
            lang_dir = os.path.join(module_path, module, f'{lang}.lproj')
            # Step 2b: Check if the subdirectory contains a subdirectory for the specified language
            if os.path.isdir(lang_dir):
                # Step 2c: Check if the language directory contains 'Localizable.strings' file
                if 'Localizable.strings' in os.listdir(lang_dir):
                    # Step 2d: Add the module name to the list of modules to translate
                    modules_list.append(module)
    # Step 3: Return the list of module names
    return modules_list


def get_translations_list(modules_dir, modules, lang='en'):
    '''
    Retrieve the list of translations from all specified modules.

    Parameters:
        modules_dir (str): The directory containing the modules.
        modules (list of str): The list of modules to iterate over.
        lang (str): The language code for which translations are sought. Defaults to 'en'.

    Returns:
        list of dict: A list of dictionaries containing the 'key', 'value', and 'comment' for each translation line.

    Logic:
        1. Iterate over each module in the list of modules:
            a. Construct the path to the Localizable.strings file for the module in the specified language.
            b. Parse the Localizable.strings file to retrieve translations.
            c. Add the module's name to each translation key to distinguish it from other modules.
        2. Return the list of translations.
    '''
    translations = []

    # Step 1: Iterate over each module in the list of modules
    for module in modules:
        # Step 1a: Construct the path to the Localizable.strings file
        path = os.path.join(modules_dir, module, module, f'{lang}.lproj', 'Localizable.strings')

        # Step 1b: Parse the Localizable.strings file to retrieve translations
        module_translations = localizable.parse_strings(filename=path)

        # Step 1c: Add the module's name to each translation key
        for line in module_translations:
            line['key'] = f"{module.upper()}.{line['key']}"

        # Concatenate the module translations to the list of all translations
        translations += module_translations

    # Step 2: Return the list of translations
    return translations


def _escape(s):
    # Reverse the replacements performed by _unescape() in the localizable library
    s = s.replace('\n', r'\n').replace('\r', r'\r').replace('"', r'\"')
    return s


def write_dict_to_file(content_list, modules_dir, lang='en'):
    translation_file = os.path.join(modules_dir, 'I18N', 'I18N', f'{lang}.lproj')
    os.makedirs(translation_file, exist_ok=True)
    with open(os.path.join(translation_file, 'Localizable.strings'), 'w') as f:
        for line_dict in content_list:
            comment = line_dict.get('comment', '')  # Retrieve the comment, if present
            if comment:
                f.write(f"/* {comment} */\n")
            f.write(f'"{line_dict.get("key")}" = "{_escape(line_dict["value"])}";\n')


if __name__ == "__main__":
    modules_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    modules = get_modules_to_translate(modules_dir)
    translation_list = get_translations_list(modules_dir, modules)
    write_dict_to_file(translation_list, modules_dir)


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
