#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const source = path.join(root, 'docs/blueprint/design-tokens.json');
const target = path.join(root, 'apps/mobile/lib/core/theme/generated/sargoshi_tokens.g.dart');
const camel = (value) => value.replace(/[-_ ]+([a-zA-Z0-9])/g, (_, char) => char.toUpperCase());
const dartColor = (hex) => 'Color(0xFF' + hex.slice(1).toUpperCase() + ')';

function render(tokens) {
  const colors = Object.entries(tokens.color);
  const lines = [
    '// GENERATED FILE — DO NOT EDIT BY HAND.',
    '// Source: docs/blueprint/design-tokens.json',
    '// Regenerate: node tools/gen-tokens.mjs',
    '',
    "import 'package:flutter/material.dart';",
    '',
    '@immutable',
    'class SargoshiColors extends ThemeExtension<SargoshiColors> {',
    '  const SargoshiColors._(this.tokens);',
    '',
    '  final Map<String, Color> tokens;',
    '',
    '  static const Map<String, Color> palette = {',
  ];
  colors.forEach(([name, value]) => lines.push("    '" + camel(name) + "': " + dartColor(value) + ','));
  lines.push('  };', '', '  static const SargoshiColors defaults = SargoshiColors._(palette);', '');
  colors.forEach(([name]) => lines.push("  Color get " + camel(name) + " => tokens['" + camel(name) + "']!;"));
  lines.push('');
  Object.entries(tokens.gradient).forEach(([name, values]) => {
    lines.push('  static const List<Color> ' + camel(name) + 'Gradient = [' + values.map(dartColor).join(', ') + '];');
  });
  lines.push('', '  @override', '  SargoshiColors copyWith({');
  colors.forEach(([name]) => lines.push('    Color? ' + camel(name) + ','));
  lines.push('  }) => SargoshiColors._({');
  colors.forEach(([name]) => lines.push("      '" + camel(name) + "': " + camel(name) + ' ?? this.' + camel(name) + ','));
  lines.push('  });', '', '  @override', '  SargoshiColors lerp(covariant SargoshiColors? other, double t) {', '    if (other == null) return this;', '    return SargoshiColors._({');
  colors.forEach(([name]) => lines.push("      '" + camel(name) + "': Color.lerp(" + camel(name) + ', other.' + camel(name) + ', t)!,'));
  lines.push('    });', '  }', '}', '', 'abstract final class SargoshiSpace {');
  tokens.space.forEach((value) => lines.push('  static const double s' + value + ' = ' + value + ';'));
  lines.push('}', '', 'abstract final class SargoshiShape {');
  Object.entries(tokens.radius).forEach(([name, value]) => lines.push('  static const double ' + camel(name) + ' = ' + value + ';'));
  lines.push('}', '', 'abstract final class SargoshiMotion {');
  Object.entries(tokens.motion).filter(([, value]) => Number.isInteger(value)).forEach(([name, value]) => lines.push('  static const Duration ' + camel(name) + ' = Duration(milliseconds: ' + value + ');'));
  if (typeof tokens.motion.springSheet === 'string') {
    const stiffness = tokens.motion.springSheet.match(/stiffness\s+([0-9.]+)/i);
    const damping = tokens.motion.springSheet.match(/damping\s+([0-9.]+)/i);
    if (!stiffness || !damping) throw new Error('Invalid springSheet token format');
    lines.push('  static const double springSheetStiffness = ' + stiffness[1] + ';');
    lines.push('  static const double springSheetDamping = ' + damping[1] + ';');
  }
  lines.push('}', '', 'abstract final class SargoshiOpacity {');
  Object.entries(tokens.opacity).forEach(([name, value]) => lines.push('  static const double ' + camel(name) + ' = ' + value + ';'));
  lines.push('}', '', 'abstract final class SargoshiStroke {');
  Object.entries(tokens.stroke).forEach(([name, value]) => lines.push('  static const double ' + camel(name) + ' = ' + value + ';'));
  lines.push('}', '', 'abstract final class SargoshiIconSize {');
  Object.entries(tokens.icon).forEach(([name, value]) => lines.push('  static const double ' + camel(name) + ' = ' + value + ';'));
  lines.push('}', '', 'abstract final class SargoshiLayout {');
  Object.entries(tokens.layout).forEach(([name, value]) => lines.push('  static const double ' + camel(name) + ' = ' + value + ';'));
  lines.push('}', '', 'abstract final class SargoshiType {');
  Object.entries(tokens.type).forEach(([name, spec]) => {
    const [family, weight, size, lineHeight] = spec;
    lines.push('  static const TextStyle ' + camel(name) + ' = TextStyle(',
      "    fontFamily: '" + family + "',", '    fontWeight: FontWeight.w' + weight + ',',
      '    fontSize: ' + size + ',', '    height: ' + (lineHeight / size) + ',');
    if (family !== 'NotoNaskhArabic') lines.push("    fontFamilyFallback: ['NotoNaskhArabic'],");
    lines.push('  );', '');
  });
  lines.push('}', '', 'abstract final class SargoshiBreakpoint {');
  Object.entries(tokens.breakpoints).forEach(([name, value]) => lines.push('  static const double ' + camel(name) + ' = ' + value + ';'));
  lines.push('  static const double minInteractiveTarget = ' + tokens.target.min + ';', '}');
  return lines.join('\n') + '\n';
}

if (!fs.existsSync(source)) throw new Error('Design token source not found: ' + source);
const tokens = JSON.parse(fs.readFileSync(source, 'utf8'));
const output = render(tokens);
if (process.argv.includes('--check')) {
  if (!fs.existsSync(target) || fs.readFileSync(target, 'utf8') !== output) {
    console.error('Token output is stale. Run: node tools/gen-tokens.mjs');
    process.exit(1);
  }
  console.log('Token generator: OK (generated output matches source)');
} else {
  fs.mkdirSync(path.dirname(target), { recursive: true });
  fs.writeFileSync(target, output, 'utf8');
  console.log('Generated ' + path.relative(root, target));
}
