import plistlib
import os
import yaml
from pathlib import Path
import sys
import json

class PlistManager:
    def __init__(self, config_dir, config_files):
        self.config_dir = config_dir
        self.config_files = config_files

    def get_config_paths(self):
        return [Path(self.config_dir) / config_name for config_name in self.config_files]

    def get_product_name(self):
        return os.getenv('PRODUCT_NAME')

    def get_bundle_identifier(self):
        return os.getenv('PRODUCT_BUNDLE_IDENTIFIER')

    def get_info_plist_path(self):
        return os.getenv('INFOPLIST_PATH')
        
    def get_wrapper_name(self):
        return os.getenv('WRAPPER_NAME')

    def get_built_products_path(self):
        return os.getenv('BUILT_PRODUCTS_DIR')

    def get_bundle_config_path(self):
        return os.path.join(self.get_built_products_path(), self.get_wrapper_name(), 'config.plist')

    def get_app_info_plist_path(self):
        built_products_path = self.get_built_products_path()
        info_plist_path = self.get_info_plist_path()
        
        if built_products_path and info_plist_path:
            return os.path.join(built_products_path, info_plist_path)
        else:
            return None
            
    def get_firebase_info_plist_path(self):
        built_products_path = self.get_built_products_path()
        wrapper_name = self.get_wrapper_name()

        if built_products_path and wrapper_name:
            return os.path.join(built_products_path, wrapper_name, 'GoogleService-Info.plist')
        else:
            print("The BUILT_PRODUCTS_DIR or WRAPPER_NAME environment variable is not set.")
            return None

    def get_firebase_config_path(self):
        built_products_path = self.get_built_products_path()
        wrapper_name = self.get_wrapper_name()

        if built_products_path and wrapper_name:
            return os.path.join(built_products_path, wrapper_name, 'firebase.plist')
        else:
            print("The BUILT_PRODUCTS_DIR or WRAPPER_NAME environment variable is not set.")
            return None

    def load_config(self):
        properties = {}

        for path in self.get_config_paths():
            try:
                with open(path, 'r') as file:
                    dict = yaml.safe_load(file)
                    if dict is not None:
                        properties = merge_dicts(properties, dict)
            except FileNotFoundError:
                print(f"{path} not found. Skipping.")

        return properties

    def yaml_to_plist(self):
        plist_data = {}

        for path in self.get_config_paths():
            try:
                with open(path, 'r') as file:
                    yaml_data = yaml.safe_load(file)
                    if yaml_data is not None:
                        plist_data = merge_dicts(plist_data, yaml_data)
            except FileNotFoundError:
                print(f"{path} not found. Skipping.")
            except yaml.YAMLError as e:
                print(f"Error parsing YAML file {path}: {e}")

        return plist_data

    def write_to_plist_file(self, plist, file_path):
        file_name = os.path.basename(file_path)
        with open(file_path, 'wb') as plist_file:
            plistlib.dump(plist, plist_file)
            print(f"File {file_name} has been written to:")
            print(f"{file_path}")

    def print_info_plist_contents(self, plist_path):
        if not plist_path:
            print(f"Path is not set. {plist_path}")
        try:
            with open(plist_path, 'rb') as plist_file:
                plist_contents = plistlib.load(plist_file)
            print(plist_contents)
        except Exception as e:
            print(f"Error reading plist file: {e}")

    def get_info_plist_contents(self, plist_path):
        if not plist_path:
            print(f"Path is not set. {plist_path}")
        try:
            with open(plist_path, 'rb') as plist_file:
                plist_contents = plistlib.load(plist_file)
            return plist_contents
        except Exception as e:
            print(f"Error reading plist file: {e}")
            return None

def merge_dicts(d1, d2):
    for k, v in d2.items():
        if k in d1:
            d1[k] = dict(v,**d1[k])
        else:
            d1[k] = v
    return d1

class ConfigurationManager:
    def __init__(self, plist_manager):
        self.plist_manager = plist_manager

    def get_environment_variable(self, variable):
        return os.getenv(variable)

    def add_url_scheme(self, scheme, plist, addBundleURL):
        body = {
            'CFBundleTypeRole': 'Editor',
            'CFBundleURLSchemes': scheme
        }
        
        if addBundleURL:
            bundle_identifier = self.plist_manager.get_bundle_identifier()
            body['CFBundleURLName'] = bundle_identifier
            
        existing = plist.get('CFBundleURLTypes', [])
        found = any(scheme in entry.get('CFBundleURLSchemes', []) for entry in existing)
        
        if not found:
            existing.append(body)
            plist['CFBundleURLTypes'] = existing
    
    def add_custom_array(self, key, array, plist):
        existing = plist.get(key, [])
        
        for element in array:
            if element not in existing:
                existing.append(element)
                
            plist[key] = existing
            
    def add_application_query_schemes(self, schemes, plist):
        existing = plist.get('LSApplicationQueriesSchemes', [])
        for scheme in schemes:
            if scheme not in existing:
                existing.append(scheme)
        plist['LSApplicationQueriesSchemes'] = existing
        return plist

    def add_firebase_config(self, config, firebase_info_plist_path):
        plist = {}
        firebase = config.get('FIREBASE', {})
        
        if firebase_info_plist_path and firebase:
            plist['BUNDLE_ID'] = self.plist_manager.get_bundle_identifier()
            plist['API_KEY'] = firebase.get('API_KEY', '')
            plist['CLIENT_ID'] = firebase.get('CLIENT_ID', '')
            plist['GOOGLE_APP_ID'] = firebase.get('GOOGLE_APP_ID', '')
            plist['GCM_SENDER_ID'] = firebase.get('GCM_SENDER_ID', '')

            project_id = firebase.get('PROJECT_ID', '')
            if project_id:
                plist['PROJECT_ID'] = project_id
                plist['STORAGE_BUCKET'] = project_id + '.appspot.com'
                plist['DATABASE_URL'] = 'https://' + project_id + '.firebaseio.com'

            reversed_client_id = firebase.get('REVERSED_CLIENT_ID', '')
            if reversed_client_id:
                plist['REVERSED_CLIENT_ID'] = reversed_client_id

            self.plist_manager.write_to_plist_file(plist, self.plist_manager.get_firebase_info_plist_path())
        else:
            print("Firebase config is empty. Skipping")
   
    def add_branch_config(self, config, plist):
        branch = config.get('BRANCH', {})
        enabled = branch.get('ENABLED')
        uriScheme = branch.get('URI_SCHEME')
        prefix = branch.get('DEEPLINK_PREFIX')
        
        if not prefix:
            prefix = "edx"
        
        if enabled:
            if uriScheme:
                scheme = [uriScheme]
            else:
                bundle_identifier = self.plist_manager.get_bundle_identifier()
                scheme = [bundle_identifier]
                
            self.add_custom_array("branch_universal_link_domains", [
                prefix+".app.link",
                prefix+"-alternate.app.link",
                prefix+".test-app.link",
                prefix+"-alternate.test-app.link"
                ], plist)
            self.add_url_scheme(scheme, plist, True)    
            
    def add_facebook_config(self, config, plist):
        facebook = config.get('FACEBOOK', {})
        key = facebook.get('FACEBOOK_APP_ID')
        client_token = facebook.get('CLIENT_TOKEN')

        if key and client_token:
            plist["FacebookAppID"] = key
            plist["FacebookClientToken"] = client_token
            plist["FacebookDisplayName"] = self.plist_manager.get_product_name()
            scheme = ["fb" + key]
            self.add_url_scheme(scheme, plist, False)

    def add_google_config(self, config, plist):
        google = config.get('GOOGLE', {})
        key = google.get('GOOGLE_PLUS_KEY')
        client_id = google.get('CLIENT_ID')

        if key and client_id:
            plist["GIDClientID"] = client_id
            scheme = ['.'.join(reversed(key.split('.')))]
            self.add_url_scheme(scheme, plist, False)

    def add_microsoft_config(self, config, plist):
        microsoft = config.get('MICROSOFT', {})
        key = microsoft.get('APP_ID')

        if key:
            bundle_identifier = self.plist_manager.get_bundle_identifier()
            scheme = ["msauth." + bundle_identifier]
            self.add_url_scheme(scheme, plist, False)
            self.add_application_query_schemes(["msauthv2", "msauthv3"], plist)
            
    def add_fullstory_config(self, config, plist):
        fullstory = config.get('FULLSTORY', {})
        enabled = fullstory.get('ENABLED')
        orgID = fullstory.get('ORG_ID')

        if enabled and orgID:
            plist["FullStory"] = {"orgID": orgID}

    def update_info_plist(self, plist_data, plist_path):
        if not plist_path:
            print("Path is not set.")
            sys.exit(1)

        try:
            with open(plist_path, 'rb') as plist_file:
                plist_contents = plistlib.load(plist_file)

            plist_contents.update(plist_data)

            try:
                plistlib.dumps(plist_contents)
            except Exception as e:
                print(f"Error validating plist contents: {e}")
                sys.exit(1)

            self.plist_manager.write_to_plist_file(plist_contents, plist_path)
        except FileNotFoundError:
            print(f"Plist file not found: {plist_path}")
            sys.exit(1)
        except Exception as e:
            print(f"Error reading or writing plist file: {e}")
            sys.exit(1)

def parse_yaml(file_path):
    try:
        with open(file_path, 'r') as file:
            return yaml.safe_load(file)
    except Exception as e:
        print(f"Unable to open or read the file '{file_path}': {e}")
        return None

CONFIG_SETTINGS_YAML_FILENAME = 'config_settings.yaml'
DEFAULT_CONFIG_PATH = './default_config/' + CONFIG_SETTINGS_YAML_FILENAME
CONFIG_DIRECTORY_NAME = 'config_directory'
CONFIG_MAPPINGS = 'config_mapping'
MAPPINGS_FILENAME = 'file_mappings.yaml'

def get_current_config(configuration, scheme_mappings):
    for key, values in scheme_mappings.items():
        if configuration in values:
            return key
    return None

def process_plist_files(configuration_manager, plist_manager, config):
    firebase_info_plist_path = plist_manager.get_firebase_config_path()
    info_plist_path = plist_manager.get_app_info_plist_path()
    info_plist_content = plist_manager.get_info_plist_contents(info_plist_path)

    configuration_manager.add_firebase_config(config, firebase_info_plist_path)
    configuration_manager.add_facebook_config(config, info_plist_content)
    configuration_manager.add_google_config(config, info_plist_content)
    configuration_manager.add_microsoft_config(config, info_plist_content)
    configuration_manager.add_branch_config(config, info_plist_content)
    configuration_manager.add_fullstory_config(config, info_plist_content)

    configuration_manager.update_info_plist(info_plist_content, info_plist_path)

    bundle_config_path = plist_manager.get_bundle_config_path()
    config_plist = plist_manager.yaml_to_plist()
    plist_manager.write_to_plist_file(config_plist, bundle_config_path)

def main(configuration, scheme_mappings):
    current_config = get_current_config(configuration, scheme_mappings)
    
    if current_config is None:
        print("Config not found in mappings. Exiting.")
        sys.exit(1)

    config_settings = parse_yaml(CONFIG_SETTINGS_YAML_FILENAME)
    
    if not config_settings:
        print("Parsing default config.")
        config_settings = parse_yaml(DEFAULT_CONFIG_PATH)

    config_directory = config_settings.get(CONFIG_DIRECTORY_NAME)
    config_name = config_settings.get(CONFIG_MAPPINGS, {}).get(current_config)

    if config_directory and config_name:
        path = os.path.join(config_directory, config_name)
        mappings_path = os.path.join(path, MAPPINGS_FILENAME)
        data = parse_yaml(mappings_path)
        
        if data:
            ios_files = data.get('ios', {}).get('files', [])
            plist_manager = PlistManager(path, ios_files)
            config = plist_manager.load_config()

            if config:
                configuration_manager = ConfigurationManager(plist_manager)
                process_plist_files(configuration_manager, plist_manager, config)
                print(f"Config {configuration} parsed and written successfully.")
            else:
                print("Unable to parse config files")
                sys.exit(1)

        else:
            print("Files mappings not found")
            sys.exit(1)

    else:
        print("Config directory or config name is not provided")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: script.py <configuration> <mappings>")
        sys.exit(1)

    configuration = sys.argv[1]
    scheme_mappings = json.loads(sys.argv[2])
    main(configuration, scheme_mappings)
