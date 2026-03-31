import 'package:flutter/material.dart';
import '../theme.dart';

class PodiumWidget extends StatelessWidget {
  final List<PodiumEntry> entries;

  const PodiumWidget({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    final p1 = entries.isNotEmpty ? entries[0] : null;
    final p2 = entries.length > 1 ? entries[1] : null;
    final p3 = entries.length > 2 ? entries[2] : null;

    // Display order: P2, P1, P3
    final displayOrder = [p2, p1, p3];
    final heights = [100.0, 140.0, 75.0];
    final colors = [AppTheme.silver, AppTheme.gold, AppTheme.bronze];
    final labels = ['2', '1', '3'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(3, (i) {
        final entry = displayOrder[i];
        if (entry == null) return const SizedBox(width: 100);
        return SizedBox(
          width: 110,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                entry.name,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                entry.subtitle,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: heights[i],
                decoration: BoxDecoration(
                  color: colors[i],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class PodiumEntry {
  final String name;
  final String subtitle;

  PodiumEntry({required this.name, required this.subtitle});
}
