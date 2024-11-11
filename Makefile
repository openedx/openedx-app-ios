clean_translations:
	rm -rf I18N/
	python3 i18n_scripts/translation.py --clean

translation_requirements:
	pip3 install -r i18n_scripts/requirements.txt

pull_translations: clean_translations
	atlas pull $(ATLAS_OPTIONS) translations/openedx-app-ios/I18N:I18N
	python3 i18n_scripts/translation.py --split --replace-underscore --add-xcode-files

extract_translations: clean_translations
	python3 i18n_scripts/translation.py --combine
