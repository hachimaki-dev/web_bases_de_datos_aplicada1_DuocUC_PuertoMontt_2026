/**
 * SLIDE ENGINE — Plataforma Docente · Profe Carlitos
 * 
 * Motor de presentaciones reutilizable basado en Vue 3 (CDN).
 * 
 * USO:
 * Cada HTML de presentación debe:
 * 1. Importar Vue 3 via CDN
 * 2. Importar este script
 * 3. Tener un div#app con la estructura esperada
 * 4. Llamar SlideEngine.mount('#app', { title: '...' })
 * 
 * ESTRUCTURA HTML ESPERADA:
 * <div id="app"></div>
 * <template id="slide-0">...contenido slide 0...</template>
 * <template id="slide-1">...contenido slide 1...</template>
 * ...
 * 
 * O bien, usar el modo inline con <section data-slide="N">
 */

const SlideEngine = {
  /**
   * Monta la aplicación de presentación.
   * @param {string} selector — selector CSS del contenedor (e.g. '#app')
   * @param {Object} config
   * @param {string} config.title — título mostrado en la barra superior
   * @param {number} config.totalSlides — cantidad total de slides
   */
  mount(selector, config) {
    const { createApp } = Vue;

    const app = createApp({
      data() {
        return {
          current: 0,
          total: config.totalSlides || 0,
          title: config.title || 'Presentación',
        };
      },

      computed: {
        progressWidth() {
          return ((this.current + 1) / this.total * 100) + '%';
        }
      },

      methods: {
        next() {
          if (this.current < this.total - 1) this.current++;
        },
        prev() {
          if (this.current > 0) this.current--;
        },
        goTo(index) {
          if (index >= 0 && index < this.total) this.current = index;
        }
      },

      mounted() {
        // Count slides if not provided
        if (!this.total) {
          const slides = document.querySelectorAll('[data-slide]');
          this.total = slides.length;
        }

        // Keyboard navigation
        window.addEventListener('keydown', (e) => {
          if (e.key === 'ArrowRight' || e.key === 'PageDown') {
            e.preventDefault();
            this.next();
          }
          if (e.key === 'ArrowLeft' || e.key === 'PageUp') {
            e.preventDefault();
            this.prev();
          }
          if (e.key === 'Home') {
            e.preventDefault();
            this.current = 0;
          }
          if (e.key === 'End') {
            e.preventDefault();
            this.current = this.total - 1;
          }
        });

        // Apply syntax highlighting if hljs is available
        this.$nextTick(() => {
          this.highlightCode();
        });
      },

      watch: {
        current() {
          this.$nextTick(() => {
            this.highlightCode();
          });
        }
      },

      methods: {
        next() {
          if (this.current < this.total - 1) this.current++;
        },
        prev() {
          if (this.current > 0) this.current--;
        },
        goTo(index) {
          if (index >= 0 && index < this.total) this.current = index;
        },
        highlightCode() {
          if (typeof hljs !== 'undefined') {
            document.querySelectorAll('pre code:not(.hljs)').forEach((block) => {
              hljs.highlightElement(block);
            });
          }
        }
      }
    });

    app.mount(selector);
    return app;
  }
};
