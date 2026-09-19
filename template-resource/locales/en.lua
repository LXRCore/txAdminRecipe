--[[ ═══════════════════════════════════════════════════════════════════════════
     🐺 TEMPLATE-RESOURCE — Locale: English (canonical)
     © 2026 iBoss21 / LXRCore | lxrcore.com
     ═══════════════════════════════════════════════════════════════════════════ ]]

Locale.Register('en', {
    prompt  = { drink = 'Draw water' },
    command = { well = 'Where is the nearest well?' },
    info    = {
        filled  = 'Cold and clean. You keep a bottle.',
        nearest = 'The nearest well is %{m} m away.',
    },
    error   = {
        rate     = 'Slow down.',
        invalid  = 'Nothing to draw from here.',
        too_far  = 'You are too far from the well.',
        cooldown = 'The bucket is still down. Come back in a while (%{s} s).',
        full     = 'You cannot carry any more.',
        none     = 'There is no well anywhere near.',
    },
})
