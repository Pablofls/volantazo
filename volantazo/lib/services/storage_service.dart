import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';
import '../models/session.dart';
import '../data/tracks.dart';
import '../data/cars.dart';

class StorageService {
  static const _playersKey = 'volantazo_players';
  static const _sessionsKey = 'volantazo_sessions';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Players
  List<Player> getPlayers() {
    final data = _prefs.getString(_playersKey);
    if (data == null) return [];
    return (jsonDecode(data) as List).map((e) => Player.fromJson(e)).toList();
  }

  Player addPlayer(String name) {
    final players = getPlayers();
    final player = Player(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
    );
    players.add(player);
    _prefs.setString(_playersKey, jsonEncode(players.map((p) => p.toJson()).toList()));
    return player;
  }

  void deletePlayer(String id) {
    final players = getPlayers().where((p) => p.id != id).toList();
    _prefs.setString(_playersKey, jsonEncode(players.map((p) => p.toJson()).toList()));
  }

  Player? getPlayerById(String id) {
    final players = getPlayers();
    try {
      return players.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // Sessions
  List<RaceSession> getSessions() {
    final data = _prefs.getString(_sessionsKey);
    if (data == null) return [];
    final list = (jsonDecode(data) as List).map((e) => RaceSession.fromJson(e)).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  RaceSession addSession(RaceSession session) {
    session.sortResults();
    final sessions = getSessions();
    sessions.add(session);
    _saveSessions(sessions);
    return session;
  }

  void updateSession(RaceSession session) {
    session.sortResults();
    final sessions = getSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      sessions[index] = session;
      _saveSessions(sessions);
    }
  }

  void deleteSession(String id) {
    final sessions = getSessions().where((s) => s.id != id).toList();
    _saveSessions(sessions);
  }

  RaceSession? getSessionById(String id) {
    try {
      return getSessions().firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  void _saveSessions(List<RaceSession> sessions) {
    _prefs.setString(_sessionsKey, jsonEncode(sessions.map((s) => s.toJson()).toList()));
  }

  // Stats
  List<DriverStats> getLeaderboard() {
    final sessions = getSessions();
    final stats = <String, DriverStats>{};

    for (final session in sessions) {
      for (final result in session.results) {
        if (!stats.containsKey(result.playerId)) {
          final player = getPlayerById(result.playerId);
          stats[result.playerId] = DriverStats(
            playerId: result.playerId,
            name: player?.name ?? 'Eliminado',
          );
        }
        final s = stats[result.playerId]!;
        s.races++;
        if (!result.dnf) {
          if (result.position == 1) s.wins++;
          if (result.position <= 3) s.podiums++;
        }
      }
    }

    final list = stats.values.toList();
    list.sort((a, b) {
      if (b.wins != a.wins) return b.wins.compareTo(a.wins);
      if (b.podiums != a.podiums) return b.podiums.compareTo(a.podiums);
      return b.races.compareTo(a.races);
    });
    return list;
  }

  MapEntry<Track, int>? getMostPopularTrack() {
    final sessions = getSessions();
    if (sessions.isEmpty) return null;
    final counts = <String, int>{};
    for (final s in sessions) {
      counts[s.trackId] = (counts[s.trackId] ?? 0) + 1;
    }
    final top = counts.entries.reduce((a, b) => a.value >= b.value ? a : b);
    final track = getTrackById(top.key);
    if (track == null) return null;
    return MapEntry(track, top.value);
  }

  MapEntry<Car, int>? getMostPopularCar() {
    final sessions = getSessions();
    if (sessions.isEmpty) return null;
    final counts = <String, int>{};
    for (final s in sessions) {
      counts[s.carId] = (counts[s.carId] ?? 0) + 1;
    }
    final top = counts.entries.reduce((a, b) => a.value >= b.value ? a : b);
    final car = getCarById(top.key);
    if (car == null) return null;
    return MapEntry(car, top.value);
  }

  int getPlayerSessionCount(String playerId) {
    return getSessions().where((s) => s.results.any((r) => r.playerId == playerId)).length;
  }
}

class DriverStats {
  final String playerId;
  final String name;
  int wins = 0;
  int podiums = 0;
  int races = 0;

  DriverStats({required this.playerId, required this.name});
}
