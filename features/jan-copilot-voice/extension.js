
const chokidar = require('chokidar');
const WebSocket = require('ws');
const clipboardy = require('clipboardy');
const fs = require('fs');
const path = require('path');
let say;
try { say = require('say'); } catch (e) { say = null; }

const TRANSCRIPTION_FILE = path.join(__dirname, 'jan_transcription.txt');
const WEBSOCKET_PORT = 8765;
const CLIPBOARD_POLL_INTERVAL = 1000; // ms
let watchersEnabled = {
  file: true,
  clipboard: true,
  websocket: true
};

let lastClipboard = '';

function startFileWatcher(handleTranscription) {
  chokidar.watch(TRANSCRIPTION_FILE).on('change', () => {
    if (!watchersEnabled.file) return;
    const text = fs.readFileSync(TRANSCRIPTION_FILE, 'utf8').trim();
    if (text) handleTranscription(text, 'file');
  });
}

function startClipboardWatcher(handleTranscription) {
  setInterval(() => {
    if (!watchersEnabled.clipboard) return;
    const text = clipboardy.readSync().trim();
    if (text && text !== lastClipboard) {
      lastClipboard = text;
      handleTranscription(text, 'clipboard');
    }
  }, CLIPBOARD_POLL_INTERVAL);
}

function startWebSocketServer(handleTranscription) {
  const wss = new WebSocket.Server({ port: WEBSOCKET_PORT });
  wss.on('connection', ws => {
    ws.on('message', msg => {
      if (!watchersEnabled.websocket) return;
      const text = msg.toString().trim();
      if (text) handleTranscription(text, 'websocket');
    });
  });
  console.log(`WebSocket server listening on port ${WEBSOCKET_PORT}`);
}

function showJanSettingsPanel(context, handleTranscription) {
  const vscode = require('vscode');
  const panel = vscode.window.createWebviewPanel(
    'janSettings',
    'Jan Copilot Voice Settings',
    vscode.ViewColumn.One,
    { enableScripts: true }
  );
  panel.webview.html = `
    <html>
      <body>
        <h2>Jan Copilot Voice Settings</h2>
        <form>
          <label><input type="checkbox" id="fileWatcher" ${watchersEnabled.file ? 'checked' : ''}/> Enable File Watcher</label><br>
          <label><input type="checkbox" id="clipboardWatcher" ${watchersEnabled.clipboard ? 'checked' : ''}/> Enable Clipboard Watcher</label><br>
          <label><input type="checkbox" id="websocketWatcher" ${watchersEnabled.websocket ? 'checked' : ''}/> Enable WebSocket Watcher</label><br>
        </form>
        <button onclick="vscode.postMessage({ command: 'simulate' })">Simulate Jan Transcription</button>
        <p>Configure TTS: Set JAN_TTS=on in your environment.</p>
        <div id="status"></div>
        <script>
          const vscode = acquireVsCodeApi();
          document.getElementById('fileWatcher').addEventListener('change', e => {
            vscode.postMessage({ command: 'toggle', watcher: 'file', enabled: e.target.checked });
          });
          document.getElementById('clipboardWatcher').addEventListener('change', e => {
            vscode.postMessage({ command: 'toggle', watcher: 'clipboard', enabled: e.target.checked });
          });
          document.getElementById('websocketWatcher').addEventListener('change', e => {
            vscode.postMessage({ command: 'toggle', watcher: 'websocket', enabled: e.target.checked });
          });
        </script>
      </body>
    </html>
  `;
  panel.webview.onDidReceiveMessage(message => {
    if (message.command === 'toggle') {
      watchersEnabled[message.watcher] = message.enabled;
      vscode.window.showInformationMessage(`${message.watcher} watcher ${message.enabled ? 'enabled' : 'disabled'}`);
    }
    if (message.command === 'simulate') {
      handleTranscription('Test transcription from Jan', 'demo');
    }
  });
}

async function handleTranscriptionVSCode(text, source) {
  const vscode = require('vscode');
  console.log(`[${source}] Transcription:`, text);
  vscode.window.showInformationMessage(`Jan (${source}): ${text}`);
  let copilotResponse = null;
  try {
    copilotResponse = await vscode.commands.executeCommand('github.copilot.chat.sendMessage', text);
    console.log('Sent to Copilot Chat:', text);
    vscode.window.showInformationMessage(`Sent to Copilot Chat: ${text}`);
  } catch (err) {
    console.log('Copilot Chat API not available:', err);
    vscode.window.showErrorMessage('Copilot Chat API not available');
  }
  if (say && process.env.JAN_TTS === 'on') {
    say.speak(`You said: ${text}`);
    if (copilotResponse) say.speak(`Copilot replied: ${copilotResponse}`);
  }
}

function activate(context) {
  startFileWatcher(handleTranscriptionVSCode);
  startClipboardWatcher(handleTranscriptionVSCode);
  startWebSocketServer(handleTranscriptionVSCode);
  console.log('Jan Copilot Voice extension activated.');
  context.subscriptions.push(
    require('vscode').commands.registerCommand('janCopilotVoice.showSettings', () => showJanSettingsPanel(context, handleTranscriptionVSCode)),
    require('vscode').commands.registerCommand('janCopilotVoice.simulateTranscription', () => handleTranscriptionVSCode('Test transcription from Jan', 'demo'))
  );
}

function deactivate() {}

module.exports = {
  activate,
  deactivate
};
