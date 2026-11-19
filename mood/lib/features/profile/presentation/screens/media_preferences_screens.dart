import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/providers/account_setup_provider.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

class _SubScreenAppBar extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SubScreenAppBar({
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              title,
              textAlign: TextAlign.center,
              style: AppTypography.titleLarge.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: OnboardingColors.textDark,
              ),
            ),
          ),
          SizedBox(
            width: 48,
            child: trailing ?? const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 70_Light_photo gallery
// =============================================================================
class PhotoGalleryScreen extends StatelessWidget {
  const PhotoGalleryScreen({super.key});

  static const _decemberPhotos = [
    ([Color(0xFF455A64), Color(0xFF90A4AE)], Icons.groups_rounded, 'Team Coffee'),
    ([Color(0xFF8D6E63), Color(0xFFD7CCC8)], Icons.local_cafe_rounded, 'Morning Cafe'),
    ([Color(0xFF0288D1), Color(0xFF4FC3F7)], Icons.beach_access_rounded, 'Sunny Walk'),
    ([Color(0xFF546E7A), Color(0xFFB0BEC5)], Icons.laptop_mac_rounded, 'Study Desk'),
    ([Color(0xFF66BB6A), Color(0xFFA5D6A7)], Icons.eco_rounded, 'Fresh Salad'),
    ([Color(0xFF7E57C2), Color(0xFFB39DDB)], Icons.music_note_rounded, 'Evening Tunes'),
    ([Color(0xFFFF7043), Color(0xFFFFAB91)], Icons.restaurant_rounded, 'Dinner Out'),
    ([Color(0xFF26A69A), Color(0xFF80CBC4)], Icons.park_rounded, 'Park Stroll'),
    ([Color(0xFF5C6BC0), Color(0xFF9FA8DA)], Icons.menu_book_rounded, 'Reading Hour'),
    ([Color(0xFFEC407A), Color(0xFFF48FB1)], Icons.local_florist_rounded, 'Flowers'),
    ([Color(0xFFFFA726), Color(0xFFFFCC80)], Icons.wb_sunny_rounded, 'Golden Hour'),
    ([Color(0xFF42A5F5), Color(0xFF90CAF9)], Icons.pool_rounded, 'Swimming'),
    ([Color(0xFF8D6E63), Color(0xFFBCAAA4)], Icons.bakery_dining_rounded, 'Bakery'),
    ([Color(0xFF66BB6A), Color(0xFF81C784)], Icons.directions_bike_rounded, 'Cycling'),
    ([Color(0xFFAB47BC), Color(0xFFCE93D8)], Icons.nightlight_round, 'Night Sky'),
    ([Color(0xFFEF5350), Color(0xFFE57373)], Icons.fitness_center_rounded, 'Workout'),
  ];

  static const _novemberPhotos = [
    ([Color(0xFF546E7A), Color(0xFF78909C)], Icons.hiking_rounded, 'Trail Hike'),
    ([Color(0xFFFFB74D), Color(0xFFFFE0B2)], Icons.ramen_dining_rounded, 'Warm Soup'),
    ([Color(0xFF29B6F6), Color(0xFF81D4FA)], Icons.flight_rounded, 'Weekend Trip'),
    ([Color(0xFF9CCC65), Color(0xFFC5E1A5)], Icons.self_improvement_rounded, 'Yoga'),
    ([Color(0xFF7986CB), Color(0xFFC5CAE9)], Icons.movie_rounded, 'Movie Night'),
    ([Color(0xFFFF8A65), Color(0xFFFFCCBC)], Icons.cake_rounded, 'Celebration'),
    ([Color(0xFF4DB6AC), Color(0xFFB2DFDB)], Icons.water_rounded, 'Lakeside'),
    ([Color(0xFFA1887F), Color(0xFFD7CCC8)], Icons.coffee_rounded, 'Latte Art'),
  ];

  void _openPreview(
    BuildContext context,
    List<Color> colors,
    IconData icon,
    String caption,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  icon,
                  size: 72,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              Positioned(
                bottom: 18,
                left: 18,
                right: 18,
                child: Text(
                  caption,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
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
              _SubScreenAppBar(
                title: 'Photo Gallery',
                trailing: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Showing all logged memory photos'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.search_rounded,
                    size: 24,
                    color: OnboardingColors.textDark,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
                  children: [
                    _buildMonthSection(context, 'December, 2024', _decemberPhotos),
                    const SizedBox(height: 22),
                    _buildMonthSection(context, 'November, 2024', _novemberPhotos),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSection(
    BuildContext context,
    String title,
    List<(List<Color>, IconData, String)> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.label.copyWith(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: OnboardingColors.textMuted,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () => _openPreview(context, item.$1, item.$2, item.$3),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: item.$1,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  item.$2,
                  color: Colors.white.withValues(alpha: 0.72),
                  size: 26,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// =============================================================================
// 71_Light_daily reminder
// =============================================================================
class DailyReminderScreen extends ConsumerStatefulWidget {
  const DailyReminderScreen({super.key});

  @override
  ConsumerState<DailyReminderScreen> createState() =>
      _DailyReminderScreenState();
}

class _DailyReminderScreenState extends ConsumerState<DailyReminderScreen> {
  bool _enabled = true;
  String _ringtone = 'Lollipop';
  double _volume = 0.55;
  bool _vibration = false;

  Future<void> _pickTime() async {
    final setup = ref.read(accountSetupProvider);
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: setup.reminderHour,
        minute: setup.reminderMinute,
      ),
    );
    if (picked != null) {
      ref
          .read(accountSetupProvider.notifier)
          .setReminderTime(picked.hour, picked.minute);
    }
  }

  Future<void> _pickRingtone() async {
    const tones = ['Lollipop', 'Chime', 'Morning Dew', 'Gentle Bell', 'Zen Gong'];
    final chosen = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: OnboardingColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ringtone',
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: OnboardingColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              ...tones.map((t) => ListTile(
                    title: Text(
                      t,
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 15,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    trailing: t == _ringtone
                        ? const Icon(
                            Icons.check_rounded,
                            color: OnboardingColors.primaryGreen,
                          )
                        : null,
                    onTap: () => Navigator.of(ctx).pop(t),
                  )),
            ],
          ),
        ),
      ),
    );
    if (chosen != null && mounted) {
      setState(() => _ringtone = chosen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(accountSetupProvider);
    final hh = setup.reminderHour.toString().padLeft(2, '0');
    final mm = setup.reminderMinute.toString().padLeft(2, '0');
    final period = setup.reminderHour >= 12 ? 'PM' : 'AM';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              const _SubScreenAppBar(title: 'Daily Reminder'),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: OnboardingColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          OnboardingColors.borderLight.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Daily Reminder Switch
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Daily Reminder',
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: OnboardingColors.textDark,
                              ),
                            ),
                            Switch(
                              value: _enabled,
                              onChanged: (v) => setState(() => _enabled = v),
                              activeTrackColor: OnboardingColors.primaryGreen,
                              activeThumbColor: Colors.white,
                              inactiveTrackColor: const Color(0xFFE5E7EB),
                              inactiveThumbColor: Colors.white,
                              trackOutlineColor:
                                  WidgetStateProperty.all(Colors.transparent),
                            ),
                          ],
                        ),
                      ),

                      // Reminder Time
                      InkWell(
                        onTap: _pickTime,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Reminder Time',
                                  style: AppTypography.titleMedium.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: OnboardingColors.textDark,
                                  ),
                                ),
                              ),
                              Text(
                                '$hh:$mm $period',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 14,
                                  color: OnboardingColors.textMuted,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 20,
                                color: OnboardingColors.textDark,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Ringtone
                      InkWell(
                        onTap: _pickRingtone,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Ringtone',
                                  style: AppTypography.titleMedium.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: OnboardingColors.textDark,
                                  ),
                                ),
                              ),
                              Text(
                                _ringtone,
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 14,
                                  color: OnboardingColors.textMuted,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 20,
                                color: OnboardingColors.textDark,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Volume Slider Row
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.volume_off_outlined,
                              size: 20,
                              color: OnboardingColors.textMuted,
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor:
                                      OnboardingColors.primaryGreen,
                                  inactiveTrackColor: const Color(0xFFE5E7EB),
                                  thumbColor: OnboardingColors.white,
                                  overlayColor: OnboardingColors.primaryGreen
                                      .withValues(alpha: 0.14),
                                  trackHeight: 4,
                                ),
                                child: Slider(
                                  value: _volume,
                                  onChanged: (v) => setState(() => _volume = v),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.volume_up_outlined,
                              size: 20,
                              color: OnboardingColors.textMuted,
                            ),
                          ],
                        ),
                      ),

                      // Vibration Switch
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Vibration',
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: OnboardingColors.textDark,
                              ),
                            ),
                            Switch(
                              value: _vibration,
                              onChanged: (v) => setState(() => _vibration = v),
                              activeTrackColor: OnboardingColors.primaryGreen,
                              activeThumbColor: Colors.white,
                              inactiveTrackColor: const Color(0xFFE5E7EB),
                              inactiveThumbColor: Colors.white,
                              trackOutlineColor:
                                  WidgetStateProperty.all(Colors.transparent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 72_Light_export data
// =============================================================================
class ExportDataScreen extends StatelessWidget {
  const ExportDataScreen({super.key});

  void _triggerExport(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Preparing $label export...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              const _SubScreenAppBar(title: 'Export Data'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        'Export Diary',
                        style: AppTypography.label.copyWith(
                          fontSize: 12,
                          color: OnboardingColors.textMuted,
                        ),
                      ),
                    ),
                    _ExportCard(
                      items: [
                        (
                          label: 'Export to CSV',
                          onTap: () => _triggerExport(context, 'CSV'),
                        ),
                        (
                          label: 'Export to PDF',
                          onTap: () => _triggerExport(context, 'PDF'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        'Export Attachments',
                        style: AppTypography.label.copyWith(
                          fontSize: 12,
                          color: OnboardingColors.textMuted,
                        ),
                      ),
                    ),
                    _ExportCard(
                      items: [
                        (
                          label: 'Export Voice Memo',
                          onTap: () => _triggerExport(context, 'Voice Memo'),
                        ),
                        (
                          label: 'Export Photos',
                          onTap: () => _triggerExport(context, 'Photos'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExportCard extends StatelessWidget {
  final List<({String label, VoidCallback onTap})> items;

  const _ExportCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OnboardingColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: OnboardingColors.borderLight.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        children: items.map((item) {
          return InkWell(
            onTap: item.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.label,
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: OnboardingColors.textDark,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// =============================================================================
// 73_Light_preferences
// =============================================================================
class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String _firstDay = 'Monday';
  String _timeFormat = 'System Default';
  String _resetTime = '00:00 AM';
  String _cacheSize = '45.8 MB';

  Future<void> _pickOption(
    String title,
    List<String> options,
    String current,
    ValueChanged<String> onSelected,
  ) async {
    final chosen = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: OnboardingColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: OnboardingColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              ...options.map((opt) => ListTile(
                    title: Text(
                      opt,
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 15,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    trailing: opt == current
                        ? const Icon(
                            Icons.check_rounded,
                            color: OnboardingColors.primaryGreen,
                          )
                        : null,
                    onTap: () => Navigator.of(ctx).pop(opt),
                  )),
            ],
          ),
        ),
      ),
    );
    if (chosen != null) onSelected(chosen);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              const _SubScreenAppBar(title: 'Preferences'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  children: [
                    _prefGroup([
                      _prefRow('Health Connect', null, () {}),
                      _prefRow('App Logo', null, () {}),
                      _prefRow('Widget', null, () {}),
                    ]),
                    const SizedBox(height: 16),
                    _prefGroup([
                      _prefRow(
                        'First Day of Week',
                        _firstDay,
                        () => _pickOption(
                          'First Day of Week',
                          ['Monday', 'Sunday', 'Saturday'],
                          _firstDay,
                          (v) => setState(() => _firstDay = v),
                        ),
                      ),
                      _prefRow(
                        'Time Format',
                        _timeFormat,
                        () => _pickOption(
                          'Time Format',
                          ['System Default', '12-Hour', '24-Hour'],
                          _timeFormat,
                          (v) => setState(() => _timeFormat = v),
                        ),
                      ),
                      _prefRow(
                        'Day Reset Time',
                        _resetTime,
                        () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 0, minute: 0),
                          );
                          if (picked != null && mounted) {
                            final hh = picked.hour.toString().padLeft(2, '0');
                            final mm = picked.minute.toString().padLeft(2, '0');
                            final p = picked.hour >= 12 ? 'PM' : 'AM';
                            setState(() => _resetTime = '$hh:$mm $p');
                          }
                        },
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _prefGroup([
                      _prefRow('Restart All Progress', null, () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Progress reset cancelled.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }),
                      _prefRow('Clear Cache', _cacheSize, () {
                        setState(() => _cacheSize = '0.0 MB');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cache cleared!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _prefGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: OnboardingColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: OnboardingColors.borderLight.withValues(alpha: 0.7),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _prefRow(String title, String? value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: OnboardingColors.textDark,
                ),
              ),
            ),
            if (value != null) ...[
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 13.5,
                  color: OnboardingColors.textMuted,
                ),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: OnboardingColors.textDark,
            ),
          ],
        ),
      ),
    );
  }
}
