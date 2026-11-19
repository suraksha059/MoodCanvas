import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/presentation/providers/daily_capture_provider.dart';

/// Step 4 of Daily Capture: Personal Journal Entry.
class JournalEntryStep extends ConsumerStatefulWidget {
  const JournalEntryStep({super.key});

  @override
  ConsumerState<JournalEntryStep> createState() => _JournalEntryStepState();
}

class _JournalEntryStepState extends ConsumerState<JournalEntryStep> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    final initialText = ref.read(dailyCaptureProvider).journal;
    _textController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  int _countWords(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }

  @override
  Widget build(BuildContext context) {
    final captureState = ref.watch(dailyCaptureProvider);
    final notifier = ref.read(dailyCaptureProvider.notifier);

    final charCount = captureState.journal.length;
    final wordCount = _countWords(captureState.journal);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What happened today?',
            style: AppTypography.displayLarge.copyWith(
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A single word, a fleeting conversation, or a whole story. (Optional)',
            style: AppTypography.bodyLarge,
          ),

          const SizedBox(height: 24),

          // Journal Parchment Container
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.borderSubtle),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _textController,
                  maxLines: 8,
                  minLines: 5,
                  cursorColor: AppColors.amberWarmth,
                  style: AppTypography.journal.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write whatever comes to mind...',
                    hintStyle: AppTypography.journal.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (text) => notifier.setJournal(text),
                ),

                const SizedBox(height: 16),

                const Divider(color: AppColors.borderSubtle, height: 1),

                const SizedBox(height: 12),

                // Character & Word count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.edit_note_rounded,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$wordCount ${wordCount == 1 ? "word" : "words"}',
                          style: AppTypography.label.copyWith(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$charCount characters',
                      style: AppTypography.label.copyWith(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
