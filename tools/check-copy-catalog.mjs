#!/usr/bin/env node
// Checks the blueprint copy catalogue against Flutter's English and Urdu ARB files.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const sourcePath = path.join(root, 'docs/spec-data/copy-en.csv');
const englishPath = path.join(root, 'apps/mobile/lib/l10n/app_en.arb');
const urduPath = path.join(root, 'apps/mobile/lib/l10n/app_ur.arb');

function parseCsv(input) {
  const rows = [];
  let row = [];
  let cell = '';
  let quoted = false;
  for (let index = 0; index < input.length; index += 1) {
    const character = input[index];
    if (quoted) {
      if (character === '"') {
        if (input[index + 1] === '"') {
          cell += '"';
          index += 1;
        } else {
          quoted = false;
        }
      } else {
        cell += character;
      }
    } else if (character === '"') {
      quoted = true;
    } else if (character === ',') {
      row.push(cell);
      cell = '';
    } else if (character === '\n') {
      row.push(cell);
      rows.push(row);
      row = [];
      cell = '';
    } else if (character !== '\r') {
      cell += character;
    }
  }
  if (cell.length > 0 || row.length > 0) {
    row.push(cell);
    rows.push(row);
  }
  if (quoted) throw new Error('copy-en.csv contains an unterminated quoted field');
  return rows;
}

function placeholders(value) {
  return new Set([...value.matchAll(/\{([A-Za-z][A-Za-z0-9_]*)\}/g)]
    .map((match) => match[1]));
}

function normalizedSourcePlaceholders(value) {
  return value.replace(/\{([^{}]+)\}/g, (_match, rawName) => {
    const normalized = rawName.trim().replace(/\s+([a-z])/g, (_space, letter) => letter.toUpperCase());
    return `{${normalized}}`;
  });
}

function readJson(file) {
  try {
    return JSON.parse(fs.readFileSync(file, 'utf8'));
  } catch (error) {
    throw new Error(`Cannot read valid JSON from ${path.relative(root, file)}: ${error.message}`);
  }
}

const table = parseCsv(fs.readFileSync(sourcePath, 'utf8'));
const header = table.shift();
if (header?.join(',') !== 'key,where,text') {
  throw new Error('copy-en.csv must have the header: key,where,text');
}

const rows = table.filter((row) => row.length > 1 || row[0] !== '');
const seen = new Set();
const errors = [];
for (const [index, row] of rows.entries()) {
  const [key, where, sourceText] = row;
  if (row.length !== 3) {
    errors.push(`Row ${index + 2} must contain exactly 3 CSV columns (found ${row.length})`);
  }
  if (!key || !where || sourceText === undefined) {
    errors.push(`Row ${index + 2} is incomplete`);
    continue;
  }
  if (seen.has(key)) errors.push(`Duplicate source key: ${key}`);
  seen.add(key);
}

const english = readJson(englishPath);
const urdu = readJson(urduPath);
if (urdu['@@x-review'] !== 'needs native Urdu review') {
  errors.push('app_ur.arb must retain the native Urdu review marker');
}

for (const [index, row] of rows.entries()) {
  const [key, , sourceText] = row;
  if (typeof english[key] !== 'string') {
    errors.push(`English ARB is missing string key ${key}`);
    continue;
  }
  if (typeof urdu[key] !== 'string') {
    errors.push(`Urdu ARB is missing string key ${key}`);
    continue;
  }

  const sourceNames = placeholders(normalizedSourcePlaceholders(sourceText));
  const englishNames = placeholders(english[key]);
  const urduNames = placeholders(urdu[key]);
  for (const name of sourceNames) {
    if (!englishNames.has(name)) errors.push(`${key}: English is missing placeholder {${name}}`);
    if (!urduNames.has(name)) errors.push(`${key}: Urdu is missing placeholder {${name}}`);
  }
  for (const name of englishNames) {
    if (!sourceNames.has(name)) errors.push(`${key}: English has unexpected placeholder {${name}}`);
  }
  for (const name of urduNames) {
    if (!sourceNames.has(name)) errors.push(`${key}: Urdu has unexpected placeholder {${name}}`);
  }
}

if (errors.length > 0) {
  process.stderr.write(`Copy catalogue check failed (${errors.length} issue(s)):\n${errors.map((e) => `- ${e}`).join('\n')}\n`);
  process.exit(1);
}

process.stdout.write(`Copy catalogue check passed: ${rows.length} source keys are present in English and Urdu with matching placeholders.\n`);
