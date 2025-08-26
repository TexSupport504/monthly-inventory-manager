// Jan Copilot Voice Extension
// Integrates Jan open-source AI assistant with GitHub Copilot in VS Code
// Supports file, clipboard, and WebSocket integration for hands-free workflows

const chokidar = require('chokidar');
const WebSocket = require('ws');
const clipboardy = require('clipboardy');
const fs = require('fs');
const path = require('path');

// --- Configuration ---
const TRANSCRIPTION_FILE = path.join(__dirname, 'jan_transcription.txt');
const WEBSOCKET_PORT = 8765;
const CLIPBOARD_POLL_INTERVAL = 1000; // ms

// --- File Watcher ---
function startFileWatcher() {
  chokidar.watch(TRANSCRIPTION_FILE).on('change', () => {
    const text = fs.readFileSync(TRANSCRIPTION_FILE, 'utf8').trim();
    if (text) handleTranscription(text, 'file');
  });
}

// --- Clipboard Watcher ---
let lastClipboard = '';
function startClipboardWatcher() {
  setInterval(() => {
    const text = clipboardy.readSync().trim();
    if (text && text !== lastClipboard) {
      lastClipboard = text;
      handleTranscription(text, 'clipboard');
    }
  }, CLIPBOARD_POLL_INTERVAL);
}

// --- WebSocket Server ---
function startWebSocketServer() {
  const wss = new WebSocket.Server({ port: WEBSOCKET_PORT });
  wss.on('connection', ws => {
    ws.on('message', msg => {
      const text = msg.toString().trim();
      if (text) handleTranscription(text, 'websocket');
    });
  });
  console.log(`WebSocket server listening on port ${WEBSOCKET_PORT}`);
}

// --- Main Handler ---
function handleTranscription(text, source) {
  // Insert transcription into Copilot Chat (simulate by logging)
  console.log(`[${source}] Transcription:`, text);
  // TODO: Integrate with Copilot Chat API or VS Code commands
  // Optionally trigger TTS for Copilot response
}

// --- Entry Point ---
function main() {
  startFileWatcher();
  startClipboardWatcher();
  startWebSocketServer();
  console.log('Jan Copilot Voice extension started.');
}

main();
