import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/storage_service.dart';
import '../models/session.dart';
import '../data/tracks.dart';
import '../data/cars.dart';
import '../theme.dart';

class NewSessionScreen extends StatefulWidget {
  final StorageService storage;

  const NewSessionScreen({super.key, required this.storage});

  @override
  State<NewSessionScreen> createState() => _NewSessionScreenState();
}

class _NewSessionScreenState extends State<NewSessionScreen> {
  String? _selectedTrack;
  String? _selectedCar;
  final Set<String> _selectedPlayers = {};
  final Map<String, List<TextEditingController>> _timeControllers = {};
  final Map<String, bool> _dnfFlags = {};
  DateTime _date = DateTime.now();
  String _trackSearch = '';
  String _carSearch = '';

  @override
  void dispose() {
    for (final controllers in _timeControllers.values) {
      for (final c in controllers) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void _togglePlayer(String id) {
    setState(() {
      if (_selectedPlayers.contains(id)) {
        _selectedPlayers.remove(id);
        _timeControllers[id]?.forEach((c) => c.dispose());
        _timeControllers.remove(id);
        _dnfFlags.remove(id);
      } else {
        _selectedPlayers.add(id);
        _timeControllers[id] = [
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
        ];
        _dnfFlags[id] = false;
      }
    });
  }

  void _save() {
    if (_selectedTrack == null) {
      _showError('Selecciona una pista');
      return;
    }
    if (_selectedCar == null) {
      _showError('Selecciona un carro');
      return;
    }
    if (_selectedPlayers.length < 2) {
      _showError('Selecciona al menos 2 pilotos');
      return;
    }

    final results = <RaceResult>[];
    for (final pid in _selectedPlayers) {
      final isDnf = _dnfFlags[pid] ?? false;

      if (isDnf) {
        results.add(RaceResult(playerId: pid, lapTime: '0:00.000', dnf: true));
        continue;
      }

      final controllers = _timeControllers[pid]!;
      final min = int.tryParse(controllers[0].text) ?? 0;
      final sec = int.tryParse(controllers[1].text) ?? 0;
      final ms = int.tryParse(controllers[2].text) ?? 0;

      if (min == 0 && sec == 0 && ms == 0) {
        _showError('Ingresa el tiempo de todos los pilotos (o marca DNF)');
        return;
      }

      final lapTime = '$min:${sec.toString().padLeft(2, '0')}.${ms.toString().padLeft(3, '0')}';
      results.add(RaceResult(playerId: pid, lapTime: lapTime));
    }

    final session = widget.storage.addSession(RaceSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
      trackId: _selectedTrack!,
      carId: _selectedCar!,
      results: results,
    ));

    Navigator.pop(context);
    Navigator.pushNamed(context, '/session', arguments: session.id);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppTheme.danger),
    );
  }

  @override
  Widget build(BuildContext context) {
    final players = widget.storage.getPlayers();

    final filteredTracks = allTracks.where((t) =>
        t.name.toLowerCase().contains(_trackSearch.toLowerCase()) ||
        t.country.toLowerCase().contains(_trackSearch.toLowerCase())).toList();

    final filteredCars = allCars.where((c) =>
        c.name.toLowerCase().contains(_carSearch.toLowerCase()) ||
        c.category.toLowerCase().contains(_carSearch.toLowerCase())).toList();

    final tracksByCountry = <String, List<Track>>{};
    for (final t in filteredTracks) {
      tracksByCountry.putIfAbsent(t.country, () => []).add(t);
    }

    final carsByCategory = <String, List<Car>>{};
    for (final c in filteredCars) {
      carsByCategory.putIfAbsent(c.category, () => []).add(c);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('NUEVA CARRERA'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(height: 3, color: AppTheme.primary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Date
          _label('FECHA'),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _date = picked);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text('${_date.day}/${_date.month}/${_date.year}'),
                  const Spacer(),
                  const Icon(Icons.calendar_today, size: 18, color: AppTheme.textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Track
          _label('PISTA'),
          TextField(
            decoration: const InputDecoration(hintText: 'Buscar pista...', prefixIcon: Icon(Icons.search, size: 20)),
            onChanged: (v) => setState(() => _trackSearch = v),
          ),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              children: tracksByCountry.entries.map((entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4),
                    child: Text(entry.key, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1)),
                  ),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: entry.value.map((t) => ChoiceChip(
                      label: Text(t.name, style: const TextStyle(fontSize: 13)),
                      selected: _selectedTrack == t.id,
                      onSelected: (_) => setState(() => _selectedTrack = t.id),
                    )).toList(),
                  ),
                  const SizedBox(height: 8),
                ],
              )).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Car
          _label('CARRO'),
          TextField(
            decoration: const InputDecoration(hintText: 'Buscar carro...', prefixIcon: Icon(Icons.search, size: 20)),
            onChanged: (v) => setState(() => _carSearch = v),
          ),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              children: carsByCategory.entries.map((entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4),
                    child: Text(entry.key, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1)),
                  ),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: entry.value.map((c) => ChoiceChip(
                      label: Text(c.name, style: const TextStyle(fontSize: 13)),
                      selected: _selectedCar == c.id,
                      onSelected: (_) => setState(() => _selectedCar = c.id),
                    )).toList(),
                  ),
                  const SizedBox(height: 8),
                ],
              )).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Players
          _label('PILOTOS'),
          if (players.length < 2)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Necesitas al menos 2 pilotos. Ve a la pestaña Pilotos.',
                    style: TextStyle(color: AppTheme.textSecondary)),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: players.map((p) => FilterChip(
                label: Text(p.name),
                selected: _selectedPlayers.contains(p.id),
                onSelected: (_) => _togglePlayer(p.id),
                selectedColor: AppTheme.primary,
                checkmarkColor: Colors.white,
              )).toList(),
            ),
          const SizedBox(height: 24),

          // Lap times
          if (_selectedPlayers.isNotEmpty) ...[
            _label('TIEMPOS'),
            ..._selectedPlayers.map((pid) {
              final player = widget.storage.getPlayerById(pid);
              if (player == null) return const SizedBox.shrink();
              final controllers = _timeControllers[pid]!;
              final isDnf = _dnfFlags[pid] ?? false;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(player.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                          const Spacer(),
                          FilterChip(
                            label: const Text('DNF', style: TextStyle(fontSize: 12)),
                            selected: isDnf,
                            onSelected: (v) => setState(() => _dnfFlags[pid] = v),
                            selectedColor: AppTheme.danger,
                            checkmarkColor: Colors.white,
                          ),
                        ],
                      ),
                      if (!isDnf) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _timeField(controllers[0], 'min', 59),
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text(':', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
                            _timeField(controllers[1], 'seg', 59),
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
                            _timeField(controllers[2], 'ms', 999, width: 65),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('GUARDAR CARRERA', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1)),
    );
  }

  Widget _timeField(TextEditingController controller, String hint, int max, {double width = 55}) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        ),
      ),
    );
  }
}
