#!/usr/bin/env node
import { spawnSync } from 'node:child_process';
const checks = ['flutter --version','flutter doctor -v','dart --version','rustc --version','cargo --version','rustup target list --installed','java -version','adb version','docker --version','docker compose version','node --version','git --version','emulator -list-avds','adb devices'];
let failed=0;
for (const c of checks) { console.log('\n> '+c); const r=spawnSync(c.split(' ')[0],c.split(' ').slice(1),{stdio:'inherit',shell:process.platform==='win32'}); if(r.status!==0){failed++;console.error('FAILED: '+c);} }
console.log('\nToolchain command checks: '+(failed?'FAILED '+failed+' check(s)':'all commands exited successfully'));
process.exit(failed?1:0);
