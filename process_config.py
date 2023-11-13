import plistlib
import os
import yaml
from pathlib import Path
import sys

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
                        properties.update(dict)
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
                        plist_data.update(yaml_data)
            except FileNotFoundError:
                print(f"{path} not found. Skipping.")
            except yaml.YAMLError as e:
                print(f"Error parsing YAML file {path}: {e}")

        return plist_data

    def write_to_plist_file(self, plist, file_path):
        file_name = os.path.basename(file_path)
        with open(file_path, 'wb') as plist_file:
            plistlib.dump(plist, plist_file)
            print(f"File {file_name} has been written to {file_path}")

    def print_info_plist_contents(self, plist_path):
        if not plist_path:
            print(f"Path is not set. {plist_path}")
        try:
            with open(plist_path, 'rb') as plist_file:
                plist_contents = plistlib.load(plist_file)
            print(plist_contents)
        except Exception as e:
            print(f"Error reading plist file: {e}")
            

class ConfigurationManager:
    def __init__(self, plist_manager):
        self.plist_manager = plist_manager

    def get_environment_variable(self, variable):
        return os.getenv(variable)

    def add_url_scheme(self, scheme, plist):
        body = {
            'CFBundleTypeRole': 'Editor',
            'CFBundleURLSchemes': scheme
        }
        existing = plist.get('CFBundleURLTypes', [])
        found = any(scheme in entry.get('CFBundleURLSchemes', []) for entry in existing)
        if not found:
            existing.append(body)
            plist['CFBundleURLTypes'] = existing

    def add_firebase_config(self, config, plist, firebase_info_plist_path):
        firebase = config.get('FIREBASE', {})
        
        if firebase_info_plist_path:
            plist['BUNDLE_ID'] = firebase.get('BUNDLE_ID', '')
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

    def add_facebook_config(self, config, plist):
        facebook = config.get('FACEBOOK', {})
        key = facebook.get('FACEBOOK_APP_ID')
        client_token = facebook.get('CLIENT_TOKEN')

        if key and client_token:
            plist["FacebookAppID"] = key
            plist["FacebookClientToken"] = client_token
            plist["FacebookDisplayName"] = self.plist_manager.get_product_name()
            scheme = ["fb" + key]
            self.add_url_scheme(scheme, plist)

    def add_google_config(self, config, plist):
        google = config.get('GOOGLE', {})
        key = google.get('GOOGLE_PLUS_KEY')

        if key:
            scheme = ['.'.join(reversed(key.split('.')))]
            self.add_url_scheme(scheme, plist)

    def add_microsoft_config(self, config, plist):
        microsoft = config.get('MICROSOFT', {})
        key = microsoft.get('APP_ID')

        if key:
            bundle_identifier = self.plist_manager.get_bundle_identifier()
            scheme = ["msauth." + bundle_identifier]
            self.add_url_scheme(scheme, plist)

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

def main():
    def parse_yaml(file_path):
        try:
            with open(file_path, 'r') as file:
                return yaml.safe_load(file)
        except Exception:
            print(f"Error opening or reading the file '{file_path}', No config file was written.")
            sys.exit(0)

    yaml_path = 'config.yaml'
    yaml_files = ['shared.yaml', 'ios.yaml']
    
    config_data = parse_yaml(yaml_path)
    directory = config_data.get('directory')
    config_name = config_data.get('config')
    print(f'directory: {directory}')
    print(f'config: {config_name}')

    config_dir = os.path.join(directory, config_name)
    plist_manager = PlistManager(config_dir, yaml_files)
    config = plist_manager.load_config()
    
    if not config:
        print("Config is empty. Skipping")
    else:
        configuration_manager = ConfigurationManager(plist_manager)
        info_plist_path = plist_manager.get_info_plist_path()
        firebase_info_plist_path = plist_manager.get_firebase_config_path()
        app_info_plist_path = plist_manager.get_app_info_plist_path()

        plist = {}
        configuration_manager.add_firebase_config(config, plist, firebase_info_plist_path)
        configuration_manager.add_facebook_config(config, plist)
        configuration_manager.add_google_config(config, plist)
        configuration_manager.add_microsoft_config(config, plist)
        configuration_manager.update_info_plist(plist, app_info_plist_path)
        
        bundle_config_path = plist_manager.get_bundle_config_path()
        config_plist = plist_manager.yaml_to_plist()
        plist_manager.write_to_plist_file(config_plist, bundle_config_path)

if __name__ == "__main__":
    main()
