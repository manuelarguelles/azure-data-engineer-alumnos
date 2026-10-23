(function () {
  var slides = Array.prototype.slice.call(document.querySelectorAll('.slide'));
  var temas = ['claro', 'oscuro', 'dsrp'];
  var baseFont = 1;
  var escala = 1;
  var tema = 'oscuro';
  var actual = 0;

  function leer(clave, porDefecto) {
    try { var v = localStorage.getItem(clave); return v === null ? porDefecto : v; }
    catch (e) { return porDefecto; }
  }
  function guardar(clave, valor) {
    try { localStorage.setItem(clave, String(valor)); } catch (e) {}
  }

  function aplicarTema() {
    temas.forEach(function (t) { document.body.classList.toggle('tema-' + t, t === tema); });
    document.body.dataset.tema = tema;
    var boton = document.getElementById('bTema');
    if (boton) {
      boton.textContent = tema === 'dsrp' ? 'Tema: DSRP' : 'Tema: ' + tema;
      boton.setAttribute('aria-pressed', String(tema !== 'claro'));
    }
  }

  function aplicarEscala() {
    document.documentElement.style.setProperty('--fs', String(baseFont * escala));
    var etiqueta = document.getElementById('escalaValor');
    if (etiqueta) { etiqueta.textContent = Math.round(escala * 100) + '%'; }
  }

  function show(n) {
    actual = Math.min(slides.length - 1, Math.max(0, n));
    slides.forEach(function (s, k) { s.classList.toggle('on', k === actual); });
    var barra = document.getElementById('bar');
    if (barra) { barra.style.width = ((actual + 1) / slides.length * 100) + '%'; }
    var progreso = document.getElementById('progress');
    if (progreso) { progreso.textContent = (actual + 1) + ' / ' + slides.length; }
    try { history.replaceState(null, '', '#' + (actual + 1)); } catch (e) {}
  }

  function theme() {
    tema = temas[(temas.indexOf(tema) + 1) % temas.length];
    guardar('deck-tema', tema);
    aplicarTema();
  }

  function setScale(v) {
    escala = Math.min(1.3, Math.max(0.8, Math.round(v * 100) / 100));
    guardar('deckEscala', escala);
    aplicarEscala();
  }

  function panel(abrir) {
    var p = document.getElementById('refsPanel');
    var b = document.getElementById('bMarcas');
    if (!p) { return; }
    var visible = typeof abrir === 'boolean' ? abrir : !p.classList.contains('open');
    p.classList.toggle('open', visible);
    if (b) { b.setAttribute('aria-expanded', String(visible)); }
  }

  function deckAudit() {
    var problemas = [];
    slides.forEach(function (s) {
      var estaba = s.classList.contains('on');
      if (!estaba) { s.classList.add('on'); }
      var vertical = s.scrollHeight - s.clientHeight;
      var horizontal = s.scrollWidth - s.clientWidth;
      if (vertical > 2 || horizontal > 2) {
        problemas.push({ slide: s.id, vertical: vertical, horizontal: horizontal });
      }
      if (!estaba) { s.classList.remove('on'); }
    });
    return { pass: problemas.length === 0, problemas: problemas, total: slides.length };
  }


  function iniciarSorter(root) {
    var banco = root.querySelector('.banco');
    var zonas = Array.prototype.slice.call(root.querySelectorAll('.zona'));
    var status = root.querySelector('.sorter-status');
    var reset = root.querySelector('.sorter-reset');
    var seleccion = null;
    var arrastrada = null;

    function fichas() {
      return Array.prototype.slice.call(root.querySelectorAll('.ficha'));
    }
    function estado() {
      var total = fichas().length;
      var puestas = fichas().filter(function (f) { return f.parentElement.classList.contains('zona-bandeja'); });
      var bien = puestas.filter(function (f) {
        return f.closest('.zona').dataset.zone === f.dataset.cat;
      }).length;
      puestas.forEach(function (f) {
        var ok = f.closest('.zona').dataset.zone === f.dataset.cat;
        f.classList.toggle('ok', ok);
        f.classList.toggle('mal', !ok);
        f.setAttribute('aria-label', f.textContent + (ok ? ' · correcto' : ' · revisar'));
      });
      status.textContent = puestas.length + ' de ' + total + ' clasificadas · ' + bien + ' correctas';
    }
    function elegir(f) {
      if (seleccion) { seleccion.classList.remove('sel'); seleccion.setAttribute('aria-pressed', 'false'); }
      seleccion = f === seleccion ? null : f;
      if (seleccion) { seleccion.classList.add('sel'); seleccion.setAttribute('aria-pressed', 'true'); }
    }
    function soltar(f, zona) {
      if (!f || !zona) { return; }
      zona.querySelector('.zona-bandeja').appendChild(f);
      f.classList.remove('sel');
      f.setAttribute('aria-pressed', 'false');
      seleccion = null;
      estado();
    }

    fichas().forEach(function (f) {
      f.setAttribute('aria-pressed', 'false');
      f.addEventListener('click', function (ev) { ev.stopPropagation(); elegir(f); });
      f.addEventListener('dragstart', function (ev) {
        arrastrada = f;
        if (ev.dataTransfer) { ev.dataTransfer.setData('text/plain', f.textContent); ev.dataTransfer.effectAllowed = 'move'; }
      });
      f.addEventListener('dragend', function () { arrastrada = null; });
    });
    zonas.forEach(function (z) {
      z.addEventListener('dragover', function (ev) { ev.preventDefault(); z.classList.add('over'); });
      z.addEventListener('dragleave', function () { z.classList.remove('over'); });
      z.addEventListener('drop', function (ev) {
        ev.preventDefault(); z.classList.remove('over'); soltar(arrastrada, z);
      });
      z.addEventListener('click', function () { if (seleccion) { soltar(seleccion, z); } });
      z.addEventListener('keydown', function (ev) {
        if ((ev.key === 'Enter' || ev.key === ' ') && seleccion) { ev.preventDefault(); soltar(seleccion, z); }
      });
    });
    reset.addEventListener('click', function () {
      fichas().forEach(function (f) {
        f.classList.remove('ok', 'mal', 'sel');
        f.setAttribute('aria-pressed', 'false');
        banco.appendChild(f);
      });
      seleccion = null;
      estado();
    });
    estado();
  }

  function iniciarZoom() {
    var capa = document.getElementById('zoom');
    var imagen = capa ? capa.querySelector('img') : null;
    var cerrar = document.getElementById('zoomClose');
    if (!capa || !imagen) { return; }
    function abrir(src, alt) {
      imagen.src = src; imagen.alt = alt || '';
      capa.hidden = false;
      if (cerrar) { cerrar.focus(); }
    }
    function ocultar() { capa.hidden = true; imagen.removeAttribute('src'); }
    Array.prototype.slice.call(document.querySelectorAll('.gal .zoom')).forEach(function (b) {
      b.addEventListener('click', function () { abrir(b.dataset.src, b.dataset.alt); });
    });
    capa.addEventListener('click', function (ev) { if (ev.target === capa) { ocultar(); } });
    if (cerrar) { cerrar.addEventListener('click', ocultar); }
    document.addEventListener('keydown', function (ev) { if (ev.key === 'Escape' && !capa.hidden) { ocultar(); } });
  }

  function iniciar() {
    tema = leer('deck-tema', 'oscuro');
    if (temas.indexOf(tema) === -1) { tema = 'oscuro'; }
    escala = parseFloat(leer('deckEscala', '1')) || 1;
    if (escala < 0.8 || escala > 1.3) { escala = 1; }
    aplicarTema();
    aplicarEscala();

    document.getElementById('bPrev').onclick = function () { show(actual - 1); };
    document.getElementById('bNext').onclick = function () { show(actual + 1); };
    document.getElementById('bTema').onclick = theme;
    document.getElementById('bMenos').onclick = function () { setScale(escala - 0.05); };
    document.getElementById('bMas').onclick = function () { setScale(escala + 0.05); };
    document.getElementById('bMarcas').onclick = function () { panel(); };
    document.getElementById('refsClose').onclick = function () { panel(false); };

    document.addEventListener('keydown', function (e) {
      if (e.target.closest('input,textarea,summary,.sorter')) { return; }
      if (e.key === 'Escape') { panel(false); }
      if (['ArrowRight', 'PageDown', ' '].indexOf(e.key) !== -1 && !e.target.closest('button,a,video')) {
        e.preventDefault(); show(actual + 1);
      }
      if (['ArrowLeft', 'PageUp'].indexOf(e.key) !== -1) { e.preventDefault(); show(actual - 1); }
      if (e.key === 't' || e.key === 'T') { theme(); }
      if (e.key === 'f' || e.key === 'F') { panel(); }
    });

    Array.prototype.slice.call(document.querySelectorAll('[data-sorter]')).forEach(iniciarSorter);
    iniciarZoom();

    var inicial = parseInt((location.hash || '#1').slice(1), 10) || 1;
    show(inicial - 1);
  }

  window.deckAudit = deckAudit;
  window.deck = { show: show, theme: theme, setScale: setScale, panel: panel, get index() { return actual; } };
  window.s01 = window.deck;

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', iniciar);
  } else {
    iniciar();
  }
})();
