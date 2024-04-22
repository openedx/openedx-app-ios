Atlas Translations Management Design
####################################

Date: 25 March 2024

Status
******
Accepted

Context
*******

Open edX microservices and micro-frontends use the processes outlined in `OEP-58`_ to pull the latest
translations from the `openedx-translations repository`_.

The main changes that `OEP-58`_ introduced to the Open edX project are the following:

- Extract the English translation source entries and commit them into the `openedx-translations repository`_
- The `GitHub Transifex app`_ will automatically commit the translations to the `openedx-translations repository`_
- Provide a command that utilizes the `atlas`_ tool to pull translations in both development and web server image builds

Microservices, micro-frontends, XBlocks and plugins use as few translation files as possible to make it easier for Translators
to locate and translate relevant resources.

`edx-platform`_ translation strings used to be split between 7 files, but this has been deprecated in favor of
``edx-platform.po`` and ``edx-platform-js.po`` files.
More details are available in the `edx-platform resources combination decision document`_.

`openedx-app-ios`_ uses a modular architecture. Each module has its own i18n
localizable strings file. This is useful for Developer Experience, but can be harmful
to the Translator Experience. Translators often are unaware of the engineering
architecture and would like to be able to quickly search for strings regardless of
their location in the code.

Decision
********

Combine English ``Localizable.strings`` files from mobile app modules before pushing them to the `openedx-translations repository`_.
split back the translated files into the modules after pulling from the `openedx-translations repository`_ via
`atlas`_.

The `OEP-58`_ workflow for mobile apps will proceed as follows:

* The `openedx-translations repository`_ runs a daily cronjob to collect strings from the `openedx-app-ios`_ ``main`` branch.

  * The `extract-translation-source-files.yml`_ workflow will clone the `openedx-app-ios`_ repo.

  * The `extract-translation-source-files.yml`_ workflow will run `openedx-app-ios`_'s ``make combine_translations``.

  * ``make combine_translations`` combines English ``Localizable.strings`` files from the mobile app modules into a single ``I18N/I18N/en.lproj/Localizable.strings`` file.

  * The ``I18N/I18N/en.lproj/Localizable.strings`` file is committed in the `openedx-translations repository`_.

  * The `GitHub Transifex app`_ will fetch the updated English source ``.strings`` files from `openedx-translations repository`_

  * Translators can translate the strings in the `Transifex openedx-translations project`_

  * The `GitHub Transifex app`_ syncs the translated strings into the `openedx-translations repository`_

* Developers run ``make pull_translations`` to pull the translations from the `openedx-translations repository`_

  * ``make pull_translations`` runs `atlas pull`_ to pull the translations

  * The translations will be pulled as a single file for each language e.g. ``I18N/I18N/ar.lproj/Localizable.strings``

  * Then ``make pull_translations`` will run ``python scripts/split_translation_files.py`` to split
    the translations by module and place them in their corresponding directories
    e.g. ``Course/Course/ar.lproj/Localizable.strings``

Notable changes
===============

- Translation files are no longer committed directly to the mobie app repositories (`openedx-app-ios`_ / `openedx-app-android`_)
- Before releasing to App Store, developers need to run a new ``make pull_translations`` command

String file combination and splitting process
=============================================
This is a new process that's being introduced to have the best combination
of Developer Experience and Translator Experience.

The best experience for Translators requires combining source strings into as few transifex resources as possible.
The best experience for Engineers requires splitting translation source files to fit within the modular architecture.

Combining the files during ``combine_translations``
---------------------------------------------------

Combining the string files to aid Translator Experience in the following manner:

Suppose we have two modules with one Localizable.strings file in each::

  Course/Course/en.lproj/Localizable.strings
    "COURSE_CONTAINER.VIDEOS" =  "Videos";
    "COURSE_CONTAINER.DATES" =  "Dates";
    "COURSE_CONTAINER.DISCUSSIONS" =  "Discussions";
    "COURSE_CONTAINER.HANDOUTS" =  "Handouts";
    "COURSE_CONTAINER.HANDOUTS_IN_DEVELOPING" =  "Handouts In developing";

    "HANDOUTS_CELL_HANDOUTS.TITLE" = "Handouts";
    "HANDOUTS_CELL_ANNOUNCEMENTS.TITLE" = "Announcements";

  Dashboard/Dashboard/en.lproj/Localizable.strings:
    "TITLE" = "Dashboard";
    "HEADER.COURSES" = "Courses";
    "HEADER.WELCOME_BACK" = "Welcome back. Let's keep learning.";

    "EMPTY.TITLE" = "It's empty";
    "EMPTY.SUBTITLE" = "You are not enrolled in any courses yet.";

This combine translations script will collect the strings, remove unneeded comments and combine them in a temporary
file while prefixing each entry with its module name. This will make splitting clear and
avoid collision in string IDs::

  I18N/I18N/en.lproj/Localizable.strings
    "COURSE.COURSE_CONTAINER.VIDEOS" =  "Videos";
    "COURSE.COURSE_CONTAINER.DATES" =  "Dates";
    "COURSE.COURSE_CONTAINER.DISCUSSIONS" =  "Discussions";
    "COURSE.COURSE_CONTAINER.HANDOUTS" =  "Handouts";
    "COURSE.COURSE_CONTAINER.HANDOUTS_IN_DEVELOPING" =  "Handouts In developing";
    "COURSE.HANDOUTS_CELL_HANDOUTS.TITLE" = "Handouts";
    "COURSE.HANDOUTS_CELL_ANNOUNCEMENTS.TITLE" = "Announcements";
    "DASHBOARD.TITLE" = "Dashboard";
    "DASHBOARD.HEADER.COURSES" = "Courses";
    "DASHBOARD.HEADER.WELCOME_BACK" = "Welcome back. Let's keep learning.";
    "DASHBOARD.EMPTY.TITLE" = "It's empty";
    "DASHBOARD.EMPTY.SUBTITLE" = "You are not enrolled in any courses yet.";

This combined file will be pushed to the `openedx-translations repository`_ as described in `OEP-58`_.

This process happens entirely on the CI server (GitHub in this case) after each pull request merge without developer
intervention.

Splitting the files after ``pull_translations``
-----------------------------------------------

After pulling the translations from the `openedx-translations repository`_ via `atlas pull`_, there will be a single
strings file for each language:

.. code::

  I18N/I18N/uk.lproj/Localizable.strings
  I18N/I18N/ar.lproj/Localizable.strings
  I18N/I18N/fr.lproj/Localizable.strings
  I18N/I18N/es-419.lproj/Localizable.strings

- The script will run through each module's ``en.lproj/Localizable.strings``
- Identify which entries in the app strings file are translated in the e.g. ``I18N/I18N/ar.lproj/Localizable.strings`` file.
- Create module strings file in the each module and put the strings that exists in the ``en.lproj/Localizable.strings`` file
- The automatic module name prefix that ``combine_translations`` script has added is removed

.. code::

  Course/Course/uk.lproj/Localizable.strings
  Course/Course/ar.lproj/Localizable.strings
  Course/Course/fr.lproj/Localizable.strings
  Course/Course/es-419.lproj/Localizable.strings
  ...
  Dashboard/Dashboard/uk.lproj/Localizable.strings
  Dashboard/Dashboard/ar.lproj/Localizable.strings
  Dashboard/Dashboard/fr.lproj/Localizable.strings
  Dashboard/Dashboard/es-419.lproj/Localizable.strings

This script should ensure that every entry in the source English file, should have an entry in the
translated files even if it has no translations. This will ensure app builds don't fail.


Python language for scripting
=============================
Python will be used in scripting the pull/push when needed.
This is in-line with the Theming tooling which is has been written in Python.


Alternatives
************
- Writing scripts in native languages such as Kotlin and Swift has been dismissed as per core team request.
- Pushing multiple strings file resources for each mobile app to the `openedx-translations repository`_ is
  dismissed to avoid having too many resources per mobile app in the Transifex project.
- Combining the strings files without a prefix is dismissed because it needs a dedicated validation script which
  could confuse the community contributors by adding a new rule to ensure no duplicate strings are found.

.. _OEP-58: https://docs.openedx.org/en/latest/developers/concepts/oep58.html
.. _openedx-translations repository: https://github.com/openedx/openedx-translations
.. _edx-platform: https://github.com/openedx/edx-platform
.. _atlas: https://github.com/openedx/openedx-atlas
.. _atlas pull: https://github.com/openedx/openedx-atlas?tab=readme-ov-file#usage
.. _edx-platform resources combination decision document: https://github.com/openedx/edx-platform/blob/master/docs/decisions/0018-standarize-django-po-files.rst
.. _GitHub Transifex app: https://github.com/apps/transifex-integration
.. _openedx-app-android: https://github.com/openedx/openedx-app-android
.. _openedx-app-ios: https://github.com/openedx/openedx-app-ios
.. _extract-translation-source-files.yml: https://github.com/openedx/openedx-translations/blob/2566e0c9a30d033e5dd8d05d4c12601c8e37b4ef/.github/workflows/extract-translation-source-files.yml
.. _Transifex openedx-translations project: https://app.transifex.com/open-edx/openedx-translations/content/
