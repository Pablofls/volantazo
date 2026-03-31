class RaceResult {
  final String playerId;
  String lapTime;
  int position;
  bool dnf;

  RaceResult({
    required this.playerId,
    required this.lapTime,
    this.position = 0,
    this.dnf = false,
  });

  Map<String, dynamic> toJson() => {
        'playerId': playerId,
        'lapTime': lapTime,
        'position': position,
        'dnf': dnf,
      };

  factory RaceResult.fromJson(Map<String, dynamic> json) => RaceResult(
        playerId: json['playerId'],
        lapTime: json['lapTime'],
        position: json['position'] ?? 0,
        dnf: json['dnf'] ?? false,
      );
}

class RaceSession {
  final String id;
  final String date;
  final String trackId;
  final String carId;
  List<RaceResult> results;

  RaceSession({
    required this.id,
    required this.date,
    required this.trackId,
    required this.carId,
    required this.results,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'trackId': trackId,
        'carId': carId,
        'results': results.map((r) => r.toJson()).toList(),
      };

  factory RaceSession.fromJson(Map<String, dynamic> json) => RaceSession(
        id: json['id'],
        date: json['date'],
        trackId: json['trackId'],
        carId: json['carId'],
        results: (json['results'] as List)
            .map((r) => RaceResult.fromJson(r))
            .toList(),
      );

  void sortResults() {
    results.sort((a, b) {
      if (a.dnf && !b.dnf) return 1;
      if (!a.dnf && b.dnf) return -1;
      if (a.dnf && b.dnf) return 0;
      return _lapTimeToMs(a.lapTime).compareTo(_lapTimeToMs(b.lapTime));
    });
    for (int i = 0; i < results.length; i++) {
      results[i].position = i + 1;
    }
  }

  static int _lapTimeToMs(String timeStr) {
    final parts = timeStr.split(':');
    int minutes = 0;
    String rest;
    if (parts.length == 2) {
      minutes = int.tryParse(parts[0]) ?? 0;
      rest = parts[1];
    } else {
      rest = parts[0];
    }
    final secParts = rest.split('.');
    final secs = int.tryParse(secParts[0]) ?? 0;
    final ms = int.tryParse(
            (secParts.length > 1 ? secParts[1] : '0').padRight(3, '0').substring(0, 3)) ??
        0;
    return minutes * 60000 + secs * 1000 + ms;
  }
}
