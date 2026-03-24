import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'gloss.dart';
import 'theme.dart';
import 'widgets.dart';
import 'navigation.dart';

// Cached base style for app bar title to avoid creating new TextStyle per build
final TextStyle _appBarTitleStyle = GoogleFonts.fredoka(
  fontWeight: FontWeight.w600,
  color: KawaiiColors.heading,
);

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII SCAFFOLD — gradient background + optional sparkle field
//  Accepts either a single `body` or `pages` + `navItems` for
//  automatic IndexedStack + KawaiiBottomNavBar wiring.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiScaffold extends StatefulWidget {
  /// Single-page mode: just a body widget.
  final Widget? body;

  /// Multi-page mode: provide pages + navItems for automatic
  /// IndexedStack + KawaiiBottomNavBar. Pages are built once
  /// and kept alive across tab switches (no rebuild lag).
  final List<Widget>? pages;
  final List<KawaiiNavItem>? navItems;
  final int initialPage;
  final ValueChanged<int>? onPageChanged;

  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool sparkles;
  final int sparkleCount;

  const KawaiiScaffold({
    super.key,
    this.body,
    this.pages,
    this.navItems,
    this.initialPage = 0,
    this.onPageChanged,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.sparkles = true,
    this.sparkleCount = 10,
  }) : assert(body != null || (pages != null && navItems != null),
        'Provide either body or pages+navItems');

  @override
  KawaiiScaffoldState createState() => KawaiiScaffoldState();
}

class KawaiiScaffoldState extends State<KawaiiScaffold> {
  late int _pageIndex;

  /// Programmatically switch to a page (for external navigation).
  void setPage(int index) => setState(() => _pageIndex = index);

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    final isMultiPage = widget.pages != null;
    final content = isMultiPage
        ? IndexedStack(index: _pageIndex, children: widget.pages!)
        : widget.body!;

    final navBar = isMultiPage
        ? KawaiiBottomNavBar(
            items: widget.navItems!,
            currentIndex: _pageIndex,
            onTap: (i) {
              setState(() => _pageIndex = i);
              widget.onPageChanged?.call(i);
            },
          )
        : widget.bottomNavigationBar;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: widget.appBar,
      bottomNavigationBar: navBar,
      floatingActionButton: widget.floatingActionButton,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [KawaiiColors.bgTop, KawaiiColors.bgMid, KawaiiColors.bgBottom],
          ),
        ),
        child: sparkles
            ? KawaiiSparkleField(
                count: widget.sparkleCount,
                child: SafeArea(bottom: false, child: content),
              )
            : SafeArea(bottom: false, child: content),
      ),
    );
  }

  bool get sparkles => widget.sparkles;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII APP BAR — frosted glass with glossy shine
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;

  const KawaiiAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: KawaiiSurface(tactile: false,
          gloss: GlossLevel.subtle,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: KawaiiOpacity.heavy),
                KawaiiColors.pinkTop.withValues(alpha: KawaiiOpacity.medium),
              ],
            ),
            border: const Border(
              bottom: BorderSide(
                color: KawaiiColors.cardBorder,
                width: KawaiiBorderWidth.thin,
              ),
            ),
            boxShadow: [KawaiiShadows.soft(KawaiiColors.pinkShadow)],
          ),
          height: preferredSize.height + topPadding,
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final titleWidget = DefaultTextStyle.merge(
      style: _appBarTitleStyle.copyWith(fontSize: 20),
      child: title,
    );

    return SizedBox(
      height: 56,
      child: NavigationToolbar(
        leading: leading,
        middle: titleWidget,
        trailing: actions != null
            ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
            : null,
        centerMiddle: centerTitle,
        middleSpacing: NavigationToolbar.kMiddleSpacing,
      ),
    );
  }
}
