# Jan Copilot Voice Extension

Integrates the Jan open-source AI assistant with GitHub Copilot in VS Code for hands-free, voice-driven workflows.

## Features
- File watcher: auto-inserts transcriptions from Jan
- Clipboard watcher: polls for new transcriptions
- WebSocket server: accepts transcriptions from Jan
- Modular, cross-platform, easy to extend

## Setup
1. `cd features/jan-copilot-voice`
2. `npm install`
3. `node extension.js` (or integrate as VS Code extension)

## Usage
- Point Jan to output transcriptions to `jan_transcription.txt` in this folder
- Or send transcriptions via clipboard or WebSocket (port 8765)
- Extension will log and (optionally) insert into Copilot Chat

## Customization
- Edit `extension.js` to integrate with Copilot Chat API or VS Code commands
- Add TTS or other automation as needed

## License
MIT
