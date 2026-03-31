import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/storage_service.dart';
import '../models/session.dart';
import '../theme.dart';

class EditSessionScreen extends StatefulWidget {
  final StorageService storage;
  final String sessionId;

  const EditSessionScreen({super.key, required this.storage, required this.sessionId});

  @override
  State<EditSessionScreen> createState() => _EditSessionScreenState();
}

class _EditSessionScreenState extends State<EditSessionScreen> {
  late RaceSession _session;
  final Map<String, List<TextEditingController>> _controllers = {};
  final Map<String, bool> _dnfFlags = {};

  @override
  void initState() {
    super.initState();
    _session = widget.storage.getSessionById(widget.sessionId)!;
    for (final r in _session.results) {
      _dnfFlags[r.playerId] = r.dnf;
      if (r.dnf) {
        _controllers[r.playerId] = [
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
        ];
      } else {
        final parts = r.lapTime.split(':');
        final min = parts[0];
        final rest = parts.length > 1 ? parts[1] : parts[0];
        final secParts = rest.split('.');
        _controllers[r.playerId] = [
          TextEditingController(text: min),
          TextEditingController(text: secParts[0]),
          TextEditingController(text: secParts.length > 1 ? secParts[1] : '0'),
        ];
      }
    }
  }

  @override
  void dispose() {
    for (final controllers in _controllers.values) {
      for (final c in controllers) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void _save() {
    final results = <RaceResult>[];
    for (final r in _session.results) {
      final isDnf = _dnfFlags[r.playerId] ?? false;

      if (isDnf) {
        results.add(RaceResult(playerId: r.playerId, lapTime: '0:00.000', dnf: true));
        continue;
      }

      final controllers = _controllers[r.playerId]!;
      final min = int.tryParse(controllers[0].text) ?? 0;
      final sec = int.tryParse(controllers[1].text) ?? 0;
      final ms = int.tryParse(controllers[2].text) ?? 0;

      if (min == 0 && sec == 0 && ms == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingresa el tiempo de todos los pilotos (o marca DNF)'), backgroundColor: AppTheme.danger),
        );
        return;
      }

      final lapTime = '$min:${sec.toString().padLeft(2, '0')}.${ms.toString().padLeft(3, '0')}';
      results.add(RaceResult(playerId: r.playerId, lapTime: lapTime));
    }

    _session.results = results;
    widget.storage.updateSession(_session);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EDITAR RESULTADOS'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(height: 3, color: AppTheme.primary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._session.results.map((r) {
            final player = widget.storage.getPlayerById(r.playerId);
            if (player == null) return const SizedBox.shrink();
            final controllers = _controllers[r.playerId]!;
            final isDnf = _dnfFlags[r.playerId] ?? false;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(player.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        const Spacer(),
                        FilterChip(
                          label: const Text('DNF', style: TextStyle(fontSize: 12)),
                          selected: isDnf,
                          onSelected: (v) => setState(() => _dnfFlags[r.playerId] = v),
                          selectedColor: AppTheme.danger,
                          checkmarkColor: Colors.white,
                        ),
                      ],
                    ),
                    if (!isDnf) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _timeField(controllers[0], 'min'),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text(':', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
                          _timeField(controllers[1], 'seg'),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
                          _timeField(controllers[2], 'ms', width: 65),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('GUARDAR CAMBIOS', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _timeField(TextEditingController controller, String hint, {double width = 55}) {
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
