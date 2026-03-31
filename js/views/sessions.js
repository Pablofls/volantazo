import { getSessions, getPlayerById } from '../store.js';
import { getTrackById, getCarById } from '../data.js';

export function render() {
  const sessions = getSessions();

  if (sessions.length === 0) {
    return `
      <div class="sessions-view">
        <div class="view-header">
          <h1 class="section-title">Carreras</h1>
          <a href="#/sessions/new" class="btn btn-primary">Nueva Carrera</a>
        </div>
        <div class="empty-state small">
          <p>No hay carreras registradas.</p>
        </div>
      </div>
    `;
  }

  return `
    <div class="sessions-view">
      <div class="view-header">
        <h1 class="section-title">Carreras</h1>
        <a href="#/sessions/new" class="btn btn-primary">Nueva Carrera</a>
      </div>
      <div class="race-list">
        ${sessions.map(s => {
          const track = getTrackById(s.trackId);
          const car = getCarById(s.carId);
          const winner = s.results[0];
          const winnerPlayer = winner ? getPlayerById(winner.playerId) : null;
          return `
            <a href="#/sessions/${s.id}" class="race-card">
              <div class="race-info">
                <span class="race-date">${new Date(s.date).toLocaleDateString('es-MX')}</span>
                <span class="race-track">${track ? track.name : s.trackId}</span>
                <span class="race-car">${car ? car.name : s.carId}</span>
              </div>
              <div class="race-meta">
                <span class="race-players">${s.results.length} pilotos</span>
                <div class="race-winner">
                  <span class="winner-label">P1</span>
                  <span class="winner-name">${winnerPlayer ? winnerPlayer.name : 'Desconocido'}</span>
                </div>
              </div>
            </a>
          `;
        }).join('')}
      </div>
    </div>
  `;
}

export function init() {}
