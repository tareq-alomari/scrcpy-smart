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
    statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Right, 100);
    statusBarItem.command = 'scrcpy-smart.quickPick';
    statusBarItem.text = '$(sync~spin) Setting up...';
    statusBarItem.tooltip = 'Setting up Scrcpy Smart';
    statusBarItem.show();
    context.subscriptions.push(statusBarItem);
    
    autoSetup(context).catch(() => {});
    
    statusBarItem.text = '$(device-mobile) Scrcpy';
    statusBarItem.tooltip = 'Click to connect device';

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
        vscode.commands.registerCommand('scrcpy-smart.installDeps', () => installDependencies()),
        vscode.commands.registerCommand('scrcpy-smart.setup', () => {
            context.globalState.update('setupCompleted', false);
            autoSetup(context);
        })
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
        { label: '$(gear) Run Setup Wizard', action: 'setup' },
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
        setup: () => { vscode.commands.executeCommand('scrcpy-smart.setup'); },
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
    
    if (!fs.existsSync(script) && !script.includes('/')) {
        try {
            await execAsync(`command -v ${script}`);
        } catch {
            const choice = await vscode.window.showErrorMessage(
                '❌ scrcpy-smart not found. Please install it first.',
                'Open Installation Guide',
                'Set Custom Path'
            );
            if (choice === 'Open Installation Guide') {
                vscode.env.openExternal(vscode.Uri.parse('https://github.com/tareq-alomari/scrcpy-smart#-quick-install'));
            } else if (choice === 'Set Custom Path') {
                vscode.commands.executeCommand('workbench.action.openSettings', 'scrcpy-smart.scriptPath');
            }
            return;
        }
    }
    
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
    
    const config = vscode.workspace.getConfiguration('scrcpy-smart');
    const customPath = config.get<string>('scriptPath');
    
    if (customPath && fs.existsSync(customPath)) {
        scriptPath = customPath;
        return scriptPath;
    }
    
    const homeDir = os.homedir();
    const paths = [
        'scrcpy-smart',
        path.join(homeDir, '.local', 'bin', 'scrcpy-smart'),
        '/usr/local/bin/scrcpy-smart',
        '/usr/bin/scrcpy-smart'
    ];
    
    scriptPath = paths.find(p => {
        try {
            return fs.existsSync(p) || execAsync(`command -v ${p}`).then(() => true).catch(() => false);
        } catch {
            return false;
        }
    }) || 'scrcpy-smart';
    
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

async function autoSetup(context: vscode.ExtensionContext) {
    const setupDone = context.globalState.get<boolean>('setupCompleted');
    if (setupDone) {
        scriptPath = getScriptPath();
        return;
    }
    
    const steps: string[] = [];
    
    // Check scrcpy-smart CLI
    try {
        await execAsync('command -v scrcpy-smart');
        scriptPath = 'scrcpy-smart';
    } catch {
        steps.push('scrcpy-smart CLI');
    }
    
    // Check scrcpy
    try {
        await execAsync('command -v scrcpy');
        scrcpyInstalled = true;
    } catch {
        steps.push('scrcpy');
        scrcpyInstalled = false;
    }
    
    // Check ADB
    try {
        await execAsync('command -v adb');
    } catch {
        steps.push('ADB');
    }
    
    if (steps.length === 0) {
        await context.globalState.update('setupCompleted', true);
        vscode.window.showInformationMessage('✅ Scrcpy Smart is ready!');
        return;
    }
    
    const missing = steps.join(', ');
    const choice = await vscode.window.showWarningMessage(
        `⚠️ Missing: ${missing}. Install automatically?`,
        'Install All',
        'Manual Setup',
        'Later'
    );
    
    if (choice === 'Install All') {
        await autoInstallAll(context, steps);
    } else if (choice === 'Manual Setup') {
        vscode.env.openExternal(vscode.Uri.parse('https://github.com/tareq-alomari/scrcpy-smart#-quick-install'));
    }
}

async function autoInstallAll(context: vscode.ExtensionContext, missing: string[]) {
    const terminal = vscode.window.createTerminal('Scrcpy Setup');
    terminal.show();
    
    const platform = process.platform;
    const commands: string[] = [];
    
    if (missing.includes('scrcpy-smart CLI')) {
        commands.push('echo "📦 Installing scrcpy-smart CLI..."');
        commands.push('curl -fsSL https://raw.githubusercontent.com/tareq-alomari/scrcpy-smart/main/install.sh | bash');
    }
    
    if (missing.includes('scrcpy') || missing.includes('ADB')) {
        commands.push('echo "📦 Installing scrcpy and ADB..."');
        
        if (platform === 'linux') {
            commands.push('sudo apt update && sudo apt install -y scrcpy adb');
        } else if (platform === 'darwin') {
            commands.push('brew install scrcpy android-platform-tools');
        } else if (platform === 'win32') {
            commands.push('winget install Genymobile.scrcpy');
            commands.push('winget install Google.PlatformTools');
        }
    }
    
    commands.push('echo "✅ Installation complete! Please restart VS Code."');
    terminal.sendText(commands.join(' && '));
    
    await vscode.window.showInformationMessage(
        '📦 Installing dependencies... Check terminal for progress. Restart VS Code when done.',
        'Restart Now'
    ).then(choice => {
        if (choice === 'Restart Now') {
            vscode.commands.executeCommand('workbench.action.reloadWindow');
        }
    });
    
    await context.globalState.update('setupCompleted', true);
}

export function deactivate() {
    statusBarItem?.dispose();
}
