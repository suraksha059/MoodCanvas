import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/presentation/widgets/mood_log_card.dart';
import '../../../onboarding/presentation/providers/account_setup_provider.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';
import '../../../profile/presentation/providers/manage_activities_provider.dart';
import '../../domain/daily_entry.dart';
import '../providers/entry_repository_provider.dart';
import '../widgets/mood_gauge_dial.dart';

/// Complete 3-step light-theme Daily Mood Tracking flow matching
/// 27_Light - 34_Light & 40_Light:
/// Step 0: How do you feel today? (Mood Gauge Dial)
/// Step 1: What have you done? (Collapsible Activity Groups)
/// Step 2: Add more details (Quick Note, Voice Memo, Photos -> Save)
class DailyCaptureFlowScreen extends ConsumerStatefulWidget {
  final int initialMood;
  final DateTime? initialDate;

  const DailyCaptureFlowScreen({
    super.key,
    this.initialMood = 3,
    this.initialDate,
  });

  @override
  ConsumerState<DailyCaptureFlowScreen> createState() =>
      _DailyCaptureFlowScreenState();
}

class _DailyCaptureFlowScreenState
    extends ConsumerState<DailyCaptureFlowScreen> {
  int _step = 0; // 0 = Mood Gauge, 1 = Activities, 2 = Details
  late int _selectedMood;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  final Set<String> _selectedActivities = {};
  final Set<String> _collapsedGroups = {};
  final Set<String> _expandedShowMoreGroups = {};

  final TextEditingController _noteController = TextEditingController();
  bool _hasVoiceMemo = false;
  bool _isRecording = false;
  final List<List<Color>> _attachedPhotos = [];
  bool _isSaving = false;

  static const _moodNames = ['Bad', 'Not Good', 'Okay', 'Good', 'Great'];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static const _samplePhotoPresets = [
    [Color(0xFF8D6E63), Color(0xFFD7CCC8)],
    [Color(0xFF4E342E), Color(0xFFA1887F)],
    [Color(0xFF0288D1), Color(0xFF4FC3F7)],
    [Color(0xFF66BB6A), Color(0xFFA5D6A7)],
  ];

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.initialMood.clamp(0, 4);
    _selectedDate = widget.initialDate ?? DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  bool get _isToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _saveEntry() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final entryDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      final dateStr = DailyEntry.toDateString(entryDate);
      final entry = DailyEntry(
        id: 'entry_${dateStr}_${now.millisecondsSinceEpoch}',
        date: entryDate,
        dateString: dateStr,
        mood: _moodNames[_selectedMood],
        moodIntensity: (_selectedMood + 1) * 2,
        energy: _selectedMood >= 3
            ? 'Energized'
            : _selectedMood == 2
                ? 'Balanced'
                : 'Low',
        activities: _selectedActivities.toList(),
        journal: _noteController.text.trim(),
        canvasSeed: entryDate.millisecondsSinceEpoch % 100000,
        createdAt: now,
        updatedAt: now,
      );

      final repo = ref.read(dailyEntryRepositoryProvider);
      await repo.saveOrUpdateTodayEntry(entry);

      if (mounted) {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _handleClose() {
    if (_step > 0) {
      setState(() => _step--);
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(accountSetupProvider);
    final paletteColors = moodColorPalettes[setup.colorPaletteIndex];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor:
            _step == 1 ? const Color(0xFFF6F7F8) : OnboardingColors.white,
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            child: _step == 0
                ? _buildMoodGaugeStep(paletteColors)
                : _step == 1
                    ? _buildActivitiesStep()
                    : _buildDetailsStep(),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // STEP 0: Mood Gauge Dial (27_Light - 31_Light & 40_Light)
  // ===========================================================================
  Widget _buildMoodGaugeStep(List<Color> paletteColors) {
    final moodName = _moodNames[_selectedMood];
    final moodColor = paletteColors[_selectedMood];
    final monthStr = _months[_selectedDate.month - 1];
    final datePrefix =
        _isToday ? 'Today' : _weekdays[_selectedDate.weekday - 1];
    final dateText = '$datePrefix, $monthStr ${_selectedDate.day}';
    final timeText =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    return Column(
      key: const ValueKey('step_mood_gauge'),
      children: [
        // Top Bar: X | Date & Time Chips
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: _handleClose,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 24,
                  color: OnboardingColors.textDark,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickDate,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dateText,
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: OnboardingColors.textDark,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    GestureDetector(
                      onTap: _pickTime,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            timeText,
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.access_time_rounded,
                            size: 15,
                            color: OnboardingColors.textDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Headline
        Text(
          _isToday ? 'How do you feel today?' : 'How do you feel that day?',
          textAlign: TextAlign.center,
          style: AppTypography.displayMedium.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: OnboardingColors.textDark,
            letterSpacing: -0.3,
          ),
        ),

        const Spacer(flex: 2),

        // Large Mood Face
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: HomeMoodFace(
            key: ValueKey(_selectedMood),
            color: moodColor,
            moodLevel: _selectedMood,
            size: 142,
          ),
        ),

        const SizedBox(height: 22),

        // Mood Label
        Text(
          moodName,
          style: AppTypography.titleLarge.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: OnboardingColors.textDark,
          ),
        ),

        const Spacer(flex: 2),

        // Interactive 5-Segment Gauge Dial
        MoodGaugeDial(
          selectedMood: _selectedMood,
          paletteColors: paletteColors,
          onMoodSelected: (level) => setState(() => _selectedMood = level),
        ),

        const Spacer(flex: 1),

        // Bottom CTA Button ("I Feel Good!")
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => setState(() => _step = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: OnboardingColors.primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                'I Feel $moodName!',
                style: AppTypography.button.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // STEP 1: What have you done? (32_Light_mood tracking)
  // ===========================================================================
  Widget _buildActivitiesStep() {
    final allGroups = ref.watch(manageActivitiesProvider);
    final enabledGroups = allGroups.where((g) => g.enabled).toList();
    final groups = enabledGroups.isEmpty ? allGroups : enabledGroups;

    return Column(
      key: const ValueKey('step_activities'),
      children: [
        // Top Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: _handleClose,
              icon: const Icon(
                Icons.close_rounded,
                size: 24,
                color: OnboardingColors.textDark,
              ),
            ),
          ),
        ),

        Text(
          'What have you done?',
          textAlign: TextAlign.center,
          style: AppTypography.displayMedium.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: OnboardingColors.textDark,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),

        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            itemCount: groups.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final group = groups[index];
              final isCollapsed = _collapsedGroups.contains(group.id);
              final isExpandedAll = _expandedShowMoreGroups.contains(group.id);
              final hasMore = group.activities.length > 12;
              final visibleItems = (!hasMore || isExpandedAll)
                  ? group.activities
                  : group.activities.take(12).toList();

              return Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  color: OnboardingColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: OnboardingColors.borderLight.withValues(alpha: 0.7),
                  ),
                ),
                child: Column(
                  children: [
                    // Group Header Row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            group.name,
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (isCollapsed) {
                                _collapsedGroups.remove(group.id);
                              } else {
                                _collapsedGroups.add(group.id);
                              }
                            });
                          },
                          icon: Icon(
                            isCollapsed
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            color: OnboardingColors.textDark,
                            size: 22,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 28,
                          ),
                        ),
                      ],
                    ),

                    if (!isCollapsed) ...[
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: visibleItems.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, itemIdx) {
                          final act = visibleItems[itemIdx];
                          final selected =
                              _selectedActivities.contains(act.name);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selected) {
                                  _selectedActivities.remove(act.name);
                                } else {
                                  _selectedActivities.add(act.name);
                                }
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 160),
                                  width: 48,
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selected
                                        ? OnboardingColors.primaryGreen
                                        : OnboardingColors.backgroundLight,
                                  ),
                                  child: Text(
                                    act.emoji,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  act.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.label.copyWith(
                                    fontSize: 11,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: selected
                                        ? OnboardingColors.primaryGreen
                                        : OnboardingColors.textDark,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      if (hasMore) ...[
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isExpandedAll) {
                                _expandedShowMoreGroups.remove(group.id);
                              } else {
                                _expandedShowMoreGroups.add(group.id);
                              }
                            });
                          },
                          child: Text(
                            isExpandedAll ? 'Show less' : 'Show more...',
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: OnboardingColors.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              );
            },
          ),
        ),

        // Bottom Continue CTA
        Container(
          color: OnboardingColors.white,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => setState(() => _step = 2),
              style: ElevatedButton.styleFrom(
                backgroundColor: OnboardingColors.primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                'Continue',
                style: AppTypography.button.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // STEP 2: Add more details (33_Light & 34_Light_mood tracking)
  // ===========================================================================
  Widget _buildDetailsStep() {
    return Column(
      key: const ValueKey('step_details'),
      children: [
        // Top Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: _handleClose,
              icon: const Icon(
                Icons.close_rounded,
                size: 24,
                color: OnboardingColors.textDark,
              ),
            ),
          ),
        ),

        Text(
          'Add more details',
          textAlign: TextAlign.center,
          style: AppTypography.displayMedium.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: OnboardingColors.textDark,
            letterSpacing: -0.3,
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Note
                Text(
                  'Quick Note',
                  style: AppTypography.titleMedium.copyWith(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: OnboardingColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _noteController,
                  maxLines: 4,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 14.5,
                    height: 1.5,
                    color: OnboardingColors.textDark,
                  ),
                  cursorColor: OnboardingColors.primaryGreen,
                  decoration: InputDecoration(
                    hintText: 'Add your note...',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      fontSize: 14,
                      color: OnboardingColors.textLight,
                    ),
                    filled: true,
                    fillColor: OnboardingColors.backgroundLight,
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: OnboardingColors.primaryGreen,
                        width: 1.4,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Voice Memo
                Text(
                  'Voice Memo',
                  style: AppTypography.titleMedium.copyWith(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: OnboardingColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),

                if (_hasVoiceMemo) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: OnboardingColors.backgroundLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            OnboardingColors.borderLight.withValues(alpha: 0.7),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: OnboardingColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '00:28',
                          style: AppTypography.label.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: OnboardingColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: OnboardingColors.primaryGreen
                                  .withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => setState(() => _hasVoiceMemo = false),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: OnboardingColors.moodRed,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                InkWell(
                  onTap: () {
                    setState(() {
                      if (_isRecording) {
                        _isRecording = false;
                        _hasVoiceMemo = true;
                      } else {
                        _isRecording = true;
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _isRecording
                          ? OnboardingColors.softGreenBg
                          : OnboardingColors.backgroundLight,
                      borderRadius: BorderRadius.circular(14),
                      border: _isRecording
                          ? Border.all(color: OnboardingColors.primaryGreen)
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isRecording
                              ? Icons.stop_circle_outlined
                              : Icons.mic_none_rounded,
                          size: 20,
                          color: _isRecording
                              ? OnboardingColors.moodRed
                              : OnboardingColors.primaryGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isRecording ? 'Tap to Stop Recording' : 'Tap to Record',
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: OnboardingColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Photo Section
                Text(
                  'Photo',
                  style: AppTypography.titleMedium.copyWith(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: OnboardingColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),

                if (_attachedPhotos.isNotEmpty) ...[
                  SizedBox(
                    height: 82,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _attachedPhotos.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final colors = _attachedPhotos[index];
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 78,
                              height: 78,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: colors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Icon(
                                Icons.photo_outlined,
                                color: Colors.white.withValues(alpha: 0.7),
                                size: 26,
                              ),
                            ),
                            Positioned(
                              top: -5,
                              right: -5,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _attachedPhotos.removeAt(index));
                                },
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: OnboardingColors.moodRed,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                Row(
                  children: [
                    Expanded(
                      child: _PhotoActionButton(
                        icon: Icons.camera_alt_outlined,
                        label: 'Camera',
                        onTap: () {
                          setState(() {
                            _attachedPhotos.add(
                              _samplePhotoPresets[_attachedPhotos.length %
                                  _samplePhotoPresets.length],
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PhotoActionButton(
                        icon: Icons.photo_outlined,
                        label: 'Gallery',
                        onTap: () {
                          setState(() {
                            _attachedPhotos.add(
                              _samplePhotoPresets[(_attachedPhotos.length + 1) %
                                  _samplePhotoPresets.length],
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Bottom Save CTA
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: OnboardingColors.primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                _isSaving ? 'Saving...' : 'Save',
                style: AppTypography.button.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PhotoActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: OnboardingColors.backgroundLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 19, color: OnboardingColors.primaryGreen),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.titleMedium.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: OnboardingColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
