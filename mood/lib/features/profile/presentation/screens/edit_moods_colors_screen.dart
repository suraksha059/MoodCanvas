import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/presentation/widgets/mood_log_card.dart';
import '../../../onboarding/presentation/providers/account_setup_provider.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

// =============================================================================
// 74_Light & 77_Light: Edit Moods & Colors
// =============================================================================
class EditMoodsColorsScreen extends ConsumerStatefulWidget {
  const EditMoodsColorsScreen({super.key});

  @override
  ConsumerState<EditMoodsColorsScreen> createState() =>
      _EditMoodsColorsScreenState();
}

class _EditMoodsColorsScreenState extends ConsumerState<EditMoodsColorsScreen> {
  late int _selectedPresetIndex;
  List<Color>? _customPalette;
  bool _usingCustom = false;

  @override
  void initState() {
    super.initState();
    _selectedPresetIndex = ref.read(accountSetupProvider).colorPaletteIndex;
  }

  List<Color> get _activeColors =>
      _usingCustom && _customPalette != null
          ? _customPalette!
          : moodColorPalettes[_selectedPresetIndex];

  Future<void> _openCustomColorPicker() async {
    final result = await Navigator.of(context).push<List<Color>>(
      MaterialPageRoute<List<Color>>(
        builder: (_) => CustomMoodColorsScreen(
          initialColors: List<Color>.from(_activeColors),
        ),
      ),
    );

    if (result != null && result.length == 5 && mounted) {
      setState(() {
        _customPalette = result;
        _usingCustom = true;
      });
    }
  }

  void _save() {
    if (!_usingCustom) {
      ref
          .read(accountSetupProvider.notifier)
          .setColorPalette(_selectedPresetIndex);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final activeColors = _activeColors;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
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
                        'Edit Moods & Colors',
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

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    // Top Live 5-Mood Preview Card with Green Pencil Badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: OnboardingColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: OnboardingColors.borderLight
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(5, (i) {
                              return HomeMoodFace(
                                color: activeColors[i],
                                moodLevel: i,
                                size: 46,
                              );
                            }),
                          ),
                        ),
                        Positioned(
                          top: -6,
                          right: -6,
                          child: GestureDetector(
                            onTap: _openCustomColorPicker,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: OnboardingColors.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                size: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // "Custom Mood Colors" button (74_Light) OR Saved Custom Palette Card (77_Light)
                    if (_customPalette == null)
                      GestureDetector(
                        onTap: _openCustomColorPicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: OnboardingColors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: OnboardingColors.borderLight
                                  .withValues(alpha: 0.8),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Custom Mood Colors',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                        ),
                      )
                    else
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _usingCustom = true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: OnboardingColors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _usingCustom
                                      ? OnboardingColors.primaryGreen
                                      : OnboardingColors.borderLight,
                                  width: _usingCustom ? 1.8 : 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: _customPalette!.map((c) {
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
                          Positioned(
                            top: -6,
                            right: -6,
                            child: GestureDetector(
                              onTap: _openCustomColorPicker,
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: OnboardingColors.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    // Preset Palette Cards
                    ...List.generate(moodColorPalettes.length, (index) {
                      final palette = moodColorPalettes[index];
                      final isSelected =
                          !_usingCustom && _selectedPresetIndex == index;
                      final isPremium = index == moodColorPalettes.length - 1;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () => setState(() {
                                _usingCustom = false;
                                _selectedPresetIndex = index;
                              }),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: OnboardingColors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? OnboardingColors.primaryGreen
                                        : OnboardingColors.borderLight
                                            .withValues(alpha: 0.7),
                                    width: isSelected ? 1.8 : 1.0,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Bottom Save Button
              Container(
                color: OnboardingColors.white,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnboardingColors.primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'Save',
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
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 75_Light & 76_Light: Custom Mood Colors Picker
// =============================================================================
class CustomMoodColorsScreen extends StatefulWidget {
  final List<Color> initialColors;

  const CustomMoodColorsScreen({
    super.key,
    required this.initialColors,
  });

  @override
  State<CustomMoodColorsScreen> createState() => _CustomMoodColorsScreenState();
}

class _CustomMoodColorsScreenState extends State<CustomMoodColorsScreen> {
  late List<Color> _colors;
  int _activeMoodSlot = 2;

  static const List<List<Color>> _swatchRows = [
    [Color(0xFFEF9A9A), Color(0xFFE57373), Color(0xFFEF5350), Color(0xFFF44336), Color(0xFFE53935)],
    [Color(0xFFF48FB1), Color(0xFFF06292), Color(0xFFEC407A), Color(0xFFE91E63), Color(0xFFD81B60)],
    [Color(0xFFCE93D8), Color(0xFFBA68C8), Color(0xFFAB47BC), Color(0xFF9C27B0), Color(0xFF8E24AA)],
    [Color(0xFF90CAF9), Color(0xFF64B5F6), Color(0xFF42A5F5), Color(0xFF2196F3), Color(0xFF1E88E5)],
    [Color(0xFF80DEEA), Color(0xFF4DD0E1), Color(0xFF26C6DA), Color(0xFF00BCD4), Color(0xFF00ACC1)],
    [Color(0xFF80CBC4), Color(0xFF4DB6AC), Color(0xFF26A69A), Color(0xFF009688), Color(0xFF00897B)],
    [Color(0xFFA5D6A7), Color(0xFF81C784), Color(0xFF66BB6A), Color(0xFF4CAF50), Color(0xFF43A047)],
    [Color(0xFFC5E1A5), Color(0xFFAED581), Color(0xFF9CCC65), Color(0xFF8BC34A), Color(0xFF7CB342)],
  ];

  @override
  void initState() {
    super.initState();
    _colors = List<Color>.from(widget.initialColors);
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _colors[_activeMoodSlot];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar: X | "Custom Mood Colors"
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 24,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Custom Mood Colors',
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

              // Top 5 Selectable Mood Faces
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    final isSelected = _activeMoodSlot == index;
                    return GestureDetector(
                      onTap: () => setState(() => _activeMoodSlot = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? OnboardingColors.primaryGreen
                                : Colors.transparent,
                            width: 2.2,
                          ),
                        ),
                        child: HomeMoodFace(
                          color: _colors[index],
                          moodLevel: index,
                          size: 46,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // 8 x 5 Color Swatch Grid
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                  child: Column(
                    children: _swatchRows.map((row) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: row.map((swatch) {
                            final isCurrent = swatch.toARGB32() ==
                                activeColor.toARGB32();
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _colors[_activeMoodSlot] = swatch;
                                });
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: swatch,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: isCurrent
                                    ? Container(
                                        width: 24,
                                        height: 24,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Bottom OK CTA
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(_colors),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnboardingColors.primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'OK',
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
          ),
        ),
      ),
    );
  }
}
