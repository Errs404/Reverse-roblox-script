/**
 * Lua Safe Minifier - v2
 * 
 * Menghilangkan whitespace yang TIDAK diperlukan dengan aman,
 * tapi TETAP menjaga space antara keyword & identifier biar gak rusak.
 * 
 * Cara pakai: node minify.js < input.lua > output.lua
 */

// Lua keywords - space WAJIB setelah keyword ini kalo diikuti identifier/number/keyword lain
const LUAKW = new Set([
  'and', 'break', 'do', 'else', 'elseif', 'end', 'for', 'function',
  'goto', 'if', 'in', 'local', 'not', 'or', 'repeat', 'return',
  'then', 'until', 'while'
]);

// Operator chars (single char) - gak perlu space di sekitarnya
const OP_CHARS = new Set('=+-*/%^#<>,.;:()[]{}');

// String delimiters
const STR_DELIMS = new Set(['"', "'"]);

/**
 * Tokenize Lua code into tokens with types
 */
function tokenize(code) {
  const tokens = [];
  let i = 0;
  const len = code.length;

  while (i < len) {
    const ch = code[i];
    
    // Long string [[...]]
    if (ch === '[') {
      let eqCount = 0;
      let j = i + 1;
      while (j < len && code[j] === '=') { eqCount++; j++; }
      if (j < len && code[j] === '[') {
        // It's a long string/comment
        const closeSeq = ']' + '='.repeat(eqCount) + ']';
        const endIdx = code.indexOf(closeSeq, j + 1);
        if (endIdx !== -1) {
          const content = code.slice(i, endIdx + closeSeq.length);
          tokens.push({ type: 'string', value: content, raw: content });
          i = endIdx + closeSeq.length;
          continue;
        }
      }
    }

    // Line comment --
    if (ch === '-' && i + 1 < len && code[i + 1] === '-') {
      const endIdx = code.indexOf('\n', i + 2);
      if (endIdx !== -1) {
        const content = code.slice(i, endIdx);
        tokens.push({ type: 'comment', value: content, raw: content });
        i = endIdx;
        continue;
      } else {
        // Rest of file
        tokens.push({ type: 'comment', value: code.slice(i), raw: code.slice(i) });
        break;
      }
    }

    // Block comment --[[...]]
    if (ch === '-' && i + 1 < len && code[i + 1] === '-' && i + 2 < len && code[i + 2] === '[') {
      let eqCount = 0;
      let j = i + 3;
      while (j < len && code[j] === '=') { eqCount++; j++; }
      if (j < len && code[j] === '[') {
        const closeSeq = ']' + '='.repeat(eqCount) + ']';
        const endIdx = code.indexOf(closeSeq, j + 1);
        if (endIdx !== -1) {
          tokens.push({ type: 'comment', value: code.slice(i, endIdx + closeSeq.length), raw: code.slice(i, endIdx + closeSeq.length) });
          i = endIdx + closeSeq.length;
          continue;
        }
      }
    }

    // Quoted strings
    if (STR_DELIMS.has(ch)) {
      const quote = ch;
      let j = i + 1;
      let escaped = false;
      let closed = false;
      while (j < len) {
        if (escaped) { escaped = false; j++; continue; }
        if (code[j] === '\\') { escaped = true; j++; continue; }
        if (code[j] === quote) { closed = true; break; }
        j++;
      }
      if (closed) {
        const content = code.slice(i, j + 1);
        tokens.push({ type: 'string', value: content, raw: content });
        i = j + 1;
        continue;
      }
    }

    // Whitespace
    if (/\s/.test(ch)) {
      let ws = '';
      while (i < len && /\s/.test(code[i])) {
        ws += code[i];
        i++;
      }
      tokens.push({ type: 'space', value: ws, raw: ws });
      continue;
    }

    // Single-char operators
    if (OP_CHARS.has(ch)) {
      tokens.push({ type: 'op', value: ch, raw: ch });
      i++;
      continue;
    }

    // Multi-char operators: ~=, <=, >=, ==, .., ...
    if ((ch === '~' || ch === '!' ) && i + 1 < len && code[i+1] === '=') {
      tokens.push({ type: 'op', value: ch + '=', raw: ch + '=' });
      i += 2; continue;
    }
    if (ch === '<' && i + 1 < len && code[i+1] === '=') {
      tokens.push({ type: 'op', value: '<=', raw: '<=' });
      i += 2; continue;
    }
    if (ch === '>' && i + 1 < len && code[i+1] === '=') {
      tokens.push({ type: 'op', value: '>=', raw: '>=' });
      i += 2; continue;
    }
    if (ch === '=' && i + 1 < len && code[i+1] === '=') {
      tokens.push({ type: 'op', value: '==', raw: '==' });
      i += 2; continue;
    }
    if (ch === '.' && i + 1 < len && code[i+1] === '.') {
      if (i + 2 < len && code[i+2] === '.') {
        tokens.push({ type: 'op', value: '...', raw: '...' });
        i += 3; continue;
      }
      tokens.push({ type: 'op', value: '..', raw: '..' });
      i += 2; continue;
    }
    if (ch === ':' && i + 1 < len && code[i+1] === ':') {
      // :: label syntax
      tokens.push({ type: 'op', value: '::', raw: '::' });
      i += 2; continue;
    }

    // Numbers
    if (/\d/.test(ch) || (ch === '.' && i + 1 < len && /\d/.test(code[i+1]))) {
      let num = '';
      // Hex
      if (ch === '0' && i + 1 < len && code[i+1].toLowerCase() === 'x') {
        num = code.slice(i, i+2);
        i += 2;
        while (i < len && /[0-9a-fA-F.]/.test(code[i])) { num += code[i]; i++; }
      } else {
        while (i < len && /\d/.test(code[i])) { num += code[i]; i++; }
        if (i < len && code[i] === '.') { num += '.'; i++; while (i < len && /\d/.test(code[i])) { num += code[i]; i++; } }
        if (i < len && code[i].toLowerCase() === 'e') {
          num += 'e'; i++;
          if (i < len && (code[i] === '+' || code[i] === '-')) { num += code[i]; i++; }
          while (i < len && /\d/.test(code[i])) { num += code[i]; i++; }
        }
      }
      tokens.push({ type: 'number', value: num, raw: num });
      continue;
    }

    // Identifiers (and keywords)
    if (/[a-zA-Z_]/.test(ch)) {
      let word = '';
      while (i < len && /[a-zA-Z0-9_]/.test(code[i])) { word += code[i]; i++; }
      const type = LUAKW.has(word) ? 'keyword' : 'ident';
      tokens.push({ type, value: word, raw: word });
      continue;
    }

    // Unknown char (just pass through)
    tokens.push({ type: 'unknown', value: ch, raw: ch });
    i++;
  }

  return tokens;
}

/**
 * Determine if a space is REQUIRED between two adjacent tokens
 */
function needsSpace(left, right) {
  if (!left || !right) return false;
  
  // Skip space tokens
  if (left.type === 'space' || right.type === 'space') return false;
  
  const lv = left.value;
  const rv = right.value;

  // String to string? Could be two concatenated strings - keep space
  if (left.type === 'string' && right.type === 'string') return true;

  // Keyword followed by identifier/number/keyword - NEEDS space
  if (left.type === 'keyword' && (right.type === 'ident' || right.type === 'number' || right.type === 'keyword')) {
    return true;
  }

  // identifier/number followed by keyword - NEEDS space (e.g., "x end", "5 then")
  if ((left.type === 'ident' || left.type === 'number') && right.type === 'keyword') {
    return true;
  }

  // identifier followed by identifier - NEEDS space (two statements)
  if (left.type === 'ident' && right.type === 'ident') {
    return true;
  }

  // ) followed by identifier/keyword - NEEDS space (end of call, new statement)
  if (lv === ')' && (right.type === 'ident' || right.type === 'keyword' || right.type === 'number' || rv === '(')) {
    return true;
  }

  // ] followed by identifier/keyword/( - NEEDS space
  if (lv === ']' && (right.type === 'ident' || right.type === 'keyword' || rv === '(')) {
    return true;
  }

  // } followed by identifier/keyword - NEEDS space
  if (lv === '}' && (right.type === 'ident' || right.type === 'keyword' || right.type === 'number')) {
    return true;
  }

  // identifier/keyword followed by ( - NO space (function call)
  // but keyword followed by ( - depends, usually no space in Lua
  
  // number followed by identifier - NEEDS space (e.g., "1end" -> "1 end")
  // Wait, in Lua "1end" would be parsed as "1" "end" anyway, but minified should keep space
  if (left.type === 'number' && right.type === 'ident') {
    return true;
  }

  // identifier followed by number - NEEDS space
  if (left.type === 'ident' && right.type === 'number') {
    return true;
  }

  // Close bracket/paren followed by open bracket/paren/op - usually no space
  // But ')' followed by '{' is fine without space
  // 'end' followed by anything - needs space
  if (lv === 'end' && (right.type === 'ident' || right.type === 'keyword' || right.type === 'number' || right.type === 'op' && rv === '(')) {
    return true;
  }

  // '.' after number? "1.5" vs "1 .5" - but we handle numbers already
  
  // ',' followed by '(' - no space needed (e.g., `func1,func2`)
  // Actually, ',' followed by identifier - no space needed

  return false;
}

/**
 * Minify Lua code safely
 */
function minify(code) {
  const tokens = tokenize(code);
  
  // First pass: collapse all spaces to single space, remove comments
  const filtered = [];
  for (const tok of tokens) {
    if (tok.type === 'comment') continue;
    if (tok.type === 'space') {
      // Collapse to single space
      if (filtered.length > 0 && filtered[filtered.length-1].type !== 'space') {
        filtered.push({ type: 'space', value: ' ', raw: ' ' });
      }
      continue;
    }
    filtered.push(tok);
  }

  // Remove trailing space
  if (filtered.length > 0 && filtered[filtered.length-1].type === 'space') {
    filtered.pop();
  }

  // Second pass: remove unnecessary spaces
  const result = [];
  for (let i = 0; i < filtered.length; i++) {
    const tok = filtered[i];
    
    if (tok.type === 'space') {
      // Determine if this space is needed
      const prev = result.length > 0 ? result[result.length-1] : null;
      const next = i + 1 < filtered.length ? filtered[i+1] : null;
      
      if (needsSpace(prev, next)) {
        result.push({ type: 'space', value: ' ', raw: ' ' });
      }
      // else: skip this space entirely
      continue;
    }
    
    result.push(tok);
  }

  // Join
  return result.map(t => t.value).join('');
}

// CLI
if (require.main === module) {
  const fs = require('fs');
  const input = process.argv[2] ? fs.readFileSync(process.argv[2], 'utf8') : fs.readFileSync('/dev/stdin', 'utf8');
  try {
    const output = minify(input);
    console.log(output);
    
    // Validate with luaparse
    try {
      const lp = require('luaparse');
      lp.parse(output);
      console.error('✓ Valid Lua - luaparse OK', file);
    } catch(e) {
      console.error('✗ INVALID Lua - luaparse error:', e.message, file);
    }
  } catch(e) {
    console.error('Error:', e.message);
    process.exit(1);
  }
}

module.exports = { minify, tokenize };
