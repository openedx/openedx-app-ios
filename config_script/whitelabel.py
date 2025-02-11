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
from textwrap import dedent
from process_config import PlistManager  # type: ignore

class WhitelabelApp:
    EXAMPLE_CONFIG_FILE = dedent("""
    # Notes:
    # Config file can contain next options:
    images_import_dir: 'path/to/asset/Images' # folder where importing images are placed
    assets:
      AssetName:
        images_path: 'Theme/Theme/Assets.xcassets' # path where images are placed in this Asset
        colors_path: 'Theme/Theme/Assets.xcassets/Colors' # path where colors are placed in this Asset
        icon_path: 'Theme/Assets.xcassets' # path where the app icon is placed in this Asset 
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
            current_path: ''  # optional: path to icon inside icon_path
            image_name: 'appIcon.jpg'  # image to replace the current AppIcon - png or jpg are supported
    project_config:
      project_path: 'path/to/project/project.pbxproj' # path to project.pbxproj file
      dev_team: '1234567890' # apple development team id
      project_extra_targets: ['Target1', 'Target2'] # targets in the workspace other than 'OpenEdX' in which the new dev_team should be set
      marketing_version: '1.0.1' # app marketing version
      current_project_version: '2' # app build number
      configurations:
        config1: # build configuration name in project
          app_bundle_id: "bundle.id.app.new1" # bundle ID which should be set
          product_name: "Mobile App Name1" # app name which should be set
          env_config: 'prod' # env name for this configuration. possible values: prod/dev/stage (values which config_settings.yaml defines)
        config2: # build configuration name in project
          app_bundle_id: "bundle.id.app.new2" # bundle ID which should be set
          product_name: "Mobile App Name2" # app name which should be set
          env_config: 'dev' # env name for this configuration. possible values: prod/dev/stage (values which config_settings.yaml defines)
    font:
      font_import_file_path: 'path/to/importing/Font_file.ttf' # path to ttf font file what should be imported to project
      project_font_file_path: 'path/to/font/file/in/project/font.ttf' # path to existing ttf font file in project
      project_font_names_json_path: 'path/to/names/file/in project/fonts.json' # path to existing font names json-file in project
      font_names:
        light: 'SFPro-Light'
        regular: 'FontName-Regular'
        medium: 'FontName-Medium'
        semiBold: 'FontName-Semibold'
        bold: 'FontName-Bold'
    files:
      file_name:
        import_file_path: 'path/to/importing/file_name.any'
        project_file_path: 'path/to/json/file/in/project/file_name.any'
    """)

    def __init__(self, **kwargs):            
        self.assets_dir = kwargs.get('images_import_dir')
        if not self.assets_dir:
            self.assets_dir = '.'

        self.assets = kwargs.get('assets', {})
        self.project_config = kwargs.get('project_config', {})
        self.font = kwargs.get('font', {})
        self.files = kwargs.get('files', {})

        if self.project_config:
            if "project_path" in self.project_config:
                self.config_project_path = self.project_config["project_path"]
            else:
                logging.error("Path to project file is not defined")
        else:
            logging.debug("Project settings config not found")
    
    def whitelabel(self):
        # Update the properties, resources, and configuration of the current app.
        self.copy_assets()
        self.copy_font()
        self.copy_project_files()
        if self.project_config:
            self.set_app_project_config()
        self.set_flags_from_mobile_config()

    def copy_assets(self):
        if self.assets:
            for asset in self.assets.items():
                self.replace_images(asset)
                self.replace_colors(asset)
                self.replace_app_icon(asset)
        else:
            logging.debug("Assets config not found")

    def replace_images(self, asset_data):
        asset = asset_data[1]
        asset_name = asset_data[0]
        if "images" in asset :
            asset_path = asset["images_path"] if "images_path" in asset else ""
            for name, image in asset["images"].items():
                current_path = image["current_path"] if "current_path" in image else ""
                path_to_imageset = os.path.join(asset_path, current_path, name+'.imageset')
                content_json_path = os.path.join(path_to_imageset, 'Contents.json')
                image_name_original = ''
                dark_image_name_original = ''
                with open(content_json_path, 'r') as openfile:
                    json_object = json.load(openfile)
                    for json_image in json_object["images"]:
                        if "appearances" in json_image:
                            # dark
                            if "filename" in json_image:
                                dark_image_name_original = json_image["filename"]
                        else:
                            # light
                            if "filename" in json_image:
                                image_name_original = json_image["filename"]
                has_dark = True if "dark_image_name" in image else False
                image_name_import = image["image_name"] if "image_name" in image else ''
                dark_image_name_import =  image["dark_image_name"] if "dark_image_name" in image else ''
                
                # conditions to start updating
                file_path = os.path.join(path_to_imageset, image_name_original)
                dark_file_path = os.path.join(path_to_imageset, dark_image_name_original)
                files_to_changes_exist = os.path.exists(file_path) and image_name_original != '' # 1
                if has_dark:
                    files_to_changes_exist = files_to_changes_exist and os.path.exists(dark_file_path) and dark_image_name_original != ''
                contents_json_is_good = os.path.exists(content_json_path) and image_name_original != '' # 2
                if has_dark:
                    contents_json_is_good = contents_json_is_good and dark_image_name_original != ''
                
                path_to_imageset_exists = os.path.exists(path_to_imageset) # 3
                file_to_copy_path = os.path.join(self.assets_dir, image_name_import)
                dark_file_to_copy_path = os.path.join(self.assets_dir, dark_image_name_import)
                files_to_copy_exist = os.path.exists(file_to_copy_path) # 4
                if has_dark:
                    files_to_copy_exist = files_to_copy_exist and os.path.exists(dark_file_to_copy_path)

                if files_to_changes_exist and contents_json_is_good and path_to_imageset_exists and files_to_copy_exist:
                    # Delete current file(s)
                    os.remove(file_path)
                    if has_dark:
                        os.remove(dark_file_path)
                    # Change Contents.json
                    with open(content_json_path, 'r') as openfile:
                        contents_string = openfile.read()
                    contents_string = contents_string.replace(image_name_original, image_name_import)
                    if has_dark:
                        contents_string = contents_string.replace(dark_image_name_original, dark_image_name_import)
                    with open(content_json_path, 'w') as openfile:
                        openfile.write(contents_string)
                    # Copy new file(s)
                    shutil.copy(file_to_copy_path, path_to_imageset)
                    logging.debug(asset_name+"->images->"+name+": 'light mode'/universal image was updated with "+image_name_import)
                    if has_dark:
                        shutil.copy(dark_file_to_copy_path, path_to_imageset)
                        logging.debug(asset_name+"->images->"+name+": 'dark mode' image was updated with "+dark_image_name_import)
                else:
                    # Handle errors
                    if not files_to_changes_exist:
                        logging.error(asset_name+"->images->"+name+": original file(s) doesn't exist")
                    elif not contents_json_is_good:
                        logging.error(asset_name+"->images->"+name+": Contents.json doesn't exist or wrong original file(s) in config")
                    elif not path_to_imageset_exists:
                        logging.error(asset_name+"->images->"+name+": "+ path_to_imageset + " doesn't exist")
                    elif not files_to_copy_exist:
                        logging.error(asset_name+"->images->"+name+": file(s) to copy doesn't exist")

    def replace_colors(self, asset_data):
        asset = asset_data[1]
        asset_name = asset_data[0]
        if "colors" in asset:
            colors_path = asset["colors_path"] if "colors_path" in asset else ""
            for name, color in asset["colors"].items():
                current_path = color["current_path"] if "current_path" in color else ""
                path_to_colorset = os.path.join(colors_path, current_path, name+'.colorset')
                light_color = color["light"]
                dark_color = color["dark"]
                alpha = str(color["alpha"]) if "alpha" in color else None
                alpha_light = str(color["alpha_light"]) if "alpha_light" in color else alpha
                alpha_dark = str(color["alpha_dark"]) if "alpha_dark" in color else alpha
                # Change Contents.json
                content_json_path = os.path.join(path_to_colorset, 'Contents.json')
                if os.path.exists(content_json_path):
                    with open(content_json_path, 'r') as openfile:
                        json_object = json.load(openfile)
                        for key in range(len(json_object["colors"])):
                            if "appearances" in json_object["colors"][key]:
                                # dark
                                changed_components = self.change_color_components(json_object["colors"][key]["color"]["components"], dark_color, name, alpha_dark)
                                json_object["colors"][key]["color"]["components"] = changed_components
                            else:
                                # light
                                changed_components = self.change_color_components(json_object["colors"][key]["color"]["components"], light_color, name, alpha_light)
                                json_object["colors"][key]["color"]["components"] = changed_components
                        new_json = json.dumps(json_object) 
                    with open(content_json_path, 'w') as openfile:
                        openfile.write(new_json)
                    logging.debug(asset_name+"->colors->"+name+": color was updated with light:'"+light_color+"' dark:'"+dark_color+"'")
                else:
                    logging.error(asset_name+"->colors->"+name+": " + content_json_path + " doesn't exist")

    def change_color_components(self, components, color, name, alpha):
        color = color.replace("#", "")
        if len(color) != 6: 
            print('Config for color "'+name+'" is incorrect')
        else:
            components["red"] = "0x"+color[0]+color[1]
            components["green"] = "0x"+color[2]+color[3]
            components["blue"] = "0x"+color[4]+color[5]
            if alpha is not None:
                components["alpha"] = alpha
        return components
    
    def replace_app_icon(self, asset_data):
        asset = asset_data[1]
        asset_name = asset_data[0]
        if "icon" in asset:
            icon_path = asset["icon_path"] if "icon_path" in asset else ""
            for name, icon in asset["icon"].items():
                current_path = icon["current_path"] if "current_path" in icon else ""
                path_to_iconset = os.path.join(icon_path, current_path, name+'.appiconset')
                content_json_path = os.path.join(path_to_iconset, 'Contents.json')
                with open(content_json_path, 'r') as openfile:
                    json_object = json.load(openfile)
                    json_icon = json_object["images"][0]
                    file_to_change = json_icon["filename"]
                    size_to_change = json_icon["size"]
                file_to_copy = icon["image_name"]
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
                        logging.debug(asset_name+"->icon->"+name+": app icon was updated with "+file_to_copy)
                    else:
                        logging.error(asset_name+"->icon->"+name+": " + file_to_copy_path + " doesn't exist")    
                else:
                    logging.error(asset_name+"->icon->"+name+": " + file_to_change_path + " doesn't exist")

    def set_app_project_config(self):
        self.set_build_related_params()
        self.set_project_global_params()

    def set_build_related_params(self):
        # check if configurations exist
        if "configurations" in self.project_config:
            configurations = self.project_config["configurations"]
            # read project file
            with open(self.config_project_path, 'r') as openfile:
                config_file_string = openfile.read()
            errors_texts = []
            for name, config in configurations.items():
                # replace parameters for every config
                config_file_string = self.replace_parameter_in_config("app_bundle_id", config_file_string, config, name, errors_texts)
                config_file_string = self.replace_parameter_in_config("product_name", config_file_string, config, name, errors_texts)
            # write to project file
            with open(self.config_project_path, 'w') as openfile:
                openfile.write(config_file_string)
            # print success message or errors if are presented
            if len(errors_texts) == 0:
                logging.debug("Project configurations parameters were successfully changed")
            else:
                for error in errors_texts:
                    logging.error(error)
        else:
            logging.error("Project configurations are not defined")

    def replace_parameter_in_config(self, parameter, config_file_string, config, config_name, errors_texts):
        # if parameter is configured
        if parameter in config:
            parameter_value = config[parameter]
            #  if parameter's value is not empty
            if parameter_value != '' and parameter_value is not None:
                parameter_string = ''
                parameter_regex = ''
                # define regex rule and replacement string for every possible parameter
                if parameter == "app_bundle_id":
                    parameter_string = "PRODUCT_BUNDLE_IDENTIFIER = "+parameter_value+";"
                    parameter_regex = "PRODUCT_BUNDLE_IDENTIFIER = .*;"
                elif parameter == "product_name":
                    parameter_string = "PRODUCT_NAME = \""+parameter_value+"\";"
                    parameter_regex = "PRODUCT_NAME = \".*\";"
                # if regex is defined
                if parameter_regex != '':
                    # replace parameter in config file
                    config_file_string = self.replace_parameter_for_build_config(config_file_string, config_name, parameter_string, parameter_regex, errors_texts)
                else:
                    errors_texts.append("project_config->configurations->"+config_name+": Regex rule for '"+parameter+"' is not defined in config script")
            else:
                errors_texts.append("project_config->configurations->"+config_name+": '"+parameter+"' parameter is empty in config")
        else:
            errors_texts.append("project_config->configurations->"+config_name+": '"+parameter+"' was not found in config")
        return config_file_string
    
    def replace_parameter_for_build_config(self, config_file_string, config_name, new_param_string, search_param_regex, errors_texts):
        # search substring for current build config only 
        search_string = re.search(self.regex_string_for_build_config(config_name), config_file_string)
        # if build config is found
        if search_string is not None:
            # get build config as string
            config_string = search_string.group()
            config_string_out = config_string
            # search parameter in config_string
            parameter_search_string = re.search(search_param_regex, config_string)
            if parameter_search_string is not None:
                # get parameter_string as string
                parameter_string = parameter_search_string.group()
                # replace existing parameter value with new value
                config_string_out = config_string.replace(parameter_string, new_param_string)
            else:
                errors_texts.append(config_name+": Check regex please. Can't find place in project file where place '"+new_param_string+"'")
            # if something found
            if config_string != config_string_out:
                config_file_string = config_file_string.replace(config_string, config_string_out)
        else:
            errors_texts.append(config_name+": not found in project file")
        return config_file_string

    def regex_string_for_build_config(self, build_config):
        # regex to search build config inside project file
        return f"/\\* {build_config} \\*/ = {{\n\t\t\tisa = XCBuildConfiguration;\n\t\t\tbaseConfigurationReference = [\\s|\\S]*\t\t\tname = {build_config};"
    
    def set_project_global_params(self):
        # set values for 'global' parameters
        self.set_global_parameter("dev_team")
        self.set_global_parameter("marketing_version")
        self.set_global_parameter("current_project_version")
        self.set_team_for_extra_targets()

    def set_global_parameter(self, parameter):
        # if parameter is defined in config
        if parameter in self.project_config:
            parameter_value = self.project_config[parameter]
            # if parameter value is not empty
            if parameter_value != '' and parameter_value is not None:
                # read project file
                with open(self.config_project_path, 'r') as openfile:
                    config_file_string = openfile.read()
                config_file_string_out = config_file_string
                parameter_string = ''
                parameter_regex = ''
                # define regex rule and replacement string for every possible parameter
                if parameter == "dev_team":
                    parameter_string = 'DEVELOPMENT_TEAM = '+parameter_value+';'
                    parameter_regex = 'DEVELOPMENT_TEAM = (.{10}|\"\");'
                elif parameter == "marketing_version":
                    parameter_string = 'MARKETING_VERSION = '+parameter_value+';'
                    parameter_regex = 'MARKETING_VERSION = .*;'
                elif parameter == "current_project_version":
                    parameter_string = 'CURRENT_PROJECT_VERSION = '+parameter_value+';'
                    parameter_regex = 'CURRENT_PROJECT_VERSION = .*;'
                # if regex is defined
                if parameter_regex != '':
                    # replace all regex findings with new parameters string
                    config_file_string_out = re.sub(parameter_regex, parameter_string, config_file_string)
                else:
                    logging.error("Regex rule for '"+parameter+"' is not defined in config script")
                # if any entries were found and replaced
                if config_file_string_out != config_file_string:
                    # write to project file
                    with open(self.config_project_path, 'w') as openfile:
                        openfile.write(config_file_string_out)
                    logging.debug("'"+parameter+"' was set successfuly")
                # if nothing was found
                elif re.search(parameter_regex, config_file_string) is None:
                    logging.error("Check regex please. Nothing was found for '"+parameter+"' in project file")
                # if parameter was found but it's replaced already
                elif re.search(parameter_regex, config_file_string).group() == parameter_string and parameter_string != '':
                    logging.debug("Looks like '"+parameter+"' is set already")
                # if parameter was not found and it's not empty
                elif parameter_string != '':
                    logging.error("No '"+parameter+"' is found in project file")
            else:
                logging.error("'"+parameter+"' is empty in config")
        else:
            logging.error("'"+parameter+"' is not defined")

    def set_team_for_extra_targets(self):
        # if parameter is defined in config
        if "project_extra_targets" in self.project_config:
            if "dev_team" in self.project_config:
                targets = self.project_config["project_extra_targets"]
                for target in targets:
                    self.set_team_for_target(target)
            else:
                logging.error("'dev_team' is not defined in config")
        else:
            logging.error("'project_extra_targets' are not defined in config")

    def set_team_for_target(self, target):
        dev_team = self.project_config["dev_team"]
        # related path to target config
        path_to_target_config =  os.path.join(self.config_project_path.replace("/project.pbxproj", ""), "..", target,target+".xcodeproj", "project.pbxproj")
        # read project file for target
        with open(path_to_target_config, 'r') as openfile:
            config_file_string = openfile.read()
        config_file_string_out = config_file_string
        # string and regex for dev team
        parameter_string = 'DEVELOPMENT_TEAM = '+dev_team+';'
        parameter_regex = 'DEVELOPMENT_TEAM = (.{10}|\"\");'
        # replace all regex findings with new parameters string
        config_file_string_out = re.sub(parameter_regex, parameter_string, config_file_string)
        # if something was changed
        if config_file_string_out != config_file_string:
            # write to target's project file
            with open(path_to_target_config, 'w') as openfile:
                openfile.write(config_file_string_out)
            logging.debug("DEVELOPMENT_TEAM for '"+target+"' target was set successfuly")
        # if nothing was found
        elif re.search(parameter_regex, config_file_string) is None:
                logging.error("Check regex please. Nothing was found for 'DEVELOPMENT_TEAM' in '"+target+"' target project file")
        else:
            logging.debug("Looks like DEVELOPMENT_TEAM for '"+target+"' target is set already")
    
    def copy_font(self):
        # check if font config exists
        if self.font:
            if "font_import_file_path" in self.font:
                font_import_file_path = self.font["font_import_file_path"]
                if "project_font_file_path" in self.font:
                    project_font_file_path = self.font["project_font_file_path"]
                    # if source and destination file exist
                    self.copy_file(font_import_file_path, project_font_file_path, "Font")
                else:
                    logging.error("'project_font_file_path' not found in config")
            else:
                logging.error("'font_import_file_path' not found in config")
            # read font names from config
            if "font_names" in self.font:
                font_names = self.font["font_names"]
                # set font names
                self.set_font_names(font_names)
            else:
                logging.error("'font_names' not found in config")
        else:
            logging.debug("Font not found in config")

    def copy_file(self, file_src, file_dest, title):
        # try to copy file and show success/error message
        try:
            shutil.copy(file_src, file_dest)
        except IOError as e:
            logging.error("Unable to copy file. "+e)
        else:
            logging.debug(title+" file was replaced in project")

    def set_font_names(self, font_names):
        if "project_font_names_json_path" in self.font:
            project_font_names_json_path = self.font["project_font_names_json_path"]
            # read names json file from project
            with open(project_font_names_json_path, 'r') as openfile:
                json_object = json.load(openfile)
            # go through font types and replace with values from config
            for key, _ in json_object.items():
                if key in font_names:
                    config_font_name_value = font_names[key]
                    json_object[key] = config_font_name_value
            # generate new json
            new_json = json.dumps(json_object) 
            # write to json file
            with open(project_font_names_json_path, 'w') as openfile:
                openfile.write(new_json)
            logging.debug("Font names were set successfuly")
        else:
            logging.error("'project_font_names_json_path' not found in config")

    def copy_project_files(self):
        # check if files config exists
        if self.files:
            for copy_file_data in self.files.items():
                file_name = copy_file_data[0]
                copy_file = copy_file_data[1]
                if "import_file_path" in copy_file:
                    import_file_path = copy_file["import_file_path"]
                    if "project_file_path" in copy_file:
                        project_file_path = copy_file["project_file_path"]
                        # if source and destination file exist
                        if os.path.exists(import_file_path):
                            if os.path.exists(project_file_path):
                                self.copy_file(import_file_path, project_file_path, file_name)
                            else:
                                logging.error(project_file_path+" file doesn't exist")
                        else:
                            logging.error(import_file_path+" file doesn't exist")
                    else:
                        logging.error("'project_file_path' for "+file_name+" not found in config")
                else:
                    logging.error("'import_file_path' for "+file_name+" not found in config")
        else:
            logging.debug("Project's Files for copying not found in config")

    # params from MOBILE CONFIG
    CONFIG_SETTINGS_YAML_FILENAME = 'config_settings.yaml'
    DEFAULT_CONFIG_PATH = './default_config/' + CONFIG_SETTINGS_YAML_FILENAME
    CONFIG_DIRECTORY_NAME = 'config_directory'
    CONFIG_MAPPINGS = 'config_mapping'
    MAPPINGS_FILENAME = 'file_mappings.yaml'

    def parse_yaml(self, file_path):
        try:
            with open(file_path, 'r') as file:
                return yaml.safe_load(file)
        except Exception as e:
            logging.error(f"Unable to open or read the file '{file_path}': {e}")
            return None

    def get_mobile_config(self, config_directory,  config_folder, errors_texts):
        # get path to mappings file
        path = os.path.join(config_directory, config_folder)
        mappings_path = os.path.join(path, self.MAPPINGS_FILENAME)
        # read mappings file
        data = self.parse_yaml(mappings_path)
        if data:
            # get config for ios described in mappings file
            ios_files = data.get('ios', {}).get('files', [])
            # re-use PlistManager class from process_config.py script
            plist_manager = PlistManager(path, ios_files)
            config = plist_manager.load_config()
            if config:
                return config
            else:
                errors_texts.append("Unable to parse config for "+config_folder)
        else:
            errors_texts.append("Files mappings for "+config_folder+" not found")
        return None

    def set_flags_from_mobile_config(self):
        # get path to mobile config
        config_settings = self.parse_yaml(self.CONFIG_SETTINGS_YAML_FILENAME)
        if not config_settings:
            config_settings = self.parse_yaml(self.DEFAULT_CONFIG_PATH)
        config_directory = config_settings.get(self.CONFIG_DIRECTORY_NAME)
        # check if we found config directory
        if config_directory:
            # check if configurations exist
            if "configurations" in self.project_config:
                configurations = self.project_config["configurations"]
                # read project file
                with open(self.config_project_path, 'r') as openfile:
                    project_file_string = openfile.read()
                errors_texts = []
                # iterate for all configurations
                for name, config in configurations.items():
                    if 'env_config' in config:
                        # get folder name for mobile config for current configuration by env_config
                        config_folder = config_settings.get(self.CONFIG_MAPPINGS, {}).get(config['env_config'])
                        if config_folder:
                            # example of usage
                            # project_file_string = self.replace_fullstory_flag(project_file_string, config_directory, name, config_folder, errors_texts)
                            pass
                        else:
                            logging.error("Config folder for '"+config['env_config']+"' is not defined in config_settings.yaml->config_mapping")
                    else:
                        logging.error("'env_config' is not defined for "+name)
                # write to project file
                with open(self.config_project_path, 'w') as openfile:
                    openfile.write(project_file_string)
                # print success message or errors if are presented
                if len(errors_texts) == 0:
                    logging.debug("Mobile config user-defined flags were successfully changed")
                else:
                    for error in errors_texts:
                        logging.error(error)
            else:
                logging.error("Project configurations are not defined")
        else:
            logging.error("Mobile config directory not found")

#    def replace_fullstory_flag(self, project_file_string, config_directory, config_name,  config_folder, errors_texts):
#        # get mobile config
#        mobile_config = self.get_mobile_config(config_directory,  config_folder, errors_texts)
#        if mobile_config:
#            # get FULLSTORY settings from mobile config
#            fullstory_config = mobile_config.get('FULLSTORY', {})
#            if fullstory_config:
#                fullstory_config_enabled = fullstory_config.get('ENABLED')
#                fullstory_string = "FULLSTORY_ENABLED = YES;" if fullstory_config_enabled else "FULLSTORY_ENABLED = NO;"
#                fullstory_regex = "FULLSTORY_ENABLED = .*;"
#                # serach by regex and replace
#                project_file_string = self.replace_parameter_for_build_config(project_file_string, config_name, fullstory_string, fullstory_regex, errors_texts)
#        return project_file_string
#
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
            
