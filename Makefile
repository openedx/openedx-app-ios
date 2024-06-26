clean_translations_temp_directory:
	rm -rf I18N/

translation_requirements:
	pip3 install -r i18n_scripts/requirements.txt

pull_translations: clean_translations_temp_directory
	atlas pull $(ATLAS_OPTIONS) translations/openedx-app-ios/I18N:I18N
	python3 i18n_scripts/translation.py --split --replace-underscore

extract_translations: clean_translations_temp_directory
	python3 i18n_scripts/translation.py --combine
