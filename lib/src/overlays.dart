import 'dart:async';
import 'package:flutter/material.dart';
import 'gloss.dart';
import 'theme.dart';
import 'widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  SHOW KAWAII DIALOG
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Future<T?> showKawaiiDialog<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  List<Widget>? actions,
  bool scrollable = false,
  Widget? body, // replaces title+content when provided
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: const Color(0x80B4648C),
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (ctx, anim, secondaryAnim, child) {
      final curved = CurvedAnimation(parent: anim, curve: KawaiiCurves.spring);
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(scale: Tween(begin: 0.9, end: 1.0).animate(curved), child: child),
      );
    },
    pageBuilder: (ctx, _, __) {
      return SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: KawaiiSpacing.xl, right: KawaiiSpacing.xl,
                bottom: MediaQuery.viewInsetsOf(ctx).bottom),
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child: _KawaiiDialogBody(title: title, content: content,
                    actions: actions, scrollable: scrollable, body: body),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _KawaiiDialogBody extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool scrollable;
  final Widget? body;
  const _KawaiiDialogBody({required this.title, required this.content,
    this.actions, this.scrollable = false, this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(KawaiiSpacing.cardPad),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [KawaiiColors.cardFillTop, KawaiiColors.cardFillBottom],
        ),
        borderRadius: BorderRadius.circular(KawaiiBorderRadius.card),
        border: Border.all(color: KawaiiColors.cardBorder, width: KawaiiBorderWidth.thick),
        boxShadow: const [KawaiiShadows.card],
      ),
      child: Stack(children: [
        // Inner bevel
        Positioned.fill(child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(KawaiiBorderRadius.xl),
            border: Border.all(color: const Color(0x8CFFFFFF), width: KawaiiBorderWidth.thin),
          ),
        )),
        // Corner sparkles
        for (final pos in [
          const Alignment(-0.92, -0.92), const Alignment(0.92, -0.92),
          const Alignment(-0.92, 0.92), const Alignment(0.92, 0.92),
        ])
          Align(alignment: pos, child: Opacity(
            opacity: KawaiiOpacity.decorative, child: const Star4Icon(size: 6))),
        // Content
        body ?? Column(mainAxisSize: MainAxisSize.min, children: [
          Text(title, style: kHeading(size: 16)),
          const SizedBox(height: KawaiiSpacing.lg),
          scrollable ? Flexible(child: SingleChildScrollView(child: content)) : content,
          if (actions != null) ...[
            const SizedBox(height: KawaiiSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (int i = 0; i < actions!.length; i++) ...[
                  if (i > 0) const SizedBox(width: KawaiiSpacing.md),
                  actions![i],
                ],
              ],
            ),
          ],
        ]),
      ]),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  SHOW KAWAII BOTTOM SHEET
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Future<T?> showKawaiiBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool showHandle = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x80B4648C),
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [KawaiiColors.cardFillTop, KawaiiColors.cardFillBottom],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: KawaiiColors.cardBorder, width: KawaiiBorderWidth.thick),
          left: BorderSide(color: KawaiiColors.cardBorder, width: KawaiiBorderWidth.thick),
          right: BorderSide(color: KawaiiColors.cardBorder, width: KawaiiBorderWidth.thick),
        ),
        boxShadow: [KawaiiShadows.card],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        if (showHandle)
          Padding(
            padding: const EdgeInsets.only(top: KawaiiSpacing.lg, bottom: KawaiiSpacing.md),
            child: KawaiiSurface(tactile: false,
              gloss: GlossLevel.medium,
              width: 40, height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: KawaiiColors.glass.withValues(alpha: KawaiiOpacity.medium),
              ),
              child: const SizedBox.shrink(),
            ),
          ),
        // Wrap content in Flexible to avoid overflow when keyboard opens
        Flexible(child: builder(ctx)),
      ]),
    ),
  );
}

/// Defers sheet content build to after the first frame.
/// Shows a compact placeholder during the slide-in animation,
/// then swaps to the real content. This prevents jank from
/// building 60+ widgets during the route transition.
class _DeferredSheetContent extends StatefulWidget {
  final WidgetBuilder builder;
  const _DeferredSheetContent({required this.builder});
  @override
  State<_DeferredSheetContent> createState() => _DeferredSheetContentState();
}

class _DeferredSheetContentState extends State<_DeferredSheetContent> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const SizedBox(height: 120); // placeholder during slide-in
    }
    return widget.builder(context);
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  SHOW KAWAII SNACKBAR
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

enum KawaiiSnackbarType { success, error, info, warning }

void showKawaiiSnackbar({
  required BuildContext context,
  required String message,
  KawaiiSnackbarType type = KawaiiSnackbarType.info,
  Duration duration = const Duration(seconds: 3),
  Widget? action,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  entry = OverlayEntry(builder: (_) => _KawaiiSnackbarWidget(
    message: message,
    type: type,
    duration: duration,
    action: action,
    onDismiss: () => entry.remove(),
  ));
  overlay.insert(entry);
}

class _KawaiiSnackbarWidget extends StatefulWidget {
  final String message;
  final KawaiiSnackbarType type;
  final Duration duration;
  final Widget? action;
  final VoidCallback onDismiss;
  const _KawaiiSnackbarWidget({
    required this.message, required this.type,
    required this.duration, this.action, required this.onDismiss,
  });

  @override
  State<_KawaiiSnackbarWidget> createState() => _KawaiiSnackbarWidgetState();
}

class _KawaiiSnackbarWidgetState extends State<_KawaiiSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _opacity;
  Timer? _timer;

  Color get _tint => switch (widget.type) {
    KawaiiSnackbarType.success => KawaiiColors.greenBottom,
    KawaiiSnackbarType.error   => const Color(0xFFE57373),
    KawaiiSnackbarType.info    => KawaiiColors.blueBottom,
    KawaiiSnackbarType.warning => KawaiiColors.goldBottom,
  };

  IconData get _icon => switch (widget.type) {
    KawaiiSnackbarType.success => Icons.check_circle_rounded,
    KawaiiSnackbarType.error   => Icons.error_rounded,
    KawaiiSnackbarType.info    => Icons.info_rounded,
    KawaiiSnackbarType.warning => Icons.warning_rounded,
  };

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _slide = Tween(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: KawaiiCurves.spring));
    _opacity = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.5)));
    _ctrl.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  void _dismiss() async {
    _timer?.cancel();
    if (!mounted) return;
    await _ctrl.reverse();
    if (mounted) widget.onDismiss();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _tint;
    return Positioned(
      left: KawaiiSpacing.xl, right: KawaiiSpacing.xl,
      bottom: MediaQuery.of(context).padding.bottom + KawaiiSpacing.xxl,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _opacity,
          child: KawaiiSurface(tactile: false,
            gloss: GlossLevel.subtle,
            shineOpacity: 0.35,
            shineHeight: 0.40,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
              gradient: const LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0xA6FFFFFF), Color(0x73FFF8FC)],
              ),
              border: Border.all(color: color.withValues(alpha: KawaiiOpacity.hint), width: KawaiiBorderWidth.light),
              boxShadow: [BoxShadow(color: color.withValues(alpha: KawaiiOpacity.ghost),
                blurRadius: 8, offset: const Offset(0, 3))],
            ),
            child: Row(children: [
              Icon(_icon, size: 20, color: color),
              const SizedBox(width: KawaiiSpacing.md),
              Expanded(child: Text(widget.message, style: kBody(size: 12.5, color: KawaiiColors.heading))),
              if (widget.action != null) ...[
                const SizedBox(width: KawaiiSpacing.md),
                widget.action!,
              ],
            ]),
          ),
        ),
      ),
    );
  }
}
