clean_translations_temp_directory:
	rm -rf I18N/I18N/


pull_translations:
	make clean_translations_temp_directory
	atlas pull $(ATLAS_OPTIONS) translations/openedx-app-ios/I18N/I18N/:I18N/I18N/
	python i18n_scripts/split_translation_files.py
	make clean_translations_temp_directory


combine_translations:
	make clean_translations_temp_directory
	python i18n_scripts/combine_translations_files.py