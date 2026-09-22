import 'package:flutter/material.dart';

class AppAsyncView<T> extends StatelessWidget {
  const AppAsyncView({
    super.key,
    required this.future,
    required this.dataBuilder,
    this.isEmpty,
    this.emptyBuilder,
    this.errorBuilder,
  });

  final Future<T> future;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final bool Function(T data)? isEmpty;
  final WidgetBuilder? emptyBuilder;
  final WidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return errorBuilder?.call(context) ?? const Center(child: Icon(Icons.error_outline_rounded));
        }
        final data = snapshot.data as T;
        if (isEmpty?.call(data) ?? false) {
          return emptyBuilder?.call(context) ?? const SizedBox.shrink();
        }
        return dataBuilder(context, data);
      },
    );
  }
}

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel,
  });

  final VoidCallback? onRetry;
  final String message;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 42),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null && retryLabel != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(retryLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
