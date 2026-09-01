#!/usr/bin/env node

'use strict';

const path = require('node:path');
const { spawnSync } = require('node:child_process');
const packageJson = require('../package.json');

const args = process.argv.slice(2);

if (args.length === 1 && (args[0] === '--version' || args[0] === '-v')) {
  console.log(packageJson.version);
  process.exit(0);
}

if (process.platform !== 'darwin') {
  console.error('zyhy-network only supports macOS.');
  process.exit(1);
}

const script = path.join(__dirname, '..', 'zyhy-private-split');
const command = args[0] || 'status';
const rootCommands = new Set([
  'add',
  'apply',
  'clear',
  'install',
  'refresh',
  'remove',
  'uninstall'
]);
const intervalNeedsRoot = command === 'interval' && args.length > 1;

let executable = '/bin/bash';
let commandArgs = [script, ...args];

if ((rootCommands.has(command) || intervalNeedsRoot) && process.getuid?.() !== 0) {
  executable = '/usr/bin/sudo';
  commandArgs = ['/bin/bash', script, ...args];
}

const result = spawnSync(executable, commandArgs, { stdio: 'inherit' });

if (result.error) {
  console.error(`failed to run zyhy-network: ${result.error.message}`);
  process.exit(1);
}

if (result.signal) {
  if (result.signal === 'SIGPIPE') {
    process.exit(0);
  }
  console.error(`zyhy-network stopped by signal ${result.signal}`);
  process.exit(1);
}

process.exit(result.status ?? 1);
