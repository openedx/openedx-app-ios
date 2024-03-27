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

Microservices, micro-frontends, XBlocks and plugins use as few translation files as possible to makes it easier for Translators
to locate and translate relevant resources.

`edx-platform`_ translations strings used to be split between 7 files, but this has been deprecated in favor of
``edx-platform.po`` and ``edx-platform-js.po`` files.
More details are available in the `edx-platform resources combination decision document`_.

The `openedx-app-ios`_ uses a clean architecture. Therefore, each clean architecture module has its own i18n
localizable strings file. This is useful for Developer Experience.
However, it's not good for Translator Experience because translators
often are unaware of the application engineering architecture and would like to be able to quickly search for strings
regardless of their location in the code.

Decision
********

This decision requires a few changes to the mobile app translation workflow:

- Translation files are no longer comitted directly to the mobie app repositories (`openedx-app-ios`_ / `openedx-app-android`_)
- Keep the i18n string files split into each module without hurting Developer Experience.
- String files are combined into a single file before uploading it to Transifex
  (through the `openedx-translations repository`_)
- Translators can translate the entire app within a single transifex resource
- Before releasing to App Store, developers need to run a new ``make pull_translations`` command
- After translations are pulled the translation files are split into each module
  as if it has been individual resource (a new script)


String file combination and splitting process
=============================================
This is a new process that's being introduced to have the best combination
of Developer Experience and Translator Experience.

Translators need to have less resources as possible,
while Engineers need to have clean architecture with strings split into each app to aid maintainability.

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
