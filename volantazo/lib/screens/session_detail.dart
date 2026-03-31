import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../data/tracks.dart';
import '../data/cars.dart';
import '../theme.dart';
import '../widgets/podium.dart';
import 'edit_session.dart';

class SessionDetailScreen extends StatefulWidget {
  final StorageService storage;
  final String sessionId;

  const SessionDetailScreen({super.key, required this.storage, required this.sessionId});

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final session = widget.storage.getSessionById(widget.sessionId);
    if (session == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Carrera no encontrada')),
      );
    }

    final track = getTrackById(session.trackId);
    final car = getCarById(session.carId);
    final nonDnf = session.results.where((r) => !r.dnf).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(track?.name ?? session.trackId),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditSessionScreen(storage: widget.storage, sessionId: widget.sessionId)),
              );
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppTheme.danger),
            tooltip: 'Eliminar',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Eliminar carrera'),
                  content: const Text('¿Eliminar esta carrera?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                    TextButton(
                      onPressed: () {
                        widget.storage.deleteSession(widget.sessionId);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Eliminar', style: TextStyle(color: AppTheme.danger)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(height: 3, color: AppTheme.primary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  track?.name ?? session.trackId,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
                ),
                const SizedBox(height: 4),
                Text(
                  '${car?.name ?? session.carId}  ·  ${session.date}',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (nonDnf.isNotEmpty)
            PodiumWidget(
              entries: nonDnf.take(3).map((r) {
                final player = widget.storage.getPlayerById(r.playerId);
                return PodiumEntry(name: player?.name ?? '?', subtitle: r.lapTime);
              }).toList(),
            ),
          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(40),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(90),
                  3: FixedColumnWidth(80),
                },
                children: [
                  TableRow(children: [
                    _th('POS'),
                    _th('PILOTO'),
                    _th('TIEMPO'),
                    _th('DIF'),
                  ]),
                  ...session.results.asMap().entries.map((entry) {
                    final i = entry.key;
                    final r = entry.value;
                    final player = widget.storage.getPlayerById(r.playerId);
                    final gap = (i == 0 || r.dnf || session.results[0].dnf) ? '' : _getGap(session.results[0].lapTime, r.lapTime);

                    return TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: _positionBadge(r.position),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(player?.name ?? '?', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          r.dnf ? 'DNF' : r.lapTime,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                            color: r.dnf ? AppTheme.danger : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          gap.isNotEmpty ? '+$gap' : (i == 0 && !r.dnf ? '-' : ''),
                          style: const TextStyle(fontFamily: 'monospace', color: AppTheme.textSecondary),
                        ),
                      ),
                    ]);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _th(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1)),
    );
  }

  Widget _positionBadge(int pos) {
    Color bg;
    Color fg = Colors.black;
    switch (pos) {
      case 1: bg = AppTheme.gold; break;
      case 2: bg = AppTheme.silver; break;
      case 3: bg = AppTheme.bronze; break;
      default: bg = AppTheme.surfaceHover; fg = Colors.white;
    }
    return CircleAvatar(
      radius: 14,
      backgroundColor: bg,
      child: Text('$pos', style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }

  int _parseTime(String t) {
    final parts = t.split(':');
    final min = int.tryParse(parts[0]) ?? 0;
    final rest = parts.length > 1 ? parts[1] : parts[0];
    final secParts = rest.split('.');
    final sec = int.tryParse(secParts[0]) ?? 0;
    final ms = int.tryParse((secParts.length > 1 ? secParts[1] : '0').padRight(3, '0').substring(0, 3)) ?? 0;
    return min * 60000 + sec * 1000 + ms;
  }

  String _getGap(String leaderTime, String driverTime) {
    final diff = _parseTime(driverTime) - _parseTime(leaderTime);
    final sec = diff ~/ 1000;
    final ms = diff % 1000;
    return '$sec.${ms.toString().padLeft(3, '0')}';
  }
}
