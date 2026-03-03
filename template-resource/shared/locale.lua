--[[
  ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
  ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
  ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗
  ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝
  ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
  ════════════════════════════════════════════════════════════════
  🐺 Template Resource — Localization System
  Multi-Language Support
  ════════════════════════════════════════════════════════════════
  SERVER INFORMATION
  ──────────────────────────────────────────────────────────────
  Server:    The Land of Wolves 🐺
  Developer: iBoss21 / The Lux Empire
  Website:   https://www.wolves.land
  Discord:   https://discord.gg/CrKcWdfd3A
  Store:     https://theluxempire.tebex.io
  ════════════════════════════════════════════════════════════════
  © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
  ════════════════════════════════════════════════════════════════
]]

Locale = {}

-- ═══════════════════════════════════════════════════════════
-- ██████ TRANSLATION TABLES █████████████████████████████████
-- ═══════════════════════════════════════════════════════════

Locale.Translations = {
    -- ═══════════════════════════════════════════════════════════
    -- English (en)
    -- ═══════════════════════════════════════════════════════════
    ['en'] = {
        -- Interactions
        ['interact_loot'] = 'Press ~INPUT_CONTEXT~ to search',
        ['interact_looting'] = 'Searching...',
        ['interact_looted'] = 'Already searched',
        
        -- Success Messages
        ['loot_success'] = 'You found something!',
        ['loot_found_money'] = 'Found $%s',
        ['loot_found_item'] = 'Found %sx %s',
        ['loot_found_nothing'] = 'Nothing useful here',
        
        -- Error Messages
        ['loot_cooldown'] = 'You need to wait before searching again',
        ['loot_too_far'] = 'You are too far away',
        ['loot_cancelled'] = 'Search cancelled',
        ['loot_failed'] = 'Search failed',
        
        -- Progress Bar
        ['progress_searching'] = 'Searching...',
        
        -- Notifications
        ['notify_title'] = 'Looting',
        ['notify_error'] = 'Error',
        ['notify_success'] = 'Success',
        
        -- Security
        ['security_exploit_detected'] = 'Exploit attempt detected',
        ['security_kicked'] = 'You have been kicked for exploiting',
    },
    
    -- ═══════════════════════════════════════════════════════════
    -- Spanish (es)
    -- ═══════════════════════════════════════════════════════════
    ['es'] = {
        ['interact_loot'] = 'Presiona ~INPUT_CONTEXT~ para buscar',
        ['interact_looting'] = 'Buscando...',
        ['interact_looted'] = 'Ya buscado',
        ['loot_success'] = '¡Encontraste algo!',
        ['loot_found_money'] = 'Encontrado $%s',
        ['loot_found_item'] = 'Encontrado %sx %s',
        ['loot_found_nothing'] = 'Nada útil aquí',
        ['loot_cooldown'] = 'Necesitas esperar antes de buscar de nuevo',
        ['loot_too_far'] = 'Estás muy lejos',
        ['loot_cancelled'] = 'Búsqueda cancelada',
        ['loot_failed'] = 'Búsqueda fallida',
        ['progress_searching'] = 'Buscando...',
        ['notify_title'] = 'Botín',
        ['notify_error'] = 'Error',
        ['notify_success'] = 'Éxito',
        ['security_exploit_detected'] = 'Intento de exploit detectado',
        ['security_kicked'] = 'Has sido expulsado por hacer trampa',
    },
    
    -- ═══════════════════════════════════════════════════════════
    -- French (fr)
    -- ═══════════════════════════════════════════════════════════
    ['fr'] = {
        ['interact_loot'] = 'Appuyez sur ~INPUT_CONTEXT~ pour fouiller',
        ['interact_looting'] = 'Fouille en cours...',
        ['interact_looted'] = 'Déjà fouillé',
        ['loot_success'] = 'Vous avez trouvé quelque chose!',
        ['loot_found_money'] = 'Trouvé $%s',
        ['loot_found_item'] = 'Trouvé %sx %s',
        ['loot_found_nothing'] = 'Rien d\'utile ici',
        ['loot_cooldown'] = 'Vous devez attendre avant de fouiller à nouveau',
        ['loot_too_far'] = 'Vous êtes trop loin',
        ['loot_cancelled'] = 'Fouille annulée',
        ['loot_failed'] = 'Fouille échouée',
        ['progress_searching'] = 'Fouille...',
        ['notify_title'] = 'Pillage',
        ['notify_error'] = 'Erreur',
        ['notify_success'] = 'Succès',
        ['security_exploit_detected'] = 'Tentative d\'exploitation détectée',
        ['security_kicked'] = 'Vous avez été expulsé pour exploitation',
    },
    
    -- ═══════════════════════════════════════════════════════════
    -- German (de)
    -- ═══════════════════════════════════════════════════════════
    ['de'] = {
        ['interact_loot'] = 'Drücke ~INPUT_CONTEXT~ zum Durchsuchen',
        ['interact_looting'] = 'Durchsuchen...',
        ['interact_looted'] = 'Bereits durchsucht',
        ['loot_success'] = 'Du hast etwas gefunden!',
        ['loot_found_money'] = '$%s gefunden',
        ['loot_found_item'] = '%sx %s gefunden',
        ['loot_found_nothing'] = 'Nichts Nützliches hier',
        ['loot_cooldown'] = 'Du musst warten, bevor du wieder suchen kannst',
        ['loot_too_far'] = 'Du bist zu weit weg',
        ['loot_cancelled'] = 'Suche abgebrochen',
        ['loot_failed'] = 'Suche fehlgeschlagen',
        ['progress_searching'] = 'Durchsuchen...',
        ['notify_title'] = 'Plünderung',
        ['notify_error'] = 'Fehler',
        ['notify_success'] = 'Erfolg',
        ['security_exploit_detected'] = 'Exploit-Versuch erkannt',
        ['security_kicked'] = 'Du wurdest wegen Exploits gekickt',
    },
    
    -- ═══════════════════════════════════════════════════════════
    -- Portuguese (pt)
    -- ═══════════════════════════════════════════════════════════
    ['pt'] = {
        ['interact_loot'] = 'Pressione ~INPUT_CONTEXT~ para procurar',
        ['interact_looting'] = 'Procurando...',
        ['interact_looted'] = 'Já procurado',
        ['loot_success'] = 'Você encontrou algo!',
        ['loot_found_money'] = 'Encontrado $%s',
        ['loot_found_item'] = 'Encontrado %sx %s',
        ['loot_found_nothing'] = 'Nada útil aqui',
        ['loot_cooldown'] = 'Você precisa esperar antes de procurar novamente',
        ['loot_too_far'] = 'Você está muito longe',
        ['loot_cancelled'] = 'Busca cancelada',
        ['loot_failed'] = 'Busca falhou',
        ['progress_searching'] = 'Procurando...',
        ['notify_title'] = 'Saque',
        ['notify_error'] = 'Erro',
        ['notify_success'] = 'Sucesso',
        ['security_exploit_detected'] = 'Tentativa de exploit detectada',
        ['security_kicked'] = 'Você foi expulso por fazer exploit',
    }
}

-- ═══════════════════════════════════════════════════════════
-- ██████ TRANSLATION FUNCTION ███████████████████████████████
-- ═══════════════════════════════════════════════════════════

---Get translated string
---@param key string The translation key
---@param ... any Optional format arguments
---@return string The translated string
function Locale.Get(key, ...)
    local lang = Config.Lang or 'en'
    local translations = Locale.Translations[lang] or Locale.Translations['en']
    local text = translations[key] or key
    
    -- Format string if arguments provided
    if ... then
        return string.format(text, ...)
    end
    
    return text
end

-- Alias for easier usage
_L = Locale.Get

-- ═══════════════════════════════════════════════════════════
-- ██████ DEBUG FUNCTION █████████████████████████████████████
-- ═══════════════════════════════════════════════════════════

---Print debug message if debug is enabled
---@param message string The debug message
function Locale.Debug(message)
    if Config.Debug and Config.Debug.enabled then
        print("^3[DEBUG] ^0" .. message)
    end
end

-- ═══════════════════════════════════════════════════════════
-- ██████ END OF LOCALIZATION ████████████████████████████████
-- ═══════════════════════════════════════════════════════════
