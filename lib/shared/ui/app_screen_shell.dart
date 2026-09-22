import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../app/app_tokens.dart';

enum AppScreenTone { surface, brand }

class AppScreenShell extends StatelessWidget {
  const AppScreenShell({
    super.key,
    required this.body,
    this.title,
    this.actions = const [],
    this.scrollable = false,
    this.maxWidth = AppConstraints.contentMaxWidth,
    this.padding = const EdgeInsets.fromLTRB(22, 18, 22, 28),
    this.bottomNavigationBar,
    this.centerTitle = false,
    this.tone = AppScreenTone.surface,
  });

  final Widget body;
  final String? title;
  final List<Widget> actions;
  final bool scrollable;
  final double maxWidth;
  final EdgeInsets padding;
  final Widget? bottomNavigationBar;
  final bool centerTitle;
  final AppScreenTone tone;

  @override
  Widget build(BuildContext context) {
    final isBrand = tone == AppScreenTone.brand;
    final content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: scrollable
            ? Scrollbar(
                child: CustomScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverPadding(
                      padding: padding,
                      sliver: SliverToBoxAdapter(child: body),
                    ),
                  ],
                ),
              )
            : Padding(padding: padding, child: body),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: false,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              centerTitle: centerTitle,
              actions: actions,
              backgroundColor: isBrand ? AppColors.brandTop : AppColors.surface,
              foregroundColor: isBrand ? Colors.white : AppColors.ink,
            ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: isBrand ? null : AppColors.surface,
          gradient: isBrand
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.brandTop, AppColors.brandBottom],
                )
              : null,
        ),
        child: SafeArea(top: title == null, child: content),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
