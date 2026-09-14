/**
 * ACTIVITY ENGINE — Plataforma Docente · Profe Carlitos
 * 
 * Componentes Vue 3 para actividades interactivas de verificación.
 * Se registran como componentes globales en la app Vue.
 * 
 * COMPONENTES DISPONIBLES:
 * - <quiz-question>     Alternativas o V/F con retroalimentación
 * - <multi-select>      Selección múltiple (varias correctas)
 * - <code-error>        Encontrar el error en código
 * - <code-fill>         Completar código faltante
 * - <matching-pairs>    Términos pareados
 * - <word-search>       Sopa de letras
 * - <crossword-puzzle>  Crucigrama
 * - <order-steps>       Ordenar pasos de código
 * 
 * USO:
 * Después de crear la app Vue, llamar:
 *   ActivityEngine.register(app);
 * antes de app.mount()
 */

const ActivityEngine = {

  /**
   * Registra todos los componentes de actividad en una app Vue.
   * @param {Object} app — instancia de createApp() de Vue 3
   */
  register(app) {

    // =========================================================
    // QUIZ QUESTION — Alternativas o V/F
    // =========================================================
    app.component('quiz-question', {
      props: {
        question: String,
        options: Array,        // [{text: 'opción', correct: false}, ...]
        explanation: String,
        hint: { type: String, default: '' },
        level: { type: String, default: 'base' } // base | inter | avanzado
      },
      data() {
        return {
          selected: null,
          submitted: false,
          showHint: false
        };
      },
      computed: {
        isCorrect() {
          if (this.selected === null) return false;
          return this.options[this.selected].correct;
        },
        levelLabel() {
          const labels = { base: '🟢 Base', inter: '🔵 Intermedio', avanzado: '🟣 Avanzado' };
          return labels[this.level] || labels.base;
        }
      },
      methods: {
        select(i) {
          if (!this.submitted) this.selected = i;
        },
        check() {
          if (this.selected !== null) this.submitted = true;
        },
        reset() {
          this.selected = null;
          this.submitted = false;
          this.showHint = false;
        }
      },
      template: `
        <div class="question-block" :class="{ correct: submitted && isCorrect, incorrect: submitted && !isCorrect }">
          <span class="q-label">{{ levelLabel }}</span>
          <p style="font-weight:700; font-size:17px;" v-html="question"></p>
          <ul class="option-list">
            <li v-for="(opt, i) in options" :key="i"
                class="option-item"
                :class="{
                  selected: selected === i && !submitted,
                  'correct-answer': submitted && opt.correct,
                  'wrong-answer': submitted && selected === i && !opt.correct
                }"
                @click="select(i)">
              <span style="font-weight:700; min-width:20px;">{{ String.fromCharCode(65 + i) }})</span>
              <span v-html="opt.text"></span>
            </li>
          </ul>
          <button v-if="hint && !showHint && !submitted" class="hint-btn" @click="showHint = true">💡 Pista</button>
          <div v-if="showHint && !submitted" class="hint-text show">{{ hint }}</div>
          <button v-if="!submitted" class="check-btn" :disabled="selected === null" @click="check">Verificar</button>
          <div v-if="submitted" class="feedback show" :class="{ correct: isCorrect, incorrect: !isCorrect }">
            {{ isCorrect ? '✓ Correcto.' : '✗ Incorrecto.' }} {{ explanation }}
          </div>
          <button v-if="submitted" class="btn" style="margin-top:8px; font-size:13px;" @click="reset">Reintentar</button>
        </div>
      `
    });

    // =========================================================
    // MULTI SELECT — Varias respuestas correctas
    // =========================================================
    app.component('multi-select', {
      props: {
        question: String,
        options: Array,        // [{text, correct}, ...]
        explanation: String,
        hint: { type: String, default: '' },
        level: { type: String, default: 'base' }
      },
      data() {
        return { selected: [], submitted: false, showHint: false };
      },
      computed: {
        isCorrect() {
          const correctIndices = this.options.map((o, i) => o.correct ? i : -1).filter(i => i >= 0);
          return correctIndices.length === this.selected.length &&
                 correctIndices.every(i => this.selected.includes(i));
        },
        levelLabel() {
          const labels = { base: '🟢 Base', inter: '🔵 Intermedio', avanzado: '🟣 Avanzado' };
          return labels[this.level] || labels.base;
        }
      },
      methods: {
        toggle(i) {
          if (this.submitted) return;
          const idx = this.selected.indexOf(i);
          if (idx >= 0) this.selected.splice(idx, 1);
          else this.selected.push(i);
        },
        check() { if (this.selected.length) this.submitted = true; },
        reset() { this.selected = []; this.submitted = false; this.showHint = false; }
      },
      template: `
        <div class="question-block" :class="{ correct: submitted && isCorrect, incorrect: submitted && !isCorrect }">
          <span class="q-label">{{ levelLabel }} · Selección múltiple</span>
          <p style="font-weight:700; font-size:17px;" v-html="question"></p>
          <ul class="option-list">
            <li v-for="(opt, i) in options" :key="i"
                class="option-item"
                :class="{
                  selected: selected.includes(i) && !submitted,
                  'correct-answer': submitted && opt.correct,
                  'wrong-answer': submitted && selected.includes(i) && !opt.correct
                }"
                @click="toggle(i)">
              <span style="font-weight:700; min-width:20px;">☐</span>
              <span v-html="opt.text"></span>
            </li>
          </ul>
          <button v-if="hint && !showHint && !submitted" class="hint-btn" @click="showHint = true">💡 Pista</button>
          <div v-if="showHint && !submitted" class="hint-text show">{{ hint }}</div>
          <button v-if="!submitted" class="check-btn" :disabled="!selected.length" @click="check">Verificar</button>
          <div v-if="submitted" class="feedback show" :class="{ correct: isCorrect, incorrect: !isCorrect }">
            {{ isCorrect ? '✓ Correcto.' : '✗ Revisa tu selección.' }} {{ explanation }}
          </div>
          <button v-if="submitted" class="btn" style="margin-top:8px; font-size:13px;" @click="reset">Reintentar</button>
        </div>
      `
    });

    // =========================================================
    // CODE ERROR — Encontrar el error en código
    // =========================================================
    app.component('code-error', {
      props: {
        instruction: String,
        codeLines: Array,      // [{text: 'line of code', hasError: false}, ...]
        explanation: String,
        hint: { type: String, default: '' },
        level: { type: String, default: 'inter' }
      },
      data() {
        return { selected: null, submitted: false, showHint: false };
      },
      computed: {
        isCorrect() {
          if (this.selected === null) return false;
          return this.codeLines[this.selected].hasError;
        },
        errorLine() {
          return this.codeLines.findIndex(l => l.hasError);
        },
        levelLabel() {
          const labels = { base: '🟢 Base', inter: '🔵 Intermedio', avanzado: '🟣 Avanzado' };
          return labels[this.level] || labels.base;
        }
      },
      methods: {
        selectLine(i) { if (!this.submitted) this.selected = i; },
        check() { if (this.selected !== null) this.submitted = true; },
        reset() { this.selected = null; this.submitted = false; this.showHint = false; }
      },
      template: `
        <div class="question-block" :class="{ correct: submitted && isCorrect, incorrect: submitted && !isCorrect }">
          <span class="q-label">{{ levelLabel }} · Encuentra el error</span>
          <p style="font-weight:700; font-size:17px;" v-html="instruction"></p>
          <div class="code-block" style="white-space:normal; cursor:default;">
            <div v-for="(line, i) in codeLines" :key="i"
                 style="white-space:pre; padding:3px 8px; margin:0 -8px; border-radius:4px; cursor:pointer; transition: background 0.12s;"
                 :style="{
                   background: submitted && line.hasError ? '#3A5A3A' :
                               submitted && selected === i && !line.hasError ? '#5A3A3A' :
                               (!submitted && selected === i) ? '#45475A' : 'transparent'
                 }"
                 @click="selectLine(i)">
              <span style="color:#6C7086; margin-right:12px; user-select:none; font-size:13px;">{{ String(i + 1).padStart(2, ' ') }}</span>{{ line.text }}
            </div>
          </div>
          <button v-if="hint && !showHint && !submitted" class="hint-btn" @click="showHint = true">💡 Pista</button>
          <div v-if="showHint && !submitted" class="hint-text show">{{ hint }}</div>
          <button v-if="!submitted" class="check-btn" :disabled="selected === null" @click="check">Verificar</button>
          <div v-if="submitted" class="feedback show" :class="{ correct: isCorrect, incorrect: !isCorrect }">
            {{ isCorrect ? '✓ Correcto, esa es la línea con el error.' : '✗ No es esa línea. El error está en la línea ' + (errorLine + 1) + '.' }} {{ explanation }}
          </div>
          <button v-if="submitted" class="btn" style="margin-top:8px; font-size:13px;" @click="reset">Reintentar</button>
        </div>
      `
    });

    // =========================================================
    // CODE FILL — Completar código faltante
    // =========================================================
    app.component('code-fill', {
      props: {
        instruction: String,
        segments: Array,       // [{text: 'code text', isBlank: false, answer: ''}, ...]
        explanation: String,
        hint: { type: String, default: '' },
        level: { type: String, default: 'inter' }
      },
      data() {
        return {
          answers: this.segments.filter(s => s.isBlank).map(() => ''),
          submitted: false,
          showHint: false
        };
      },
      computed: {
        blanks() {
          return this.segments.filter(s => s.isBlank);
        },
        isCorrect() {
          let blankIdx = 0;
          for (const seg of this.segments) {
            if (seg.isBlank) {
              if (this.answers[blankIdx].trim().toLowerCase() !== seg.answer.trim().toLowerCase()) return false;
              blankIdx++;
            }
          }
          return true;
        },
        blankResults() {
          let blankIdx = 0;
          return this.segments.filter(s => s.isBlank).map(seg => {
            const correct = this.answers[blankIdx].trim().toLowerCase() === seg.answer.trim().toLowerCase();
            blankIdx++;
            return correct;
          });
        },
        levelLabel() {
          const labels = { base: '🟢 Base', inter: '🔵 Intermedio', avanzado: '🟣 Avanzado' };
          return labels[this.level] || labels.base;
        }
      },
      methods: {
        check() { this.submitted = true; },
        reset() {
          this.answers = this.segments.filter(s => s.isBlank).map(() => '');
          this.submitted = false;
          this.showHint = false;
        },
        getBlankIndex(segIdx) {
          let count = 0;
          for (let i = 0; i < segIdx; i++) {
            if (this.segments[i].isBlank) count++;
          }
          return count;
        }
      },
      template: `
        <div class="question-block" :class="{ correct: submitted && isCorrect, incorrect: submitted && !isCorrect }">
          <span class="q-label">{{ levelLabel }} · Completa el código</span>
          <p style="font-weight:700; font-size:17px;" v-html="instruction"></p>
          <div class="code-fill">
            <template v-for="(seg, i) in segments" :key="i">
              <template v-if="!seg.isBlank">{{ seg.text }}</template>
              <input v-else
                     v-model="answers[getBlankIndex(i)]"
                     :placeholder="'...'"
                     :class="{
                       correct: submitted && blankResults[getBlankIndex(i)],
                       incorrect: submitted && !blankResults[getBlankIndex(i)]
                     }"
                     :disabled="submitted"
                     :style="{ width: Math.max(seg.answer.length * 10 + 20, 80) + 'px' }"
              />
            </template>
          </div>
          <button v-if="hint && !showHint && !submitted" class="hint-btn" @click="showHint = true">💡 Pista</button>
          <div v-if="showHint && !submitted" class="hint-text show">{{ hint }}</div>
          <button v-if="!submitted" class="check-btn" @click="check">Verificar</button>
          <div v-if="submitted" class="feedback show" :class="{ correct: isCorrect, incorrect: !isCorrect }">
            {{ isCorrect ? '✓ Código completado correctamente.' : '✗ Revisa los campos en rojo.' }} {{ explanation }}
          </div>
          <button v-if="submitted" class="btn" style="margin-top:8px; font-size:13px;" @click="reset">Reintentar</button>
        </div>
      `
    });

    // =========================================================
    // MATCHING PAIRS — Términos pareados
    // =========================================================
    app.component('matching-pairs', {
      props: {
        instruction: { type: String, default: 'Conecta cada término con su definición.' },
        pairs: Array,          // [{term: '...', definition: '...'}, ...]
        level: { type: String, default: 'base' }
      },
      data() {
        const shuffledDefs = [...this.pairs].map(p => p.definition).sort(() => Math.random() - 0.5);
        return {
          definitions: shuffledDefs,
          selectedTerm: null,
          selectedDef: null,
          matched: {},        // { termIndex: defText }
          wrongPair: null,
          levelLabel: { base: '🟢 Base', inter: '🔵 Intermedio', avanzado: '🟣 Avanzado' }[this.level] || '🟢 Base'
        };
      },
      computed: {
        allMatched() { return Object.keys(this.matched).length === this.pairs.length; }
      },
      methods: {
        selectTerm(i) {
          if (this.matched[i] !== undefined) return;
          this.selectedTerm = i;
          this.wrongPair = null;
          this.tryMatch();
        },
        selectDef(defText) {
          if (Object.values(this.matched).includes(defText)) return;
          this.selectedDef = defText;
          this.wrongPair = null;
          this.tryMatch();
        },
        tryMatch() {
          if (this.selectedTerm === null || this.selectedDef === null) return;
          const correctDef = this.pairs[this.selectedTerm].definition;
          if (this.selectedDef === correctDef) {
            this.matched[this.selectedTerm] = this.selectedDef;
          } else {
            this.wrongPair = { term: this.selectedTerm, def: this.selectedDef };
            setTimeout(() => { this.wrongPair = null; }, 800);
          }
          this.selectedTerm = null;
          this.selectedDef = null;
        },
        reset() {
          this.matched = {};
          this.selectedTerm = null;
          this.selectedDef = null;
          this.wrongPair = null;
          this.definitions = [...this.pairs].map(p => p.definition).sort(() => Math.random() - 0.5);
        }
      },
      template: `
        <div class="question-block">
          <span class="q-label">{{ levelLabel }} · Términos pareados</span>
          <p style="font-weight:700; font-size:17px;">{{ instruction }}</p>
          <div class="matching-grid">
            <div>
              <div v-for="(pair, i) in pairs" :key="'t'+i"
                   class="matching-item"
                   :class="{
                     selected: selectedTerm === i,
                     matched: matched[i] !== undefined,
                     wrong: wrongPair && wrongPair.term === i
                   }"
                   @click="selectTerm(i)">
                <strong>{{ pair.term }}</strong>
              </div>
            </div>
            <div>
              <div v-for="(def, j) in definitions" :key="'d'+j"
                   class="matching-item"
                   :class="{
                     selected: selectedDef === def,
                     matched: Object.values(matched).includes(def),
                     wrong: wrongPair && wrongPair.def === def
                   }"
                   @click="selectDef(def)"
                   style="font-size:14px; text-align:left;">
                {{ def }}
              </div>
            </div>
          </div>
          <div v-if="allMatched" class="feedback show correct" style="margin-top:12px;">
            ✓ Todos los pares conectados correctamente.
          </div>
          <button v-if="allMatched" class="btn" style="margin-top:8px; font-size:13px;" @click="reset">Reiniciar</button>
        </div>
      `
    });

    // =========================================================
    // WORD SEARCH — Sopa de letras
    // =========================================================
    app.component('word-search', {
      props: {
        title: { type: String, default: 'Sopa de letras' },
        gridSize: { type: Number, default: 12 },
        words: Array,          // ['POLIMORFISMO', 'HERENCIA', ...]
        level: { type: String, default: 'base' }
      },
      data() {
        const { grid, placements } = this.generateGrid();
        return {
          grid,
          placements,
          selecting: false,
          startCell: null,
          currentCell: null,
          selectedCells: [],
          foundWords: [],
          foundCells: new Set(),
          levelLabel: { base: '🟢 Base', inter: '🔵 Intermedio', avanzado: '🟣 Avanzado' }[this.level] || '🟢 Base'
        };
      },
      computed: {
        allFound() { return this.foundWords.length === this.words.length; }
      },
      methods: {
        generateGrid() {
          const size = this.gridSize;
          const grid = Array.from({ length: size }, () => Array(size).fill(''));
          const placements = [];
          const directions = [
            [0, 1], [1, 0], [1, 1], [0, -1], [-1, 0], [-1, -1], [1, -1], [-1, 1]
          ];

          const sortedWords = [...this.words].sort((a, b) => b.length - a.length);

          for (const word of sortedWords) {
            let placed = false;
            const upper = word.toUpperCase();
            for (let attempt = 0; attempt < 200; attempt++) {
              const dir = directions[Math.floor(Math.random() * directions.length)];
              const r = Math.floor(Math.random() * size);
              const c = Math.floor(Math.random() * size);
              if (this.canPlace(grid, upper, r, c, dir, size)) {
                const cells = [];
                for (let k = 0; k < upper.length; k++) {
                  grid[r + dir[0] * k][c + dir[1] * k] = upper[k];
                  cells.push([r + dir[0] * k, c + dir[1] * k]);
                }
                placements.push({ word: upper, cells });
                placed = true;
                break;
              }
            }
            if (!placed) {
              // Force horizontal placement in first available row
              for (let r = 0; r < size; r++) {
                for (let c = 0; c <= size - upper.length; c++) {
                  if (this.canPlace(grid, upper, r, c, [0, 1], size)) {
                    const cells = [];
                    for (let k = 0; k < upper.length; k++) {
                      grid[r][c + k] = upper[k];
                      cells.push([r, c + k]);
                    }
                    placements.push({ word: upper, cells });
                    placed = true;
                    break;
                  }
                }
                if (placed) break;
              }
            }
          }

          // Fill empty cells with random letters
          const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
          for (let r = 0; r < size; r++) {
            for (let c = 0; c < size; c++) {
              if (!grid[r][c]) grid[r][c] = letters[Math.floor(Math.random() * 26)];
            }
          }
          return { grid, placements };
        },

        canPlace(grid, word, r, c, dir, size) {
          for (let k = 0; k < word.length; k++) {
            const nr = r + dir[0] * k;
            const nc = c + dir[1] * k;
            if (nr < 0 || nr >= size || nc < 0 || nc >= size) return false;
            if (grid[nr][nc] && grid[nr][nc] !== word[k]) return false;
          }
          return true;
        },

        cellKey(r, c) { return r + ',' + c; },

        startSelect(r, c) {
          this.selecting = true;
          this.startCell = [r, c];
          this.currentCell = [r, c];
          this.updateSelection();
        },

        moveSelect(r, c) {
          if (!this.selecting) return;
          this.currentCell = [r, c];
          this.updateSelection();
        },

        endSelect() {
          if (!this.selecting) return;
          this.selecting = false;
          this.checkWord();
          this.selectedCells = [];
        },

        updateSelection() {
          if (!this.startCell || !this.currentCell) return;
          const [r1, c1] = this.startCell;
          const [r2, c2] = this.currentCell;
          const dr = Math.sign(r2 - r1);
          const dc = Math.sign(c2 - c1);
          
          // Must be a valid direction (horizontal, vertical, or diagonal)
          if (dr === 0 && dc === 0) {
            this.selectedCells = [this.cellKey(r1, c1)];
            return;
          }
          if (dr !== 0 && dc !== 0 && Math.abs(r2 - r1) !== Math.abs(c2 - c1)) {
            this.selectedCells = [this.cellKey(r1, c1)];
            return;
          }

          const steps = Math.max(Math.abs(r2 - r1), Math.abs(c2 - c1));
          this.selectedCells = [];
          for (let k = 0; k <= steps; k++) {
            this.selectedCells.push(this.cellKey(r1 + dr * k, c1 + dc * k));
          }
        },

        checkWord() {
          const selectedLetters = this.selectedCells.map(key => {
            const [r, c] = key.split(',').map(Number);
            return this.grid[r][c];
          }).join('');

          for (const placement of this.placements) {
            if (this.foundWords.includes(placement.word)) continue;
            const placementKeys = placement.cells.map(([r, c]) => this.cellKey(r, c));
            const forward = placementKeys.join('|');
            const backward = [...placementKeys].reverse().join('|');
            const selected = this.selectedCells.join('|');
            if (selected === forward || selected === backward) {
              this.foundWords.push(placement.word);
              placementKeys.forEach(k => this.foundCells.add(k));
              break;
            }
          }
        },

        isSelected(r, c) { return this.selectedCells.includes(this.cellKey(r, c)); },
        isFound(r, c) { return this.foundCells.has(this.cellKey(r, c)); },
        isWordFound(word) { return this.foundWords.includes(word.toUpperCase()); }
      },
      template: `
        <div class="question-block">
          <span class="q-label">{{ levelLabel }} · Sopa de letras</span>
          <p style="font-weight:700; font-size:17px;">{{ title }}</p>
          <div class="wordsearch-grid"
               :style="{ gridTemplateColumns: 'repeat(' + gridSize + ', 1fr)' }"
               @mouseleave="endSelect">
            <template v-for="(row, r) in grid" :key="'row'+r">
              <div v-for="(cell, c) in row" :key="r+'-'+c"
                   class="ws-cell"
                   :class="{ selected: isSelected(r, c), found: isFound(r, c) }"
                   @mousedown.prevent="startSelect(r, c)"
                   @mouseenter="moveSelect(r, c)"
                   @mouseup="endSelect">
                {{ cell }}
              </div>
            </template>
          </div>
          <div class="ws-wordlist">
            <span v-for="word in words" :key="word" class="ws-word" :class="{ found: isWordFound(word) }">
              {{ word }}
            </span>
          </div>
          <div v-if="allFound" class="feedback show correct" style="margin-top:12px;">
            ✓ Encontraste todas las palabras.
          </div>
        </div>
      `
    });

    // =========================================================
    // CROSSWORD PUZZLE — Crucigrama
    // =========================================================
    app.component('crossword-puzzle', {
      props: {
        title: { type: String, default: 'Crucigrama' },
        gridData: Array,       // 2D array: '' for black, {letter, number?} for cells
        acrossClues: Array,    // [{number, clue}, ...]
        downClues: Array,      // [{number, clue}, ...]
        level: { type: String, default: 'inter' }
      },
      data() {
        const answers = {};
        for (let r = 0; r < this.gridData.length; r++) {
          for (let c = 0; c < this.gridData[r].length; c++) {
            if (this.gridData[r][c]) {
              answers[r + ',' + c] = '';
            }
          }
        }
        return {
          answers,
          submitted: false,
          levelLabel: { base: '🟢 Base', inter: '🔵 Intermedio', avanzado: '🟣 Avanzado' }[this.level] || '🔵 Intermedio'
        };
      },
      computed: {
        isCorrect() {
          for (let r = 0; r < this.gridData.length; r++) {
            for (let c = 0; c < this.gridData[r].length; c++) {
              const cell = this.gridData[r][c];
              if (cell && this.answers[r + ',' + c].toUpperCase() !== cell.letter.toUpperCase()) {
                return false;
              }
            }
          }
          return true;
        }
      },
      methods: {
        check() { this.submitted = true; },
        reset() {
          for (const key in this.answers) this.answers[key] = '';
          this.submitted = false;
        },
        cellCorrect(r, c) {
          const cell = this.gridData[r][c];
          return cell && this.answers[r + ',' + c].toUpperCase() === cell.letter.toUpperCase();
        },
        onInput(r, c, event) {
          const val = event.target.value;
          if (val.length > 0) {
            this.answers[r + ',' + c] = val[val.length - 1].toUpperCase();
            // Auto-advance to next cell
            const next = event.target.parentElement.nextElementSibling;
            if (next) {
              const inp = next.querySelector('input');
              if (inp) inp.focus();
            }
          }
        }
      },
      template: `
        <div class="question-block" :class="{ correct: submitted && isCorrect, incorrect: submitted && !isCorrect }">
          <span class="q-label">{{ levelLabel }} · Crucigrama</span>
          <p style="font-weight:700; font-size:17px;">{{ title }}</p>
          <div class="crossword-grid" :style="{ gridTemplateColumns: 'repeat(' + gridData[0].length + ', 1fr)' }">
            <template v-for="(row, r) in gridData" :key="'r'+r">
              <template v-for="(cell, c) in row" :key="'c'+r+'-'+c">
                <div v-if="cell" class="cw-cell">
                  <span v-if="cell.number" class="cw-number">{{ cell.number }}</span>
                  <input v-model="answers[r+','+c]"
                         maxlength="2"
                         :class="{ correct: submitted && cellCorrect(r,c), incorrect: submitted && !cellCorrect(r,c) }"
                         @input="onInput(r, c, $event)"
                         :disabled="submitted" />
                </div>
                <div v-else class="cw-black"></div>
              </template>
            </template>
          </div>
          <div class="cw-clues">
            <div>
              <h4>→ Horizontales</h4>
              <div v-for="clue in acrossClues" :key="'a'+clue.number" class="cw-clue">
                <strong>{{ clue.number }}.</strong> {{ clue.clue }}
              </div>
            </div>
            <div>
              <h4>↓ Verticales</h4>
              <div v-for="clue in downClues" :key="'d'+clue.number" class="cw-clue">
                <strong>{{ clue.number }}.</strong> {{ clue.clue }}
              </div>
            </div>
          </div>
          <button v-if="!submitted" class="check-btn" @click="check" style="margin-top:16px;">Verificar crucigrama</button>
          <div v-if="submitted" class="feedback show" :class="{ correct: isCorrect, incorrect: !isCorrect }">
            {{ isCorrect ? '✓ Crucigrama completado correctamente.' : '✗ Hay errores. Las celdas en rosa son incorrectas.' }}
          </div>
          <button v-if="submitted" class="btn" style="margin-top:8px; font-size:13px;" @click="reset">Reintentar</button>
        </div>
      `
    });

    // =========================================================
    // ORDER STEPS — Ordenar pasos de código
    // =========================================================
    app.component('order-steps', {
      props: {
        instruction: String,
        steps: Array,          // [{text: '...', correctOrder: 1}, ...] 
        explanation: String,
        level: { type: String, default: 'inter' }
      },
      data() {
        const shuffled = [...this.steps].sort(() => Math.random() - 0.5);
        return {
          items: shuffled,
          dragIdx: null,
          submitted: false,
          levelLabel: { base: '🟢 Base', inter: '🔵 Intermedio', avanzado: '🟣 Avanzado' }[this.level] || '🔵 Intermedio'
        };
      },
      computed: {
        isCorrect() {
          return this.items.every((item, i) => item.correctOrder === i + 1);
        }
      },
      methods: {
        dragStart(i) { this.dragIdx = i; },
        dragOver(e) { e.preventDefault(); },
        drop(i) {
          if (this.dragIdx === null || this.submitted) return;
          const item = this.items.splice(this.dragIdx, 1)[0];
          this.items.splice(i, 0, item);
          this.dragIdx = null;
        },
        moveUp(i) {
          if (i === 0 || this.submitted) return;
          const temp = this.items[i];
          this.items[i] = this.items[i - 1];
          this.items[i - 1] = temp;
          this.items = [...this.items]; // trigger reactivity
        },
        moveDown(i) {
          if (i >= this.items.length - 1 || this.submitted) return;
          const temp = this.items[i];
          this.items[i] = this.items[i + 1];
          this.items[i + 1] = temp;
          this.items = [...this.items];
        },
        check() { this.submitted = true; },
        reset() {
          this.items = [...this.steps].sort(() => Math.random() - 0.5);
          this.submitted = false;
        }
      },
      template: `
        <div class="question-block" :class="{ correct: submitted && isCorrect, incorrect: submitted && !isCorrect }">
          <span class="q-label">{{ levelLabel }} · Ordena los pasos</span>
          <p style="font-weight:700; font-size:17px;" v-html="instruction"></p>
          <div style="max-width:700px;">
            <div v-for="(item, i) in items" :key="item.text"
                 draggable="true"
                 @dragstart="dragStart(i)"
                 @dragover="dragOver"
                 @drop="drop(i)"
                 style="display:flex; align-items:center; gap:8px; padding:10px 14px; margin-bottom:6px; border:1px solid var(--line); border-radius:6px; cursor:grab; background: var(--bg); font-family: var(--font-mono); font-size: 14px; transition: background 0.15s;"
                 :style="{
                   background: submitted && item.correctOrder === i + 1 ? 'var(--correct)' :
                               submitted ? 'var(--incorrect)' : ''
                 }">
              <span style="display:flex; flex-direction:column; gap:2px; margin-right:4px;">
                <button class="btn" style="padding:2px 6px; font-size:10px; line-height:1;" @click="moveUp(i)" :disabled="submitted">▲</button>
                <button class="btn" style="padding:2px 6px; font-size:10px; line-height:1;" @click="moveDown(i)" :disabled="submitted">▼</button>
              </span>
              <span style="color:var(--ink-muted); min-width:24px; font-weight:700;">{{ i + 1 }}.</span>
              <code v-html="item.text" style="background:none;padding:0;"></code>
            </div>
          </div>
          <button v-if="!submitted" class="check-btn" @click="check">Verificar orden</button>
          <div v-if="submitted" class="feedback show" :class="{ correct: isCorrect, incorrect: !isCorrect }">
            {{ isCorrect ? '✓ Orden correcto.' : '✗ El orden no es correcto.' }} {{ explanation }}
          </div>
          <button v-if="submitted" class="btn" style="margin-top:8px; font-size:13px;" @click="reset">Reintentar</button>
        </div>
      `
    });

  }
};
