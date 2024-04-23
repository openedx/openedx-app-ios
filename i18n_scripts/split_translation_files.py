import os, localizable
from collections import OrderedDict


def separate_translation_to_modules(modules_dir, lang_dir):
    translations = {}
    file_path = os.path.join(modules_dir, 'I18N', lang_dir, 'Localizable.strings')
    lang_list = localizable.parse_strings(filename=file_path)
    for translation_entry in lang_list:
        module_name, _dot, key_remainder = translation_entry['key'].partition('.')
        split_entry = {
            'key': key_remainder,
            'value': _escape(translation_entry['value']),
            'comment': translation_entry['comment']
        }
        translations.setdefault(module_name, []).append(split_entry)
    return translations


def _escape(s):
    # Reverse the replacements performed by _unescape() in the localizable library
    s = s.replace('\n', r'\n').replace('\r', r'\r').replace('"', r'\"')
    return s


def get_languages_dirs(modules_dir):
    lang_parent_dir = os.path.join(modules_dir, 'I18N')
    languages_dirs = [directory for directory in os.listdir(lang_parent_dir) if directory.endswith('.lproj')]
    return languages_dirs


def write_translations(modules_dir, lang_dir, modules_translations):
    for module, translation_list in modules_translations.items():
        with open(os.path.join(modules_dir, module, module, lang_dir, 'Localizable.strings'), 'w') as f:
            for translation_entry in translation_list:
                comment = translation_entry.get('comment', '')  # Retrieve the comment, if present
                if comment:
                    f.write(f"/* {comment} */\n")
                f.write(f'"{translation_entry["key"]}" = "{(translation_entry["value"])}";\n')


def split_translation_files(modules_dir=None):
    if not modules_dir:
        modules_dir = os.path.dirname(os.path.dirname(__file__))
    languages_dirs = get_languages_dirs(modules_dir)
    for lang_dir in languages_dirs:
        translations = separate_translation_to_modules(modules_dir, lang_dir)
        write_translations(modules_dir, lang_dir, translations)


if __name__ == "__main__":
    split_translation_files()