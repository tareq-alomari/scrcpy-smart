import * as vscode from 'vscode';
import { exec } from 'child_process';
import { promisify } from 'util';
import * as path from 'path';
import * as os from 'os';
import * as fs from 'fs';

const execAsync = promisify(exec);
let statusBarItem: vscode.StatusBarItem;
let currentDevice: string | null = null;
let scriptPath: string | null = null;
let scrcpyInstalled: boolean | null = null;

export function activate(context: vscode.ExtensionContext) {
    scriptPath = getScriptPath();
    checkDependencies().catch(() => {});
    
    statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Right, 100);
    statusBarItem.command = 'scrcpy-smart.quickPick';
    statusBarItem.text = '$(device-mobile) Scrcpy';
    statusBarItem.tooltip = 'Click to connect device';
    statusBarItem.show();
    context.subscriptions.push(statusBarItem);

    context.subscriptions.push(
        vscode.commands.registerCommand('scrcpy-smart.connect', () => connectDevice(context)),
        vscode.commands.registerCommand('scrcpy-smart.quickPick', () => showQuickPick(context)),
        vscode.commands.registerCommand('scrcpy-smart.connectIP', async () => {
            const ip = await vscode.window.showInputBox({ prompt: 'Enter device IP address' });
            if (ip) await connectDevice(context, ['--ip', ip]);
        }),
        vscode.commands.registerCommand('scrcpy-smart.screenshot', async () => {
            await runCommand(context, ['--screenshot']);
            showNotification('Screenshot captured', 'success');
        }),
        vscode.commands.registerCommand('scrcpy-smart.listDevices', () => runCommand(context, ['--list'])),
        vscode.commands.registerCommand('scrcpy-smart.reset', async () => {
            await runCommand(context, ['--reset']);
            currentDevice = null;
            updateStatusBar();
            showNotification('Connection reset', 'info');
        }),
        vscode.commands.registerCommand('scrcpy-smart.connectProfile', () => connectWithProfile(context)),
        vscode.commands.registerCommand('scrcpy-smart.installDeps', () => installDependencies())
    );
}

async function showQuickPick(context: vscode.ExtensionContext) {
    const items = [
        { label: '$(plug) Connect Device', action: 'connect' },
        { label: '$(globe) Connect to IP', action: 'connectIP' },
        { label: '$(device-camera) Take Screenshot', action: 'screenshot' },
        { label: '$(list-unordered) List Devices', action: 'list' },
        { label: '$(symbol-misc) Gaming Profile', action: 'gaming' },
        { label: '$(record) Recording Profile', action: 'recording' },
        { label: '$(presentation) Demo Profile', action: 'demo' },
        { label: '$(cloud-download) Install Dependencies', action: 'install' },
        { label: '$(refresh) Reset Connection', action: 'reset' }
    ];

    const selected = await vscode.window.showQuickPick(items, { placeHolder: 'Select Scrcpy action' });
    if (!selected) return;

    const actions: { [key: string]: () => void | Promise<void> } = {
        connect: () => connectDevice(context),
        connectIP: () => { vscode.commands.executeCommand('scrcpy-smart.connectIP'); },
        screenshot: () => { vscode.commands.executeCommand('scrcpy-smart.screenshot'); },
        list: () => { vscode.commands.executeCommand('scrcpy-smart.listDevices'); },
        gaming: () => connectDevice(context, ['--profile', 'gaming']),
        recording: () => connectDevice(context, ['--profile', 'recording']),
        demo: () => connectDevice(context, ['--profile', 'demo']),
        install: () => { vscode.commands.executeCommand('scrcpy-smart.installDeps'); },
        reset: () => { vscode.commands.executeCommand('scrcpy-smart.reset'); }
    };

    await actions[selected.action]?.();
}

async function connectWithProfile(context: vscode.ExtensionContext) {
    const profiles = [
        { label: 'Gaming', description: 'High FPS, low latency', value: 'gaming' },
        { label: 'Recording', description: 'High quality', value: 'recording' },
        { label: 'Demo', description: 'Borderless, always-on-top', value: 'demo' },
        { label: 'Battery', description: 'Low power consumption', value: 'battery' }
    ];

    const selected = await vscode.window.showQuickPick(profiles, { placeHolder: 'Select profile' });
    if (selected) await connectDevice(context, ['--profile', selected.value]);
}

function updateStatusBar(device?: string) {
    if (device) {
        currentDevice = device;
        statusBarItem.text = `$(device-mobile) ${device}`;
        statusBarItem.tooltip = `Connected to ${device}`;
    } else {
        currentDevice = null;
        statusBarItem.text = '$(device-mobile) Scrcpy';
        statusBarItem.tooltip = 'Click to connect device';
    }
}

async function connectDevice(context: vscode.ExtensionContext, args: string[] = []) {
    const script = scriptPath || getScriptPath();
    
    try {
        await vscode.window.withProgress({
            location: vscode.ProgressLocation.Notification,
            title: 'Connecting...',
            cancellable: false
        }, () => execAsync(`bash "${script}" ${args.join(' ')}`));
        
        updateStatusBar('Device');
        showNotification('Connected', 'success');
    } catch (error: any) {
        showNotification(`Failed: ${error.message}`, 'error');
    }
}

async function runCommand(context: vscode.ExtensionContext, args: string[]) {
    const script = scriptPath || getScriptPath();
    try {
        const { stdout } = await execAsync(`bash "${script}" ${args.join(' ')}`);
        if (stdout) vscode.window.showInformationMessage(stdout);
    } catch (error: any) {
        showNotification(`Error: ${error.message}`, 'error');
    }
}

function getScriptPath(): string {
    if (scriptPath) return scriptPath;
    
    const homeDir = os.homedir();
    const paths = [
        path.join(homeDir, '.local', 'bin', 'scrcpy-smart'),
        path.join(homeDir, 'scrcpy-smart', 'scrcpy-smart.sh')
    ];
    
    scriptPath = paths.find(p => fs.existsSync(p)) || paths[1];
    return scriptPath;
}

function showNotification(message: string, type: 'success' | 'error' | 'info' = 'info') {
    const icons = { success: '✅', error: '❌', info: 'ℹ️' };
    const msg = `${icons[type]} ${message}`;
    type === 'error' ? vscode.window.showErrorMessage(msg) : vscode.window.showInformationMessage(msg);
}

async function checkDependencies() {
    if (scrcpyInstalled !== null) return;
    
    try {
        await execAsync('command -v scrcpy');
        scrcpyInstalled = true;
    } catch {
        scrcpyInstalled = false;
        const choice = await vscode.window.showWarningMessage('⚠️ scrcpy not found. Install it now?', 'Install', 'Later');
        if (choice === 'Install') await installDependencies();
    }
}

async function installDependencies() {
    const homeDir = os.homedir();
    const isWindows = process.platform === 'win32';
    const installerPath = path.join(homeDir, 'scrcpy-smart', isWindows ? 'install-scrcpy.ps1' : 'install-scrcpy.sh');
    const command = isWindows ? `powershell -ExecutionPolicy Bypass -File "${installerPath}"` : `bash "${installerPath}"`;
    
    if (!fs.existsSync(installerPath)) {
        const choice = await vscode.window.showErrorMessage('❌ Installer not found. Install manually?', 'Open Guide', 'Cancel');
        if (choice === 'Open Guide') vscode.env.openExternal(vscode.Uri.parse('https://github.com/Genymobile/scrcpy#get-the-app'));
        return;
    }

    const terminal = vscode.window.createTerminal('Scrcpy Installer');
    terminal.show();
    terminal.sendText(command);
    vscode.window.showInformationMessage('📦 Installing scrcpy... Check terminal for progress.');
}

export function deactivate() {
    statusBarItem?.dispose();
}
