import argparse
import logging
import os
import shutil
import sys
import yaml
import json
import coloredlogs
from PIL import Image
import re

class WhitelabelApp:
    EXAMPLE_CONFIG_FILE = """
        ---
        # Notes:
        # Config file can contain next optins:
        import_dir: 'path/to/asset/Images' # folder where importing images are placed
        assets:
            AssetName:
                imagesPath: 'Theme/Theme/Assets.xcassets' # path where images are placed in this Asset
                colorsPath: 'Theme/Theme/Assets.xcassets/Colors' # path where colors are placed in this Asset
                iconPath: 'Theme/Assets.xcassets' # path where the app icon is placed in this Asset 
                images:
                    image1: # Asset name
                        imageName: 'some_image.svg' # image to replace the existing one for image1 Asset (light/universal)
                    image2: # Asset name
                        currentPath: 'SomeFolder' # Path to image2.imageset inside Assets.xcassets
                        imageName: 'Rectangle.png' # image to replace the existing one for image2 Asset (light/universal)
                        darkImageName: 'RectangleDark.png' # image to replace the existing dark appearance for image2 Asset (dark)
                colors:
                    LoginBackground: # color asset name in Assets
                        currentPath: '' # optional: path to color inside colorsPath
                        light: '#FFFFFF'
                        dark: '#ED5C13'
                icon:
                    AppIcon:
                        currentPath: ''  # optional: path to icon inside iconPath
                        imageName: 'appIcon.jpg'  # image to replace the current AppIcon - png or jpg are supported
        projectConfig:
            projectPath: 'path/to/project/project.pbxproj' # path to project.pbxproj file
            devTeam: '1234567890' # apple development team id
            appBundleID:
                configurations:
                    config1: # configuration name - can be any
                        from_id: "bundle.id.app.old" # bundle ID to be changed
                        to_id: "bundle.id.app.new" # bundle ID which should be set
        """

    def __init__(self, **kwargs):            
        self.assets_dir = kwargs.get('import_dir')
        if not self.assets_dir:
            self.assets_dir = '.'

        self.assets = kwargs.get('assets', {})
        self.project_config = kwargs.get('projectConfig', {})

        if "projectPath" in self.project_config:
            self.config_project_path = self.project_config["projectPath"]
        else:
            logging.error("Path to project file is not defined")
    
    def whitelabel(self):
        # Update the properties, resources, and configuration of the current app.
        self.copy_assets()
        self.set_app_project_config()

    def copy_assets(self):
        if self.assets:
            for asset in self.assets.items():
                self.replace_images(asset)
                self.replace_colors(asset)
                self.replace_app_icon(asset)
        else:
            logging.debug("Assets not found")

        

    def replace_images(self, assetData):
        asset = assetData[1]
        assetName = assetData[0]
        if "images" in asset :
            assetPath = asset["imagesPath"] if "imagesPath" in asset else ""
            for name, image in asset["images"].items():
                currentPath = image["currentPath"] if "currentPath" in image else ""
                path_to_imageset = os.path.join(assetPath, currentPath, name+'.imageset')
                content_json_path = os.path.join(path_to_imageset, 'Contents.json')
                imageNameOriginal = ''
                darkImageNameOriginal = ''
                with open(content_json_path, 'r') as openfile:
                    json_object = json.load(openfile)
                    for json_image in json_object["images"]:
                        if "appearances" in json_image:
                            # dark
                            darkImageNameOriginal = json_image["filename"]
                        else:
                            # light
                            imageNameOriginal = json_image["filename"]
                hasDark = True if "darkImageName" in image else False
                imageNameImport = image["imageName"] if "imageName" in image else ''
                darkImageNameImport =  image["darkImageName"] if "darkImageName" in image else ''
                
                # conditions to start updating
                file_path = os.path.join(path_to_imageset, imageNameOriginal)
                dark_file_path = os.path.join(path_to_imageset, darkImageNameOriginal)
                files_to_changes_exist = os.path.exists(file_path) and imageNameOriginal != '' # 1
                if hasDark:
                    files_to_changes_exist = files_to_changes_exist and os.path.exists(dark_file_path) and darkImageNameOriginal != ''
                contents_json_is_good = os.path.exists(content_json_path) and imageNameOriginal != '' # 2
                if hasDark:
                    contents_json_is_good = contents_json_is_good and darkImageNameOriginal != ''
                
                path_to_imageset_exists = os.path.exists(path_to_imageset) # 3
                file_to_copy_path = os.path.join(self.assets_dir, imageNameImport)
                dark_file_to_copy_path = os.path.join(self.assets_dir, darkImageNameImport)
                files_to_copy_exist = os.path.exists(file_to_copy_path) # 4
                if hasDark:
                    files_to_copy_exist = files_to_copy_exist and os.path.exists(dark_file_to_copy_path)

                if files_to_changes_exist and contents_json_is_good and path_to_imageset_exists and files_to_copy_exist:
                    # Delete current file(s)
                    os.remove(file_path)
                    if hasDark:
                        os.remove(dark_file_path)
                    # Change Contents.json
                    with open(content_json_path, 'r') as openfile:
                        contents_string = openfile.read()
                    contents_string = contents_string.replace(imageNameOriginal, imageNameImport)
                    if hasDark:
                        contents_string = contents_string.replace(darkImageNameOriginal, darkImageNameImport)
                    with open(content_json_path, 'w') as openfile:
                        openfile.write(contents_string)
                    # Copy new file(s)
                    shutil.copy(file_to_copy_path, path_to_imageset)
                    logging.debug(assetName+"->images->"+name+": 'light mode'/universal image was updated with "+imageNameImport)
                    if hasDark:
                        shutil.copy(dark_file_to_copy_path, path_to_imageset)
                        logging.debug(assetName+"->images->"+name+": 'dark mode' image was updated with "+darkImageNameImport)
                else:
                    # Handle errors
                    if not files_to_changes_exist:
                        logging.error(assetName+"->images->"+name+": original file(s) doesn't exist")
                    elif not contents_json_is_good:
                        logging.error(assetName+"->images->"+name+": Contents.json doesn't exist or wrong original file(s) in config")
                    elif not path_to_imageset_exists:
                        logging.error(assetName+"->images->"+name+": "+ path_to_imageset + " doesn't exist")
                    elif not files_to_copy_exist:
                        logging.error(assetName+"->images->"+name+": file(s) to copy doesn't exist")

    def replace_colors(self, assetData):
        asset = assetData[1]
        assetName = assetData[0]
        if "colors" in asset:
            colorsPath = asset["colorsPath"] if "colorsPath" in asset else ""
            for name, color in asset["colors"].items():
                currentPath = color["currentPath"] if "currentPath" in color else ""
                path_to_colorset = os.path.join(colorsPath, currentPath, name+'.colorset')
                light_color = color["light"]
                dark_color = color["dark"]
                # Change Contents.json
                content_json_path = os.path.join(path_to_colorset, 'Contents.json')
                if os.path.exists(content_json_path):
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
                    logging.debug(assetName+"->colors->"+name+": color was updated with light:'"+light_color+"' dark:'"+dark_color+"'")
                else:
                    logging.error(assetName+"->colors->"+name+": " + content_json_path + " doesn't exist")

    def change_color_components(self, components, color, name):
        color = color.replace("#", "")
        if len(color) != 6: 
            print('Config for color "'+name+'" is incorrect')
        else:
            components["red"] = "0x"+color[0]+color[1]
            components["green"] = "0x"+color[2]+color[3]
            components["blue"] = "0x"+color[4]+color[5]
        return components
    
    def replace_app_icon(self, assetData):
        asset = assetData[1]
        assetName = assetData[0]
        if "icon" in asset:
            iconPath = asset["iconPath"] if "iconPath" in asset else ""
            for name, icon in asset["icon"].items():
                currentPath = icon["currentPath"] if "currentPath" in icon else ""
                path_to_iconset = os.path.join(iconPath, currentPath, name+'.appiconset')
                content_json_path = os.path.join(path_to_iconset, 'Contents.json')
                with open(content_json_path, 'r') as openfile:
                    json_object = json.load(openfile)
                    json_icon = json_object["images"][0]
                    file_to_change = json_icon["filename"]
                    size_to_change = json_icon["size"]
                file_to_copy = icon["imageName"]
                file_to_copy_path = os.path.join(self.assets_dir, file_to_copy)
                file_to_change_path = os.path.join(path_to_iconset, file_to_change)
                if os.path.exists(file_to_change_path):
                    if os.path.exists(file_to_copy_path):
                        # get new file width and height
                        img = Image.open(file_to_copy_path)
                        # get width and height 
                        width = img.width 
                        height = img.height
                        # Delete current file
                        os.remove(file_to_change_path)
                        # Change Contents.json
                        with open(content_json_path, 'r') as openfile:
                            contents_string = openfile.read()
                        contents_string = contents_string.replace(file_to_change, file_to_copy)
                        contents_string = contents_string.replace(size_to_change, str(width)+'x'+str(height))
                        with open(content_json_path, 'w') as openfile:
                            openfile.write(contents_string)
                        # Copy new file
                        shutil.copy(file_to_copy_path, path_to_iconset)
                        logging.debug(assetName+"->icon->"+name+": 'app icon was updated with "+file_to_copy)
                    else:
                        logging.error(assetName+"->icon->"+name+": " + file_to_copy_path + " doesn't exist")    
                else:
                    logging.error(assetName+"->icon->"+name+": " + file_to_change_path + " doesn't exist")

    def set_app_project_config(self):
        self.set_app_bundle_ids()
        self.set_dev_team()


    def set_app_bundle_ids(self):
        if "appBundleID" in self.project_config:
            app_bundle_id = self.project_config["appBundleID"]
            # read project file
            with open(self.config_project_path, 'r') as openfile:
                config_file_string = openfile.read()
            errors_texts = []
            for name, config in app_bundle_id["configurations"].items():
                # if from_id and to_id are configured
                if "from_id" in config and "to_id" in config:
                    from_id = config["from_id"]
                    from_id_string = "PRODUCT_BUNDLE_IDENTIFIER = "+from_id+";"
                    to_id = config["to_id"]
                    to_id_string = "PRODUCT_BUNDLE_IDENTIFIER = "+to_id+";"
                    if to_id != '':
                        # if from_id is in project file
                        if from_id_string in config_file_string:
                            config_file_string = config_file_string.replace(from_id_string, to_id_string)
                        # else if to_id is not set already
                        elif to_id_string not in config_file_string:
                            errors_texts.append("appBundleID->configurations->"+name+": bundle id '"+from_id+"' was not found in project")
                    else:
                        errors_texts.append("appBundleID->configurations->"+name+": 'to_id' parameter is empty in config")
                else:
                    errors_texts.append("appBundleID->configurations->"+name+": bundle ids were not found in config")
            # write to project file
            with open(self.config_project_path, 'w') as openfile:
                openfile.write(config_file_string)
            # print success message or errors if are presented
            if len(errors_texts) == 0:
                logging.debug("Bundle ids were successfully changed")
            else:
                for error in errors_texts:
                    logging.error(error)
        else:
            logging.error("Bundle ids config is not defined")       
    
    def set_dev_team(self):
        if "devTeam" in self.project_config:
            devTeam = self.project_config["devTeam"]
            if devTeam != '':
                # read project file
                with open(self.config_project_path, 'r') as openfile:
                    config_file_string = openfile.read()
                config_file_string_out = re.sub('DEVELOPMENT_TEAM = .{10};','DEVELOPMENT_TEAM = '+devTeam+';', config_file_string)
                # if any entries were found and replaced
                if config_file_string_out != config_file_string:
                    # write to project file
                    with open(self.config_project_path, 'w') as openfile:
                        openfile.write(config_file_string_out)
                    logging.debug("Dev Team was set successfuly")
                else:
                    logging.error("No dev Team is found in project file")
            else:
                logging.error("Dev Team is empty in config")
        else:
            logging.error("Dev Team is not defined")       


        
def main():
    """
    Parse the command line arguments, and pass them to WhitelabelApp.
    """
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--help-config-file', action='store_true', help="Print out a sample config-file, and exit")
    parser.add_argument('--config-file', '-c', help="Path to the configuration file")
    parser.add_argument('--verbose', '-v', action='count', help="Enable verbose logging.")
    args = parser.parse_args()

    if args.help_config_file:
        print(WhitelabelApp.EXAMPLE_CONFIG_FILE)
        sys.exit(0)

    if not args.config_file:
        parser.print_help()
        sys.exit(1)

    if args.verbose is None:
        args.verbose = 0
    log_level = logging.WARN
    if args.verbose > 0:
        log_level = logging.DEBUG
    logging.basicConfig(level=log_level)
    logger = logging.getLogger(name='whitelabel_config')
    coloredlogs.install(level=log_level, logger=logger)

    with open(args.config_file) as f:
        config = yaml.safe_load(f) or {}

    # Use the config_file's directory as the default config_dir
    config.setdefault('config_dir', os.path.dirname(args.config_file))

    whitelabeler = WhitelabelApp(**config)
    whitelabeler.whitelabel()


if __name__ == "__main__":
    main()
            