import { getPlayers, addPlayer, deletePlayer, getPlayerSessionCount } from '../store.js';

export function render() {
  const players = getPlayers();

  return `
    <div class="players-view">
      <h1 class="section-title">Pilotos</h1>

      <form id="add-player-form" class="add-player-form">
        <input type="text" id="player-name" placeholder="Nombre del piloto" maxlength="30" required autocomplete="off" />
        <button type="submit" class="btn btn-primary">Agregar</button>
      </form>

      ${players.length === 0 ? `
        <div class="empty-state small">
          <p>No hay pilotos registrados. Agrega al menos 2 para iniciar una carrera.</p>
        </div>
      ` : `
        <div class="players-list">
          ${players.map(p => {
            const sessionCount = getPlayerSessionCount(p.id);
            return `
              <div class="player-row" data-id="${p.id}">
                <div class="player-info">
                  <span class="player-name">${p.name}</span>
                  <span class="player-races">${sessionCount} carrera${sessionCount !== 1 ? 's' : ''}</span>
                </div>
                <button class="btn btn-danger btn-sm delete-player" data-id="${p.id}" data-name="${p.name}" data-sessions="${sessionCount}">Eliminar</button>
              </div>
            `;
          }).join('')}
        </div>
      `}
    </div>
  `;
}

export function init() {
  const form = document.getElementById('add-player-form');
  if (form) {
    form.addEventListener('submit', (e) => {
      e.preventDefault();
      const input = document.getElementById('player-name');
      const name = input.value.trim();
      if (name) {
        addPlayer(name);
        window.app.navigate(window.location.hash);
      }
    });
  }

  document.querySelectorAll('.delete-player').forEach(btn => {
    btn.addEventListener('click', () => {
      const id = btn.dataset.id;
      const name = btn.dataset.name;
      const sessions = parseInt(btn.dataset.sessions);
      let msg = `¿Eliminar a ${name}?`;
      if (sessions > 0) {
        msg += ` Tiene ${sessions} carrera${sessions !== 1 ? 's' : ''} registrada${sessions !== 1 ? 's' : ''}.`;
      }
      if (confirm(msg)) {
        deletePlayer(id);
        window.app.navigate(window.location.hash);
      }
    });
  });
}
