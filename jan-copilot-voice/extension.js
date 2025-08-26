const vscode = require('vscode');
const chokidar = require('chokidar');
const clipboardy = require('clipboardy');
const WebSocket = require('ws');
const fs = require('fs');

// === CONFIGURATION ===
const JAN_TRANSCRIPTION_FILE = vscode.workspace.getConfiguration('janCopilotVoice').get('transcriptionFile') || `${process.env.HOME || process.env.USERPROFILE}/jan_transcription.txt`;
const JAN_WS_PORT = vscode.workspace.getConfiguration('janCopilotVoice').get('wsPort') || 8765;
const USE_FILE_WATCHER = vscode.workspace.getConfiguration('janCopilotVoice').get('useFileWatcher') ?? true;
const USE_CLIPBOARD_WATCHER = vscode.workspace.getConfiguration('janCopilotVoice').get('useClipboardWatcher') ?? false;
const USE_WS_WATCHER = vscode.workspace.getConfiguration('janCopilotVoice').get('useWebSocketWatcher') ?? false;
const ENABLE_TTS = vscode.workspace.getConfiguration('janCopilotVoice').get('enableTTS') ?? false;

let lastClipboard = '';
let lastFileContent = '';
let wsServer = null;

function insertToCopilotChat(text) {
    // Focus Copilot Chat input and insert text
    vscode.commands.executeCommand('github.copilot-chat.focus').then(() => {
        vscode.commands.executeCommand('editor.action.insertSnippet', {snippet: text});
    });
}

function speakText(text) {
    if (!ENABLE_TTS) return;
    // Use VS Code's built-in speech extension if available
    vscode.commands.executeCommand('vscode-speech.speak', text);
}

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
        vscode.commands.registerCommand('janCopilotVoice.startWatcher', () => {
            if (USE_FILE_WATCHER) startFileWatcher();
            if (USE_CLIPBOARD_WATCHER) startClipboardWatcher();
            if (USE_WS_WATCHER) startWebSocketWatcher();
            vscode.window.showInformationMessage('Jan-Copilot Voice Watcher started!');
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
