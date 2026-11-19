import '../models/canvas_artwork_data.dart';

/// Mapping between activity names and their artistic visual motifs.
class ActivityVisualRules {
  ActivityVisualRules._();

  static MotifType? getMotifForActivity(String activityName) {
    switch (activityName.toLowerCase()) {
      case 'music':
        return MotifType.waveLines;
      case 'nature':
        return MotifType.leafCurve;
      case 'exercise':
        return MotifType.dynamicSpark;
      case 'travel':
        return MotifType.flowingPath;
      case 'reading':
        return MotifType.layeredFrames;
      case 'friends':
      case 'family':
        return MotifType.clusterDots;
      case 'rest':
        return MotifType.softCloud;
      case 'work':
      case 'study':
        return MotifType.structureGrid;
      case 'food':
        return MotifType.warmEmbers;
      case 'creative':
        return MotifType.pigmentArc;
      case 'self-care':
        return MotifType.waterRipple;
      case 'gaming':
      case 'shopping':
        return MotifType.crystalNode;
      default:
        return null;
    }
  }
}
