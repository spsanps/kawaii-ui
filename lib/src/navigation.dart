import 'package:flutter/material.dart';
import 'gloss.dart';
import 'theme.dart';
import 'sound_engine.dart';
import 'widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  NAV ITEM MODEL
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

@immutable
class KawaiiNavItem {
  final Widget icon;
  final String label;
  final int? badge;

  const KawaiiNavItem({
    required this.icon,
    required this.label,
    this.badge,
  });
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII BOTTOM NAV BAR — frosted glass bar with sliding pill
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiBottomNavBar extends StatelessWidget {
  final List<KawaiiNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? color;

  const KawaiiBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final primary = color ?? KawaiiColors.pinkBottom;
    if (items.isEmpty) return const SizedBox.shrink();
    final mq = MediaQuery.of(context);
    final bottomPad = mq.padding.bottom;
    final itemWidth = mq.size.width / items.length;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: KawaiiOpacity.solid),
            Colors.white.withValues(alpha: KawaiiOpacity.heavy),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: primary.withValues(alpha: KawaiiOpacity.muted),
            width: KawaiiBorderWidth.thin,
          ),
        ),
        boxShadow: [KawaiiShadows.deep(primary)],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPad),
        child: SizedBox(
          height: 60,
          child: Stack(
            children: [
              // Sliding pill indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: KawaiiCurves.spring,
                left: currentIndex * itemWidth + itemWidth * 0.12,
                top: 6,
                width: itemWidth * 0.76,
                height: 48,
                child: KawaiiSurface(tactile: false,
                  gloss: GlossLevel.subtle,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: KawaiiOpacity.hint),
                    borderRadius: BorderRadius.circular(KawaiiBorderRadius.md),
                    border: Border.all(
                      color: primary.withValues(alpha: KawaiiOpacity.whisper),
                      width: KawaiiBorderWidth.thin,
                    ),
                  ),
                  child: const SizedBox.expand(),
                ),
              ),

              // Items row
              Row(
                children: List.generate(items.length, (i) {
                  final item = items[i];
                  final selected = i == currentIndex;
                  return Expanded(
                    child: KawaiiPressable(
                      pressScale: KawaiiTokens.pressScale,
                      pressTranslateY: KawaiiTokens.pressTranslateY,
                      onTap: () {
                        SoundGate.instance.tryPlay(KawaiiSound.tick);
                        onTap(i);
                      },
                      child: SizedBox.expand(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconTheme(
                                  data: IconThemeData(
                                    color: selected ? primary : KawaiiColors.muted,
                                    size: 22,
                                  ),
                                  child: item.icon,
                                ),
                                if (item.badge != null && item.badge! > 0)
                                  Positioned(
                                    right: -8,
                                    top: -6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: KawaiiSpacing.sm,
                                        vertical: KawaiiSpacing.xs,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: KawaiiBorderWidth.light,
                                        ),
                                      ),
                                      child: Text(
                                        '${item.badge}',
                                        style: kBody(
                                          size: 9,
                                          weight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: KawaiiSpacing.xs),
                            Text(
                              item.label,
                              style: kBody(
                                size: 10,
                                weight: selected ? FontWeight.w800 : FontWeight.w600,
                                color: selected ? primary : KawaiiColors.muted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII TAB BAR — compact glass container with sliding glossy pill
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiTabBar extends StatelessWidget {
  final List<dynamic> tabs; // String or Widget
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color? color;

  const KawaiiTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final primary = color ?? KawaiiColors.pinkBottom;
    final count = tabs.length;
    if (count == 0) return const SizedBox.shrink();

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: primary.withValues(alpha: KawaiiOpacity.whisper),
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.md),
        border: Border.all(
          color: primary.withValues(alpha: KawaiiOpacity.hint),
          width: KawaiiBorderWidth.thin,
        ),
      ),
      padding: const EdgeInsets.all(3),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / count;
          return Stack(
            children: [
              // Sliding glossy pill
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: KawaiiCurves.spring,
                left: selectedIndex * tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: KawaiiSurface(tactile: false,
                  gloss: GlossLevel.medium,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        primary.withValues(alpha: KawaiiOpacity.heavy),
                        primary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(
                      KawaiiBorderRadius.sm,
                    ),
                    border: Border.all(
                      color: primary.withValues(alpha: KawaiiOpacity.medium),
                      width: KawaiiBorderWidth.thin,
                    ),
                    boxShadow: [KawaiiShadows.soft(primary)],
                  ),
                  child: const SizedBox.expand(),
                ),
              ),

              // Tab labels
              Row(
                children: List.generate(count, (i) {
                  final selected = i == selectedIndex;
                  final tab = tabs[i];
                  return Expanded(
                    child: KawaiiPressable(
                      pressScale: KawaiiTokens.pressScale,
                      pressTranslateY: 1.0,
                      onTap: () {
                        SoundGate.instance.tryPlay(KawaiiSound.tick);
                        onChanged(i);
                      },
                      child: Center(
                        child: tab is Widget
                            ? tab
                            : Text(
                                '$tab',
                                style: kBody(
                                  size: 12,
                                  weight: selected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: selected
                                      ? Colors.white
                                      : primary.withValues(
                                          alpha: KawaiiOpacity.strong),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
