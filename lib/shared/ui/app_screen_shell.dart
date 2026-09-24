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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child:
            scrollable
                ? Scrollbar(
                  radius: const Radius.circular(AppRadii.pill),
                  child: CustomScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
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
      appBar:
          title == null
              ? null
              : AppBar(
                title: Text(title!),
                centerTitle: centerTitle,
                actions: actions,
                backgroundColor: isBrand ? AppColors.brandTop : scheme.surface,
                foregroundColor: isBrand ? Colors.white : scheme.onSurface,
              ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: isBrand ? null : scheme.surface,
          gradient:
              isBrand
                  ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.brandTop,
                      AppColors.brandDeep,
                      AppColors.brandBottom,
                    ],
                  )
                  : null,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isBrand) ...[
              Positioned(
                top: -160,
                right: -100,
                child: IgnorePointer(
                  child: Container(
                    width: 310,
                    height: 310,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.055),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.10),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -118,
                bottom: -178,
                child: IgnorePointer(
                  child: Container(
                    width: 310,
                    height: 310,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.brandHighlight.withValues(alpha: 0.12),
                    ),
                  ),
                ),
              ),
            ],
            SafeArea(top: title == null, child: content),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
