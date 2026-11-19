import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/app_tokens.dart';
import '../../../../core/feedback/motion_tokens.dart';
import '../../../../core/game/game_models.dart';

class MatchPlayerBar extends StatelessWidget {
  const MatchPlayerBar({
    super.key,
    required this.name,
    required this.side,
    required this.active,
    required this.stonesOnBoard,
    required this.stonesToPlace,
    this.rating,
    this.thinking = false,
    this.thinkingLabel,
    this.reduceMotion = false,
    this.compact = false,
  });

  final String name;
  final PlayerSide side;
  final bool active;
  final int stonesOnBoard;
  final int stonesToPlace;
  final int? rating;
  final bool thinking;
  final String? thinkingLabel;
  final bool reduceMotion;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 58 : 86,
      child: AnimatedContainer(
        duration: reduceMotion ? Duration.zero : MotionTokens.normal,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 9 : 12,
          vertical: compact ? 4 : 8,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.brandSoft : Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.medium),
          border: Border.all(
            color: active ? AppColors.brandDeep : AppColors.line,
            width: compact ? 1.5 : (active ? 1.6 : 1),
          ),
          boxShadow:
              active
                  ? [
                    BoxShadow(
                      color: AppColors.brandDeep.withValues(alpha: 0.11),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ]
                  : const <BoxShadow>[],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _StoneAvatar(side: side, diameter: compact ? 32 : 38),
            SizedBox(width: compact ? 7 : AppSpacing.sm),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    compact
                        ? [
                          // The glow is painted inside a permanently reserved
                          // name box. A turn change only changes decoration;
                          // it never inserts/removes content or shifts the row.
                          AnimatedContainer(
                            duration:
                                reduceMotion
                                    ? Duration.zero
                                    : MotionTokens.fast,
                            constraints: const BoxConstraints(minHeight: 24),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  active
                                      ? Colors.white.withValues(alpha: 0.72)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color:
                                    active
                                        ? AppColors.brandDeep
                                        : Colors.transparent,
                              ),
                              boxShadow:
                                  active
                                      ? [
                                        BoxShadow(
                                          color: AppColors.brandDeep.withValues(
                                            alpha: 0.28,
                                          ),
                                          blurRadius: 12,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                      : const <BoxShadow>[],
                            ),
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            rating == null
                                ? '$stonesOnBoard • +$stonesToPlace'
                                : '$rating • $stonesOnBoard • +$stonesToPlace',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ]
                        : [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                              ),
                              if (active) ...[
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.success.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            rating == null
                                ? '$stonesOnBoard • +$stonesToPlace'
                                : '$rating • $stonesOnBoard • +$stonesToPlace',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 3),
                          _ReserveRack(
                            side: side,
                            count: stonesToPlace,
                            active: active,
                            reduceMotion: reduceMotion,
                          ),
                        ],
              ),
            ),
            if (thinkingLabel != null) ...[
              const SizedBox(width: 6),
              SizedBox(
                width: 82,
                child: AnimatedOpacity(
                  duration: reduceMotion ? Duration.zero : MotionTokens.fast,
                  opacity: thinking ? 1 : 0,
                  child: IgnorePointer(
                    child: _ThinkingPill(label: thinkingLabel!),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StoneAvatar extends StatelessWidget {
  const _StoneAvatar({required this.side, required this.diameter});

  final PlayerSide side;
  final double diameter;

  @override
  Widget build(BuildContext context) => Container(
    width: diameter,
    height: diameter,
    decoration: _stoneDecoration(side, shadow: true),
    child: Align(
      alignment: const Alignment(-0.28, -0.34),
      child: Container(
        width: 9,
        height: 6,
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: side == PlayerSide.dark ? 0.25 : 0.74,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );
}

class _ReserveRack extends StatelessWidget {
  const _ReserveRack({
    required this.side,
    required this.count,
    required this.active,
    required this.reduceMotion,
  });

  final PlayerSide side;
  final int count;
  final bool active;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const preferredDiameter = 18.0;
          const minimumDiameter = 12.0;
          const overlapFactor = 0.48;
          final safeCount = count < 1 ? 1 : count;
          final maxWidth =
              math
                  .max(
                    68.0,
                    constraints.maxWidth.isFinite
                        ? constraints.maxWidth - 30
                        : 150.0,
                  )
                  .toDouble();
          final widthPerStone =
              maxWidth / (1 + (safeCount - 1) * overlapFactor);
          final diameter =
              math
                  .min(
                    preferredDiameter,
                    math.max(minimumDiameter, widthPerStone),
                  )
                  .toDouble();
          final step = diameter * overlapFactor;
          final rackWidth = count == 0 ? 0.0 : diameter + (count - 1) * step;

          return Semantics(
            label: count.toString(),
            child: Row(
              children: [
                Container(
                  constraints: const BoxConstraints(minWidth: 22),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color:
                        active ? AppColors.brandDeep : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                  child: Text(
                    count.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: active ? Colors.white : AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: SizedBox(
                      width: rackWidth,
                      height: 22,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: List<Widget>.generate(count, (index) {
                          final stone = Container(
                            width: diameter,
                            height: diameter,
                            decoration: _stoneDecoration(side, shadow: true),
                          );
                          return PositionedDirectional(
                            start: index * step,
                            top: (22 - diameter) / 2,
                            child:
                                index == 0 && active
                                    ? _ActiveReserveStone(
                                      reduceMotion: reduceMotion,
                                      child: stone,
                                    )
                                    : stone,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ActiveReserveStone extends StatefulWidget {
  const _ActiveReserveStone({required this.child, required this.reduceMotion});

  final Widget child;
  final bool reduceMotion;

  @override
  State<_ActiveReserveStone> createState() => _ActiveReserveStoneState();
}

class _ActiveReserveStoneState extends State<_ActiveReserveStone> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !widget.reduceMotion) {
        setState(() => _expanded = true);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _ActiveReserveStone oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reduceMotion && !oldWidget.reduceMotion) {
      _expanded = false;
    } else if (!widget.reduceMotion && oldWidget.reduceMotion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _expanded = true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reduceMotion) {
      return Transform.scale(scale: 1.12, child: widget.child);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _expanded ? 1 : 0),
      duration: MotionTokens.reservePulse,
      curve: Curves.easeInOut,
      onEnd: () {
        if (mounted) {
          setState(() => _expanded = !_expanded);
        }
      },
      builder:
          (context, value, child) => Opacity(
            opacity: 0.68 + value * 0.32,
            child: Transform.scale(
              scale: 1.02 + value * 0.18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.selection.withValues(
                        alpha: 0.28 + value * 0.22,
                      ),
                      blurRadius: 5 + value * 9,
                      spreadRadius: value * 1.4,
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
      child: widget.child,
    );
  }
}

class _ThinkingPill extends StatelessWidget {
  const _ThinkingPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(AppRadii.pill),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    ),
  );
}

BoxDecoration _stoneDecoration(PlayerSide side, {required bool shadow}) {
  final isDark = side == PlayerSide.dark;
  return BoxDecoration(
    shape: BoxShape.circle,
    gradient: RadialGradient(
      center: const Alignment(-0.38, -0.44),
      radius: 0.95,
      colors:
          isDark
              ? const [Color(0xFF77736E), Color(0xFF292725), Color(0xFF050505)]
              : const [Color(0xFFFFFFFF), Color(0xFFF0EDE7), Color(0xFFBEB9B0)],
      stops: const [0.0, 0.55, 1.0],
    ),
    border: Border.all(
      color: isDark ? const Color(0xFF070707) : const Color(0xFF9F9A91),
      width: 1.2,
    ),
    boxShadow:
        shadow
            ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.20),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ]
            : const <BoxShadow>[],
  );
}
