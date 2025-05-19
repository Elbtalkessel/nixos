"""
Typesafe-ish ideavimrc generation.
"""

from typing import Mapping, Union, NamedTuple, Literal, Any

type Mode = Literal[
    "map",
    "nmap",
    "imap",
    "vmap",
    "xmap",
    "smap",
    "cmap",
    "omap",
]
type NMode = Literal[
    "nnoremap",
    "inoremap",
    "vnoremap",
    "xnoremap",
    "snoremap",
    "cnoremap",
    "onoremap",
]


def plug(fname: str) -> str:
    """
    A plugin action.
    """
    return f"<plug>({fname})"


def act(fname: str) -> str:
    """
    A IDE action.
    """
    return f"<action>({fname})"


def explain[T: dict[Any, Any]](description: str, value: T) -> T:
    value.__dict__["description"] = description
    return value


class _(NamedTuple):
    mode: Mode | NMode
    action: Union[list["Keymap"], str]
    description: str | None = None


type Keymap = Mapping[str, Union["Keymap", _]]


what: Keymap = {
    "<leader>": {
        "<leader>": {
            "k": _("map", plug("easymotion-k"), "look up"),
            "j": _("map", plug("easymotion-j"), "look down"),
            "h": _("map", plug("easymotion-b"), "look left"),
            "l": _("map", plug("easymotion-w"), "look right"),
        },
        "/": _("nnoremap", ":noh<return>", "clear highlight"),
        "i": explain(
            "information",
            {
                "a": _("nmap", act("ShowErrorDescription")),
            },
        ),
    },
    "ctrl": {
        "h": _("nnoremap", "<C-w>h"),
        "l": _("nnoremap", "<C-w>l"),
        "k": _("nnoremap", "<C-w>k"),
        "j": _("nnoremap", "<C-w>j"),
        "i": _("nmap", act("Back")),
        "o": _("nmap", act("Back")),
        "m": _("nmap", act("ShowPopupMenu")),
        "shift": {
            "m": _("nmap", act("ToolWindowsGroup")),
        },
    },
    "[[": _("nmap", act("MethodUp")),
    "]]": _("nmap", act("MethodDown")),
    "<": _("vnoremap", "<gv"),
    ">": _("vnoremap", ">gv"),
    "-": _("nmap", act("ShowNavBar")),
}
