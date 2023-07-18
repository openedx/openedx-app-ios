# This makefile exists to assist in setting up the repository for customization.
# The actual build of this project is performed through XCode.
.SILENT: whitelabel
whitelabel:
	if [ ! -f OpenEdx/Environment.swift ]; then cp OpenEdX/Environment.swift{.example,}; fi
	if [ ! -f Core/Core/Theme.swift ]; then cp Core/Core/Theme.swift{.example,}; fi
	rsync -r --ignore-existing OpenEdx/Assets.xcassets{.example/,}
	rsync -r --ignore-existing Core/Core/Assets.xcassets{.example/,}
	echo "Setup complete. Please customize the follwing files in XCode:"
	echo "    OpenEdX/Environment.swift   # Contains Oauth config for your server."
	echo "    OpenEdX/Assets.xcassets/    # Contains assets for iOS package metadata, such as icons."
	echo "    Core/Core/Assets.xcassets/  # Contains icons, images, and other theme assets."
	echo "    Core/Core/Theme.swift       # Contains theme metadata, such as font specifications."
