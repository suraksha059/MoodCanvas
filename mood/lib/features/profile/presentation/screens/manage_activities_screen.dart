import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';
import '../providers/manage_activities_provider.dart';
import 'select_activity_emoji_screen.dart';

// =============================================================================
// 80_Light - 85_Light: Manage Activities Screen
// =============================================================================
class ManageActivitiesScreen extends ConsumerWidget {
  const ManageActivitiesScreen({super.key});

  Future<void> _showGroupNameSheet(
    BuildContext context,
    WidgetRef ref, {
    ActivityGroupModel? editingGroup,
  }) async {
    final controller =
        TextEditingController(text: editingGroup?.name ?? '');
    final isRename = editingGroup != null;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(ctx).bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: OnboardingColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        isRename ? 'Rename Group' : 'Add New Group',
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFEEEEEE), height: 1),
                    const SizedBox(height: 18),
                    Text(
                      'Group Name',
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      style: AppTypography.bodyLarge.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: OnboardingColors.textDark,
                      ),
                      cursorColor: OnboardingColors.primaryGreen,
                      decoration: InputDecoration(
                        hintText: 'e.g. Shopping',
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: OnboardingColors.textLight,
                        ),
                        filled: true,
                        fillColor: OnboardingColors.backgroundLight,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: OnboardingColors.primaryGreen,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              style: TextButton.styleFrom(
                                backgroundColor: OnboardingColors.softGreenBg,
                                foregroundColor: OnboardingColors.primaryGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: AppTypography.button.copyWith(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: OnboardingColors.primaryGreen,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                final text = controller.text.trim();
                                if (text.isNotEmpty) {
                                  final notifier = ref
                                      .read(manageActivitiesProvider.notifier);
                                  if (isRename) {
                                    notifier.renameGroup(editingGroup.id, text);
                                  } else {
                                    notifier.addGroup(text);
                                  }
                                }
                                Navigator.of(ctx).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: OnboardingColors.primaryGreen,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                              child: Text(
                                'Save',
                                style: AppTypography.button.copyWith(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteGroupSheet(
    BuildContext context,
    WidgetRef ref,
    ActivityGroupModel group,
  ) async {
    await showModalBottomSheet<void>(
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
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Delete Group "${group.name}"',
                    textAlign: TextAlign.center,
                    style: AppTypography.titleLarge.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: OnboardingColors.moodRed,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFEEEEEE), height: 1),
                  const SizedBox(height: 18),
                  Text(
                    'Sure you want to delete this group?',
                    textAlign: TextAlign.center,
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: OnboardingColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Deleting group will remove all activities (${group.activities.length}) within. This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 13.5,
                      height: 1.5,
                      color: OnboardingColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            style: TextButton.styleFrom(
                              backgroundColor: OnboardingColors.softGreenBg,
                              foregroundColor: OnboardingColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: AppTypography.button.copyWith(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: OnboardingColors.primaryGreen,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(manageActivitiesProvider.notifier)
                                  .deleteGroup(group.id);
                              Navigator.of(ctx).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: OnboardingColors.primaryGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: Text(
                              'Yes, Delete',
                              style: AppTypography.button.copyWith(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openGroupDetail(BuildContext context, String groupId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ActivityGroupDetailScreen(groupId: groupId),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(manageActivitiesProvider);
    final notifier = ref.read(manageActivitiesProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar: Back | "Manage Activities" | +
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
                        'Manage Activities',
                        textAlign: TextAlign.center,
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showGroupNameSheet(context, ref),
                      icon: const Icon(
                        Icons.add_rounded,
                        size: 26,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              // Reorderable Groups Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: OnboardingColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: OnboardingColors.borderLight
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Expanded(
                          child: ReorderableListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            itemCount: groups.length,
                            onReorder: notifier.reorderGroups,
                            itemBuilder: (context, index) {
                              final group = groups[index];
                              return Column(
                                key: ValueKey(group.id),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        _openGroupDetail(context, group.id),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 11,
                                      ),
                                      child: Row(
                                        children: [
                                          ReorderableDragStartListener(
                                            index: index,
                                            child: const Padding(
                                              padding: EdgeInsets.only(right: 8),
                                              child: Icon(
                                                Icons.drag_indicator_rounded,
                                                size: 18,
                                                color: OnboardingColors.textLight,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                notifier.toggleGroup(group.id),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 160),
                                              width: 21,
                                              height: 21,
                                              decoration: BoxDecoration(
                                                color: group.enabled
                                                    ? OnboardingColors
                                                        .primaryGreen
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: group.enabled
                                                      ? OnboardingColors
                                                          .primaryGreen
                                                      : OnboardingColors
                                                          .textLight,
                                                  width: 1.6,
                                                ),
                                              ),
                                              child: group.enabled
                                                  ? const Icon(
                                                      Icons.check_rounded,
                                                      size: 14,
                                                      color: Colors.white,
                                                    )
                                                  : null,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              '${group.name} (${group.activities.length})',
                                              style: AppTypography.titleMedium
                                                  .copyWith(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    OnboardingColors.textDark,
                                              ),
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            color: OnboardingColors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            icon: const Icon(
                                              Icons.more_vert_rounded,
                                              size: 20,
                                              color: OnboardingColors.textDark,
                                            ),
                                            onSelected: (value) {
                                              if (value == 'edit') {
                                                _openGroupDetail(
                                                    context, group.id);
                                              } else if (value == 'rename') {
                                                _showGroupNameSheet(
                                                  context,
                                                  ref,
                                                  editingGroup: group,
                                                );
                                              } else if (value == 'delete') {
                                                _showDeleteGroupSheet(
                                                    context, ref, group);
                                              }
                                            },
                                            itemBuilder: (_) => const [
                                              PopupMenuItem(
                                                value: 'edit',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit_outlined,
                                                        size: 18,
                                                        color: OnboardingColors
                                                            .textDark),
                                                    SizedBox(width: 10),
                                                    Text('Edit',
                                                        style: TextStyle(
                                                            color:
                                                                OnboardingColors
                                                                    .textDark)),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 'rename',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .drive_file_rename_outline,
                                                        size: 18,
                                                        color: OnboardingColors
                                                            .textDark),
                                                    SizedBox(width: 10),
                                                    Text('Rename',
                                                        style: TextStyle(
                                                            color:
                                                                OnboardingColors
                                                                    .textDark)),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        size: 18,
                                                        color: OnboardingColors
                                                            .moodRed),
                                                    SizedBox(width: 10),
                                                    Text('Delete',
                                                        style: TextStyle(
                                                            color:
                                                                OnboardingColors
                                                                    .moodRed)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (index < groups.length - 1)
                                    const Divider(
                                      color: Color(0xFFF3F4F6),
                                      height: 1,
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Tap check to enable activity in the log',
                            style: AppTypography.label.copyWith(
                              fontSize: 11.5,
                              color: OnboardingColors.textLight,
                              fontWeight: FontWeight.w400,
                            ),
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
      ),
    );
  }
}

// =============================================================================
// 86_Light - 94_Light: Activity Group Detail Screen (e.g. "Work (8)")
// =============================================================================
class ActivityGroupDetailScreen extends ConsumerWidget {
  final String groupId;

  const ActivityGroupDetailScreen({
    super.key,
    required this.groupId,
  });

  Future<void> _showActivitySheet(
    BuildContext context,
    WidgetRef ref, {
    ActivityItemModel? editingActivity,
  }) async {
    final isEdit = editingActivity != null;
    final nameController =
        TextEditingController(text: editingActivity?.name ?? '');
    String selectedEmoji = editingActivity?.emoji ?? '';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.viewInsetsOf(ctx).bottom,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: OnboardingColors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E7EB),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            isEdit ? 'Edit Activity' : 'Add New Activity',
                            style: AppTypography.titleLarge.copyWith(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFEEEEEE), height: 1),
                        const SizedBox(height: 20),

                        // Circular Emoji Picker Button (87_Light / 90_Light / 93_Light)
                        Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final picked = await Navigator.of(context)
                                      .push<String>(
                                    MaterialPageRoute<String>(
                                      builder: (_) =>
                                          const SelectActivityEmojiScreen(),
                                    ),
                                  );
                                  if (picked != null) {
                                    setModalState(() => selectedEmoji = picked);
                                  }
                                },
                                child: Container(
                                  width: 68,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: OnboardingColors.white,
                                    border: Border.all(
                                      color: OnboardingColors.borderLight,
                                      width: 1.3,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: selectedEmoji.isEmpty
                                      ? const Icon(
                                          Icons.add_rounded,
                                          size: 28,
                                          color: OnboardingColors.textDark,
                                        )
                                      : Text(
                                          selectedEmoji,
                                          style: const TextStyle(fontSize: 32),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Activity Emoji',
                                style: AppTypography.label.copyWith(
                                  fontSize: 12,
                                  color: OnboardingColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),
                        Text(
                          'Activity Name',
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: OnboardingColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: nameController,
                          textCapitalization: TextCapitalization.words,
                          style: AppTypography.bodyLarge.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: OnboardingColors.textDark,
                          ),
                          cursorColor: OnboardingColors.primaryGreen,
                          decoration: InputDecoration(
                            hintText: 'Enter Name...',
                            hintStyle: AppTypography.bodyMedium.copyWith(
                              color: OnboardingColors.textLight,
                            ),
                            filled: true,
                            fillColor: OnboardingColors.backgroundLight,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: OnboardingColors.primaryGreen,
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),

                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        OnboardingColors.softGreenBg,
                                    foregroundColor:
                                        OnboardingColors.primaryGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: AppTypography.button.copyWith(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      color: OnboardingColors.primaryGreen,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final name = nameController.text.trim();
                                    if (name.isNotEmpty) {
                                      final notifier = ref.read(
                                          manageActivitiesProvider.notifier);
                                      if (isEdit) {
                                        notifier.editActivity(
                                          groupId,
                                          editingActivity.id,
                                          selectedEmoji.isEmpty
                                              ? editingActivity.emoji
                                              : selectedEmoji,
                                          name,
                                        );
                                      } else {
                                        notifier.addActivity(
                                          groupId,
                                          selectedEmoji,
                                          name,
                                        );
                                      }
                                    }
                                    Navigator.of(ctx).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        OnboardingColors.primaryGreen,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                  ),
                                  child: Text(
                                    'Save',
                                    style: AppTypography.button.copyWith(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showDeleteActivitySheet(
    BuildContext context,
    WidgetRef ref,
    ActivityItemModel activity,
  ) async {
    await showModalBottomSheet<void>(
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
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Delete Activity "${activity.name}"',
                    textAlign: TextAlign.center,
                    style: AppTypography.titleLarge.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: OnboardingColors.moodRed,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFEEEEEE), height: 1),
                  const SizedBox(height: 18),
                  Text(
                    'Sure you want to delete this activity?',
                    textAlign: TextAlign.center,
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: OnboardingColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Deleting activity will remove it from all associated logs. This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 13.5,
                      height: 1.5,
                      color: OnboardingColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            style: TextButton.styleFrom(
                              backgroundColor: OnboardingColors.softGreenBg,
                              foregroundColor: OnboardingColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: AppTypography.button.copyWith(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: OnboardingColors.primaryGreen,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(manageActivitiesProvider.notifier)
                                  .deleteActivity(groupId, activity.id);
                              Navigator.of(ctx).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: OnboardingColors.primaryGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: Text(
                              'Yes, Delete',
                              style: AppTypography.button.copyWith(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(manageActivitiesProvider);
    final group = groups.firstWhere(
      (g) => g.id == groupId,
      orElse: () => const ActivityGroupModel(
        id: '',
        name: 'Group',
        enabled: true,
        activities: [],
      ),
    );
    final notifier = ref.read(manageActivitiesProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar: Back | "Work (8)" | +
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
                        '${group.name} (${group.activities.length})',
                        textAlign: TextAlign.center,
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showActivitySheet(context, ref),
                      icon: const Icon(
                        Icons.add_rounded,
                        size: 26,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                  child: group.activities.isEmpty
                      ? Center(
                          child: Text(
                            'Tap + to add your first activity in ${group.name}.',
                            style: AppTypography.bodyMedium.copyWith(
                              color: OnboardingColors.textMuted,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: OnboardingColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: OnboardingColors.borderLight
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ReorderableListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            itemCount: group.activities.length,
                            onReorder: (oldIndex, newIndex) =>
                                notifier.reorderActivities(
                                    groupId, oldIndex, newIndex),
                            itemBuilder: (context, index) {
                              final activity = group.activities[index];
                              return Column(
                                key: ValueKey(activity.id),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 11,
                                    ),
                                    child: Row(
                                      children: [
                                        ReorderableDragStartListener(
                                          index: index,
                                          child: const Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.drag_indicator_rounded,
                                              size: 18,
                                              color: OnboardingColors.textLight,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          activity.emoji,
                                          style: const TextStyle(fontSize: 22),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            activity.name,
                                            style: AppTypography.titleMedium
                                                .copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: OnboardingColors.textDark,
                                            ),
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          color: OnboardingColors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          icon: const Icon(
                                            Icons.more_vert_rounded,
                                            size: 20,
                                            color: OnboardingColors.textDark,
                                          ),
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _showActivitySheet(
                                                context,
                                                ref,
                                                editingActivity: activity,
                                              );
                                            } else if (value == 'delete') {
                                              _showDeleteActivitySheet(
                                                context,
                                                ref,
                                                activity,
                                              );
                                            }
                                          },
                                          itemBuilder: (_) => const [
                                            PopupMenuItem(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit_outlined,
                                                      size: 18,
                                                      color: OnboardingColors
                                                          .textDark),
                                                  SizedBox(width: 10),
                                                  Text('Edit',
                                                      style: TextStyle(
                                                          color:
                                                              OnboardingColors
                                                                  .textDark)),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .delete_outline_rounded,
                                                      size: 18,
                                                      color: OnboardingColors
                                                          .moodRed),
                                                  SizedBox(width: 10),
                                                  Text('Delete',
                                                      style: TextStyle(
                                                          color:
                                                              OnboardingColors
                                                                  .moodRed)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (index < group.activities.length - 1)
                                    const Divider(
                                      color: Color(0xFFF3F4F6),
                                      height: 1,
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                ],
                              );
                            },
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
