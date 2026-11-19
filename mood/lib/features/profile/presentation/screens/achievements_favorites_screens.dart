import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/presentation/widgets/mood_log_card.dart';
import '../../../onboarding/presentation/providers/account_setup_provider.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

// =============================================================================
// 65_Light & 66_Light: Achievements & Badge Detail Modal
// =============================================================================
class _BadgeItem {
  final String title;
  final IconData icon;
  final Color color;
  final bool unlocked;
  final String earnedDate;

  const _BadgeItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.unlocked,
    this.earnedDate = 'December 22, 2024.',
  });
}

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  static const _lockedGray = Color(0xFFD1D5DB);

  static const List<_BadgeItem> _badges = [
    _BadgeItem(
      title: 'Shining Star',
      icon: Icons.star_rounded,
      color: OnboardingColors.primaryGreen,
      unlocked: true,
    ),
    _BadgeItem(
      title: 'Mood Master',
      icon: Icons.workspace_premium_rounded,
      color: _lockedGray,
      unlocked: false,
    ),
    _BadgeItem(
      title: 'Consistent Logger',
      icon: Icons.military_tech_rounded,
      color: Color(0xFF9C27B0),
      unlocked: true,
    ),
    _BadgeItem(
      title: 'Zen Guru',
      icon: Icons.spa_rounded,
      color: _lockedGray,
      unlocked: false,
    ),
    _BadgeItem(
      title: 'Persistent Performer',
      icon: Icons.gavel_rounded,
      color: Color(0xFF3F51B5),
      unlocked: true,
    ),
    _BadgeItem(
      title: 'Early Bird',
      icon: Icons.wb_sunny_rounded,
      color: _lockedGray,
      unlocked: false,
    ),
    _BadgeItem(
      title: 'Night Owl',
      icon: Icons.nightlight_round,
      color: Color(0xFFFF9800),
      unlocked: true,
    ),
    _BadgeItem(
      title: 'Insight Seeker',
      icon: Icons.search_rounded,
      color: _lockedGray,
      unlocked: false,
    ),
    _BadgeItem(
      title: 'Wellness Warrior',
      icon: Icons.eco_rounded,
      color: Color(0xFF4CAF50),
      unlocked: true,
    ),
    _BadgeItem(
      title: 'Health Hero',
      icon: Icons.monitor_heart_rounded,
      color: _lockedGray,
      unlocked: false,
    ),
    _BadgeItem(
      title: 'Creative Soul',
      icon: Icons.palette_rounded,
      color: Color(0xFF795548),
      unlocked: true,
    ),
    _BadgeItem(
      title: 'Well Done',
      icon: Icons.favorite_rounded,
      color: Color(0xFFEF5350),
      unlocked: true,
    ),
    _BadgeItem(
      title: 'Mindful Master',
      icon: Icons.psychology_rounded,
      color: Color(0xFFE91E63),
      unlocked: true,
    ),
    _BadgeItem(
      title: 'Fitness Fanatic',
      icon: Icons.fitness_center_rounded,
      color: _lockedGray,
      unlocked: false,
    ),
    _BadgeItem(
      title: 'Mood Explorer',
      icon: Icons.explore_rounded,
      color: Color(0xFF00BCD4),
      unlocked: true,
    ),
    _BadgeItem(
      title: 'Social Butterfly',
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFF5C6BC0),
      unlocked: true,
    ),
    _BadgeItem(
      title: 'Goal Getter',
      icon: Icons.track_changes_rounded,
      color: Color(0xFF009688),
      unlocked: true,
    ),
    _BadgeItem(
      title: 'Gratitude Guru',
      icon: Icons.local_florist_rounded,
      color: _lockedGray,
      unlocked: false,
    ),
  ];

  void _showBadgeDetail(BuildContext context, _BadgeItem badge) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            decoration: const BoxDecoration(
              color: OnboardingColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    badge.unlocked
                        ? 'I got the achievements:'
                        : 'Achievement locked:',
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: OnboardingColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Radial Sunburst + Large Badge Circle
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (badge.unlocked)
                          CustomPaint(
                            size: const Size(140, 140),
                            painter: _SunburstPainter(
                              color: badge.color.withValues(alpha: 0.10),
                            ),
                          ),
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: badge.unlocked
                                ? badge.color.withValues(alpha: 0.16)
                                : const Color(0xFFF3F4F6),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: badge.color,
                            ),
                            child: Icon(
                              badge.icon,
                              size: 44,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    '${badge.title}!',
                    textAlign: TextAlign.center,
                    style: AppTypography.displayMedium.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: OnboardingColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    badge.unlocked
                        ? badge.earnedDate
                        : 'Keep logging your daily moods to unlock this badge.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 13,
                      color: OnboardingColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'MoodCanvas',
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: OnboardingColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Share Achievements CTA
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Shared "${badge.title}" achievement!'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.share_outlined, size: 19),
                      label: Text(
                        badge.unlocked ? 'Share Achievements' : 'Close',
                        style: AppTypography.button.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OnboardingColors.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 24,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Achievements',
                        textAlign: TextAlign.center,
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // 3-Column Badges Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  itemCount: _badges.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.84,
                  ),
                  itemBuilder: (context, index) {
                    final badge = _badges[index];
                    return GestureDetector(
                      onTap: () => _showBadgeDetail(context, badge),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 78,
                            height: 78,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: badge.unlocked
                                  ? badge.color.withValues(alpha: 0.14)
                                  : const Color(0xFFF3F4F6),
                            ),
                            padding: const EdgeInsets.all(7),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: badge.color,
                              ),
                              child: Icon(
                                badge.icon,
                                size: 32,
                                color: badge.unlocked
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            badge.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppTypography.label.copyWith(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: badge.unlocked
                                  ? OnboardingColors.textDark
                                  : OnboardingColors.textMuted,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SunburstPainter extends CustomPainter {
  final Color color;

  const _SunburstPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const rays = 12;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < rays; i++) {
      final start = i * (2 * math.pi / rays);
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          start,
          math.pi / (rays * 1.4),
          false,
        )
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SunburstPainter oldDelegate) =>
      oldDelegate.color != color;
}

// =============================================================================
// 67_Light, 68_Light & 69_Light: Favorites Screen
// =============================================================================
class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  bool _isSearching = false;
  String _query = '';
  String? _toastMessage;

  late List<HomeMoodLogItem> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = [
      const HomeMoodLogItem(
        id: 'fav_good',
        moodLevel: 3,
        moodTitle: 'Good',
        timestampLabel: 'Today, Dec 22  ·  20:05 PM',
        tags: [
          (emoji: '😊', label: 'Happy'),
          (emoji: '😌', label: 'Relaxed'),
          (emoji: '✨', label: 'Inspired'),
          (emoji: '🤝', label: 'Teamwork'),
          (emoji: '📈', label: 'Promotion'),
          (emoji: '📚', label: 'Classes'),
          (emoji: '💊', label: 'Medication'),
          (emoji: '🌙', label: 'Dream'),
          (emoji: '🥗', label: 'Lunch'),
          (emoji: '🎮', label: 'Gaming'),
          (emoji: '🧑‍🤝‍🧑', label: 'Friends'),
          (emoji: '🙏', label: 'Gratitude'),
          (emoji: '📋', label: 'Planning'),
          (emoji: '🍳', label: 'Cooking'),
          (emoji: '☀️', label: 'Sunny'),
          (emoji: '🏊', label: 'Swimming'),
        ],
        note:
            'Today, I feel very good. Work, social, weather, everything was perfect.',
        audioDuration: '00:28',
        photoThumbGradients: [
          [Color(0xFF8D6E63), Color(0xFFD7CCC8)],
          [Color(0xFF4E342E), Color(0xFFA1887F)],
          [Color(0xFF0288D1), Color(0xFF4FC3F7)],
        ],
      ),
      const HomeMoodLogItem(
        id: 'fav_great',
        moodLevel: 4,
        moodTitle: 'Great',
        timestampLabel: 'Dec 13  ·  20:09 PM',
        tags: [
          (emoji: '😎', label: 'Confident'),
          (emoji: '☀️', label: 'Energized'),
          (emoji: '😌', label: 'Calm'),
          (emoji: '🗣️', label: 'Presentation'),
          (emoji: '🤝', label: 'Meeting'),
          (emoji: '🎓', label: 'Lectures'),
          (emoji: '🥗', label: 'Healthy Eating'),
          (emoji: '💤', label: 'Nap'),
          (emoji: '🍎', label: 'Fruits'),
          (emoji: '✍️', label: 'Writing'),
          (emoji: '🧑‍🤝‍🧑', label: 'Friends'),
          (emoji: '🎯', label: 'Goal Setting'),
          (emoji: '⏳', label: 'Focus Time'),
          (emoji: '🧹', label: 'Cleaning'),
          (emoji: '🌧️', label: 'Rainy'),
          (emoji: '🧘', label: 'Yoga'),
        ],
        note:
            'Today I slept soundly, presented my progress confidently, and ate healthy fruit.',
        audioDuration: '00:28',
        photoThumbGradients: [
          [Color(0xFF455A64), Color(0xFF90A4AE)],
          [Color(0xFF5D4037), Color(0xFFBCAAA4)],
          [Color(0xFF00ACC1), Color(0xFF80DEEA)],
          [Color(0xFFFF7043), Color(0xFFFFAB91)],
        ],
      ),
      const HomeMoodLogItem(
        id: 'fav_bad',
        moodLevel: 1,
        moodTitle: 'Bad',
        timestampLabel: 'Dec 10  ·  20:45 PM',
        tags: [
          (emoji: '😌', label: 'Content'),
          (emoji: '😰', label: 'Anxious'),
          (emoji: '😕', label: 'Insecure'),
        ],
        note: 'A tough afternoon, but journaling helped me unwind before bed.',
      ),
    ];
  }

  void _removeFavorite(String id, String message) {
    setState(() {
      _favorites.removeWhere((item) => item.id == id);
      _toastMessage = message;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _toastMessage == message) {
        setState(() => _toastMessage = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(accountSetupProvider);
    final paletteColors = moodColorPalettes[setup.colorPaletteIndex];

    final displayed = _query.isEmpty
        ? _favorites
        : _favorites.where((item) {
            final q = _query.toLowerCase();
            return item.moodTitle.toLowerCase().contains(q) ||
                item.note.toLowerCase().contains(q) ||
                item.tags.any((t) => t.label.toLowerCase().contains(q));
          }).toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // Top Bar: Back | "Favorites" | Search
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: _isSearching
                        ? Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  autofocus: true,
                                  onChanged: (v) =>
                                      setState(() => _query = v.trim()),
                                  decoration: InputDecoration(
                                    hintText: 'Search favorites...',
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: const Icon(
                                      Icons.search_rounded,
                                      size: 20,
                                      color: OnboardingColors.textLight,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(() {
                                  _isSearching = false;
                                  _query = '';
                                }),
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: OnboardingColors.textDark,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  size: 24,
                                  color: OnboardingColors.textDark,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Favorites',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.titleLarge.copyWith(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                    color: OnboardingColors.textDark,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    setState(() => _isSearching = true),
                                icon: const Icon(
                                  Icons.search_rounded,
                                  size: 24,
                                  color: OnboardingColors.textDark,
                                ),
                              ),
                            ],
                          ),
                  ),

                  // Favorites Feed
                  Expanded(
                    child: displayed.isEmpty
                        ? Center(
                            child: Text(
                              'No favorite mood logs yet.',
                              style: AppTypography.bodyMedium.copyWith(
                                color: OnboardingColors.textMuted,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
                            itemCount: displayed.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final item = displayed[index];
                              return _FavoriteMoodCard(
                                item: item,
                                paletteColors: paletteColors,
                                onEdit: () => context.push('/capture'),
                                onRemoveFavorite: () => _removeFavorite(
                                  item.id,
                                  'Removed from favorites!',
                                ),
                                onDelete: () => _removeFavorite(
                                  item.id,
                                  'Mood log deleted.',
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            // Floating White Pill Toast matching 69_Light_favorites
            if (_toastMessage != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 36,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: OnboardingColors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: OnboardingColors.primaryGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _toastMessage!,
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: OnboardingColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteMoodCard extends StatelessWidget {
  final HomeMoodLogItem item;
  final List<Color> paletteColors;
  final VoidCallback onEdit;
  final VoidCallback onRemoveFavorite;
  final VoidCallback onDelete;

  const _FavoriteMoodCard({
    required this.item,
    required this.paletteColors,
    required this.onEdit,
    required this.onRemoveFavorite,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MoodLogCard(item: item, paletteColors: paletteColors),
        // Overlay popup menu directly over the top-right more_vert icon (68_Light)
        Positioned(
          top: 12,
          right: 10,
          child: PopupMenuButton<String>(
            color: OnboardingColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            icon: const Icon(
              Icons.more_vert_rounded,
              size: 20,
              color: Colors.transparent,
            ),
            onSelected: (val) {
              if (val == 'edit') {
                onEdit();
              } else if (val == 'remove') {
                onRemoveFavorite();
              } else if (val == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined,
                        size: 18, color: OnboardingColors.textDark),
                    SizedBox(width: 10),
                    Text('Edit',
                        style: TextStyle(color: OnboardingColors.textDark)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'remove',
                child: Row(
                  children: [
                    Icon(Icons.star_rounded,
                        size: 18, color: OnboardingColors.badgeOrange),
                    SizedBox(width: 10),
                    Text('Remove from Favorites',
                        style: TextStyle(color: OnboardingColors.textDark)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded,
                        size: 18, color: OnboardingColors.moodRed),
                    SizedBox(width: 10),
                    Text('Delete',
                        style: TextStyle(color: OnboardingColors.moodRed)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
