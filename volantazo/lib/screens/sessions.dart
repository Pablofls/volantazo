import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../data/tracks.dart';
import '../data/cars.dart';
import '../theme.dart';

class SessionsScreen extends StatefulWidget {
  final StorageService storage;

  const SessionsScreen({super.key, required this.storage});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  @override
  Widget build(BuildContext context) {
    final sessions = widget.storage.getSessions();

    if (sessions.isEmpty) {
      return const Center(
        child: Text('No hay carreras registradas.', style: TextStyle(color: AppTheme.textSecondary)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, i) {
        final s = sessions[i];
        final track = getTrackById(s.trackId);
        final car = getCarById(s.carId);
        final winner = s.results.isNotEmpty ? s.results.first : null;
        final winnerName = winner != null && !winner.dnf
            ? (widget.storage.getPlayerById(winner.playerId)?.name ?? '?')
            : null;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.pushNamed(context, '/session', arguments: s.id).then((_) => setState(() {})),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(track?.name ?? s.trackId, style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(
                          '${car?.name ?? s.carId} · ${s.date} · ${s.results.length} pilotos',
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  if (winnerName != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppTheme.gold, borderRadius: BorderRadius.circular(4)),
                      child: const Text('P1', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    Text(winnerName, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
