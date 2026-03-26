import 'package:flutter/material.dart';
import 'gloss.dart';
import 'theme.dart';
import 'sound_engine.dart';
import 'painters.dart';
import 'widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII CHECKBOX
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color color;
  final double size;

  const KawaiiCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.color = const Color(0xFFF08CAE),
    this.size = 28,
  });

  @override
  State<KawaiiCheckbox> createState() => _KawaiiCheckboxState();
}

class _KawaiiCheckboxState extends State<KawaiiCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.value ? 1.0 : 0.0,
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: KawaiiCurves.spring);
  }

  @override
  void didUpdateWidget(KawaiiCheckbox old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      widget.value ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    SoundGate.instance.tryPlay(KawaiiSound.tick);
    widget.onChanged?.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    final c = widget.color;

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: KawaiiCurves.soft,
        width: s,
        height: s,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          gradient: widget.value
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [c.withValues(alpha: KawaiiOpacity.heavy), c],
                )
              : LinearGradient(
                  colors: [
                    c.withValues(alpha: KawaiiOpacity.whisper),
                    c.withValues(alpha: KawaiiOpacity.ghost),
                  ],
                ),
          border: Border.all(
            color: widget.value
                ? c.withValues(alpha: KawaiiOpacity.medium)
                : KawaiiColors.glass.withValues(alpha: KawaiiOpacity.hint),
            width: widget.value
                ? KawaiiBorderWidth.medium
                : KawaiiBorderWidth.thin,
          ),
        ),
        child: widget.value
            ? KawaiiSurface(tactile: false,
                decoration: const BoxDecoration(color: Colors.transparent),
                gloss: GlossLevel.full,
                child: AnimatedBuilder(
                  animation: _scale,
                  builder: (_, __) => Transform.scale(
                    scale: _scale.value,
                    child: kawaiiIcon(
                      const CheckPainter(color: Colors.white),
                      size: s * 0.7,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII RADIO
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiRadio<T> extends StatefulWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T>? onChanged;
  final Color color;
  final double size;
  final bool playSound;

  const KawaiiRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.color = const Color(0xFFF08CAE),
    this.size = 22,
    this.playSound = true,
  });

  @override
  State<KawaiiRadio<T>> createState() => _KawaiiRadioState<T>();
}

class _KawaiiRadioState<T> extends State<KawaiiRadio<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  bool get _selected => widget.value == widget.groupValue;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: _selected ? 1.0 : 0.0,
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: KawaiiCurves.spring);
  }

  @override
  void didUpdateWidget(KawaiiRadio<T> old) {
    super.didUpdateWidget(old);
    final sel = _selected;
    final wasSel = old.value == old.groupValue;
    if (sel != wasSel) {
      sel ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _select() {
    if (!_selected) {
      if (widget.playSound) SoundGate.instance.tryPlay(KawaiiSound.tick);
      widget.onChanged?.call(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    final c = widget.color;

    return GestureDetector(
      onTap: _select,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: KawaiiCurves.soft,
        width: s,
        height: s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _selected
              ? Colors.transparent
              : c.withValues(alpha: KawaiiOpacity.ghost),
          border: Border.all(
            color: _selected
                ? c
                : KawaiiColors.glass.withValues(alpha: KawaiiOpacity.hint),
            width: _selected
                ? KawaiiBorderWidth.medium
                : KawaiiBorderWidth.thin,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _scale,
            builder: (_, __) => Transform.scale(
              scale: _scale.value,
              child: KawaiiSurface(tactile: false,
                width: s * 0.5,
                height: s * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [c, c.withValues(alpha: KawaiiOpacity.heavy)],
                  ),
                ),
                gloss: GlossLevel.medium,
                child: const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII SLIDER
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final Color color;
  final int? divisions;

  const KawaiiSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.color = const Color(0xFFF08CAE),
    this.divisions,
  });

  @override
  State<KawaiiSlider> createState() => _KawaiiSliderState();
}

class _KawaiiSliderState extends State<KawaiiSlider> {
  bool _dragging = false;

  static const _trackH = 8.0;
  static const _thumbD = 24.0;

  double _snap(double v) {
    if (widget.divisions == null || widget.divisions! <= 0) return v;
    final step = 1.0 / widget.divisions!;
    return (v / step).round() * step;
  }

  void _onDrag(BuildContext ctx, Offset globalPos) {
    final box = ctx.findRenderObject() as RenderBox;
    final local = box.globalToLocal(globalPos);
    final trackW = box.size.width - _thumbD;
    final raw = ((local.dx - _thumbD / 2) / trackW).clamp(0.0, 1.0);
    widget.onChanged?.call(_snap(raw));
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    final v = widget.value.clamp(0.0, 1.0);

    return GestureDetector(
      onPanStart: (d) {
        setState(() => _dragging = true);
        _onDrag(context, d.globalPosition);
      },
      onPanUpdate: (d) => _onDrag(context, d.globalPosition),
      onPanEnd: (_) {
        setState(() => _dragging = false);
        SoundGate.instance.tryPlay(KawaiiSound.tick);
      },
      child: SizedBox(
        height: _thumbD + 8,
        child: LayoutBuilder(builder: (ctx, box) {
          final trackW = box.maxWidth - _thumbD;
          final thumbX = _thumbD / 2 + trackW * v;

          return Stack(
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.none,
            children: [
              // Track background
              Positioned(
                left: _thumbD / 2,
                right: _thumbD / 2,
                child: Container(
                  height: _trackH,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_trackH / 2),
                    color: c.withValues(alpha: KawaiiOpacity.whisper),
                    border: Border.all(
                      color: KawaiiColors.glass.withValues(
                          alpha: KawaiiOpacity.hint),
                      width: KawaiiBorderWidth.thin,
                    ),
                  ),
                ),
              ),

              // Track fill
              Positioned(
                left: _thumbD / 2,
                width: trackW * v,
                child: KawaiiSurface(tactile: false,
                  height: _trackH,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_trackH / 2),
                    gradient: LinearGradient(
                      colors: [
                        c.withValues(alpha: KawaiiOpacity.heavy),
                        c,
                      ],
                    ),
                  ),
                  gloss: GlossLevel.subtle,
                  child: const SizedBox.shrink(),
                ),
              ),

              // Thumb
              Positioned(
                left: thumbX - _thumbD / 2,
                child: KawaiiPressable(
                  pressScale: _dragging ? 1.08 : 1.0,
                  pressTranslateY: 0,
                  child: AnimatedScale(
                    scale: _dragging ? 1.12 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    curve: KawaiiCurves.spring,
                    child: Container(
                      width: _thumbD,
                      height: _thumbD,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Color(0xFFF8F0F4)],
                        ),
                        border: Border.all(
                          color: const Color(0x38C8A0B4),
                          width: KawaiiBorderWidth.light,
                        ),
                        boxShadow: [KawaiiShadows.soft(Colors.black)],
                      ),
                      // Top-lit shine on thumb
                      child: ClipOval(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.45, 0.5],
                              colors: [
                                Colors.white.withValues(alpha: 0.55),
                                Colors.white.withValues(alpha: 0.08),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
