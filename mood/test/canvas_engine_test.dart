import 'package:flutter_test/flutter_test.dart';
import 'package:mood/features/canvas/domain/engine/canvas_generator.dart';
import 'package:mood/features/canvas/domain/models/canvas_artwork_data.dart';
import 'package:mood/features/capture/domain/energy_level.dart';
import 'package:mood/features/capture/domain/mood_type.dart';

void main() {
  group('MoodCanvas Canvas Engine Tests', () {
    final date = DateTime(2026, 9, 18);

    test('Deterministic reproduction test: exact same inputs yield identical seed', () {
      final artwork1 = CanvasGenerator.generate(
        date: date,
        mood: MoodType.calm,
        moodIntensity: 7,
        energy: EnergyLevel.balanced,
        activities: {'Music', 'Nature'},
      );

      final artwork2 = CanvasGenerator.generate(
        date: date,
        mood: MoodType.calm,
        moodIntensity: 7,
        energy: EnergyLevel.balanced,
        activities: {'Music', 'Nature'},
      );

      expect(artwork1.seed, equals(artwork2.seed));
      expect(artwork1.primaryOrbs.first.relativeCenter,
          equals(artwork2.primaryOrbs.first.relativeCenter));
      expect(artwork1.motifs.length, equals(artwork2.motifs.length));
    });

    test('Different moods produce distinct color palettes and background auras', () {
      final happyCanvas = CanvasGenerator.generate(
        date: date,
        mood: MoodType.happy,
        moodIntensity: 8,
        energy: EnergyLevel.high,
        activities: {'Exercise'},
      );

      final sadCanvas = CanvasGenerator.generate(
        date: date,
        mood: MoodType.sad,
        moodIntensity: 8,
        energy: EnergyLevel.low,
        activities: {'Rest'},
      );

      expect(happyCanvas.backgroundColor, isNot(equals(sadCanvas.backgroundColor)));
      expect(happyCanvas.seed, isNot(equals(sadCanvas.seed)));
    });

    test('Activities generate appropriate visual motifs', () {
      final canvasWithMusic = CanvasGenerator.generate(
        date: date,
        mood: MoodType.calm,
        moodIntensity: 6,
        energy: EnergyLevel.balanced,
        activities: {'Music', 'Reading'},
      );

      final motifTypes = canvasWithMusic.motifs.map((m) => m.type).toList();
      expect(motifTypes, contains(MotifType.waveLines)); // Music
      expect(motifTypes, contains(MotifType.layeredFrames)); // Reading
    });

    test('Energy levels scale orb count and particle density', () {
      final lowEnergyCanvas = CanvasGenerator.generate(
        date: date,
        mood: MoodType.calm,
        moodIntensity: 5,
        energy: EnergyLevel.veryLow,
        activities: {},
      );

      final highEnergyCanvas = CanvasGenerator.generate(
        date: date,
        mood: MoodType.calm,
        moodIntensity: 5,
        energy: EnergyLevel.veryHigh,
        activities: {},
      );

      expect(lowEnergyCanvas.secondaryOrbs.length,
          lessThan(highEnergyCanvas.secondaryOrbs.length));
      expect(lowEnergyCanvas.particles.length,
          lessThan(highEnergyCanvas.particles.length));
    });
  });
}
