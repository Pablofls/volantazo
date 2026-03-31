import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../data/tracks.dart';
import '../data/cars.dart';
import '../theme.dart';
import '../widgets/podium.dart';

class HomeScreen extends StatefulWidget {
  final StorageService storage;

  const HomeScreen({super.key, required this.storage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final sessions = widget.storage.getSessions();
    final leaderboard = widget.storage.getLeaderboard();
    final popularTrack = widget.storage.getMostPopularTrack();
    final popularCar = widget.storage.getMostPopularCar();

    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏁', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text(
                'Bienvenido a Volantazo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Registra pilotos y crea tu primera carrera',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Clasificación General'),
          const SizedBox(height: 8),
          PodiumWidget(
            entries: leaderboard.take(3).map((d) => PodiumEntry(
              name: d.name,
              subtitle: '${d.wins} victoria${d.wins != 1 ? 's' : ''}',
            )).toList(),
          ),
          const SizedBox(height: 24),

          if (leaderboard.isNotEmpty) ...[
            _buildStandingsTable(leaderboard),
            const SizedBox(height: 24),
          ],

          Row(
            children: [
              if (popularTrack != null)
                Expanded(child: _statCard('Pista Favorita', popularTrack.key.name, '${popularTrack.key.country} · ${popularTrack.value} carrera${popularTrack.value != 1 ? 's' : ''}')),
              if (popularTrack != null && popularCar != null) const SizedBox(width: 12),
              if (popularCar != null)
                Expanded(child: _statCard('Carro Favorito', popularCar.key.name, '${popularCar.key.category} · ${popularCar.value} carrera${popularCar.value != 1 ? 's' : ''}')),
            ],
          ),
          const SizedBox(height: 8),
          _statCard('Total Carreras', '${sessions.length}', '${leaderboard.length} piloto${leaderboard.length != 1 ? 's' : ''}'),
          const SizedBox(height: 24),

          _sectionTitle('Carreras Recientes'),
          const SizedBox(height: 8),
          ...sessions.take(5).map((s) {
            final track = getTrackById(s.trackId);
            final car = getCarById(s.carId);
            final winner = s.results.isNotEmpty ? s.results.first : null;
            final winnerName = winner != null
                ? (widget.storage.getPlayerById(winner.playerId)?.name ?? 'Desconocido')
                : '';
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
                              '${car?.name ?? s.carId} · ${s.date}',
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      if (winner != null && !winner.dnf) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.gold,
                            borderRadius: BorderRadius.circular(4),
                          ),
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
          }),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(width: 4, height: 24, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1)),
      ],
    );
  }

  Widget _statCard(String label, String value, String detail) {
    return Card(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.primary, width: 3)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(detail, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildStandingsTable(List<DriverStats> leaderboard) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(40),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(50),
            3: FixedColumnWidth(55),
            4: FixedColumnWidth(65),
          },
          children: [
            TableRow(
              children: [
                _tableHeader('POS'),
                _tableHeader('PILOTO'),
                _tableHeader('VIC'),
                _tableHeader('POD'),
                _tableHeader('CARR'),
              ],
            ),
            ...leaderboard.asMap().entries.map((entry) {
              final i = entry.key;
              final d = entry.value;
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _positionBadge(i + 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('${d.wins}')),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('${d.podiums}')),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('${d.races}')),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader(String text) {
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
}
