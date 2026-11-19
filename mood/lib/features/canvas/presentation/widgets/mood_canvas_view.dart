import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../capture/domain/energy_level.dart';
import '../../../capture/domain/mood_type.dart';
import '../../domain/engine/canvas_generator.dart';
import '../../domain/models/canvas_artwork_data.dart';
import 'mood_canvas_painter.dart';

/// Reusable widget rendering a procedural MoodCanvas artwork.
/// Supports arbitrary dimensions, animated breathing motion, and custom frame radii.
class MoodCanvasView extends StatefulWidget {
  final CanvasArtworkData? artworkData;

  // Convenient direct inputs if precomputed data is not supplied
  final MoodType? mood;
  final int moodIntensity;
  final EnergyLevel? energy;
  final Set<String> activities;
  final DateTime? date;

  final double? width;
  final double? height;
  final double borderRadius;
  final bool isAnimated;

  const MoodCanvasView({
    super.key,
    this.artworkData,
    this.mood,
    this.moodIntensity = 5,
    this.energy,
    this.activities = const {},
    this.date,
    this.width,
    this.height,
    this.borderRadius = 24.0,
    this.isAnimated = true,
  });

  @override
  State<MoodCanvasView> createState() => _MoodCanvasViewState();
}

class _MoodCanvasViewState extends State<MoodCanvasView>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late CanvasArtworkData _resolvedArtwork;

  @override
  void initState() {
    super.initState();
    _resolvedArtwork = _resolveArtworkData();

    if (widget.isAnimated) {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 5000),
      )..repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant MoodCanvasView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.artworkData != oldWidget.artworkData ||
        widget.mood != oldWidget.mood ||
        widget.moodIntensity != oldWidget.moodIntensity ||
        widget.energy != oldWidget.energy ||
        widget.activities != oldWidget.activities) {
      _resolvedArtwork = _resolveArtworkData();
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  CanvasArtworkData _resolveArtworkData() {
    if (widget.artworkData != null) {
      return widget.artworkData!;
    }

    final targetMood = widget.mood ?? MoodType.calm;
    final targetEnergy = widget.energy ?? EnergyLevel.balanced;
    final targetDate = widget.date ?? DateTime.now();

    return CanvasGenerator.generate(
      date: targetDate,
      mood: targetMood,
      moodIntensity: widget.moodIntensity,
      energy: targetEnergy,
      activities: widget.activities,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_animationController != null) {
      content = AnimatedBuilder(
        animation: _animationController!,
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.width ?? double.infinity, widget.height ?? double.infinity),
            painter: MoodCanvasPainter(
              artwork: _resolvedArtwork,
              progress: _animationController!.value,
            ),
          );
        },
      );
    } else {
      content = CustomPaint(
        size: Size(widget.width ?? double.infinity, widget.height ?? double.infinity),
        painter: MoodCanvasPainter(
          artwork: _resolvedArtwork,
          progress: 0.0,
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: AppColors.borderSubtle,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: RepaintBoundary(child: content),
      ),
    );
  }
}
