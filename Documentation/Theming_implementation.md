# Theming Implementation
This documentation provides instructions on how to implement Theme assets for the OpenEdX iOS project.

## Python dependecies 
The `whitelabel.py` theming script requires the following Python dependencies to be installed:
- `pip install coloredlogs`
- `pip install pillow`
- `pip install pyyaml`

## How to Run the Script
The theming script `whitelabel.py` can be ran from the OpenEdX iOS root project folder with the following command:
```bash
python config_script/whitelabel.py --config-file=path/to/configfile/whitelabel.yaml -v
```
Where 
- `config_script/whitelabel.py` is the path to the `whitelabel.py` script.
- `--config-file=path/to/configfile/whitelabel.yaml`  is the path to the configuration file `whitelabel.yaml`
- `-v` sets the log level.

## Config Options
The config file `whitelabel.yaml` can be created by yourself or obtained from some config repo.
This config can contain the following options:
### Folder with source assets
This is the folder where all image assets, which should be copied into the project, are placed:
```yaml
import_dir: 'path/to/images/source'
```
### Xcode Project Settings
The theming script can change the app name, version, development team and app bundle ID:
```yaml
project_config:
    project_path: 'path/to/project/project.pbxproj' # path to project.pbxproj file
    dev_team: '1234567890' # Apple development team ID
    marketing_version: '1.0.1' # App marketing version
    current_project_version: '2' # App build number
    configurations:
        config1: # Configuration name - can be any
            app_bundle_id: "bundle.id.app.new" # Bundle ID to be set
            product_name: "Mobile App Name" # App Name to be set
```
### Assets
The config `whitelabel.yaml` can contain a few Asset items (every added Xcode project can have its own Assets). 
Every Asset item can be configured with images, colors, and app Icon Assets:
```yaml
assets:
    AssetName:
        images_path: 'Theme/Theme/Assets.xcassets' # path where images are placed in this Asset
        colors_path: 'Theme/Theme/Assets.xcassets/Colors' # path where colors are placed in this Asset
        icon_path: 'Theme/Assets.xcassets' # path where app icon is placed in this Asset 
        images:
            image1: # Asset name
                image_name: 'some_image.svg' # image to replace the existing one for image1 Asset (light/universal)
            image2: # Asset name
                current_path: 'SomeFolder' # Path to image2.imageset inside Assets.xcassets
                image_name: 'Rectangle.png' # image to replace the existing one for image2 Asset (light/universal)
                dark_image_name: 'RectangleDark.png' # image to replace the existing dark appearance for image2 Asset (dark)
        colors:
            LoginBackground: # color asset name in Assets
                current_path: '' # optional: path to color inside colors_path
                light: '#FFFFFF'
                dark: '#ED5C13'
        icon:
            AppIcon:
                current_path: '' # optional: path to icon inside icon_path
                image_name: 'appIcon.jpg' # image to replace the current AppIcon - png or jpg are supported
```
### Log level
You can set the log level to 'DEBUG' by adding the `-v` parameter to the script running.
The default log level is 'WARN'
## 