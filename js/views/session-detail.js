import { getSessionById, deleteSession, getPlayerById } from '../store.js';
import { getTrackById, getCarById } from '../data.js';

let sessionId = null;

export function setSessionId(id) {
  sessionId = id;
}

export function render() {
  const session = getSessionById(sessionId);
  if (!session) {
    return `
      <div class="empty-state small">
        <p>Carrera no encontrada.</p>
        <a href="#/sessions" class="btn btn-outline">Ver carreras</a>
      </div>
    `;
  }

  const track = getTrackById(session.trackId);
  const car = getCarById(session.carId);

  return `
    <div class="session-detail-view">
      <div class="view-header">
        <a href="#/sessions" class="btn btn-outline btn-sm">Volver</a>
        <button class="btn btn-danger btn-sm" id="delete-session">Eliminar</button>
      </div>

      <div class="session-header">
        <h1 class="race-title">${track ? track.name : session.trackId}</h1>
        <div class="race-subtitle">
          <span>${car ? car.name : session.carId}</span>
          <span class="dot-sep"></span>
          <span>${new Date(session.date).toLocaleDateString('es-MX', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}</span>
        </div>
      </div>

      <!-- Podium -->
      <div class="podium-container detail-podium">
        ${renderPodium(session.results)}
      </div>

      <!-- Full Results -->
      <div class="results-table">
        <table>
          <thead>
            <tr>
              <th>POS</th>
              <th>PILOTO</th>
              <th>TIEMPO</th>
              <th>DIFERENCIA</th>
            </tr>
          </thead>
          <tbody>
            ${session.results.map((r, i) => {
              const player = getPlayerById(r.playerId);
              const gap = i === 0 ? '' : getGap(session.results[0].lapTime, r.lapTime);
              return `
                <tr class="${i < 3 ? 'top-three' : ''}">
                  <td><span class="position-badge p${r.position}">${r.position}</span></td>
                  <td class="driver-name">${player ? player.name : 'Desconocido'}</td>
                  <td class="lap-time">${r.lapTime}</td>
                  <td class="gap">${gap ? `+${gap}` : '-'}</td>
                </tr>
              `;
            }).join('')}
          </tbody>
        </table>
      </div>
    </div>
  `;
}

function renderPodium(results) {
  const positions = [results[1], results[0], results[2]].filter(Boolean);
  const heights = ['120px', '160px', '90px'];
  const labels = ['2', '1', '3'];
  const colors = ['var(--silver)', 'var(--gold)', 'var(--bronze)'];

  return positions.map((r, i) => {
    const player = getPlayerById(r.playerId);
    return `
      <div class="podium-spot">
        <div class="podium-driver">
          <span class="podium-name">${player ? player.name : 'Desconocido'}</span>
          <span class="podium-time">${r.lapTime}</span>
        </div>
        <div class="podium-block" style="height: ${heights[i]}; background: ${colors[i]}">
          <span class="podium-position">${labels[i]}</span>
        </div>
      </div>
    `;
  }).join('');
}

function getGap(leaderTime, driverTime) {
  const parse = (t) => {
    const [m, rest] = t.split(':');
    const [s, ms] = rest.split('.');
    return parseInt(m) * 60000 + parseInt(s) * 1000 + parseInt(ms.padEnd(3, '0').slice(0, 3));
  };
  const diff = parse(driverTime) - parse(leaderTime);
  const sec = Math.floor(diff / 1000);
  const ms = diff % 1000;
  return `${sec}.${String(ms).padStart(3, '0')}`;
}

export function init() {
  const deleteBtn = document.getElementById('delete-session');
  if (deleteBtn) {
    deleteBtn.addEventListener('click', () => {
      if (confirm('¿Eliminar esta carrera?')) {
        deleteSession(sessionId);
        window.location.hash = '#/sessions';
      }
    });
  }
}
