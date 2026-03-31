import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../theme.dart';

class PlayersScreen extends StatefulWidget {
  final StorageService storage;

  const PlayersScreen({super.key, required this.storage});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addPlayer() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    widget.storage.addPlayer(name);
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final players = widget.storage.getPlayers();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Nombre del piloto'),
                  onSubmitted: (_) => _addPlayer(),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _addPlayer,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18)),
                child: const Text('AGREGAR'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: players.isEmpty
                ? const Center(
                    child: Text(
                      'No hay pilotos registrados.\nAgrega al menos 2 para iniciar una carrera.',
                      style: TextStyle(color: AppTheme.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, i) {
                      final p = players[i];
                      final count = widget.storage.getPlayerSessionCount(p.id);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: ListTile(
                          title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('$count carrera${count != 1 ? 's' : ''}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: AppTheme.danger),
                            onPressed: () {
                              final msg = count > 0
                                  ? '¿Eliminar a ${p.name}? Tiene $count carrera${count != 1 ? 's' : ''}.'
                                  : '¿Eliminar a ${p.name}?';
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Eliminar piloto'),
                                  content: Text(msg),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                                    TextButton(
                                      onPressed: () {
                                        widget.storage.deletePlayer(p.id);
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      child: const Text('Eliminar', style: TextStyle(color: AppTheme.danger)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
