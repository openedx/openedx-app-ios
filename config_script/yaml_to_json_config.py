#!/usr/bin/env python3
"""Convert a legacy config.yaml to config.json.

Usage: python3 config_script/yaml_to_json_config.py path/to/config.yaml
"""
import json
import sys

import yaml


def main():
    if len(sys.argv) != 2:
        print("Usage: yaml_to_json_config.py <path/to/config.yaml>")
        sys.exit(1)

    yaml_path = sys.argv[1]
    json_path = yaml_path.rsplit('.', 1)[0] + '.json'

    with open(yaml_path) as f:
        data = yaml.safe_load(f)

    with open(json_path, 'w') as f:
        json.dump(data, f, indent=2, sort_keys=True)
        f.write('\n')

    print(f"Wrote {json_path}. Delete {yaml_path} once you've checked it in.")


if __name__ == "__main__":
    main()
