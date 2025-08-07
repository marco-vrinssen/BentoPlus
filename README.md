# Bento Plus

## Addon for World of Warcraft Retail offering lightweight, efficient interface enhancements and features designed to improve your gameplay experience.

### Interface Enhancements

- **Auto-open Warband Bank**: Automatically opens the Warband Bank tab when visiting the bank
- **Hide nameplate buffs**: Removes buff displays on nameplates for a cleaner appearance
- **Clean arena frames**: Hides casting bars, CC remover frames, names, and debuff frames on arena frames; repositions stealth icons
- **Mute alert banners**: Silences guild achievement and loot alert banner sounds and notifications
- **Hide prestige badges**: Removes prestige badges from target and focus frames
- **Smart status bars**: Hides XP tracking bar automatically when reaching maximum level
- **Hide vehicle seat indicator**: Removes the vehicle seat indicator frame
- **Scale action button highlights**: Increases combat highlight size on action buttons for better visibility
- **Enhanced tooltips**: Adds helpful tooltip information to the main menu button

### Automation Features

- **Auto-sell and repair**: Automatically sells junk items and repairs equipment at merchants
- **Instant auto-looting**: Sets loot rate to instant and automatically loots all items
- **Smart PvP ghost release**: Auto-releases ghost in PvP zones when no self-resurrect options are available
- **Dynamic Tab targeting**: Auto-rebinds Tab key to target enemy players in PvP zones and all enemies in PvE zones
- **Auto-apply transmog**: Automatically applies transmog changes when opening the wardrobe collection

### Customizable Features

- **Toggle raid frame auras**: Control visibility of auras on raid frames (hidden by default)
  - Uses persistent storage to remember your preference
  - Can be toggled via slash command

### Context Menu Enhancements

- **Copy player names**: Adds "Copy Full Name" option to player right-click menus
  - Works across various contexts: party, raid, guild, communities, LFG, etc.
  - Creates auto-closing dialog box for easy copying

### Messaging Tools

- **Multi-whisper messaging**: Streamlined interface for sending messages to multiple players
  - Enter player names in a scrollable text area, one per line
  - Send messages to all players in your list with a single command
  - Persistent player list management across sessions
  - Easy-to-use interface with helpful instructions

- **Auto-invite messaging**: Automated welcome messages for guild/community invitations
  - Automatically sends customizable whisper messages to invited players
  - Configurable message content with easy-to-use interface
  - Option to enable/disable auto-send functionality
  - Smart detection of successful invitations

### Auction House Improvements

- **Current expansion filter**: Automatically enables current expansion filter by default
- **Spacebar posting**: Use spacebar to quickly post auction items
- **Persistent favorites**: Automatically manages and stores auction house favorites

### Slash Commands

- **Toggle Lua errors**: `/errors`
  - Toggles the display of Lua errors for debugging purposes

- **Reload UI**: `/ui`
  - Performs a clean UI reload

- **Restart graphics**: `/gx`
  - Restarts the graphics engine for applying graphics settings

- **Full reload**: `/rl`
  - Reloads UI, restarts graphics engine, and clears cache

- **Toggle raid frame auras**: `/bentoraid`
  - Toggles visibility of auras on raid frames

- **Toggle arena frame elements**: `/bentoarena`
  - Toggles visibility of casting bars, names, and debuff frames on arena frames
  - Elements are modified by default for a cleaner arena experience
  - Uses persistent storage to remember your preference

- **Toggle button glow**: `/bentoglow`
  - Toggles visibility of button glow effects on action buttons

- **Open multi-whisper window**: `/multiwhisper`
  - Opens the multi-whisper interface for managing player lists and sending messages

- **Send multi-whisper**: `/w+ MESSAGE`
  - Sends MESSAGE to all players in your current multi-whisper list

### Quick Actions

- **Right-click Main Menu**: Right-click the main menu micro button for instant UI reload
- **Spacebar Auction Posting**: Use spacebar to quickly post items in the Auction House

### Technical Notes

- Uses persistent storage (`BentoDB`) for user preferences
- Automatically handles event registration and cleanup
- Optimized for performance with minimal resource usage
- Compatible with current World of Warcraft retail version
