from libqtile import bar, layout, widget, hook
from libqtile.config import Screen, Group, Key, Match, Drag, Click
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from qtile_extras import widget


mod = "mod4"  # Win key
alt = "mod1"
terminal = guess_terminal()
browser = "firefox"
fm = "dolphin"
am = "fuzzel"
telegram = "telegram-desktop"
# Key bindings
keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),

    # Move windows within the layout
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Resize windows
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Launch terminal
    Key([alt], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([alt], "t", lazy.spawn(telegram), desc="telegram"),
    Key([alt], "d", lazy.spawn(am), desc="app manager"),
    Key([alt], "w", lazy.spawn(browser), desc="firefox"),
    Key([alt], "e", lazy.spawn(fm), desc="file manager"),
     Key([alt], "p", lazy.spawn("pavucontrol"), desc="file manager"),


    # Kill window
    Key([mod], "c", lazy.window.kill(), desc="Kill focused window"),

    # Reload and restart Qtile
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload config"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

   Key([alt, "shift"], lazy.widget["keyboardlayout"].next_keyboard(), desc="Next keyboard layout"),

    Key([mod], "Return", lazy.layout.swap_main(), desc="Swap current window with master"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "space", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "m", lazy.window.toggle_maximize(), desc="Maximize window"),
    Key([mod], "n", lazy.window.toggle_minimize(), desc="Minimize (hide) window"),
]        

# Groups (workspaces)
groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend([
        # Switch to workspace N
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc=f"Switch to group {i.name}"),

        # Move focused window to workspace N
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name), desc=f"Move focused window to group {i.name}"),
    ])

# Layouts
layouts = [
    layout.MonadTall(border_focus="#88c0d0", border_width=2, margin=8),
    layout.Max(),
]

# Widgets and screens
widget_defaults = dict(
    font="JetBrains Mono", fontsize=12, padding=3
)
extension_defaults = widget_defaults.copy()

kb_layout = widget.KeyboardLayout(
                    configured_keyboards=["us", "ru", "ua"],  # Example layouts
                    display_map={"us": "EN", "ru": "RU"},  # Optional labels
                    update_interval=1,
                )
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %H:%M:%S"),
                widget.QuickExit(),
            ],
            24,
        ),
    ),
 Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                #widget.WindowName(),
                widget.TaskList(
                    highlight_method="block",  # or "border"
                    border="#5f5fff",  # Task highlight color
                    margin=2,  # Space between task icons
                    icon_size=18,  # Icon size
                ),
                widget.Systray(),
                kb_layout,
                widget.Clock(format="%Y-%m-%d %a %H:%M:%S"),
                widget.QuickExit(),
            ],
            24,
        ),
    ),

]

# Mouse configurations
mouse = [
    #Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button1", lazy.window.set_position(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Drag([alt], "Button3", lazy.layout.grow(), lazy.layout.shrink()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# Hook for autostart
@hook.subscribe.startup_once
def autostart():
    from subprocess import call
    call(["sh", "~/.config/qtile/autostart.sh"])

# Configuration
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="volume"),  # GPG key password entry
    ]
)
focus_on_window_activation = "smart"
auto_fullscreen = True
reconfigure_screens = True

auto_fullscreen = True
focus_on_window_activation = "smart"
wmname = "LG3D"  # For Java UI compatibility
