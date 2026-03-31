import * as home from './views/home.js';
import * as players from './views/players.js';
import * as sessions from './views/sessions.js';
import * as newSession from './views/new-session.js';
import * as sessionDetail from './views/session-detail.js';

const routes = {
  '/': home,
  '/players': players,
  '/sessions': sessions,
  '/sessions/new': newSession,
};

function getRoute(hash) {
  const path = hash.replace('#', '') || '/';

  // Check exact routes
  if (routes[path]) return { view: routes[path], params: {} };

  // Check session detail: /sessions/:id
  const sessionMatch = path.match(/^\/sessions\/(.+)$/);
  if (sessionMatch && sessionMatch[1] !== 'new') {
    return { view: sessionDetail, params: { id: sessionMatch[1] } };
  }

  return { view: home, params: {} };
}

function navigate(hash) {
  const { view, params } = getRoute(hash);

  if (params.id && view.setSessionId) {
    view.setSessionId(params.id);
  }

  const container = document.getElementById('app');
  container.innerHTML = view.render();
  view.init();

  // Update active nav
  const path = hash.replace('#', '') || '/';
  document.querySelectorAll('.nav-link').forEach(link => {
    const href = link.getAttribute('href').replace('#', '');
    link.classList.toggle('active', path === href || (href !== '/' && path.startsWith(href)));
  });

  window.scrollTo(0, 0);
}

window.addEventListener('hashchange', () => navigate(window.location.hash));
window.addEventListener('DOMContentLoaded', () => navigate(window.location.hash));

window.app = { navigate };
