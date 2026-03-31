import { getPlayers, addSession } from '../store.js';
import { tracks, cars } from '../data.js';

let selectedTrack = null;
let selectedCar = null;
let selectedPlayers = new Set();
let trackSearch = '';
let carSearch = '';

export function render() {
  const players = getPlayers();

  const trackCategories = {};
  tracks.forEach(t => {
    const cat = t.country || 'Other';
    if (!trackCategories[cat]) trackCategories[cat] = [];
    trackCategories[cat].push(t);
  });

  const carCategories = {};
  cars.forEach(c => {
    if (!carCategories[c.category]) carCategories[c.category] = [];
    carCategories[c.category].push(c);
  });

  return `
    <div class="new-session-view">
      <h1 class="section-title">Nueva Carrera</h1>

      <div class="session-form">
        <!-- Date -->
        <div class="form-section">
          <label class="form-label">Fecha</label>
          <input type="date" id="session-date" class="form-input" value="${new Date().toISOString().split('T')[0]}" />
        </div>

        <!-- Track Selection -->
        <div class="form-section">
          <label class="form-label">Pista</label>
          <input type="text" id="track-search" class="form-input search-input" placeholder="Buscar pista..." autocomplete="off" />
          <div class="selection-grid" id="track-grid">
            ${Object.entries(trackCategories).map(([country, trks]) => `
              <div class="selection-category" data-country="${country.toLowerCase()}">
                <div class="category-label">${country}</div>
                ${trks.map(t => `
                  <button type="button" class="selection-item track-item ${selectedTrack === t.id ? 'selected' : ''}" data-id="${t.id}" data-name="${t.name.toLowerCase()}">
                    ${t.name}
                  </button>
                `).join('')}
              </div>
            `).join('')}
          </div>
        </div>

        <!-- Car Selection -->
        <div class="form-section">
          <label class="form-label">Carro</label>
          <input type="text" id="car-search" class="form-input search-input" placeholder="Buscar carro..." autocomplete="off" />
          <div class="selection-grid" id="car-grid">
            ${Object.entries(carCategories).map(([cat, crs]) => `
              <div class="selection-category" data-category="${cat.toLowerCase()}">
                <div class="category-label">${cat}</div>
                ${crs.map(c => `
                  <button type="button" class="selection-item car-item ${selectedCar === c.id ? 'selected' : ''}" data-id="${c.id}" data-name="${c.name.toLowerCase()}">
                    ${c.name}
                  </button>
                `).join('')}
              </div>
            `).join('')}
          </div>
        </div>

        <!-- Player Selection -->
        <div class="form-section">
          <label class="form-label">Pilotos</label>
          ${players.length < 2 ? `
            <div class="form-warning">
              Necesitas al menos 2 pilotos. <a href="#/players">Agregar pilotos</a>
            </div>
          ` : `
            <div class="players-checkboxes">
              ${players.map(p => `
                <label class="player-checkbox ${selectedPlayers.has(p.id) ? 'checked' : ''}">
                  <input type="checkbox" value="${p.id}" ${selectedPlayers.has(p.id) ? 'checked' : ''} />
                  <span>${p.name}</span>
                </label>
              `).join('')}
            </div>
          `}
        </div>

        <!-- Lap Times (shown when players are selected) -->
        <div class="form-section" id="lap-times-section" style="${selectedPlayers.size > 0 ? '' : 'display:none'}">
          <label class="form-label">Tiempos</label>
          <div class="lap-times-list" id="lap-times-list">
            ${Array.from(selectedPlayers).map(pid => {
              const player = players.find(p => p.id === pid);
              if (!player) return '';
              return `
                <div class="lap-time-row">
                  <span class="lap-time-driver">${player.name}</span>
                  <div class="lap-time-inputs">
                    <input type="number" class="time-input time-min" data-player="${pid}" placeholder="0" min="0" max="59" />
                    <span class="time-sep">:</span>
                    <input type="number" class="time-input time-sec" data-player="${pid}" placeholder="00" min="0" max="59" />
                    <span class="time-sep">.</span>
                    <input type="number" class="time-input time-ms" data-player="${pid}" placeholder="000" min="0" max="999" />
                  </div>
                </div>
              `;
            }).join('')}
          </div>
        </div>

        <!-- Submit -->
        <div class="form-actions">
          <button type="button" class="btn btn-primary btn-lg" id="save-session">Guardar Carrera</button>
          <a href="#/sessions" class="btn btn-outline">Cancelar</a>
        </div>
      </div>
    </div>
  `;
}

export function init() {
  // Track search
  const trackSearchInput = document.getElementById('track-search');
  if (trackSearchInput) {
    trackSearchInput.addEventListener('input', (e) => {
      const q = e.target.value.toLowerCase();
      document.querySelectorAll('#track-grid .selection-item').forEach(item => {
        const match = item.dataset.name.includes(q);
        item.style.display = match ? '' : 'none';
      });
      document.querySelectorAll('#track-grid .selection-category').forEach(cat => {
        const visible = cat.querySelectorAll('.selection-item[style=""], .selection-item:not([style])');
        cat.style.display = visible.length > 0 ? '' : 'none';
      });
    });
  }

  // Car search
  const carSearchInput = document.getElementById('car-search');
  if (carSearchInput) {
    carSearchInput.addEventListener('input', (e) => {
      const q = e.target.value.toLowerCase();
      document.querySelectorAll('#car-grid .selection-item').forEach(item => {
        const match = item.dataset.name.includes(q);
        item.style.display = match ? '' : 'none';
      });
      document.querySelectorAll('#car-grid .selection-category').forEach(cat => {
        const visible = cat.querySelectorAll('.selection-item[style=""], .selection-item:not([style])');
        cat.style.display = visible.length > 0 ? '' : 'none';
      });
    });
  }

  // Track selection
  document.querySelectorAll('.track-item').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.track-item').forEach(b => b.classList.remove('selected'));
      btn.classList.add('selected');
      selectedTrack = btn.dataset.id;
    });
  });

  // Car selection
  document.querySelectorAll('.car-item').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.car-item').forEach(b => b.classList.remove('selected'));
      btn.classList.add('selected');
      selectedCar = btn.dataset.id;
    });
  });

  // Player checkboxes
  document.querySelectorAll('.player-checkbox input').forEach(cb => {
    cb.addEventListener('change', () => {
      if (cb.checked) {
        selectedPlayers.add(cb.value);
      } else {
        selectedPlayers.delete(cb.value);
      }
      cb.closest('.player-checkbox').classList.toggle('checked', cb.checked);
      // Re-render lap times
      window.app.navigate(window.location.hash);
    });
  });

  // Save session
  const saveBtn = document.getElementById('save-session');
  if (saveBtn) {
    saveBtn.addEventListener('click', () => {
      const date = document.getElementById('session-date')?.value;

      if (!selectedTrack) { alert('Selecciona una pista'); return; }
      if (!selectedCar) { alert('Selecciona un carro'); return; }
      if (selectedPlayers.size < 2) { alert('Selecciona al menos 2 pilotos'); return; }

      const results = [];
      let valid = true;

      selectedPlayers.forEach(pid => {
        const min = document.querySelector(`.time-min[data-player="${pid}"]`)?.value || '0';
        const sec = document.querySelector(`.time-sec[data-player="${pid}"]`)?.value || '0';
        const ms = document.querySelector(`.time-ms[data-player="${pid}"]`)?.value || '0';

        const minVal = parseInt(min) || 0;
        const secVal = parseInt(sec) || 0;
        const msVal = parseInt(ms) || 0;

        if (minVal === 0 && secVal === 0 && msVal === 0) {
          valid = false;
          return;
        }

        const lapTime = `${minVal}:${String(secVal).padStart(2, '0')}.${String(msVal).padStart(3, '0')}`;
        results.push({ playerId: pid, lapTime });
      });

      if (!valid) { alert('Ingresa el tiempo de todos los pilotos'); return; }

      const session = addSession({
        date,
        trackId: selectedTrack,
        carId: selectedCar,
        results,
      });

      // Reset state
      selectedTrack = null;
      selectedCar = null;
      selectedPlayers.clear();

      window.location.hash = `#/sessions/${session.id}`;
    });
  }
}
