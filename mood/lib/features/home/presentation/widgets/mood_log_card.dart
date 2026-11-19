import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

/// View model representing a single mood log entry displayed on the Home feed.
class HomeMoodLogItem {
  final String id;
  final int moodLevel; // 0 = Bad, 1 = Sad, 2 = Okay, 3 = Good, 4 = Great
  final String moodTitle;
  final String timestampLabel;
  final List<({String emoji, String label})> tags;
  final String note;
  final String? audioDuration;
  final List<List<Color>> photoThumbGradients;
  final bool isSample;

  const HomeMoodLogItem({
    required this.id,
    required this.moodLevel,
    required this.moodTitle,
    required this.timestampLabel,
    required this.tags,
    required this.note,
    this.audioDuration,
    this.photoThumbGradients = const [],
    this.isSample = false,
  });
}

/// Crisp white mood log card matching 26_Light_home ("Okay", "Good", "Great" cards).
class MoodLogCard extends StatefulWidget {
  final HomeMoodLogItem item;
  final List<Color> paletteColors;
  final VoidCallback? onTap;

  const MoodLogCard({
    super.key,
    required this.item,
    required this.paletteColors,
    this.onTap,
  });

  @override
  State<MoodLogCard> createState() => _MoodLogCardState();
}

class _MoodLogCardState extends State<MoodLogCard> {
  bool _isPlayingAudio = false;

  @override
  Widget build(BuildContext context) {
    final moodColor =
        widget.paletteColors[widget.item.moodLevel.clamp(0, 4)];

    return Material(
      color: OnboardingColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: OnboardingColors.borderLight.withValues(alpha: 0.7),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Header: Mood Face + Mood Name & Timestamp + Share / More icons
              Row(
                children: [
                  HomeMoodFace(
                    color: moodColor,
                    moodLevel: widget.item.moodLevel,
                    size: 46,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.moodTitle,
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: OnboardingColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.item.timestampLabel,
                          style: AppTypography.label.copyWith(
                            fontSize: 12,
                            color: OnboardingColors.textMuted,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Shared "${widget.item.moodTitle}" mood log',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.share_outlined,
                      size: 20,
                      color: OnboardingColors.textDark,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onTap,
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: OnboardingColors.textDark,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),

              // Activity & Feeling Chips
              if (widget.item.tags.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.item.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: OnboardingColors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: OnboardingColors.borderLight,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(tag.emoji, style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 5),
                          Text(
                            tag.label,
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: OnboardingColors.textDark,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Journal Reflection Note
              if (widget.item.note.trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  widget.item.note,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 13.5,
                    height: 1.55,
                    color: OnboardingColors.textDark.withValues(alpha: 0.88),
                  ),
                ),
              ],

              // Voice Memo Waveform Player
              if (widget.item.audioDuration != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: OnboardingColors.backgroundLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: OnboardingColors.borderLight.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() => _isPlayingAudio = !_isPlayingAudio);
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: OnboardingColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlayingAudio
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.item.audioDuration!,
                        style: AppTypography.label.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: OnboardingColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 24,
                          child: CustomPaint(
                            painter: _AudioWaveformPainter(
                              activeProgress: _isPlayingAudio ? 0.45 : 0.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Photo Memory Thumbnails Strip
              if (widget.item.photoThumbGradients.isNotEmpty) ...[
                const SizedBox(height: 14),
                Row(
                  children: List.generate(
                    widget.item.photoThumbGradients.length,
                    (index) {
                      final colors = widget.item.photoThumbGradients[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index <
                                  widget.item.photoThumbGradients.length - 1
                              ? 10
                              : 0,
                        ),
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: colors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            Icons.photo_outlined,
                            color: Colors.white.withValues(alpha: 0.65),
                            size: 22,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AudioWaveformPainter extends CustomPainter {
  final double activeProgress;

  const _AudioWaveformPainter({required this.activeProgress});

  static const _bars = [
    0.25, 0.35, 0.20, 0.55, 0.40, 0.70, 0.90, 0.50, 0.30, 0.25,
    0.20, 0.35, 0.65, 0.85, 0.45, 0.30, 0.75, 0.95, 0.60, 0.40,
    0.35, 0.80, 0.55, 0.30, 0.70, 0.88, 0.48, 0.28, 0.40, 0.25,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final spacing = size.width / _bars.length;
    final barWidth = (spacing * 0.52).clamp(2.0, 3.2);
    final midY = size.height / 2;

    for (int i = 0; i < _bars.length; i++) {
      final ratio = i / _bars.length;
      final isPlayed = ratio < activeProgress;
      final barHeight = (_bars[i] * size.height).clamp(4.0, size.height);
      final x = i * spacing + spacing / 2;

      final paint = Paint()
        ..color = isPlayed
            ? OnboardingColors.primaryGreen
            : OnboardingColors.textLight.withValues(alpha: 0.65)
        ..strokeWidth = barWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x, midY - barHeight / 2),
        Offset(x, midY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AudioWaveformPainter oldDelegate) {
    return oldDelegate.activeProgress != activeProgress;
  }
}

/// Reusable expressive circular mood face matching 26_Light_home.
class HomeMoodFace extends StatelessWidget {
  final Color color;
  final int moodLevel; // 0..4
  final double size;

  const HomeMoodFace({
    super.key,
    required this.color,
    required this.moodLevel,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _HomeMoodFacePainter(color: color, moodLevel: moodLevel),
      ),
    );
  }
}

class _HomeMoodFacePainter extends CustomPainter {
  final Color color;
  final int moodLevel;

  _HomeMoodFacePainter({required this.color, required this.moodLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = color
        ..isAntiAlias = true,
    );

    const ink = Color(0xFF232724);
    final eyePaint = Paint()
      ..color = ink
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final strokePaint = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.12
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final eyeY = center.dy - r * 0.14;
    final eyeR = r * 0.11;

    if (moodLevel == 4) {
      // Happy curved eyes for "Great"
      final leftEye = Path()
        ..moveTo(center.dx - r * 0.42, eyeY + r * 0.04)
        ..quadraticBezierTo(
          center.dx - r * 0.28,
          eyeY - r * 0.16,
          center.dx - r * 0.14,
          eyeY + r * 0.04,
        );
      final rightEye = Path()
        ..moveTo(center.dx + r * 0.14, eyeY + r * 0.04)
        ..quadraticBezierTo(
          center.dx + r * 0.28,
          eyeY - r * 0.16,
          center.dx + r * 0.42,
          eyeY + r * 0.04,
        );
      canvas.drawPath(leftEye, strokePaint);
      canvas.drawPath(rightEye, strokePaint);
    } else {
      // Dot eyes
      canvas.drawCircle(Offset(center.dx - r * 0.28, eyeY), eyeR, eyePaint);
      canvas.drawCircle(Offset(center.dx + r * 0.28, eyeY), eyeR, eyePaint);

      // Angry brows for level 0
      if (moodLevel == 0) {
        canvas.drawLine(
          Offset(center.dx - r * 0.44, eyeY - r * 0.22),
          Offset(center.dx - r * 0.14, eyeY - r * 0.10),
          strokePaint,
        );
        canvas.drawLine(
          Offset(center.dx + r * 0.44, eyeY - r * 0.22),
          Offset(center.dx + r * 0.14, eyeY - r * 0.10),
          strokePaint,
        );
      }
    }

    // Mouth expression
    final mouthPath = Path();
    if (moodLevel == 0) {
      mouthPath.moveTo(center.dx - r * 0.30, center.dy + r * 0.38);
      mouthPath.quadraticBezierTo(
        center.dx,
        center.dy + r * 0.10,
        center.dx + r * 0.30,
        center.dy + r * 0.38,
      );
    } else if (moodLevel == 1) {
      mouthPath.moveTo(center.dx - r * 0.28, center.dy + r * 0.34);
      mouthPath.quadraticBezierTo(
        center.dx,
        center.dy + r * 0.16,
        center.dx + r * 0.28,
        center.dy + r * 0.34,
      );
    } else if (moodLevel == 2) {
      mouthPath.moveTo(center.dx - r * 0.28, center.dy + r * 0.26);
      mouthPath.lineTo(center.dx + r * 0.28, center.dy + r * 0.26);
    } else if (moodLevel == 3) {
      mouthPath.moveTo(center.dx - r * 0.28, center.dy + r * 0.20);
      mouthPath.quadraticBezierTo(
        center.dx,
        center.dy + r * 0.44,
        center.dx + r * 0.28,
        center.dy + r * 0.20,
      );
    } else {
      // Big open smile for Great
      mouthPath.moveTo(center.dx - r * 0.34, center.dy + r * 0.16);
      mouthPath.quadraticBezierTo(
        center.dx,
        center.dy + r * 0.56,
        center.dx + r * 0.34,
        center.dy + r * 0.16,
      );
    }
    canvas.drawPath(mouthPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _HomeMoodFacePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.moodLevel != moodLevel;
  }
}
