import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'gloss.dart';
import 'theme.dart';
import 'widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII SCAFFOLD — gradient background + optional sparkle field
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool sparkles;
  final int sparkleCount;

  const KawaiiScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.sparkles = true,
    this.sparkleCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              KawaiiColors.bgTop,
              KawaiiColors.bgMid,
              KawaiiColors.bgBottom,
            ],
          ),
        ),
        child: sparkles
            ? KawaiiSparkleField(
                count: sparkleCount,
                child: SafeArea(child: body),
              )
            : SafeArea(child: body),
      ),
    );
  }
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
        // [OPT #8] Reduced blur sigma from 20 to 10 — visually similar
        // frosted glass effect but significantly cheaper GPU-side.
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: KawaiiSurface(
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
            border: Border(
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
      style: GoogleFonts.fredoka(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: KawaiiColors.heading,
      ),
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
