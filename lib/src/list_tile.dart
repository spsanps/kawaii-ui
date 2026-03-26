import 'package:flutter/material.dart';
import 'gloss.dart';
import 'theme.dart';
import 'sound_engine.dart';
import 'widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII LIST TILE
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiListTile extends StatelessWidget {
  final Widget? leading;
  final dynamic title; // Widget or String
  final dynamic subtitle; // Widget or String?
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool dense;

  const KawaiiListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.dense = false,
  });

  Widget _resolveText(dynamic value, TextStyle style) =>
      value is Widget ? value : Text(value.toString(), style: style);

  @override
  Widget build(BuildContext context) {
    final vPad = dense ? 8.0 : 13.0;
    final hPad = dense ? 12.0 : 15.0;

    final tile = KawaiiSurface(
      gloss: GlossLevel.subtle,
      shineOpacity: 0.35,
      shineHeight: 0.40,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
        gradient: const LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xA6FFFFFF), Color(0x73FFF8FC)],
        ),
        border: Border.all(
          color: KawaiiColors.cardBorder.withValues(alpha: KawaiiOpacity.hint),
          width: KawaiiBorderWidth.light,
        ),
        boxShadow: [BoxShadow(
          color: KawaiiColors.glass.withValues(alpha: KawaiiOpacity.ghost),
          blurRadius: 8, offset: const Offset(0, 3),
        )],
      ),
      child: Row(children: [
        if (leading != null) ...[
          leading!,
          SizedBox(width: dense ? 10.0 : KawaiiSpacing.lg),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _resolveText(title, kHeading(size: dense ? 12.0 : 13.0)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                _resolveText(subtitle, kBody(size: dense ? 10.5 : 11.5, color: KawaiiColors.muted)),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: KawaiiSpacing.md),
          trailing!,
        ],
      ]),
    );

    if (onTap == null) return tile;

    return KawaiiPressable(
      pressScale: 0.98,
      sound: KawaiiSound.tick,
      onTap: () { onTap?.call(); },
      child: tile,
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII DIVIDER
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiDivider extends StatelessWidget {
  final Color? color;
  final double indent;
  final double endIndent;

  const KawaiiDivider({
    super.key,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? KawaiiColors.cardBorder.withValues(alpha: KawaiiOpacity.muted);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KawaiiSpacing.md)
          + EdgeInsets.only(left: indent, right: endIndent),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.transparent,
            c,
            c,
            Colors.transparent,
          ], stops: const [0.0, 0.3, 0.7, 1.0]),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII LIST VIEW — always-lazy list with stagger entrance
//  Prevents the #1 perf mistake: ListView(children: [...]) which
//  builds all items eagerly. This wrapper enforces lazy building.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiListView extends StatelessWidget {
  /// Number of items in the list.
  final int itemCount;

  /// Builder for each item. Called lazily — only visible items are built.
  final IndexedWidgetBuilder itemBuilder;

  /// Optional header widgets shown before the list items.
  final List<Widget> header;

  /// Padding around the list.
  final EdgeInsets padding;

  /// Whether to add stagger entrance animations to each item.
  final bool staggerEntrance;

  /// Stagger delay between items (only if staggerEntrance is true).
  final Duration staggerDelay;

  const KawaiiListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.header = const [],
    this.padding = const EdgeInsets.symmetric(
      horizontal: KawaiiSpacing.xl, vertical: KawaiiSpacing.page),
    this.staggerEntrance = false,
    this.staggerDelay = const Duration(milliseconds: 80),
  });

  @override
  Widget build(BuildContext context) {
    final totalCount = header.length + itemCount;
    return ListView.builder(
      padding: padding,
      itemCount: totalCount,
      itemBuilder: (ctx, index) {
        if (index < header.length) return header[index];
        final itemIndex = index - header.length;
        final child = itemBuilder(ctx, itemIndex);
        if (!staggerEntrance) return child;
        return KawaiiEntrance(
          delay: staggerDelay * itemIndex,
          child: child,
        );
      },
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII EXPANDABLE FORM — instant inline form, no modal sheet
//  Forces the pattern: tap button → form expands in place (instant)
//  instead of: tap button → sheet slides up (250ms delay).
//  Use this instead of showKawaiiBottomSheet for simple 1-3 field forms.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiExpandableForm extends StatefulWidget {
  /// The button label shown when the form is collapsed.
  final String buttonLabel;

  /// Button color preset (uses KawaiiButton factories).
  final Color? buttonColor;

  /// Builder for the expanded form content. Return the form fields.
  /// Call `collapse()` to close the form after submission.
  final Widget Function(BuildContext context, VoidCallback collapse) formBuilder;

  /// Whether the button should be hero-sized.
  final bool heroButton;

  /// Icon on the collapsed button.
  final Widget? buttonIcon;

  const KawaiiExpandableForm({
    super.key,
    required this.buttonLabel,
    required this.formBuilder,
    this.buttonColor,
    this.heroButton = true,
    this.buttonIcon,
  });

  @override
  State<KawaiiExpandableForm> createState() => _KawaiiExpandableFormState();
}

class _KawaiiExpandableFormState extends State<KawaiiExpandableForm> {
  bool _expanded = false;

  void _collapse() => setState(() => _expanded = false);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: KawaiiCurves.soft,
      alignment: Alignment.topCenter,
      child: _expanded
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: KawaiiSpacing.md),
              child: KawaiiCard(
                showSparkles: false,
                child: widget.formBuilder(context, _collapse),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(
                bottom: KawaiiSpacing.xxl, top: KawaiiSpacing.md),
              child: KawaiiButton(
                label: widget.buttonLabel,
                hero: widget.heroButton,
                icon: widget.buttonIcon,
                colors: KawaiiButtonColors.pink,
                onTap: () => setState(() => _expanded = true),
              ),
            ),
    );
  }
}
