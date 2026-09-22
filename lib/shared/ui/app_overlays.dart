import 'package:flutter/material.dart';

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) => ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.82,
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 24 + MediaQuery.viewInsetsOf(sheetContext).bottom,
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
    ..showSnackBar(SnackBar(content: Text(message)));
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
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: actions.map((action) {
        void onPressed() => Navigator.of(dialogContext).pop(action.value);
        return action.primary
            ? FilledButton(onPressed: onPressed, child: Text(action.label))
            : TextButton(onPressed: onPressed, child: Text(action.label));
      }).toList(),
    ),
  );
}

void closeAppOverlay<T>(BuildContext overlayContext, [T? result]) {
  Navigator.of(overlayContext).pop(result);
}
