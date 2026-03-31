import { getLeaderboard, getMostPopularTrack, getMostPopularCar, getSessions } from '../store.js';
import { getTrackById, getCarById } from '../data.js';

export function render() {
  const leaderboard = getLeaderboard();
  const popularTrack = getMostPopularTrack();
  const popularCar = getMostPopularCar();
  const sessions = getSessions();

  if (sessions.length === 0) {
    return `
      <div class="empty-state">
        <div class="empty-icon">🏁</div>
        <h2>Bienvenido a Volantazo</h2>
        <p>Registra pilotos y crea tu primera carrera para ver las estadísticas.</p>
        <div class="empty-actions">
          <a href="#/players" class="btn btn-primary">Agregar Pilotos</a>
          <a href="#/sessions/new" class="btn btn-outline">Nueva Carrera</a>
        </div>
      </div>
    `;
  }

  const top3 = leaderboard.slice(0, 3);
  const rest = leaderboard.slice(3);

  const podiumOrder = [top3[1], top3[0], top3[2]].filter(Boolean);
  const podiumHeights = ['120px', '160px', '90px'];
  const podiumLabels = ['2', '1', '3'];
  const podiumColors = ['var(--silver)', 'var(--gold)', 'var(--bronze)'];

  const trackData = popularTrack ? getTrackById(popularTrack.trackId) : null;
  const carData = popularCar ? getCarById(popularCar.carId) : null;

  return `
    <div class="home">
      <section class="hero-section">
        <h1 class="section-title">Clasificación General</h1>
        <div class="podium-container">
          ${podiumOrder.map((driver, i) => driver ? `
            <div class="podium-spot">
              <div class="podium-driver">
                <span class="podium-name">${driver.name}</span>
                <span class="podium-wins">${driver.wins} victoria${driver.wins !== 1 ? 's' : ''}</span>
              </div>
              <div class="podium-block" style="height: ${podiumHeights[i]}; background: ${podiumColors[i]}">
                <span class="podium-position">${podiumLabels[i]}</span>
              </div>
            </div>
          ` : '').join('')}
        </div>
      </section>

      ${rest.length > 0 ? `
        <section class="standings-table">
          <table>
            <thead>
              <tr>
                <th>POS</th>
                <th>PILOTO</th>
                <th>VICTORIAS</th>
                <th>PODIOS</th>
                <th>CARRERAS</th>
              </tr>
            </thead>
            <tbody>
              ${leaderboard.map((d, i) => `
                <tr class="${i < 3 ? 'top-three' : ''}">
                  <td><span class="position-badge p${i + 1}">${i + 1}</span></td>
                  <td class="driver-name">${d.name}</td>
                  <td>${d.wins}</td>
                  <td>${d.podiums}</td>
                  <td>${d.races}</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </section>
      ` : ''}

      <section class="stats-cards">
        ${trackData ? `
          <div class="stat-card">
            <div class="stat-label">Pista Favorita</div>
            <div class="stat-value">${trackData.name}</div>
            <div class="stat-detail">${trackData.country} · ${popularTrack.count} carrera${popularTrack.count !== 1 ? 's' : ''}</div>
          </div>
        ` : ''}
        ${carData ? `
          <div class="stat-card">
            <div class="stat-label">Carro Favorito</div>
            <div class="stat-value">${carData.name}</div>
            <div class="stat-detail">${carData.category} · ${popularCar.count} carrera${popularCar.count !== 1 ? 's' : ''}</div>
          </div>
        ` : ''}
        <div class="stat-card">
          <div class="stat-label">Total Carreras</div>
          <div class="stat-value">${sessions.length}</div>
          <div class="stat-detail">${leaderboard.length} piloto${leaderboard.length !== 1 ? 's' : ''}</div>
        </div>
      </section>

      <section class="recent-races">
        <h2 class="section-title">Carreras Recientes</h2>
        <div class="race-list">
          ${sessions.slice(0, 5).map(s => {
            const track = getTrackById(s.trackId);
            const car = getCarById(s.carId);
            const winner = s.results[0];
            const winnerName = winner ? (leaderboard.find(d => d.playerId === winner.playerId)?.name || 'Desconocido') : '';
            return `
              <a href="#/sessions/${s.id}" class="race-card">
                <div class="race-info">
                  <span class="race-date">${new Date(s.date).toLocaleDateString('es-MX')}</span>
                  <span class="race-track">${track ? track.name : s.trackId}</span>
                  <span class="race-car">${car ? car.name : s.carId}</span>
                </div>
                <div class="race-winner">
                  <span class="winner-label">P1</span>
                  <span class="winner-name">${winnerName}</span>
                </div>
              </a>
            `;
          }).join('')}
        </div>
      </section>
    </div>
  `;
}

export function init() {}
