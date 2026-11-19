import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../app/app_tokens.dart';

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    barrierColor: AppColors.ink.withValues(alpha: 0.42),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadii.extraLarge),
      ),
    ),
    builder:
        (sheetContext) => ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 640,
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.82,
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              left: AppSpacing.xl,
              right: AppSpacing.xl,
              bottom:
                  AppSpacing.xl + MediaQuery.viewInsetsOf(sheetContext).bottom,
            ),
            child: builder(sheetContext),
          ),
        ),
  );
}

void showAppNotice(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.medium),
        ),
        content: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Colors.white),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}

class AppDialogAction<T> {
  const AppDialogAction({
    required this.label,
    required this.value,
    this.primary = false,
  });

  final String label;
  final T value;
  final bool primary;
}

Future<T?> showAppActionDialog<T>({
  required BuildContext context,
  required String title,
  required String message,
  required List<AppDialogAction<T>> actions,
}) {
  return showDialog<T>(
    context: context,
    builder:
        (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.large),
          ),
          title: Text(title),
          content: Text(message),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          actions:
              actions.map((action) {
                void onPressed() =>
                    Navigator.of(dialogContext).pop(action.value);
                return action.primary
                    ? FilledButton(
                      onPressed: onPressed,
                      child: Text(action.label),
                    )
                    : TextButton(
                      onPressed: onPressed,
                      child: Text(action.label),
                    );
              }).toList(),
        ),
  );
}

Future<void> showAppInformationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String closeLabel,
}) {
  return showDialog<void>(
    context: context,
    builder:
        (dialogContext) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: Text(message)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(closeLabel),
            ),
          ],
        ),
  );
}

void closeAppOverlay<T>(BuildContext overlayContext, [T? result]) {
  Navigator.of(overlayContext).pop(result);
}
