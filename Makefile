clean_translations_temp_directory:
	rm -rf I18N/

create_virtual_env:
	rm -rf .venv
	python3 -m venv .venv
	# TODO: Publish new version on pypi as `python3-localizable`
	. .venv/bin/activate && pip install git+https://github.com/Amr-Nash/python-localizable.git

pull_translations: clean_translations_temp_directory create_virtual_env
	atlas pull $(ATLAS_OPTIONS) translations/openedx-app-ios/I18N/:I18N/
	. .venv/bin/activate && python i18n_scripts/split_translation_files.py
	make clean_translations_temp_directory


combine_translations: clean_translations_temp_directory create_virtual_env
	. .venv/bin/activate && python i18n_scripts/combine_translations_files.py
