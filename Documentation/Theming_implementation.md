# Theming Implementation
This documentation provides instructions on how to implement Theme assets for the OpenEdX iOS project.

## Python dependecies 
The `whitelabel.py` theming script requires the following Python dependencies to be installed:
- `pip3 install coloredlogs`
- `pip3 install pillow`
- `pip3 install pyyaml`

## How to Run the Script
The theming script `whitelabel.py` can be run from the OpenEdX iOS root project folder with the following command:
```bash
python3 config_script/whitelabel.py --config-file=path/to/configfile/whitelabel.yaml -v
```
where 
- `config_script/whitelabel.py` is the path to the `whitelabel.py` script
- `--config-file=path/to/configfile/whitelabel.yaml`  is the path to the configuration file `whitelabel.yaml`
- `-v` sets the log level (all messages if '-v' is present and errors only if is not).

## Example of whitelabel.yaml
You can get example of `whitelabel.yaml` file by run next command:
```bash
python3 config_script/whitelabel.py --help-config-file
```
Just copy script's output to your `whitelabel.yaml` file.

## Config Options
The config file `whitelabel.yaml` can be created by yourself or obtained from some config repo.
This config can contain the following options:
### Folder with source assets
This is the folder where all image assets, which should be copied into the project, are placed (can be relative or absolute):
```yaml
images_import_dir: 'path/to/images/source'
```
### Xcode Project Settings
The theming script can change the app name, version, development team and app bundle ID:
```yaml
project_config:
    project_path: 'path/to/project/project.pbxproj' # path to project.pbxproj file
    dev_team: '1234567890' # Apple development team ID
    project_extra_targets: ['Target1', 'Target2'] # targets in the workspace other than 'OpenEdX' in which the new dev_team should be set
    marketing_version: '1.0.1' # App marketing version
    current_project_version: '2' # App build number
    configurations:
        config1: # Build Configuration name in project
            app_bundle_id: "bundle.id.app.new1" # Bundle ID to be set
            product_name: "Mobile App Name1" # App Name to be set
            env_config: 'prod' # env name for this configuration. possible values: prod/dev/stage (values which config_settings.yaml defines)
        config2: # Build Configuration name in project
            app_bundle_id: "bundle.id.app.new2" # Bundle ID to be set
            product_name: "Mobile App Name2" # App Name to be set
            env_config: 'dev' # env name for this configuration. possible values: prod/dev/stage (values which config_settings.yaml defines)
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
                alpha_light: '0.4' # optional: alpha value for light color, from 0.0 to 1.0. Can be a number, not a string
                alpha_dark: '0.2' # optional: alpha value for dark color, from 0.0 to 1.0. Can be a number, not a string
                alpha: '0.5' # optional: alpha value for both light and dark colors, from 0.0 to 1.0. Can be a number, not a string
        icon:
            AppIcon:
                current_path: '' # optional: path to icon inside icon_path
                image_name: 'appIcon.jpg' # image to replace the current AppIcon - png or jpg are supported
```

### Font
The `whitelabel.yaml` configuration may contain the path to a font file, and an existing font in the project will be replaced with this font. 
This ttf file must contain multiple ttf fonts "merged" into a single ttf file. Font types used in the application:
- light
- regular
- medium
- semiBold
- bold

For this function, the configuration must contain the following parameters:
```yaml
font:
    font_import_file_path: 'path/to/importing/Font_file.ttf' # path to ttf font file what should be imported to project
    project_font_file_path: 'path/to/font/file/in/project/font.ttf' # path to existing ttf font file in project
    project_font_names_json_path: 'path/to/names/file/in project/fonts.json' # path to existing font names json-file in project
    font_names:
        light: 'FontName-Light'
        regular: 'FontName-Regular'
        medium: 'FontName-Medium'
        semiBold: 'FontName-Semibold'
        bold: 'FontName-Bold'
```

### Files
We can override any file(s) in the project folder(s). To do this, the `whitelabel.yaml` configuration must contain the path to the file to be imported, and the existing file in the project will be replaced with this file. 

For this function, the configuration must contain the following parameters:
```yaml
files:
    file_name:
        import_file_path: 'path/to/importing/file_name.any' # path to file what should be imported to project folder
        project_file_path: 'path/to/json/file/in/project/file_name.any' # path to existing file in project
```


### Log level
You can set the log level to 'DEBUG' by adding the `-v` parameter to the script running.
The default log level is 'WARN'
## 
