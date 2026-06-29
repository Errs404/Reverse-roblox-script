/**
 * Lua Safe Minifier v2.3 - Final version
 * 
 * Approach: token-based, only remove UNNECESSARY spaces.
 * JANGAN insert ; as separator - too risky for function contexts.
 * JANGAN remove spaces between keyword & identifier.
 * 
 * Rules for space removal:
 * - Around =, +, -, *, /, %, ^, #, ,, :, ; (no space needed)
 * - After (, before ), after [, before ], after {, before }
 * - Between keyword/ident/num and these operators
 * - BUT: keep space between keyword+ident, ident+keyword, ident+ident, etc.
 */

const LUAKW = new Set([
  'and', 'break', 'do', 'else', 'elseif', 'end', 'for', 'function',
  'goto', 'if', 'in', 'local', 'not', 'or', 'repeat', 'return',
  'then', 'until', 'while'
]);

function tokenize(code) {
  const tokens = [];
  let i = 0;
  const len = code.length;

  while (i < len) {
    const ch = code[i];

    // Long string [[...]]
    if (ch === '[') {
      let eq = 0, j = i + 1;
      while (j < len && code[j] === '=') { eq++; j++; }
      if (j < len && code[j] === '[') {
        const close = ']' + '='.repeat(eq) + ']';
        const end = code.indexOf(close, j + 1);
        if (end !== -1) {
          tokens.push({ t: 'str', v: code.slice(i, end + close.length) });
          i = end + close.length; continue;
        }
      }
    }

    // Comment
    if (ch === '-' && i + 1 < len && code[i + 1] === '-') {
      const endIdx = code.indexOf('\n', i + 2);
      tokens.push({ t: 'cmt', v: endIdx !== -1 ? code.slice(i, endIdx) : code.slice(i) });
      i = endIdx !== -1 ? endIdx + 1 : len;
      continue;
    }

    // Quoted strings
    if (ch === '"' || ch === "'") {
      const q = ch; let j = i + 1, esc = false;
      while (j < len) {
        if (esc) { esc = false; j++; continue; }
        if (code[j] === '\\') { esc = true; j++; continue; }
        if (code[j] === q) break;
        j++;
      }
      tokens.push({ t: 'str', v: code.slice(i, j + 1) });
      i = j + 1; continue;
    }

    // Whitespace
    if (/\s/.test(ch)) {
      while (i < len && /\s/.test(code[i])) i++;
      tokens.push({ t: 'sp', v: ' ' });
      continue;
    }

    // Multi-char ops
    if (ch === ':' && i+1 < len && code[i+1] === ':') { tokens.push({ t: 'op', v: '::' }); i+=2; continue; }
    if (ch === '~' && i+1 < len && code[i+1] === '=') { tokens.push({ t: 'op', v: '~=' }); i+=2; continue; }
    if (ch === '<' && i+1 < len && code[i+1] === '=') { tokens.push({ t: 'op', v: '<=' }); i+=2; continue; }
    if (ch === '>' && i+1 < len && code[i+1] === '=') { tokens.push({ t: 'op', v: '>=' }); i+=2; continue; }
    if (ch === '=' && i+1 < len && code[i+1] === '=') { tokens.push({ t: 'op', v: '==' }); i+=2; continue; }
    if (ch === '.' && i+1 < len && code[i+1] === '.') {
      if (i+2 < len && code[i+2] === '.') { tokens.push({ t: 'op', v: '...' }); i+=3; continue; }
      tokens.push({ t: 'op', v: '..' }); i+=2; continue;
    }

    // Numbers
    if (/\d/.test(ch) || (ch === '.' && i+1 < len && /\d/.test(code[i+1]))) {
      let n = '';
      if (ch === '0' && i+1 < len && (code[i+1] === 'x' || code[i+1] === 'X')) {
        n = ch + code[i+1]; i += 2;
        while (i < len && /[0-9a-fA-F._]/.test(code[i])) { n += code[i]; i++; }
      } else {
        while (i < len && /\d/.test(code[i])) { n += code[i]; i++; }
        if (i < len && code[i] === '.') { n += '.'; i++; while (i < len && /\d/.test(code[i])) { n += code[i]; i++; } }
        if (i < len && (code[i] === 'e' || code[i] === 'E')) {
          n += code[i]; i++;
          if (i < len && (code[i] === '+' || code[i] === '-')) { n += code[i]; i++; }
          while (i < len && /\d/.test(code[i])) { n += code[i]; i++; }
        }
      }
      tokens.push({ t: 'num', v: n }); continue;
    }

    // Single-char ops
    if ('=+-*/%^#<>,.;:()[]{}'.includes(ch)) { tokens.push({ t: 'op', v: ch }); i++; continue; }

    // Identifiers/keywords
    if (/[a-zA-Z_]/.test(ch)) {
      let w = '';
      while (i < len && /[a-zA-Z0-9_]/.test(code[i])) { w += code[i]; i++; }
      tokens.push({ t: LUAKW.has(w) ? 'kw' : 'id', v: w });
      continue;
    }

    tokens.push({ t: 'unk', v: ch }); i++;
  }

  return tokens;
}

/**
 * Does the space between these two tokens NEED to be kept?
 */
function needsSpace(left, right) {
  if (!left || !right) return false;

  const lt = left.t, rt = right.t;
  const lv = left.v, rv = right.v;

  // keyword + keyword/ident/num = space needed
  if (lt === 'kw' && (rt === 'kw' || rt === 'id' || rt === 'num')) return true;

  // ident + keyword = space needed
  if (lt === 'id' && rt === 'kw') return true;

  // ident + ident = space needed (separate statements)
  if (lt === 'id' && rt === 'id') return true;

  // number + ident/keyword/num = space needed
  if (lt === 'num' && (rt === 'id' || rt === 'kw' || rt === 'num')) return true;

  // ident + number = space needed
  if (lt === 'id' && rt === 'num') return true;

  // string + id/kw = space needed
  if (lt === 'str' && (rt === 'id' || rt === 'kw')) return true;
  if ((lt === 'id' || lt === 'kw') && rt === 'str') return true;

  // After close bracket/paren/bracket before id/kw/num = space needed
  // But NOT inside function parameter list - we can't detect this purely via tokens
  // So always use space (safe)
  if (lv === ')' && (rt === 'id' || rt === 'kw' || rt === 'num')) return true;
  if (lv === ']' && (rt === 'id' || rt === 'kw' || rt === 'num')) return true;
  if (lv === '}' && (rt === 'id' || rt === 'kw' || rt === 'num')) return true;

  // keyword/label followed by ( = no space needed. Actually skip for safety.
  // 'end' followed by anything that's not op = space needed
  if (lv === 'end' && (rt === 'id' || rt === 'kw' || rt === 'num')) return true;

  // 'else'/'elseif'/'then'/'do' followed by id/kw = space needed
  if ((lv === 'else' || lv === 'elseif' || lv === 'then' || lv === 'do') && (rt === 'id' || rt === 'kw' || rt === 'num')) return true;

  return false;
}

function minify(code) {
  let tokens = tokenize(code);
  
  // Remove comments
  tokens = tokens.filter(t => t.t !== 'cmt');

  // Collapse consecutive spaces
  const collapsed = [];
  for (const tok of tokens) {
    if (tok.t === 'sp') {
      if (collapsed.length > 0 && collapsed[collapsed.length-1].t !== 'sp') {
        collapsed.push(tok);
      }
    } else {
      collapsed.push(tok);
    }
  }
  if (collapsed.length > 0 && collapsed[collapsed.length-1].t === 'sp') collapsed.pop();

  // Remove unnecessary spaces
  const result = [];
  for (let i = 0; i < collapsed.length; i++) {
    const tok = collapsed[i];
    
    if (tok.t === 'sp') {
      // Find the actual non-space neighbors
      let left = null, right = null;
      for (let j = i - 1; j >= 0; j--) { if (collapsed[j].t !== 'sp') { left = collapsed[j]; break; } }
      for (let j = i + 1; j < collapsed.length; j++) { if (collapsed[j].t !== 'sp') { right = collapsed[j]; break; } }

      if (needsSpace(left, right)) {
        result.push(tok);
      }
      continue;
    }

    result.push(tok);
  }

  return result.map(t => t.v).join('');
}

// CLI
if (require.main === module) {
  const fs = require('fs');
  const input = fs.readFileSync(process.argv[2] || '/dev/stdin', 'utf8');
  console.log(minify(input));
}

module.exports = { minify };
