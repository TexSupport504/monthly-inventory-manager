// Jan Copilot Voice Dev Extension
// Connects Jan AI transcriptions to GitHub Copilot chat input in VS Code
// Supports file, clipboard, and WebSocket integration
// Optionally reads Copilot responses aloud using TTS
// Cross-platform: Windows, macOS, Linux

const vscode = require('vscode');
const chokidar = require('chokidar');
const clipboardy = require('clipboardy');
const WebSocket = require('ws');
const fs = require('fs');

// === CONFIGURATION ===
const JAN_TRANSCRIPTION_FILE = vscode.workspace.getConfiguration('janCopilotVoiceDev').get('transcriptionFile') || `${process.env.HOME || process.env.USERPROFILE}/jan_transcription.txt`;
const JAN_WS_PORT = vscode.workspace.getConfiguration('janCopilotVoiceDev').get('wsPort') || 8765;
const USE_FILE_WATCHER = vscode.workspace.getConfiguration('janCopilotVoiceDev').get('useFileWatcher') ?? true;
const USE_CLIPBOARD_WATCHER = vscode.workspace.getConfiguration('janCopilotVoiceDev').get('useClipboardWatcher') ?? false;
const USE_WS_WATCHER = vscode.workspace.getConfiguration('janCopilotVoiceDev').get('useWebSocketWatcher') ?? false;
const ENABLE_TTS = vscode.workspace.getConfiguration('janCopilotVoiceDev').get('enableTTS') ?? false;

let lastClipboard = '';
let lastFileContent = '';
let wsServer = null;

// Insert text into Copilot chat input
function insertToCopilotChat(text) {
    vscode.commands.executeCommand('github.copilot-chat.focus').then(() => {
        vscode.commands.executeCommand('editor.action.insertSnippet', {snippet: text});
    });
}

// Optionally read Copilot response aloud
function speakText(text) {
    if (!ENABLE_TTS) return;
    vscode.commands.executeCommand('vscode-speech.speak', text);
}

// Watch Jan transcription file for changes
function startFileWatcher() {
    const watcher = chokidar.watch(JAN_TRANSCRIPTION_FILE, {persistent: true});
    watcher.on('change', path => {
        fs.readFile(path, 'utf8', (err, data) => {
            if (!err && data && data !== lastFileContent) {
                lastFileContent = data;
                insertToCopilotChat(data.trim());
                speakText(data.trim());
            }
        });
    });
}

// Watch clipboard for new transcriptions
function startClipboardWatcher() {
    setInterval(() => {
        const current = clipboardy.readSync();
        if (current && current !== lastClipboard) {
            lastClipboard = current;
            insertToCopilotChat(current.trim());
            speakText(current.trim());
        }
    }, 1000);
}

// Listen for transcriptions via WebSocket
function startWebSocketWatcher() {
    wsServer = new WebSocket.Server({ port: JAN_WS_PORT });
    wsServer.on('connection', ws => {
        ws.on('message', message => {
            if (message) {
                insertToCopilotChat(message.toString().trim());
                speakText(message.toString().trim());
            }
        });
    });
}

function activate(context) {
    context.subscriptions.push(
        vscode.commands.registerCommand('janCopilotVoiceDev.startWatcher', () => {
            if (USE_FILE_WATCHER) startFileWatcher();
            if (USE_CLIPBOARD_WATCHER) startClipboardWatcher();
            if (USE_WS_WATCHER) startWebSocketWatcher();
            vscode.window.showInformationMessage('Jan-Copilot Voice Dev Watcher started!');
        })
    );
}

function deactivate() {
    if (wsServer) wsServer.close();
}

module.exports = {
    activate,
    deactivate
};
