# Jan Copilot Voice Dev Integration

This VS Code extension enables a fully hands-free, voice-driven workflow between the Jan open-source AI assistant and GitHub Copilot.

## Features

- Detects new transcriptions from Jan via file, clipboard, or WebSocket
- Automatically inserts transcribed text into Copilot chat input
- Optionally reads Copilot responses aloud using TTS
- Cross-platform: Windows, macOS, Linux

## Setup

1. Install [Jan AI assistant](https://github.com/jan-ai/jan) and configure it to output transcriptions (file, clipboard, or WebSocket)
2. Install this extension in VS Code:
   - Clone this repo into your extensions folder or use `code --install-extension`
   - Run `npm install` in the extension directory
3. Configure settings in VS Code:
   - `janCopilotVoiceDev.transcriptionFile`: Path to Jan's transcription file (for file watcher)
   - `janCopilotVoiceDev.wsPort`: Port for WebSocket (default: 8765)
   - `janCopilotVoiceDev.useFileWatcher`: Enable file watcher (default: true)
   - `janCopilotVoiceDev.useClipboardWatcher`: Enable clipboard watcher (default: false)
   - `janCopilotVoiceDev.useWebSocketWatcher`: Enable WebSocket watcher (default: false)
   - `janCopilotVoiceDev.enableTTS`: Enable text-to-speech (default: false)
4. Start the watcher: Press `F1` and run `Jan-Copilot Voice Dev Watcher`

## Usage

- Speak to Jan as usual
- Your transcription will appear in Copilot chat automatically
- Copilot will respond; optionally, response can be read aloud

## Requirements

- Jan AI assistant
- GitHub Copilot Chat extension
- (Optional) VS Code Speech extension for TTS

## Cross-platform

- All watcher methods work on Windows, macOS, and Linux

## Troubleshooting

- Ensure Jan is running and outputting transcriptions
- Check extension settings for correct file path, port, or clipboard usage
- For TTS, install the [VS Code Speech extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-speech)

## License

MIT
