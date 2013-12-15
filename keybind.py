
# originally taken from https://github.com/demizer/dotfiles/blob/master/.config/pytyle3/keybind.py

import state
import tile

bindings = {
    'Mod4-y': tile.cmd('tile'),
    'Mod4-u': tile.cmd('untile'),
    'Mod4-h': tile.cmd('decrease_master'),
    'Mod4-l': tile.cmd('increase_master'),
    'Mod4-j': tile.cmd('prev_client'),
    'Mod4-k': tile.cmd('next_client'),
    'Mod4-Shift-j': tile.cmd('switch_prev_client'),
    'Mod4-Shift-k': tile.cmd('switch_next_client'),
    'Mod4-minus': tile.cmd('remove_master'),
    'Mod4-plus': tile.cmd('add_master'),
    'Mod4-Return': tile.cmd('make_master'),
    'Mod4-f': tile.cmd('focus_master'),
    # 'Mod4-tilde': tile.cmd('cycle'),
    # 'Mod4-\': tile.cmd('cycle'),

    # 'Mod4-q': tile.debug_state,
    'Mod4-Shift-q': state.quit,
}
