const PLAYERS_KEY = 'volantazo_players';
const SESSIONS_KEY = 'volantazo_sessions';

function load(key) {
  try {
    return JSON.parse(localStorage.getItem(key)) || [];
  } catch {
    return [];
  }
}

function save(key, data) {
  localStorage.setItem(key, JSON.stringify(data));
}

// Players
export function getPlayers() {
  return load(PLAYERS_KEY);
}

export function addPlayer(name) {
  const players = getPlayers();
  const player = {
    id: crypto.randomUUID(),
    name: name.trim(),
    createdAt: new Date().toISOString(),
  };
  players.push(player);
  save(PLAYERS_KEY, players);
  return player;
}

export function deletePlayer(id) {
  const players = getPlayers().filter(p => p.id !== id);
  save(PLAYERS_KEY, players);
}

export function getPlayerById(id) {
  return getPlayers().find(p => p.id === id);
}

// Sessions
export function getSessions() {
  return load(SESSIONS_KEY).sort((a, b) => new Date(b.date) - new Date(a.date));
}

export function addSession(session) {
  const sessions = load(SESSIONS_KEY);
  const newSession = {
    id: crypto.randomUUID(),
    ...session,
    createdAt: new Date().toISOString(),
  };
  // Sort results by lap time and assign positions
  newSession.results.sort((a, b) => lapTimeToMs(a.lapTime) - lapTimeToMs(b.lapTime));
  newSession.results.forEach((r, i) => r.position = i + 1);
  sessions.push(newSession);
  save(SESSIONS_KEY, sessions);
  return newSession;
}

export function getSessionById(id) {
  return load(SESSIONS_KEY).find(s => s.id === id);
}

export function deleteSession(id) {
  const sessions = load(SESSIONS_KEY).filter(s => s.id !== id);
  save(SESSIONS_KEY, sessions);
}

// Lap time helpers
export function lapTimeToMs(timeStr) {
  // Accepts m:ss.sss or ss.sss
  const parts = timeStr.split(':');
  let minutes = 0, rest;
  if (parts.length === 2) {
    minutes = parseInt(parts[0], 10);
    rest = parts[1];
  } else {
    rest = parts[0];
  }
  const [secs, ms] = rest.split('.');
  return minutes * 60000 + parseInt(secs, 10) * 1000 + parseInt((ms || '0').padEnd(3, '0').slice(0, 3), 10);
}

export function formatLapTime(ms) {
  const minutes = Math.floor(ms / 60000);
  const seconds = Math.floor((ms % 60000) / 1000);
  const millis = ms % 1000;
  return `${minutes}:${String(seconds).padStart(2, '0')}.${String(millis).padStart(3, '0')}`;
}

// Stats
export function getLeaderboard() {
  const sessions = load(SESSIONS_KEY);
  const stats = {};

  sessions.forEach(session => {
    session.results.forEach(result => {
      if (!stats[result.playerId]) {
        const player = getPlayerById(result.playerId);
        stats[result.playerId] = {
          playerId: result.playerId,
          name: player ? player.name : 'Piloto eliminado',
          wins: 0,
          podiums: 0,
          races: 0,
        };
      }
      stats[result.playerId].races++;
      if (result.position === 1) stats[result.playerId].wins++;
      if (result.position <= 3) stats[result.playerId].podiums++;
    });
  });

  return Object.values(stats).sort((a, b) => {
    if (b.wins !== a.wins) return b.wins - a.wins;
    if (b.podiums !== a.podiums) return b.podiums - a.podiums;
    return b.races - a.races;
  });
}

export function getMostPopularTrack() {
  const sessions = load(SESSIONS_KEY);
  const counts = {};
  sessions.forEach(s => {
    counts[s.trackId] = (counts[s.trackId] || 0) + 1;
  });
  let maxId = null, maxCount = 0;
  for (const [id, count] of Object.entries(counts)) {
    if (count > maxCount) { maxId = id; maxCount = count; }
  }
  return maxId ? { trackId: maxId, count: maxCount } : null;
}

export function getMostPopularCar() {
  const sessions = load(SESSIONS_KEY);
  const counts = {};
  sessions.forEach(s => {
    counts[s.carId] = (counts[s.carId] || 0) + 1;
  });
  let maxId = null, maxCount = 0;
  for (const [id, count] of Object.entries(counts)) {
    if (count > maxCount) { maxId = id; maxCount = count; }
  }
  return maxId ? { carId: maxId, count: maxCount } : null;
}

export function getPlayerSessionCount(playerId) {
  return load(SESSIONS_KEY).filter(s => s.results.some(r => r.playerId === playerId)).length;
}
