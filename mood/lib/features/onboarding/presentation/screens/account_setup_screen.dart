import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/account_setup_provider.dart';
import '../theme/onboarding_colors.dart';
import '../widgets/social_brand_icons.dart';

/// 8-step Account Setup Wizard matching 9_Light_account setup through 17_Light_account setup.
class AccountSetupScreen extends ConsumerStatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  ConsumerState<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends ConsumerState<AccountSetupScreen> {
  static const int _totalSteps = 8;

  int _currentStep = 0; // 0..7 -> displays 1/8 .. 8/8
  late final TextEditingController _nicknameController;
  late final FixedExtentScrollController _ageWheelController;
  late final FixedExtentScrollController _hourWheelController;
  late final FixedExtentScrollController _minuteWheelController;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(accountSetupProvider);
    _nicknameController = TextEditingController(text: initial.nickname);
    _ageWheelController = FixedExtentScrollController(
      initialItem: (initial.age - 13).clamp(0, 86),
    );
    _hourWheelController = FixedExtentScrollController(
      initialItem: initial.reminderHour.clamp(0, 23),
    );
    _minuteWheelController = FixedExtentScrollController(
      initialItem: initial.reminderMinute.clamp(0, 59),
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _ageWheelController.dispose();
    _hourWheelController.dispose();
    _minuteWheelController.dispose();
    super.dispose();
  }

  void _onBack() {
    FocusScope.of(context).unfocus();
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.go('/signup');
    }
  }

  void _onContinue() {
    FocusScope.of(context).unfocus();
    if (_currentStep == 0) {
      ref
          .read(accountSetupProvider.notifier)
          .setNickname(_nicknameController.text.trim());
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      context.go('/setup-loading');
    }
  }

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(accountSetupProvider);
    final isLastStep = _currentStep == _totalSteps - 1;
    final progress = (_currentStep + 1) / _totalSteps;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Top Progress Header: Back Arrow | Green Progress Bar | Step Counter
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _onBack,
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: OnboardingColors.textDark,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 9,
                          color: const Color(0xFFEEEEEE),
                          alignment: Alignment.centerLeft,
                          child: AnimatedFractionallySizedBox(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                color: OnboardingColors.primaryGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      '${_currentStep + 1} / $_totalSteps',
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              // Active Step Body
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: KeyedSubtree(
                    key: ValueKey(_currentStep),
                    child: _buildStepBody(setup),
                  ),
                ),
              ),

              // Bottom CTA Button ("Continue" or "Finish")
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnboardingColors.primaryGreen,
                      foregroundColor: OnboardingColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      isLastStep ? 'Finish' : 'Continue',
                      style: AppTypography.button.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: OnboardingColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepBody(AccountSetupState setup) {
    switch (_currentStep) {
      case 0:
        return _buildNicknameStep();
      case 1:
        return _buildGenderStep(setup);
      case 2:
        return _buildAgeStep(setup);
      case 3:
        return _buildEmojiThemeStep(setup);
      case 4:
        return _buildColorPaletteStep(setup);
      case 5:
        return _buildRecordCategoriesStep(setup);
      case 6:
        return _buildReminderTimeStep(setup);
      case 7:
      default:
        return _buildReferralSourceStep(setup);
    }
  }

  Widget _buildStepHeader(String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.displayMedium.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: OnboardingColors.textDark,
            height: 1.25,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 14,
            height: 1.5,
            color: OnboardingColors.textMuted,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Step 1 / 8: Nickname
  // ---------------------------------------------------------------------------
  Widget _buildNicknameStep() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
      child: Column(
        children: [
          _buildStepHeader(
            'What should we call you?',
            'First things first, enter your nickname.',
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nicknameController,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.words,
            style: AppTypography.displayMedium.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: OnboardingColors.textDark,
            ),
            cursorColor: OnboardingColors.primaryGreen,
            decoration: InputDecoration(
              hintText: 'Your nickname',
              hintStyle: AppTypography.displayMedium.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: OnboardingColors.textLight,
              ),
              filled: true,
              fillColor: OnboardingColors.backgroundLight,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: OnboardingColors.primaryGreen,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 2 / 8: Gender
  // ---------------------------------------------------------------------------
  Widget _buildGenderStep(AccountSetupState setup) {
    final notifier = ref.read(accountSetupProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
      child: Column(
        children: [
          _buildStepHeader(
            'What is your gender?',
            'Help us tailor your experience.',
          ),
          const SizedBox(height: 52),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _GenderCircleOption(
                icon: Icons.male_rounded,
                label: 'Male',
                selected: setup.gender == 'Male',
                onTap: () => notifier.setGender('Male'),
              ),
              const SizedBox(width: 28),
              _GenderCircleOption(
                icon: Icons.female_rounded,
                label: 'Female',
                selected: setup.gender == 'Female',
                onTap: () => notifier.setGender('Female'),
              ),
            ],
          ),
          const SizedBox(height: 36),
          GestureDetector(
            onTap: () => notifier.setGender('Prefer not to say'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: setup.gender == 'Prefer not to say'
                    ? OnboardingColors.softGreenBg
                    : OnboardingColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: setup.gender == 'Prefer not to say'
                      ? OnboardingColors.primaryGreen
                      : OnboardingColors.borderLight,
                  width: 1.3,
                ),
              ),
              child: Text(
                'Prefer not to say',
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: setup.gender == 'Prefer not to say'
                      ? OnboardingColors.primaryGreen
                      : OnboardingColors.textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 3 / 8: Age Wheel Picker
  // ---------------------------------------------------------------------------
  Widget _buildAgeStep(AccountSetupState setup) {
    final notifier = ref.read(accountSetupProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
      child: Column(
        children: [
          _buildStepHeader(
            'How old are you?',
            "We'd like to know more about you.",
          ),
          const SizedBox(height: 28),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Center highlight divider lines
                Container(
                  width: 170,
                  height: 60,
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: OnboardingColors.primaryGreen,
                        width: 1.4,
                      ),
                    ),
                  ),
                ),

                // Scrollable Age Wheel
                ListWheelScrollView.useDelegate(
                  controller: _ageWheelController,
                  itemExtent: 54,
                  perspective: 0.002,
                  diameterRatio: 1.8,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    notifier.setAge(13 + index);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 87, // 13..99
                    builder: (context, index) {
                      final age = 13 + index;
                      final distance = (age - setup.age).abs();
                      final isSelected = distance == 0;
                      final fontSize = isSelected
                          ? 34.0
                          : distance == 1
                              ? 24.0
                              : distance == 2
                                  ? 19.0
                                  : 15.0;
                      final color = isSelected
                          ? OnboardingColors.primaryGreen
                          : OnboardingColors.textDark.withValues(
                              alpha: distance == 1
                                  ? 0.85
                                  : distance == 2
                                      ? 0.55
                                      : 0.3,
                            );

                      return Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$age',
                              style: AppTypography.displayLarge.copyWith(
                                fontSize: fontSize,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: color,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              Text(
                                'years',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: OnboardingColors.textDark,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 4 / 8: Emoji Theme Selector
  // ---------------------------------------------------------------------------
  Widget _buildEmojiThemeStep(AccountSetupState setup) {
    final notifier = ref.read(accountSetupProvider.notifier);

    const themes = [
      (style: _EmojiThemeStyle.classic, premium: false),
      (style: _EmojiThemeStyle.kawaii, premium: false),
      (style: _EmojiThemeStyle.pumpkin, premium: false),
      (style: _EmojiThemeStyle.minimal, premium: false),
      (style: _EmojiThemeStyle.outlined, premium: false),
      (style: _EmojiThemeStyle.square, premium: true),
      (style: _EmojiThemeStyle.blush, premium: true),
      (style: _EmojiThemeStyle.pastel, premium: true),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
          child: _buildStepHeader(
            'Choose your emoji theme',
            'Make mood tracking fun. Pick the emoji theme you prefer.',
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
            itemCount: themes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final theme = themes[index];
              final isSelected = setup.emojiThemeIndex == index;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () => notifier.setEmojiTheme(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: OnboardingColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? OnboardingColors.primaryGreen
                              : OnboardingColors.borderLight,
                          width: isSelected ? 1.8 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (moodIndex) {
                          return _ThemeMoodFace(
                            style: theme.style,
                            moodIndex: moodIndex,
                            size: 42,
                          );
                        }),
                      ),
                    ),
                  ),
                  if (theme.premium)
                    Positioned(
                      top: -7,
                      right: -6,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: OnboardingColors.badgeOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Step 5 / 8: Color Palette Selector
  // ---------------------------------------------------------------------------
  Widget _buildColorPaletteStep(AccountSetupState setup) {
    final notifier = ref.read(accountSetupProvider.notifier);
    final activeColors = moodColorPalettes[setup.colorPaletteIndex];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
          child: _buildStepHeader(
            'Choose your color palette',
            'Customize your emoji theme. Pick the colors you like best.',
          ),
        ),

        // Live 5-Mood Face Preview colored by active palette
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              return _PalettePreviewFace(
                color: activeColors[i],
                moodIndex: i,
                size: 52,
              );
            }),
          ),
        ),

        const SizedBox(height: 28),

        // Palette Cards
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
            itemCount: moodColorPalettes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final palette = moodColorPalettes[index];
              final isSelected = setup.colorPaletteIndex == index;
              final isPremium = index == moodColorPalettes.length - 1;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () => notifier.setColorPalette(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: OnboardingColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? OnboardingColors.primaryGreen
                              : OnboardingColors.borderLight,
                          width: isSelected ? 1.8 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: palette.map((c) {
                          return Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  if (isPremium)
                    Positioned(
                      top: -7,
                      right: -6,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: OnboardingColors.badgeOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Step 6 / 8: What do you want to record?
  // ---------------------------------------------------------------------------
  Widget _buildRecordCategoriesStep(AccountSetupState setup) {
    final notifier = ref.read(accountSetupProvider.notifier);

    const categories = [
      (title: 'Emotions', examples: 'Happy, Sad, Angry, Anxious, Excited, Calm...'),
      (title: 'Work', examples: 'Overtime, Teamwork, Meeting, Deadline...'),
      (title: 'School', examples: 'Classes, Homework, Exams, Projects, Lectures...'),
      (title: 'Health', examples: 'Exercise, Doctor Visit, Medication, Therapy...'),
      (title: 'Relationships', examples: 'Date Night, Quality Time, Conflict, Support...'),
      (title: 'Sleep', examples: 'Nap, Insomnia, Dream, Deep Sleep, Restless...'),
      (title: 'Food', examples: 'Breakfast, Lunch, Dinner, Snacks, Dessert...'),
      (title: 'Drinks', examples: 'Water, Coffee, Tea, Juice, Soda, Alcohol...'),
      (title: 'Hobbies', examples: 'Reading, Painting, Cooking, Gardening, Gaming...'),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
          child: _buildStepHeader(
            'What do you want to\nrecord?',
            'Track activities that matter to you. Choose the types of activities you want to log.',
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = setup.recordCategories.contains(cat.title);

              return GestureDetector(
                onTap: () => notifier.toggleCategory(cat.title),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: OnboardingColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? OnboardingColors.primaryGreen
                          : OnboardingColors.borderLight,
                      width: isSelected ? 1.6 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.title,
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: OnboardingColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cat.examples,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: 12.5,
                                color: OnboardingColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedOpacity(
                        opacity: isSelected ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 150),
                        child: const Icon(
                          Icons.check_rounded,
                          color: OnboardingColors.primaryGreen,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Step 7 / 8: Daily Reminder Time Wheel Picker
  // ---------------------------------------------------------------------------
  Widget _buildReminderTimeStep(AccountSetupState setup) {
    final notifier = ref.read(accountSetupProvider.notifier);
    final period = setup.reminderHour >= 12 ? 'PM' : 'AM';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
      child: Column(
        children: [
          _buildStepHeader(
            'Set daily reminder time',
            'Stay consistent with your tracking. Choose a time for daily reminders.',
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Center highlight lines on left & right columns
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 108,
                      height: 60,
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: OnboardingColors.primaryGreen,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        ':',
                        style: AppTypography.displayLarge.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.primaryGreen,
                        ),
                      ),
                    ),
                    Container(
                      width: 108,
                      height: 60,
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: OnboardingColors.primaryGreen,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Dual Wheel Pickers (Hour & Minute)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 108,
                      child: ListWheelScrollView.useDelegate(
                        controller: _hourWheelController,
                        itemExtent: 54,
                        perspective: 0.002,
                        diameterRatio: 1.8,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (h) {
                          notifier.setReminderTime(h, setup.reminderMinute);
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 24,
                          builder: (context, index) {
                            final dist = (index - setup.reminderHour).abs();
                            final isSelected = dist == 0;
                            return Center(
                              child: Text(
                                index.toString().padLeft(2, '0'),
                                style: AppTypography.displayLarge.copyWith(
                                  fontSize: isSelected
                                      ? 34
                                      : dist == 1
                                          ? 24
                                          : dist == 2
                                              ? 19
                                              : 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? OnboardingColors.primaryGreen
                                      : OnboardingColors.textDark.withValues(
                                          alpha: dist == 1
                                              ? 0.85
                                              : dist == 2
                                                  ? 0.55
                                                  : 0.3,
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    SizedBox(
                      width: 108,
                      child: ListWheelScrollView.useDelegate(
                        controller: _minuteWheelController,
                        itemExtent: 54,
                        perspective: 0.002,
                        diameterRatio: 1.8,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (m) {
                          notifier.setReminderTime(setup.reminderHour, m);
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 60,
                          builder: (context, index) {
                            final dist = (index - setup.reminderMinute).abs();
                            final isSelected = dist == 0;
                            return Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    index.toString().padLeft(2, '0'),
                                    style: AppTypography.displayLarge.copyWith(
                                      fontSize: isSelected
                                          ? 34
                                          : dist == 1
                                              ? 24
                                              : dist == 2
                                                  ? 19
                                                  : 15,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? OnboardingColors.primaryGreen
                                          : OnboardingColors.textDark.withValues(
                                              alpha: dist == 1
                                                  ? 0.85
                                                  : dist == 2
                                                      ? 0.55
                                                      : 0.3,
                                            ),
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 5),
                                    Text(
                                      period,
                                      style: AppTypography.bodyMedium.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: OnboardingColors.textDark,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You can always change this later.',
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13,
              color: OnboardingColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 8 / 8: How did you hear about MoodCanvas?
  // ---------------------------------------------------------------------------
  Widget _buildReferralSourceStep(AccountSetupState setup) {
    final notifier = ref.read(accountSetupProvider.notifier);

    final options = [
      (
        label: 'Social Media',
        icon: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF58529), Color(0xFFDD2A7B), Color(0xFF8134AF)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.tag_rounded, color: Colors.white, size: 20),
        ),
      ),
      (
        label: 'Google Search',
        icon: const SizedBox(
          width: 34,
          height: 34,
          child: Center(child: GoogleLogoIcon(size: 24)),
        ),
      ),
      (
        label: 'YouTube',
        icon: Container(
          width: 34,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFFF0000),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
        ),
      ),
      (
        label: 'App Store',
        icon: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFF0D84FF),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(Icons.apps_rounded, color: Colors.white, size: 20),
        ),
      ),
      (
        label: 'Friends / Family',
        icon: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.people_alt_rounded,
            color: Color(0xFFFF9800),
            size: 20,
          ),
        ),
      ),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
          child: _buildStepHeader(
            'Lastly, how did you hear\nabout MoodCanvas?',
            "We'd love to know how you found us.",
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 6, 24, 16),
            itemCount: options.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final opt = options[index];
              final isSelected = setup.referralSource == opt.label;

              return GestureDetector(
                onTap: () => notifier.setReferralSource(opt.label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: OnboardingColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? OnboardingColors.primaryGreen
                          : OnboardingColors.borderLight,
                      width: isSelected ? 1.6 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      opt.icon,
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          opt.label,
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                            color: OnboardingColors.textDark,
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: isSelected ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 150),
                        child: const Icon(
                          Icons.check_rounded,
                          color: OnboardingColors.primaryGreen,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GenderCircleOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderCircleOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected
                  ? OnboardingColors.primaryGreen
                  : OnboardingColors.white,
              border: Border.all(
                color: selected
                    ? OnboardingColors.primaryGreen
                    : OnboardingColors.borderLight,
                width: 1.4,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: OnboardingColors.primaryGreen.withValues(alpha: 0.28),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              size: 46,
              color: selected ? Colors.white : OnboardingColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            label,
            style: AppTypography.titleMedium.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: selected
                  ? OnboardingColors.primaryGreen
                  : OnboardingColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

enum _EmojiThemeStyle {
  classic,
  kawaii,
  pumpkin,
  minimal,
  outlined,
  square,
  blush,
  pastel,
}

class _ThemeMoodFace extends StatelessWidget {
  final _EmojiThemeStyle style;
  final int moodIndex; // 0..4
  final double size;

  const _ThemeMoodFace({
    required this.style,
    required this.moodIndex,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    BorderRadius? radius;
    bool outlined = false;
    bool blush = false;

    switch (style) {
      case _EmojiThemeStyle.classic:
        bg = moodColorPalettes[0][moodIndex];
        break;
      case _EmojiThemeStyle.kawaii:
        bg = const Color(0xFFFFF5F5);
        outlined = true;
        blush = true;
        break;
      case _EmojiThemeStyle.pumpkin:
        bg = const Color(0xFFFF9800);
        break;
      case _EmojiThemeStyle.minimal:
        bg = const Color(0xFFFFCA28);
        break;
      case _EmojiThemeStyle.outlined:
        bg = moodIndex == 0
            ? const Color(0xFFEF5350)
            : const Color(0xFFFFD54F);
        outlined = true;
        break;
      case _EmojiThemeStyle.square:
        bg = const [
          Color(0xFFFF7043),
          Color(0xFF90A4AE),
          Color(0xFF5C85B8),
          Color(0xFFFFCA28),
          Color(0xFF9CCC65),
        ][moodIndex];
        radius = BorderRadius.circular(10);
        break;
      case _EmojiThemeStyle.blush:
        bg = const [
          Color(0xFFEF5350),
          Color(0xFFFFB74D),
          Color(0xFFFFD54F),
          Color(0xFFFFCA28),
          Color(0xFFFFB300),
        ][moodIndex];
        blush = true;
        break;
      case _EmojiThemeStyle.pastel:
        bg = moodColorPalettes[1][moodIndex];
        blush = true;
        break;
    }

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _StyledMoodFacePainter(
          bgColor: bg,
          moodIndex: moodIndex,
          borderRadius: radius,
          outlined: outlined,
          blush: blush,
          isPumpkin: style == _EmojiThemeStyle.pumpkin,
        ),
      ),
    );
  }
}

class _PalettePreviewFace extends StatelessWidget {
  final Color color;
  final int moodIndex;
  final double size;

  const _PalettePreviewFace({
    required this.color,
    required this.moodIndex,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _StyledMoodFacePainter(
          bgColor: color,
          moodIndex: moodIndex,
        ),
      ),
    );
  }
}

class _StyledMoodFacePainter extends CustomPainter {
  final Color bgColor;
  final int moodIndex;
  final BorderRadius? borderRadius;
  final bool outlined;
  final bool blush;
  final bool isPumpkin;

  _StyledMoodFacePainter({
    required this.bgColor,
    required this.moodIndex,
    this.borderRadius,
    this.outlined = false,
    this.blush = false,
    this.isPumpkin = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    final fillPaint = Paint()
      ..color = bgColor
      ..isAntiAlias = true;

    if (borderRadius != null) {
      final rrect = borderRadius!.toRRect(Offset.zero & size);
      canvas.drawRRect(rrect, fillPaint);
    } else {
      canvas.drawCircle(center, r * (isPumpkin ? 0.88 : 0.96), fillPaint);
    }

    if (isPumpkin) {
      // Tiny green stem on top
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(center.dx, r * 0.14),
            width: r * 0.24,
            height: r * 0.24,
          ),
          const Radius.circular(3),
        ),
        Paint()..color = OnboardingColors.primaryGreenDark,
      );
    }

    if (outlined) {
      canvas.drawCircle(
        center,
        r * 0.92,
        Paint()
          ..color = const Color(0xFF4B5563)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..isAntiAlias = true,
      );
    }

    if (blush) {
      final blushPaint = Paint()
        ..color = const Color(0xFFFF8A80).withValues(alpha: 0.45)
        ..isAntiAlias = true;
      canvas.drawCircle(
        Offset(center.dx - r * 0.46, center.dy + r * 0.08),
        r * 0.16,
        blushPaint,
      );
      canvas.drawCircle(
        Offset(center.dx + r * 0.46, center.dy + r * 0.08),
        r * 0.16,
        blushPaint,
      );
    }

    const ink = Color(0xFF2B2B2B);
    final eyePaint = Paint()
      ..color = ink
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final eyeY = center.dy - r * 0.14;
    final eyeR = r * 0.11;
    canvas.drawCircle(Offset(center.dx - r * 0.28, eyeY), eyeR, eyePaint);
    canvas.drawCircle(Offset(center.dx + r * 0.28, eyeY), eyeR, eyePaint);

    final mouthPaint = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.12
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    if (moodIndex == 0) {
      path.moveTo(center.dx - r * 0.30, center.dy + r * 0.38);
      path.quadraticBezierTo(
        center.dx,
        center.dy + r * 0.08,
        center.dx + r * 0.30,
        center.dy + r * 0.38,
      );
    } else if (moodIndex == 1) {
      path.moveTo(center.dx - r * 0.28, center.dy + r * 0.32);
      path.quadraticBezierTo(
        center.dx,
        center.dy + r * 0.16,
        center.dx + r * 0.28,
        center.dy + r * 0.32,
      );
    } else if (moodIndex == 2) {
      path.moveTo(center.dx - r * 0.26, center.dy + r * 0.24);
      path.lineTo(center.dx + r * 0.26, center.dy + r * 0.24);
    } else if (moodIndex == 3) {
      path.moveTo(center.dx - r * 0.28, center.dy + r * 0.18);
      path.quadraticBezierTo(
        center.dx,
        center.dy + r * 0.42,
        center.dx + r * 0.28,
        center.dy + r * 0.18,
      );
    } else {
      path.moveTo(center.dx - r * 0.34, center.dy + r * 0.14);
      path.quadraticBezierTo(
        center.dx,
        center.dy + r * 0.50,
        center.dx + r * 0.34,
        center.dy + r * 0.14,
      );
    }
    canvas.drawPath(path, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant _StyledMoodFacePainter oldDelegate) {
    return oldDelegate.bgColor != bgColor || oldDelegate.moodIndex != moodIndex;
  }
}
