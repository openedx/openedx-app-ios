#!/usr/bin/env python3
"""Apply exported Open edX mobile theme to the iOS project.

Copy this script into the exported branding folder (alongside theme.json
and images/) and run it after dropping that folder inside the iOS repo.

Example:
    cp apply_ios_theme.py path/to/exported_theme/
    cd path/to/openedx-app-ios/exported_theme
    python3 apply_ios_theme.py
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Tuple

THEME_JSON_NAME = "theme.json"
PROJECT_FILE_PATH = Path("OpenEdX.xcodeproj/project.pbxproj")

# Environments present in the Xcode project and their display name suffixes.
ENV_DISPLAY_SUFFIX = {
    "prod": "",
    "stage": " Stage",
    "dev": " Dev",
}

@dataclass
class ColorTask:
    description: str
    relative_path: Path
    light_key: Optional[str]
    dark_key: Optional[str]
    preserve_dark: bool = False
    fallback_to_accent: bool = False

@dataclass
class ImageTask:
    description: str
    relative_dir: Path
    kind: str
    include_dark: bool = True
    ios_catalog: bool = True


COLOR_TASKS: Sequence[ColorTask] = (
    ColorTask("Accent color", Path("Theme/Theme/Assets.xcassets/Colors/AccentColor.colorset/Contents.json"),
              "accentColor", "accentColor", fallback_to_accent=True),
    ColorTask("Accent button color", Path("Theme/Theme/Assets.xcassets/Colors/AccentButtonColor.colorset/Contents.json"),
              "accentColor", "accentColor", fallback_to_accent=True),
    ColorTask("Accent X color", Path("Theme/Theme/Assets.xcassets/Colors/AccentXColor.colorset/Contents.json"),
              "accentColor", "accentColor", fallback_to_accent=True),
    ColorTask("Background", Path("Theme/Theme/Assets.xcassets/Colors/Background.colorset/Contents.json"),
              "background", "background"),
    ColorTask("Login background", Path("Theme/Theme/Assets.xcassets/Colors/LoginBackground.colorset/Contents.json"),
              "background", "background"),
    ColorTask("Text primary", Path("Theme/Theme/Assets.xcassets/Colors/TextColor/TextPrimary.colorset/Contents.json"),
              "textPrimary", "textPrimary"),
    ColorTask("Text secondary", Path("Theme/Theme/Assets.xcassets/Colors/TextColor/TextSecondary.colorset/Contents.json"),
              "textSecondary", "textSecondary"),
    ColorTask("Info link color", Path("Theme/Theme/Assets.xcassets/Colors/InfoColor.colorset/Contents.json"),
              "accentColor", "accentColor", fallback_to_accent=True),
    ColorTask("Text input background", Path("Theme/Theme/Assets.xcassets/Colors/TextInput/TextInputBackground.colorset/Contents.json"),
              "textInputBackground", "textInputBackground"),
    ColorTask("Text input stroke", Path("Theme/Theme/Assets.xcassets/Colors/TextInput/TextInputStroke.colorset/Contents.json"),
              "textInputStroke", "textInputStroke"),
    ColorTask("Primary button text", Path("Theme/Theme/Assets.xcassets/Colors/PrimaryButtonTextColor.colorset/Contents.json"),
              "primaryButtonText", "primaryButtonText"),
    ColorTask("Secondary button border", Path("Theme/Theme/Assets.xcassets/Colors/SecondaryButton/SecondaryButtonBorderColor.colorset/Contents.json"),
              "accentColor", "accentColor", fallback_to_accent=True),
    ColorTask("Secondary button text", Path("Theme/Theme/Assets.xcassets/Colors/SecondaryButton/SecondaryButtonTextColor.colorset/Contents.json"),
              "accentColor", "accentColor", fallback_to_accent=True),
    ColorTask("Delete account background", Path("Theme/Theme/Assets.xcassets/Colors/DeleteAccountBG.colorset/Contents.json"),
              "accentColor", "accentColor", fallback_to_accent=True),
    ColorTask("Resume button background", Path("Theme/Theme/Assets.xcassets/Colors/ResumeButton/ResumeButtonBG.colorset/Contents.json"),
              "accentColor", "accentColor", fallback_to_accent=True),
    ColorTask("Social auth color", Path("Theme/Theme/Assets.xcassets/Colors/SocialAuthColor.colorset/Contents.json"),
              "accentColor", "accentColor", fallback_to_accent=True),
    ColorTask("Toggle switch color", Path("Theme/Theme/Assets.xcassets/Colors/ToggleSwitchColor.colorset/Contents.json"),
              "accentColor", "accentColor", fallback_to_accent=True),
    ColorTask("Sliding tab stroke", Path("Theme/Theme/Assets.xcassets/Colors/SlidingTabBar/slidingStrokeColor.colorset/Contents.json"),
              "accentColor", None, preserve_dark=True, fallback_to_accent=True),
    ColorTask("Sliding tab text", Path("Theme/Theme/Assets.xcassets/Colors/SlidingTabBar/slidingTextColor.colorset/Contents.json"),
              "accentColor", None, preserve_dark=True, fallback_to_accent=True),
    ColorTask("Splash background", Path("OpenEdX/Assets.xcassets/SplashBackground.colorset/Contents.json"),
              "accentColor", "accentColor", fallback_to_accent=True),
)

IMAGE_TASKS: Sequence[ImageTask] = (
    ImageTask("Login app logo", Path("Theme/Theme/Assets.xcassets/appLogo.imageset"), "appLogoLogin"),
    ImageTask("Login header background", Path("Theme/Theme/Assets.xcassets/headerBackground.imageset"), "headerBackground"),
    ImageTask("Splash app logo", Path("OpenEdX/Assets.xcassets/appLogo.imageset"), "appLogoSplash"),
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Apply exported Open edX mobile branding to the iOS app.")
    parser.add_argument(
        "--project",
        type=Path,
        default=None,
        help="Path to openedx-app-ios repository (defaults to the parent folder of this script).",
    )
    parser.add_argument(
        "--theme",
        type=Path,
        default=None,
        help="Path to exported theme folder containing theme.json and images/. Defaults to the folder where the script lives.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show planned changes without writing files.",
    )
    return parser.parse_args()


def load_theme(theme_dir: Path) -> Dict:
    theme_json_path = theme_dir / THEME_JSON_NAME
    if not theme_json_path.exists():
        raise FileNotFoundError(f"theme.json not found at {theme_json_path}")
    with theme_json_path.open("r", encoding="utf-8") as fh:
        return json.load(fh)


def ensure_project(project_root: Path) -> None:
    if not (project_root / PROJECT_FILE_PATH).exists():
        raise FileNotFoundError(
            "Could not locate OpenEdX.xcodeproj/project.pbxproj under "
            f"{project_root}. Use --project to point to the openedx-app-ios repo."
        )


def iter_candidate_roots(start: Path, limit: int = 6) -> Sequence[Path]:
    current = start
    yielded: List[Path] = []
    for _ in range(limit):
        yielded.append(current)
        if current.parent == current:
            break
        current = current.parent
    return yielded


def resolve_project_root(theme_dir: Path, project_arg: Optional[Path]) -> Path:
    candidates: List[Path] = []
    if project_arg is not None:
        candidates.append(project_arg)
    candidates.extend(iter_candidate_roots(theme_dir))

    visited: List[Path] = []
    for candidate in candidates:
        resolved = candidate.resolve()
        if resolved in visited:
            continue
        visited.append(resolved)
        if (resolved / PROJECT_FILE_PATH).exists():
            return resolved

    raise FileNotFoundError(
        "Could not automatically locate OpenEdX.xcodeproj/project.pbxproj. "
        "Use --project to specify the openedx-app-ios repository."
    )


def resolve_theme_dir(theme_arg: Optional[Path]) -> Path:
    if theme_arg is not None:
        candidate = theme_arg.resolve()
    else:
        candidate = Path(__file__).resolve().parent
    if not (candidate / THEME_JSON_NAME).exists():
        raise FileNotFoundError(
            f"theme.json not found in {candidate}. Use --theme to point to the exported theme folder."
        )
    return candidate


def color_from_palette(palette: Dict[str, Dict], mode: str, key: Optional[str]) -> Optional[str]:
    if key is None:
        return None
    colors = palette.get(mode, {})
    value = colors.get(key)
    if value:
        return value
    # fallback to light when dark is missing
    if mode == "dark":
        value = palette.get("light", {}).get(key)
        if value:
            return value
    return None


def hex_to_components(hex_color: str) -> Dict[str, str]:
    value = hex_color.strip().lstrip("#")
    if len(value) not in (6, 8):
        raise ValueError(f"Unsupported color format: {hex_color}")
    if len(value) == 6:
        r, g, b = value[0:2], value[2:4], value[4:6]
        a = "FF"
    else:
        r, g, b, a = value[0:2], value[2:4], value[4:6], value[6:8]
    r_int = int(r, 16) / 255
    g_int = int(g, 16) / 255
    b_int = int(b, 16) / 255
    a_int = int(a, 16) / 255
    def fmt(component: float) -> str:
        return f"{component:.3f}".rstrip("0").rstrip(".") if component not in (0, 1) else f"{component:.0f}.000"
    return {
        "red": fmt(r_int),
        "green": fmt(g_int),
        "blue": fmt(b_int),
        "alpha": fmt(a_int),
    }


def apply_color_asset(theme_palette: Dict[str, Dict], project_root: Path, task: ColorTask, dry_run: bool) -> None:
    asset_path = project_root / task.relative_path
    if not asset_path.exists():
        print(f"[WARN] Color asset missing: {asset_path}")
        return

    with asset_path.open("r", encoding="utf-8") as fh:
        data = json.load(fh)

    changes: List[Tuple[str, str]] = []
    for entry in data.get("colors", []):
        is_dark = any(
            appearance.get("appearance") == "luminosity" and appearance.get("value") == "dark"
            for appearance in entry.get("appearances", [])
        )
        mode = "dark" if is_dark else "light"
        if is_dark and task.preserve_dark:
            continue
        target_hex = color_from_palette(theme_palette, mode, task.dark_key if is_dark else task.light_key)
        if not target_hex and task.fallback_to_accent:
            target_hex = color_from_palette(theme_palette, mode, "accentColor")
        if not target_hex:
            print(f"[WARN] {task.description}: no color for {mode} mode in theme.json")
            continue
        components = hex_to_components(target_hex)
        entry.setdefault("color", {}).setdefault("components", {}).update(components)
        changes.append((mode, target_hex))

    if not changes:
        print(f"[INFO] {task.description}: nothing to change")
        return

    if not dry_run:
        with asset_path.open("w", encoding="utf-8") as fh:
            json.dump(data, fh, indent=2, ensure_ascii=False)
            fh.write("\n")
        status = "[OK]"
    else:
        status = "[DRY-RUN]"

    summary = ", ".join(f"{mode}={hex_value}" for mode, hex_value in changes)
    print(f"{status} {task.description}: {summary} -> {asset_path}")


def clean_imageset(imageset_dir: Path, dry_run: bool) -> None:
    for child in imageset_dir.iterdir():
        if child.name == "Contents.json":
            continue
        if child.is_file() and not dry_run:
            child.unlink()


def prepare_contents_json(target: Path) -> Dict:
    if target.exists():
        with target.open("r", encoding="utf-8") as fh:
            try:
                data = json.load(fh)
            except json.JSONDecodeError:
                data = {}
    else:
        data = {}
    data.setdefault("info", {"author": "xcode", "version": 1})
    return data


def copy_image(theme_dir: Path, relative_path: Optional[str], images_dir: Path, dry_run: bool) -> Optional[str]:
    if not relative_path:
        return None
    source = (theme_dir / relative_path).resolve()
    if not source.exists():
        print(f"[WARN] Image {relative_path} not found under {theme_dir}")
        return None
    target_name = source.name
    destination = images_dir / target_name
    if not dry_run:
        shutil.copy2(source, destination)
    return target_name


def apply_image_asset(theme: Dict, theme_dir: Path, project_root: Path, task: ImageTask, dry_run: bool) -> None:
    imageset_dir = project_root / task.relative_dir
    contents_path = imageset_dir / "Contents.json"
    if not imageset_dir.exists():
        print(f"[WARN] Imageset missing: {imageset_dir}")
        return

    palette_images = {
        "light": theme.get("light", {}).get("images", {}),
        "dark": theme.get("dark", {}).get("images", {}),
    }

    light_rel = palette_images["light"].get(task.kind)
    dark_rel = palette_images["dark"].get(task.kind) if task.include_dark else None
    if not light_rel and dark_rel:
        light_rel = dark_rel
    if task.include_dark and not dark_rel:
        dark_rel = palette_images["light"].get(task.kind)

    if not light_rel:
        print(f"[WARN] No image reference for {task.description} in theme.json")
        return

    if not dry_run:
        imageset_dir.mkdir(parents=True, exist_ok=True)
        clean_imageset(imageset_dir, dry_run)

    light_name = copy_image(theme_dir, light_rel, imageset_dir, dry_run)
    dark_name = copy_image(theme_dir, dark_rel, imageset_dir, dry_run) if dark_rel else None
    if task.include_dark and not dark_name:
        dark_name = light_name

    data = prepare_contents_json(contents_path)
    images = []
    if light_name:
        images.append({"idiom": "universal", "filename": light_name})
    if task.include_dark and dark_name:
        images.append({
            "idiom": "universal",
            "appearances": [{"appearance": "luminosity", "value": "dark"}],
            "filename": dark_name,
        })
    data["images"] = images

    if not dry_run:
        with contents_path.open("w", encoding="utf-8") as fh:
            json.dump(data, fh, indent=2, ensure_ascii=False)
            fh.write("\n")
        status = "[OK]"
    else:
        status = "[DRY-RUN]"
    msg_parts = [f"light={light_name}"]
    if task.include_dark:
        msg_parts.append(f"dark={dark_name}")
    print(f"{status} {task.description}: {', '.join(msg_parts)} -> {imageset_dir}")


def apply_app_icon(theme: Dict, theme_dir: Path, project_root: Path, dry_run: bool) -> None:
    icon_rel = theme.get("icons", {}).get("appIcon")
    if not icon_rel:
        print("[WARN] No app icon path found in theme.json (icons.appIcon)")
        return
    iconset_dir = project_root / "OpenEdX/Assets.xcassets/AppIcon.appiconset"
    contents_path = iconset_dir / "Contents.json"
    if not iconset_dir.exists():
        print(f"[WARN] AppIcon.appiconset not found at {iconset_dir}")
        return

    if not dry_run:
        clean_imageset(iconset_dir, dry_run)
    icon_name = copy_image(theme_dir, icon_rel, iconset_dir, dry_run)
    if not icon_name:
        return

    data = prepare_contents_json(contents_path)
    data["images"] = [{
        "idiom": "universal",
        "platform": "ios",
        "size": "1024x1024",
        "filename": icon_name,
    }]
    if not dry_run:
        with contents_path.open("w", encoding="utf-8") as fh:
            json.dump(data, fh, indent=2, ensure_ascii=False)
            fh.write("\n")
        status = "[OK]"
    else:
        status = "[DRY-RUN]"
    print(f"{status} Updated app icon: {icon_name} -> {iconset_dir}")


def sanitize_bundle_component(theme_name: str) -> str:
    lowered = theme_name.lower()
    # Replace whitespace with dots
    lowered = re.sub(r"\s+", ".", lowered)
    # Remove disallowed characters
    lowered = re.sub(r"[^a-z0-9\.]+", "", lowered)
    # Collapse multiple dots and trim
    lowered = re.sub(r"\.+", ".", lowered).strip('.')
    return lowered or "app"


def update_project_display_and_bundle(theme_name: str, project_root: Path, dry_run: bool) -> None:
    project_file = project_root / PROJECT_FILE_PATH
    with project_file.open("r", encoding="utf-8") as fh:
        lines = fh.readlines()

    env_map = {
        "DebugProd": "prod",
        "ReleaseProd": "prod",
        "DebugStage": "stage",
        "ReleaseStage": "stage",
        "DebugDev": "dev",
        "ReleaseDev": "dev",
    }

    current_env: Optional[str] = None
    brace_depth = 0
    changed = False

    def formatted_name(env: str) -> str:
        suffix = ENV_DISPLAY_SUFFIX[env]
        return f"{theme_name}{suffix}".strip()

    bundle_component = sanitize_bundle_component(theme_name)

    for idx, line in enumerate(lines):
        if "/*" in line and "*/ = {" in line:
            start = line.find("/*") + 2
            end = line.find("*/", start)
            if end != -1:
                config_name = line[start:end].strip()
                current_env = env_map.get(config_name)
                brace_depth = 1 if current_env else 0
            continue

        if current_env:
            brace_depth += line.count("{") - line.count("}")
            if "INFOPLIST_KEY_CFBundleDisplayName" in line:
                new_value = formatted_name(current_env)
                new_line = f"\t\t\tINFOPLIST_KEY_CFBundleDisplayName = \"{new_value}\";\n"
                if lines[idx] != new_line:
                    lines[idx] = new_line
                    changed = True
            elif "PRODUCT_BUNDLE_IDENTIFIER" in line:
                parts = line.split("=")
                if len(parts) >= 2:
                    current_value = parts[1].strip().rstrip(';')
                    current_value = current_value.strip('"')
                    tokens = current_value.split('.') if current_value else []
                    if tokens:
                        target_index: Optional[int] = None
                        for i, token in enumerate(tokens):
                            if token.lower() == "openedx":
                                target_index = i
                                break
                        if target_index is None:
                            target_index = 1 if len(tokens) > 1 else 0
                        slug_parts = [part for part in bundle_component.split('.') if part]
                        if not slug_parts:
                            slug_parts = [bundle_component]
                        prefix = tokens[:target_index]
                        suffix = tokens[target_index + 1:]
                        while slug_parts and suffix and slug_parts[-1] == suffix[0]:
                            suffix = suffix[1:]
                        new_tokens = [*prefix, *slug_parts, *suffix]
                        new_value = '.'.join(filter(None, new_tokens)) or bundle_component
                        if new_value != current_value:
                            quote = '"' if '"' in parts[1] else ''
                            lines[idx] = f"\t\t\tPRODUCT_BUNDLE_IDENTIFIER = {quote}{new_value}{quote};\n"
                            changed = True
            elif brace_depth <= 0:
                current_env = None
                brace_depth = 0

    if changed:
        if dry_run:
            print("[DRY-RUN] Would update display names/bundle IDs in project.pbxproj")
        else:
            with project_file.open("w", encoding="utf-8") as fh:
                fh.writelines(lines)
            print("[OK] Updated display names/bundle IDs in project.pbxproj")
    else:
        print("[INFO] Display names and bundle IDs already match theme")


def main() -> int:
    args = parse_args()
    try:
        theme_dir = resolve_theme_dir(args.theme)
        project_root = resolve_project_root(theme_dir, args.project)
        ensure_project(project_root)
        theme = load_theme(theme_dir)
    except Exception as exc:
        print(f"[ERROR] {exc}")
        return 1

    print(f"[INFO] Theme folder: {theme_dir}")
    print(f"[INFO] iOS project folder: {project_root}")
    if args.dry_run:
        print("[INFO] Dry run enabled – no files will be modified.")

    palette = {
        "light": theme.get("light", {}).get("colors", {}),
        "dark": theme.get("dark", {}).get("colors", {}),
    }

    for task in COLOR_TASKS:
        apply_color_asset(palette, project_root, task, args.dry_run)

    for task in IMAGE_TASKS:
        apply_image_asset(theme, theme_dir, project_root, task, args.dry_run)

    apply_app_icon(theme, theme_dir, project_root, args.dry_run)

    theme_name = theme.get("name") or "Open edX"
    update_project_display_and_bundle(theme_name, project_root, args.dry_run)

    print("[DONE] Theme application complete")
    return 0


if __name__ == "__main__":  # pragma: no cover
    sys.exit(main())
