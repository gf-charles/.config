from qutebrowser.api import interceptor
config.load_autoconfig()

c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = 'dark'
c.tabs.position = "left"
c.tabs.show = "multiple"

c.content.blocking.adblock.lists = [
    'https://easylist.to/easylist/easylist.txt',
    'https://easylist.to/easylist/easyprivacy.txt',
    'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt',       # uBlock Origin's main filter
    'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt',  # Common annoyances, including anti-adblock
    'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt',     # Malware domains
    # 'https://raw.githubusercontent.com/reek/anti-adblock-killer/master/anti-adblock-killer-filters.txt', # Anti-Adblock Killer (may have mixed results)
]

# Bind Super+Number to switch to the corresponding tab
config.bind('<super-1>', 'tab-focus 1')
config.bind('<super-2>', 'tab-focus 2')
config.bind('<super-3>', 'tab-focus 3')
config.bind('<super-4>', 'tab-focus 4')
config.bind('<super-5>', 'tab-focus 5')
config.bind('<super-6>', 'tab-focus 6')
config.bind('<super-7>', 'tab-focus 7')
config.bind('<super-8>', 'tab-focus 8')
config.bind('<super-9>', 'tab-focus 9')

config.bind('xt', 'config-cycle tabs.show always switching never')

config.bind('<super-0>', 'tab-focus -1') # -1 means the last tab

config.set('qt.args', [
    'enable-features=WebRTCPipeWireCapturer',
])

config.bind('ym', 'hint links spawn sh -c "mpv --no-terminal --fullscreen --log-file=/tmp/mpv_debug.log --msg-level=all=v \\"{hint-url}\\" &"')
