import 'package:flutter/material.dart';
import '../../../capture/domain/daily_entry.dart';
import 'memory_gallery_card.dart';

/// Artistic two-column masonry layout for displaying memories.
/// Balances cards organically with generous spacing.
class MemoriesMasonryGrid extends StatelessWidget {
  final List<DailyEntry> entries;

  const MemoriesMasonryGrid({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    // Split entries into two columns for the staggered masonry flow
    final leftColumnEntries = <MapEntry<int, DailyEntry>>[];
    final rightColumnEntries = <MapEntry<int, DailyEntry>>[];

    for (int i = 0; i < entries.length; i++) {
      if (i.isEven) {
        leftColumnEntries.add(MapEntry(i, entries[i]));
      } else {
        rightColumnEntries.add(MapEntry(i, entries[i]));
      }
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column
          Expanded(
            child: Column(
              children: leftColumnEntries.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: MemoryGalleryCard(
                    entry: item.value,
                    index: item.key,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(width: 16),

          // Right Column
          Expanded(
            child: Column(
              children: rightColumnEntries.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: MemoryGalleryCard(
                    entry: item.value,
                    index: item.key,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
