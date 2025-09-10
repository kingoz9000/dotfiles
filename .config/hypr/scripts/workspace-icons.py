#!/usr/bin/env python3
import subprocess
import json
import time

# Mapping from window class (app) to icon
APP_ICONS = {
    "firefox": "",
    "kitty": "",
    "spotify": "",
    "obsidian": "󰎚",
    "steam": "",
    "dolphin": "",
    "org.pulseaudio.pavucontrol": "",
    "org.qutebrowser.qutebrowser": "󱛊",
    "java-lang-thread": "󰿉",
    "org.kde.okular": "",
    "steam": "",
}

# Polling interval in seconds
INTERVAL = 2


def run(cmd):
    return subprocess.check_output(cmd, shell=True).decode("utf-8")


def get_workspaces():
    out = run("hyprctl workspaces -j")
    return json.loads(out)


def get_windows():
    out = run("hyprctl clients -j")
    return json.loads(out)

def rename_workspaces():
    windows = get_windows()
    workspaces = {}

    # Group icons by workspace ID
    for win in windows:
        wid = win["workspace"]["id"]
        cls = win["class"].lower()
        icon = APP_ICONS.get(cls, "?")
        if wid not in workspaces:
            workspaces[wid] = set()
        workspaces[wid].add(icon)

    # Rename each workspace to: <number>:<icons>
    for wid, icons in workspaces.items():
        icon_str = "".join(sorted(icons))
        name = f"{wid}{icon_str}"
        run(f"hyprctl dispatch renameworkspace {wid} '{name}'")

def main():
    while True:
        try:
            rename_workspaces()
        except Exception as e:
            print("Error:", e)
        time.sleep(INTERVAL)


if __name__ == "__main__":
    main()

