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

    final tile = KawaiiSurface(tactile: false,
      gloss: GlossLevel.subtle,
      shineOpacity: 0.35,
      shineHeight: 0.40,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
        gradient: const LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xF2FFFFFF), Color(0xE6FFF8FC)],
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
      onTap: () {
        KawaiiSoundEngine().play(KawaiiSound.tick);
        onTap?.call();
      },
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
