import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/monthly_canvas_data.dart';
import 'monthly_canvas_painter.dart';

/// Reusable widget rendering the living Monthly Canvas artwork.
class MonthlyCanvasView extends StatefulWidget {
  final MonthlyCanvasData data;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isAnimated;

  const MonthlyCanvasView({
    super.key,
    required this.data,
    this.width,
    this.height,
    this.borderRadius = 28.0,
    this.isAnimated = true,
  });

  @override
  State<MonthlyCanvasView> createState() => _MonthlyCanvasViewState();
}

class _MonthlyCanvasViewState extends State<MonthlyCanvasView>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.isAnimated) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 10),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_controller != null) {
      content = AnimatedBuilder(
        animation: _controller!,
        builder: (context, _) {
          return CustomPaint(
            size: Size(
              widget.width ?? double.infinity,
              widget.height ?? double.infinity,
            ),
            painter: MonthlyCanvasPainter(
              data: widget.data,
              animationProgress: _controller!.value,
            ),
          );
        },
      );
    } else {
      content = CustomPaint(
        size: Size(
          widget.width ?? double.infinity,
          widget.height ?? double.infinity,
        ),
        painter: MonthlyCanvasPainter(
          data: widget.data,
          animationProgress: 0.0,
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: AppColors.borderSubtle, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: (widget.data.dominantMoodType?.primaryColor ?? Colors.black)
                .withValues(alpha: 0.25),
            blurRadius: 36,
            spreadRadius: 2,
            offset: const Offset(0, 12),
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
