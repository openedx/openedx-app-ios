import argparse
import logging
import os
import shutil
import subprocess
import sys
import yaml
import json

class WhitelabelApp:
    def __init__(self, **kwargs):
        EXAMPLE_CONFIG_FILE = """
        ---
        # Notes:
        # Config file can contain next optins:

        assets:
            images:
                image1: # Asset name
                    imageName: 'some_image.svg' # image file name in Assets.xcassets/image1.imageset
                    imageNameImport: 'new_image.pdf' # optional: image to replace imageName, placed in Config. Don't need if file name is the same
                image2: # Asset name
                    currentPath: 'SomeFolder' # Path to image2.imageset inside Assets.xcassets
                    imageName: 'Rectangle.png' # image file name in Assets.xcassets/SomeFolder/image2.imageset
                    darkImageName: 'RectangleDark.png' # image file name for dark appearance in Assets.xcassets/SomeFolder/image2.imageset
                    darkImageNameImport: 'NewDarkRectangle.png' # optional: image to replace darkImageName, placed in Config. Don't need if file name is the same
            colors:
                LoginBackground: # color asset name in Assets
                    light: '#FFFFFF'
                    dark: '#ED5C13'
        """
            
        self.project_assets = kwargs.get('project_assets')
        if not self.project_assets:
            self.project_assets = '.'

        self.assets_dir = kwargs.get('assets_dir')
        if not self.assets_dir:
            self.assets_dir = '.'

        self.assets = kwargs.get('assets', {})
    
    def whitelabel(self):
        # Update the properties, resources, and configuration of the current app.
        # self.update_plist()
        self.copy_assets()

    def copy_assets(self):
        self.replace_images()
        self.replace_colors()

    def replace_images(self):
        if self.assets:
            for name, image in self.assets["images"].items():
                currentPath = image["currentPath"] if "currentPath" in image else ""
                hasDark = True if "darkImageName" in image else False
                imageName = image["imageName"]
                imageNameImport = image["imageNameImport"] if "imageNameImport" in image else imageName
                darkImageName = image["darkImageName"] if "darkImageName" in image else ""
                darkImageNameImport =  image["darkImageNameImport"] if "darkImageNameImport" in image else darkImageName
                path_to_imageset = os.path.join(self.project_assets, currentPath, name+'.imageset')
                # Delete current file(s)
                file_path = os.path.join(path_to_imageset, imageName)
                if os.path.exists(file_path):
                    os.remove(file_path)
                if hasDark:
                    dark_file_path = os.path.join(path_to_imageset, darkImageName)
                    if os.path.exists(dark_file_path):
                        os.remove(dark_file_path)
                # Change Contents.json
                content_json_path = os.path.join(path_to_imageset, 'Contents.json')
                with open(content_json_path, 'r') as openfile:
                    contents_string = openfile.read()
                contents_string = contents_string.replace(imageName, imageNameImport)
                if hasDark:
                    contents_string = contents_string.replace(darkImageName, darkImageNameImport)
                with open(content_json_path, 'w') as openfile:
                    openfile.write(contents_string)
                # Copy new file(s)
                file_to_copy_path = os.path.join(self.assets_dir, imageNameImport)
                shutil.copy(file_to_copy_path, path_to_imageset)
                if hasDark:
                    dark_file_to_copy_path = os.path.join(self.assets_dir, darkImageNameImport)
                    shutil.copy(dark_file_to_copy_path, path_to_imageset)
        else:
            logging.debug("No assets to copy to %s", self.project_assets)

    def replace_colors(self):
        if self.assets:
            for name, color in self.assets["colors"].items():
                currentPath = color["currentPath"] if "currentPath" in color else ""
                path_to_colorset = os.path.join(self.project_assets, 'Colors', currentPath, name+'.colorset')
                light_color = color["light"]
                dark_color = color["dark"]
                # Change Contents.json
                content_json_path = os.path.join(path_to_colorset, 'Contents.json')
                with open(content_json_path, 'r') as openfile:
                    json_object = json.load(openfile)
                    for key in range(len(json_object["colors"])):
                        if "appearances" in json_object["colors"][key]:
                            # dark
                            changed_components = self.change_color_components(json_object["colors"][key]["color"]["components"], dark_color, name)
                            json_object["colors"][key]["color"]["components"] = changed_components
                        else:
                            # light
                            changed_components = self.change_color_components(json_object["colors"][key]["color"]["components"], light_color, name)
                            json_object["colors"][key]["color"]["components"] = changed_components
                    new_json = json.dumps(json_object) 
                with open(content_json_path, 'w') as openfile:
                    openfile.write(new_json)
        else:
            logging.debug("No assets to copy to %s", self.project_assets)

    def change_color_components(self, components, color, name):
        color = color.replace("#", "")
        if len(color) != 6: 
            print('Config for color "'+name+'" is incorrect')
        else:
            components["red"] = "0x"+color[0]+color[1]
            components["green"] = "0x"+color[2]+color[3]
            components["blue"] = "0x"+color[4]+color[5]
        return components
        
def main():
    """
    Parse the command line arguments, and pass them to WhitelabelApp.
    """
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--help-config-file', action='store_true', help="Print out a sample config-file, and exit")
    parser.add_argument('--config-file', '-c', help="Path to the configuration file")
    parser.add_argument('--verbose', '-v', action='count', help="Enable verbose logging. Repeat -v for more output.")
    args = parser.parse_args()

    # DEBUG VARS
    # args.config_file = "whitelabel.yaml"
    # args.verbose = 2

    if args.help_config_file:
        print(WhitelabelApp.EXAMPLE_CONFIG_FILE)
        sys.exit(0)

    if not args.config_file:
        parser.print_help()
        sys.exit(1)

    log_level = logging.WARN
    if args.verbose > 0:
        log_level = logging.INFO
    if args.verbose > 1:
        log_level = logging.DEBUG
    logging.basicConfig(level=log_level)

    with open(args.config_file) as f:
        config = yaml.safe_load(f) or {}

    # Use the config_file's directory as the default config_dir
    config.setdefault('config_dir', os.path.dirname(args.config_file))

    whitelabeler = WhitelabelApp(**config)
    whitelabeler.whitelabel()


if __name__ == "__main__":
    main()
            