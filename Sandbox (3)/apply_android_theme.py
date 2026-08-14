#!/usr/bin/env python3
"""Apply exported Open edX mobile theme to the Android project.

Usage:
    # Copy this script into the exported theme folder (with theme.json + images/)
    # then run it after placing the folder inside the Android repo
    python3 apply_android_theme.py [--dry-run] [--theme PATH] [--project PATH]

Defaults:
    --theme   : directory containing theme.json (defaults to the script location)
    --project : Android repo root (auto-detected by walking upwards from theme dir)
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, Optional, Tuple

THEME_JSON_NAME = "theme.json"
COLOR_FILE = Path("core/src/openedx/org/openedx/core/ui/theme/Colors.kt")
LIGHT_COLORS_XML = Path("core/src/main/res/values/colors.xml")
DARK_COLORS_XML = Path("core/src/main/res/values-night/colors.xml")
LIGHT_HEADER = Path("core/src/main/res/drawable/core_top_header.png")
DARK_HEADER = Path("core/src/main/res/drawable-night/core_top_header.png")
LOGO_LIGHT = Path("core/src/main/res/drawable/core_ic_logo.png")
LOGO_DARK = Path("core/src/main/res/drawable-night/core_ic_logo.png")
LOGO_XML_LIGHT = Path("core/src/main/res/drawable/core_ic_logo.xml")
LOGO_XML_DARK = Path("core/src/main/res/drawable-night/core_ic_logo.xml")
DIMENS_FILE = Path("core/src/main/res/values/core_theme_generated_dimens.xml")
DIMEN_WIDTH_NAME = "core_login_logo_width"
DIMEN_HEIGHT_NAME = "core_login_logo_height"
DEFAULT_LOGO_WIDTH_DP = 171.0
DEFAULT_LOGO_HEIGHT_DP = 48.0

ANDROID_RES_DIR = Path("app/src/main/res")
ANDROID_DRAWABLE_DIR = ANDROID_RES_DIR / "drawable"
ANDROID_MIPMAP_GLOB = "mipmap-*"
LAUNCHER_BACKGROUND_XML = ANDROID_DRAWABLE_DIR / "ic_launcher_background.xml"
LAUNCHER_FOREGROUND_DRAWABLE = ANDROID_DRAWABLE_DIR / "app_icon_foreground.png"
LAUNCHER_ADAPTIVE_XML = ANDROID_RES_DIR / "mipmap-anydpi-v26/ic_launcher.xml"
LAUNCHER_ADAPTIVE_ROUND_XML = ANDROID_RES_DIR / "mipmap-anydpi-v26/ic_launcher_round.xml"
SPLASH_ICON_DRAWABLE = ANDROID_DRAWABLE_DIR / "app_splash_icon.png"

FOREGROUND_BASE_SCALE = 0.72
MAX_ANDROID_ICON_SCALE = 1.0 / FOREGROUND_BASE_SCALE

CONFIG_BASE_DIR = Path("default_config")
CONFIG_ENVIRONMENTS = {
    "prod": {"suffix": "", "bundle_suffix": ""},
    "stage": {"suffix": " Stage", "bundle_suffix": ".stage"},
    "dev": {"suffix": " Dev", "bundle_suffix": ".dev"},
}

DEFAULT_ACCENT = {
    "light": "#3C68FF",
    "dark": "#5378F8",
}

# Maps theme.json color key → (light Colors.kt names, dark Colors.kt names)
COLOR_KT_MAPPINGS = (
    ("accentColor", (
        "light_primary", "light_info_variant", "light_text_accent",
        "light_text_hyper_link", "light_primary_button_background",
        "light_primary_button_bordered_text",
    ), (
        "dark_primary", "dark_info_variant", "dark_text_hyper_link",
        "dark_primary_button_background", "dark_primary_button_bordered_text",
    )),
    ("background", ("light_background",), ("dark_background",)),
    ("textPrimary", ("light_text_primary",), ("dark_text_primary",)),
    ("textSecondary", ("light_text_secondary",), ("dark_text_secondary",)),
    ("textInputBackground", ("light_text_field_background",), ("dark_text_field_background",)),
    ("textInputStroke", ("light_text_field_border",), ("dark_text_field_border",)),
    ("primaryButtonText", ("light_primary_button_text",), ("dark_primary_button_text",)),
)

LIGHT_XML_COLOR_NAMES = ("primary", "checked_tab_item")
DARK_XML_COLOR_NAMES = ("primary", "checked_tab_item")


@dataclass
class CopyTask:
    description: str
    json_key: str
    dest_path: Path
    allow_fallback: bool = True


HEADER_COPY_TASKS = (
    CopyTask("Login header (light)", "headerBackground", LIGHT_HEADER, True),
    CopyTask("Login header (dark)", "headerBackground", DARK_HEADER, True),
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Apply exported Open edX theme to Android project")
    parser.add_argument("--project", type=Path, default=None,
                        help="Path to Android repo (defaults to parent directories of theme folder)")
    parser.add_argument("--theme", type=Path, default=None,
                        help="Theme export directory (defaults to folder containing this script)")
    parser.add_argument("--dry-run", action="store_true", help="Preview changes without writing")
    return parser.parse_args()


def resolve_theme_dir(theme_arg: Optional[Path]) -> Path:
    if theme_arg:
        candidate = theme_arg.resolve()
    else:
        candidate = Path(__file__).resolve().parent
    if not (candidate / THEME_JSON_NAME).exists():
        raise FileNotFoundError(
            f"theme.json not found in {candidate}. Use --theme to point to the export folder."
        )
    return candidate


def iter_candidate_roots(start: Path, limit: int = 6) -> Iterable[Path]:
    current = start
    for _ in range(limit):
        yield current
        if current.parent == current:
            break
        current = current.parent


def resolve_project_root(theme_dir: Path, project_arg: Optional[Path]) -> Path:
    candidates = []
    if project_arg:
        candidates.append(project_arg)
    candidates.extend(iter_candidate_roots(theme_dir))
    seen = set()
    for candidate in candidates:
        resolved = candidate.resolve()
        if resolved in seen:
            continue
        seen.add(resolved)
        if (resolved / COLOR_FILE).exists() and (resolved / "settings.gradle").exists():
            return resolved
    raise FileNotFoundError("Could not locate Android project root; use --project to specify it explicitly.")


def load_theme(theme_dir: Path) -> Dict:
    with (theme_dir / THEME_JSON_NAME).open("r", encoding="utf-8") as fh:
        return json.load(fh)


def get_accent(theme: Dict, mode: str) -> str:
    colors = theme.get(mode, {}).get("colors", {})
    value = colors.get("accentColor")
    if value:
        return normalize_hex(value)
    fallback = DEFAULT_ACCENT[mode]
    print(f"[WARN] accentColor missing for {mode}; using default {fallback}")
    return normalize_hex(fallback)


def normalize_hex(value: str) -> str:
    v = value.strip().lstrip('#')
    if len(v) == 3:
        v = ''.join(ch * 2 for ch in v)
    elif len(v) not in (6, 8):
        raise ValueError(f"Unsupported hex color: {value}")
    if len(v) == 8:
        v = v[0:6]  # drop alpha from #AARRGGBB => use RGB only, alpha handled separately
    return '#' + v.upper()


def to_argb(hex_value: str) -> str:
    v = normalize_hex(hex_value)[1:]
    return '0xFF' + v.upper()


def update_colors_kt(path: Path, theme: Dict, dry_run: bool) -> None:
    text = path.read_text(encoding="utf-8")
    light_colors = theme.get("light", {}).get("colors", {})
    dark_colors = theme.get("dark", {}).get("colors", {})

    replacements: Dict[str, str] = {}
    for json_key, light_names, dark_names in COLOR_KT_MAPPINGS:
        light_val = light_colors.get(json_key)
        dark_val = dark_colors.get(json_key)
        if light_val:
            argb = to_argb(light_val)
            for name in light_names:
                replacements[name] = argb
        if dark_val:
            argb = to_argb(dark_val)
            for name in dark_names:
                replacements[name] = argb

    updated_text = text
    status = "[DRY-RUN]" if dry_run else "[OK]"
    for name, value in replacements.items():
        # Match Color(0x...) literal
        pat_literal = re.compile(rf"(val\s+{name}\s*=\s*Color\()(0x[0-9A-Fa-f]{{6,8}})(\))")
        match = pat_literal.search(updated_text)
        if match:
            updated_text = pat_literal.sub(lambda m: f"{m.group(1)}{value}{m.group(3)}", updated_text, count=1)
            print(f"{status} Colors.kt: set {name}={value}")
        else:
            # Match variable reference or Color.White/Color.Black etc.
            pat_ref = re.compile(rf"(val\s+{name}\s*=\s*)\S+")
            match_ref = pat_ref.search(updated_text)
            if match_ref:
                updated_text = pat_ref.sub(rf"\g<1>Color({value})", updated_text, count=1)
                print(f"{status} Colors.kt: set {name}=Color({value})")
            else:
                print(f"[WARN] Colors.kt: '{name}' definition not found")

    if dry_run:
        return
    path.write_text(updated_text, encoding="utf-8")


def _normalize_colors_xml(text: str) -> str:
    """Ensure every <color> tag starts on its own line with proper indentation."""
    text = re.sub(r"</color>\s*<color", "</color>\n    <color", text)
    text = re.sub(r"</color>\s*</resources>", "</color>\n</resources>", text)
    return text


def update_colors_xml(path: Path, names: Iterable[str], accent_hex: str, dry_run: bool) -> None:
    text = path.read_text(encoding="utf-8")
    updated_text = text
    status = "[DRY-RUN]" if dry_run else "[OK]"
    for name in names:
        pattern = re.compile(rf"(<color\s+name=\"{name}\"[^>]*>)(#[0-9A-Fa-f]+)(</color>)")
        match = pattern.search(updated_text)
        if match:
            updated_text = pattern.sub(lambda m: f"{m.group(1)}{accent_hex}{m.group(3)}", updated_text, count=1)
            print(f"{status} {path}: set {name}={accent_hex}")
        else:
            print(f"[WARN] {path}: color '{name}' not found")
    updated_text = _normalize_colors_xml(updated_text)
    if dry_run:
        return
    path.write_text(updated_text, encoding="utf-8")


def update_color_entry(path: Path, name: str, value: str, dry_run: bool) -> None:
    if not path.exists():
        print(f"[WARN] Color file not found: {path}")
        return
    text = path.read_text(encoding="utf-8")
    color = normalize_hex(value)
    entry_pattern = re.compile(
        rf"\s*<color\s+name=\"{name}\"[^>]*>[^<]*</color>\s*\n?",
        re.IGNORECASE,
    )
    updated = entry_pattern.sub('', text)
    insert_fragment = f"    <color name=\"{name}\">{color}</color>\n"
    if '</resources>' in updated:
        updated = updated.replace('</resources>', insert_fragment + '</resources>')
    else:
        updated = updated + insert_fragment
    updated = _normalize_colors_xml(updated)
    if updated == text:
        return
    if dry_run:
        print(f"[DRY-RUN] Would update color '{name}' in {path}")
    else:
        path.write_text(updated, encoding="utf-8")
        print(f"[OK] Updated color '{name}' in {path}")


ALLOWED_IMAGE_SUFFIXES = {'.png', '.webp'}


def copy_image(theme_dir: Path, rel_path: Optional[str], dest: Path, description: str, dry_run: bool) -> None:
    if not rel_path:
        print(f"[WARN] {description}: theme.json does not reference a file")
        return
    source = (theme_dir / rel_path).resolve()
    if not source.exists():
        print(f"[WARN] {description}: source file missing ({source})")
        return
    suffix = source.suffix.lower()
    if suffix not in ALLOWED_IMAGE_SUFFIXES:
        print(f"[WARN] {description}: unsupported format {source.suffix}; skipping copy")
        return
    if dry_run:
        print(f"[DRY-RUN] {description}: would copy {source} -> {dest}")
        return
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, dest)
    print(f"[OK] {description}: copied to {dest}")


def remove_conflicting_resource(target: Path, dry_run: bool) -> None:
    directory = target.parent
    stem = target.stem
    for ext in ('.png', '.webp', '.xml'):
        candidate = directory / f"{stem}{ext}"
        if candidate == target or not candidate.exists():
            continue
        if dry_run:
            print(f"[DRY-RUN] Would remove conflicting resource {candidate}")
        else:
            candidate.unlink()
            print(f"[OK] Removed conflicting resource {candidate}")


def apply_header_images(theme: Dict, theme_dir: Path, project_root: Path, dry_run: bool) -> None:
    for task in HEADER_COPY_TASKS:
        mode = 'dark' if 'dark' in task.description.lower() else 'light'
        images = theme.get(mode, {}).get('images', {})
        rel = images.get(task.json_key)
        if not rel and task.allow_fallback:
            other_mode = 'light' if mode == 'dark' else 'dark'
            rel = theme.get(other_mode, {}).get('images', {}).get(task.json_key)
        copy_image(theme_dir, rel, project_root / task.dest_path, task.description, dry_run)

def remove_legacy_logo_xml(project_root: Path, dry_run: bool) -> None:
    for path in (project_root / LOGO_XML_LIGHT, project_root / LOGO_XML_DARK):
        if path.exists():
            if dry_run:
                print(f"[DRY-RUN] Would remove legacy logo vector {path}")
            else:
                path.unlink()
                print(f"[OK] Removed legacy logo vector {path}")


def choose_logo_dimensions(theme: Dict) -> Optional[Tuple[float, float]]:
    for mode in ('light', 'dark'):
        meta = theme.get(mode, {}).get('imagesMeta', {})
        meta_entry = meta.get('appLogoLogin')
        if isinstance(meta_entry, dict):
            width = meta_entry.get('width')
            height = meta_entry.get('height')
            if isinstance(width, (int, float)) and isinstance(height, (int, float)) and width > 0 and height > 0:
                return float(width), float(height)
    return None


def format_dimen(value: float) -> str:
    return (f"{value:.2f}".rstrip('0').rstrip('.') if value % 1 else f"{int(value)}") + "dp"


def write_logo_dimens(project_root: Path, dims: Tuple[float, float], dry_run: bool) -> None:
    width_dp, height_dp = dims
    content = (
        "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
        "<resources>\n"
        f"    <dimen name=\"{DIMEN_WIDTH_NAME}\">{format_dimen(width_dp)}</dimen>\n"
        f"    <dimen name=\"{DIMEN_HEIGHT_NAME}\">{format_dimen(height_dp)}</dimen>\n"
        "</resources>\n"
    )
    dest = project_root / DIMENS_FILE
    if dry_run:
        print(f"[DRY-RUN] Would write logo dimensions to {dest}: {width_dp}dp × {height_dp}dp")
        return
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_text(content, encoding="utf-8")
    print(f"[OK] Wrote logo dimensions to {dest}")


def apply_logo_images(theme: Dict, theme_dir: Path, project_root: Path, dry_run: bool) -> None:
    remove_legacy_logo_xml(project_root, dry_run)

    tasks = (
        ("Login logo (light)", 'light', LOGO_LIGHT),
        ("Login logo (dark)", 'dark', LOGO_DARK),
    )

    for description, mode, target_rel_path in tasks:
        images = theme.get(mode, {}).get('images', {})
        rel = images.get('appLogoLogin')
        if not rel:
            other_mode = 'light' if mode == 'dark' else 'dark'
            rel = theme.get(other_mode, {}).get('images', {}).get('appLogoLogin')
        copy_image(theme_dir, rel, project_root / target_rel_path, description, dry_run)

    dims = choose_logo_dimensions(theme)
    if dims:
        write_logo_dimens(project_root, dims, dry_run)
    else:
        print("[WARN] Logo dimensions not provided; using defaults")
        write_logo_dimens(project_root, (DEFAULT_LOGO_WIDTH_DP, DEFAULT_LOGO_HEIGHT_DP), dry_run)
    update_logo_composables(project_root, dry_run)


def ensure_kotlin_import(text: str, import_stmt: str) -> Tuple[str, bool]:
    if import_stmt in text:
        return text, False
    lines = text.splitlines()
    insert_idx = -1
    for idx, line in enumerate(lines):
        if line.startswith("import "):
            insert_idx = idx
    if insert_idx == -1:
        for idx, line in enumerate(lines):
            if line.startswith("package "):
                insert_idx = idx
                break
    if insert_idx == -1:
        return text, False
    lines.insert(insert_idx + 1, import_stmt)
    if text.endswith("\n"):
        updated = "\n".join(lines) + "\n"
    else:
        updated = "\n".join(lines)
    return updated, True


def update_signin_logo(project_root: Path, dry_run: bool) -> bool:
    path = project_root / "core/src/openedx/org/openedx/core/ui/theme/compose/SignInLogoView.kt"
    if not path.exists():
        print(f"[WARN] SignInLogoView not found at {path}")
        return False
    text = path.read_text(encoding="utf-8")
    if f"R.dimen.{DIMEN_WIDTH_NAME}" in text and f"R.dimen.{DIMEN_HEIGHT_NAME}" in text:
        return False
    changed = False
    text, imp_changed = ensure_kotlin_import(text, "import androidx.compose.foundation.layout.size")
    changed |= imp_changed
    text, imp_changed = ensure_kotlin_import(text, "import androidx.compose.ui.res.dimensionResource")
    changed |= imp_changed
    if f"R.dimen.{DIMEN_WIDTH_NAME}" not in text:
        simple = "modifier = Modifier.padding(top = 20.dp)"
        block = "modifier = Modifier\n            .padding(top = 20.dp)"
        replacement = (
            "modifier = Modifier\n"
            "            .padding(top = 20.dp)\n"
            "            .size(\n"
            f"                width = dimensionResource(id = R.dimen.{DIMEN_WIDTH_NAME}),\n"
            f"                height = dimensionResource(id = R.dimen.{DIMEN_HEIGHT_NAME})\n"
            "            )"
        )
        if simple in text:
            text = text.replace(simple, replacement, 1)
            changed = True
        elif block in text:
            text = text.replace(block, replacement, 1)
            changed = True
        else:
            print(f"[WARN] Could not inject size modifier in {path}")
    if changed:
        if dry_run:
            print(f"[DRY-RUN] Would update logo sizing in {path}")
        else:
            path.write_text(text, encoding="utf-8")
            print(f"[OK] Updated logo sizing in {path}")
    return changed


def update_logistration_logo(project_root: Path, dry_run: bool) -> bool:
    path = project_root / "core/src/openedx/org/openedx/core/ui/theme/compose/LogistrationLogoView.kt"
    if not path.exists():
        print(f"[WARN] LogistrationLogoView not found at {path}")
        return False
    text = path.read_text(encoding="utf-8")
    if f"R.dimen.{DIMEN_WIDTH_NAME}" in text and f"R.dimen.{DIMEN_HEIGHT_NAME}" in text:
        return False
    changed = False
    text, imp_changed = ensure_kotlin_import(text, "import androidx.compose.foundation.layout.size")
    changed |= imp_changed
    text, imp_changed = ensure_kotlin_import(text, "import androidx.compose.ui.res.dimensionResource")
    changed |= imp_changed
    if f"R.dimen.{DIMEN_WIDTH_NAME}" not in text:
        block = (
            "modifier = Modifier\n"
            "            .padding(top = 64.dp, bottom = 20.dp)\n"
            "            .wrapContentWidth()"
        )
        if block in text:
            replacement = (
                "modifier = Modifier\n"
                "            .padding(top = 64.dp, bottom = 20.dp)\n"
                "            .size(\n"
                f"                width = dimensionResource(id = R.dimen.{DIMEN_WIDTH_NAME}),\n"
                f"                height = dimensionResource(id = R.dimen.{DIMEN_HEIGHT_NAME})\n"
                "            )\n"
                "            .wrapContentWidth()"
            )
            text = text.replace(block, replacement, 1)
            changed = True
        else:
            print(f"[WARN] Could not inject size modifier in {path}")
    if changed:
        if dry_run:
            print(f"[DRY-RUN] Would update logo sizing in {path}")
        else:
            path.write_text(text, encoding="utf-8")
            print(f"[OK] Updated logo sizing in {path}")
    return changed


def update_logo_composables(project_root: Path, dry_run: bool) -> None:
    update_signin_logo(project_root, dry_run)
    update_logistration_logo(project_root, dry_run)


def apply_app_icon_new_spec(theme_dir: Path, project_root: Path, spec: Dict, accent_hex: str, dry_run: bool) -> None:
    assets = spec.get("assets")
    if not isinstance(assets, dict) or not assets:
        print("[WARN] appIconAndroid.assets missing or empty; skipping Android icon update")
        return
    res_root = project_root / ANDROID_RES_DIR
    if not res_root.exists():
        print(f"[WARN] Android res directory not found at {res_root}")
        return

    for required in (
        "drawable/app_icon_foreground.png",
        "mipmap-xxxhdpi/ic_launcher.png",
        "mipmap-xxxhdpi/ic_launcher_round.png",
    ):
        if required not in assets:
            print(f"[WARN] Expected Android icon asset '{required}' not provided; proceeding with available files")

    for rel_dest, rel_source in assets.items():
        if not isinstance(rel_dest, str) or not isinstance(rel_source, str):
            print(f"[WARN] Invalid asset mapping {rel_dest!r} -> {rel_source!r}; expected strings")
            continue
        dest_path = res_root / rel_dest
        description = f"Launcher asset {rel_dest}"
        remove_conflicting_resource(dest_path, dry_run)
        copy_image(theme_dir, rel_source, dest_path, description, dry_run)

    raw_background = spec.get("backgroundColor")
    background = raw_background if isinstance(raw_background, str) and raw_background.strip() else None
    scale_value = None
    scale_raw = spec.get("scale")
    if isinstance(scale_raw, (int, float)):
        scale_value = clamp_scale(float(scale_raw), 0.1, 1.0 / FOREGROUND_BASE_SCALE)
    use_background = bool(spec.get("useBackground", True))
    splash_color_light = spec.get("splashColorLight") or spec.get("splashColor")
    splash_color_dark = spec.get("splashColorDark") or spec.get("splashColor")

    update_adaptive_icon_xml(project_root, dry_run)
    if (project_root / LAUNCHER_BACKGROUND_XML).exists() and not dry_run:
        (project_root / LAUNCHER_BACKGROUND_XML).unlink()
    elif (project_root / LAUNCHER_BACKGROUND_XML).exists():
        print(f"[DRY-RUN] Would remove legacy launcher background drawable at {project_root / LAUNCHER_BACKGROUND_XML}")

    play_store_rel = spec.get("playStore")
    if isinstance(play_store_rel, str):
        play_store_dest = project_root / "app/src/main/ic_launcher-playstore.png"
        remove_conflicting_resource(play_store_dest, dry_run)
        copy_image(theme_dir, play_store_rel, play_store_dest, "Play Store icon", dry_run)

    if isinstance(splash_color_light, str) and splash_color_light.strip():
        update_color_entry(project_root / LIGHT_COLORS_XML, 'splash', splash_color_light, dry_run)
    if isinstance(splash_color_dark, str) and splash_color_dark.strip():
        update_color_entry(project_root / DARK_COLORS_XML, 'splash', splash_color_dark, dry_run)


def apply_app_icon(theme: Dict, theme_dir: Path, project_root: Path, accent_hex: str, dry_run: bool) -> None:
    icons = theme.get("icons", {})
    android_spec = icons.get("appIconAndroid")
    if isinstance(android_spec, dict) and android_spec.get("assets"):
        apply_app_icon_new_spec(theme_dir, project_root, android_spec, accent_hex, dry_run)
        return

    rel = icons.get("appIcon")
    if not rel:
        print("[WARN] App icon not found in theme export (icons.appIcon)")
        return
    res_root = project_root / ANDROID_RES_DIR
    if not res_root.exists():
        print(f"[WARN] Android res directory not found at {res_root}")
        return

    targets: list[Tuple[Path, str]] = []
    for dirpath in res_root.glob(ANDROID_MIPMAP_GLOB):
        if dirpath.name.endswith('v26'):
            continue
        for filename in ("ic_launcher.png", "ic_launcher_round.png", "ic_launcher_foreground.png"):
            target = dirpath / filename
            if target.exists():
                desc = f"Launcher icon {dirpath.name}/{filename}"
                targets.append((target, desc))

    if not targets:
        print("[WARN] No launcher icon assets found to update")
    for target, desc in targets:
        copy_image(theme_dir, rel, target, desc, dry_run)

    # drawable copy for adaptive foreground
    copy_image(theme_dir, rel, project_root / LAUNCHER_FOREGROUND_DRAWABLE, "Launcher foreground drawable", dry_run)

    update_launcher_background_xml(project_root, accent_hex, dry_run)


def clamp_scale(value: float, minimum: float = 0.1, maximum: float = MAX_ANDROID_ICON_SCALE) -> float:
    return max(minimum, min(maximum, value))


def update_adaptive_icon_xml(project_root: Path, dry_run: bool) -> None:
    contents = (
        "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
        "<adaptive-icon xmlns:android=\"http://schemas.android.com/apk/res/android\">\n"
        "    <background android:drawable=\"@mipmap/ic_launcher_background\"/>\n"
        "    <foreground android:drawable=\"@mipmap/ic_launcher_foreground\"/>\n"
        "</adaptive-icon>\n"
    )
    for rel in (LAUNCHER_ADAPTIVE_XML, LAUNCHER_ADAPTIVE_ROUND_XML):
        path = project_root / rel
        if not path.exists():
            continue
        current = path.read_text(encoding="utf-8")
        if current == contents:
            continue
        if dry_run:
            print(f"[DRY-RUN] Would update adaptive icon XML at {path}")
        else:
            path.write_text(contents, encoding="utf-8")
            print(f"[OK] Updated adaptive icon XML at {path}")


def update_launcher_background_xml(project_root: Path, accent_hex: str, dry_run: bool) -> None:
    path = project_root / LAUNCHER_BACKGROUND_XML
    color = normalize_hex(accent_hex)
    content = (
        "<shape xmlns:android=\"http://schemas.android.com/apk/res/android\"\n"
        f"    android:shape=\"rectangle\">\n    <solid android:color=\"{color}\"/>\n</shape>\n"
    )
    if not path.exists():
        if dry_run:
            print(f"[DRY-RUN] Would create {path}")
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding="utf-8")
            print(f"[OK] Updated launcher background at {path}")
        return
    current = path.read_text(encoding="utf-8")
    if current == content:
        return
    if dry_run:
        print(f"[DRY-RUN] Would update launcher background at {path}")
    else:
        path.write_text(content, encoding="utf-8")
        print(f"[OK] Updated launcher background at {path}")


def sanitize_bundle_component(theme_name: str) -> str:
    lowered = theme_name.lower()
    lowered = re.sub(r"\s+", ".", lowered)
    lowered = re.sub(r"[^a-z0-9\.]+", "", lowered)
    lowered = re.sub(r"\.+", ".", lowered).strip('.')
    return lowered or "app"


def strip_env_suffix(app_id: str) -> str:
    for suffix in (".stage", ".dev"):
        if app_id.endswith(suffix):
            return app_id[: -len(suffix)]
    return app_id


def replace_app_id_component(app_id: str, slug: str) -> str:
    tokens = [token for token in app_id.split('.') if token]
    if not tokens:
        return slug
    target_index = None
    for idx, token in enumerate(tokens):
        if token.lower() == "openedx":
            target_index = idx
            break
    if target_index is None:
        target_index = 1 if len(tokens) > 1 else 0
    tokens[target_index] = slug
    return '.'.join(tokens)


def extract_yaml_value(text: str, key: str) -> Optional[str]:
    pattern = re.compile(rf"^{key}:\s*(['\"]?)([^'\"\n]+)\1\s*$", re.MULTILINE)
    match = pattern.search(text)
    if match:
        return match.group(2).strip()
    return None


def format_yaml_string(value: str) -> str:
    escaped = value.replace('"', '\"')
    return f'"{escaped}"'


def update_yaml_file(path: Path, replacements: Dict[str, str], dry_run: bool) -> None:
    if not path.exists():
        print(f"[WARN] Config file not found: {path}")
        return
    original = path.read_text(encoding="utf-8")
    updated = original
    for key, value in replacements.items():
        pattern = re.compile(rf"^{key}:\s*.*$", re.MULTILINE)
        line = f"{key}: {format_yaml_string(value)}"
        if pattern.search(updated):
            updated = pattern.sub(line, updated, count=1)
        else:
            updated = f"{line}\n" + updated
    if updated == original:
        return
    if dry_run:
        print(f"[DRY-RUN] Would update config {path}")
    else:
        path.write_text(updated, encoding="utf-8")
        print(f"[OK] Updated config {path}")


def update_android_configs(theme_name: str, project_root: Path, dry_run: bool) -> None:
    slug = sanitize_bundle_component(theme_name)
    for env, opts in CONFIG_ENVIRONMENTS.items():
        config_path = project_root / CONFIG_BASE_DIR / env / "config.yaml"
        if not config_path.exists():
            print(f"[WARN] Config for environment '{env}' not found at {config_path}")
            continue
        text = config_path.read_text(encoding="utf-8")
        current_app_id = extract_yaml_value(text, "APPLICATION_ID") or "org.openedx.app"
        base_app_id = strip_env_suffix(current_app_id)
        replaced = replace_app_id_component(base_app_id, slug)
        bundle_suffix = opts["bundle_suffix"]
        new_app_id = replaced if not bundle_suffix else (replaced if replaced.endswith(bundle_suffix) else replaced + bundle_suffix)
        display_name = f"{theme_name}{opts['suffix']}".strip()
        replacements = {
            "APPLICATION_ID": new_app_id,
            "PLATFORM_NAME": display_name,
            "PLATFORM_FULL_NAME": display_name,
            "ENVIRONMENT_DISPLAY_NAME": display_name,
        }
        update_yaml_file(config_path, replacements, dry_run)


def main() -> int:
    args = parse_args()
    try:
        theme_dir = resolve_theme_dir(args.theme)
        project_root = resolve_project_root(theme_dir, args.project)
        theme = load_theme(theme_dir)
    except Exception as exc:
        print(f"[ERROR] {exc}")
        return 1

    print(f"[INFO] Theme folder: {theme_dir}")
    print(f"[INFO] Android project: {project_root}")
    if args.dry_run:
        print("[INFO] Dry run enabled – no files will be modified.")

    accent_light = get_accent(theme, 'light')
    accent_dark = get_accent(theme, 'dark')

    update_colors_kt(project_root / COLOR_FILE, theme, args.dry_run)
    update_colors_xml(project_root / LIGHT_COLORS_XML, LIGHT_XML_COLOR_NAMES, accent_light, args.dry_run)
    update_colors_xml(project_root / DARK_COLORS_XML, DARK_XML_COLOR_NAMES, accent_dark, args.dry_run)

    apply_header_images(theme, theme_dir, project_root, args.dry_run)
    apply_logo_images(theme, theme_dir, project_root, args.dry_run)
    apply_app_icon(theme, theme_dir, project_root, accent_light, args.dry_run)

    theme_name = theme.get("name") or "Open edX"
    update_android_configs(theme_name, project_root, args.dry_run)

    print("[DONE] Android theme application complete")
    return 0


if __name__ == "__main__":  # pragma: no cover
    sys.exit(main())
