import os, localizable
from collections import OrderedDict


def separate_modules_translations(modules_dir, languages_dirs):
    translations = {}
    for lang_dir in languages_dirs:
        file_path = os.path.join(modules_dir, 'I18N', 'I18N', lang_dir, 'Localizable.strings')
        lang_list = localizable.parse_strings(filename=file_path)
        for line in lang_list:
            module_name, _, key_remainder = line['key'].partition('.')
            module_name = module_name
            new_line = {
                'key': key_remainder,
                'value': _escape(line['value']),
                'comment': line['comment']
            }
            translations.setdefault(module_name, {}).setdefault(lang_dir, []).append(new_line)
    return translations


def _escape(s):
    # Reverse the replacements performed by _unescape() in the localizable library
    s = s.replace('\n', r'\n').replace('\r', r'\r').replace('"', r'\"')
    return s


def get_languages_dirs(modules_dir):
    lang_parent_dir = os.path.join(modules_dir, 'I18N', 'I18N')
    languages_dirs = [directory for directory in os.listdir(lang_parent_dir) if directory.endswith('.lproj')]
    return languages_dirs


def write_translations(modules_dir, modules_translations):
    for module, lang_dirs in modules_translations.items():
        for lang_dir, translation_list in lang_dirs.items():
            with open(os.path.join(modules_dir, module, module, lang_dir, 'Localizable.strings'), 'w') as f:
                for line in translation_list:
                    comment = line.get('comment', '')  # Retrieve the comment, if present
                    if comment:
                        f.write(f"/* {comment} */\n")
                    f.write(f'"{line["key"]}" = "{(line["value"])}";\n')


if __name__ == "__main__":
    modules_dir = os.path.dirname(os.path.dirname(__file__))
    languages_dirs = get_languages_dirs(modules_dir)
    translations = separate_modules_translations(modules_dir, languages_dirs)
    write_translations(modules_dir, translations)
