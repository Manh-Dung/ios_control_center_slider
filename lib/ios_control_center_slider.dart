import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class IosControlCenterSlider extends StatefulWidget {
  final double currentValue;
  final ValueChanged<double>? onChanged;
  final String name;

  const IosControlCenterSlider({
    super.key,
    required this.currentValue,
    this.onChanged,
    required this.name,
  });

  @override
  State<IosControlCenterSlider> createState() => _IosControlCenterSliderState();
}

class _IosControlCenterSliderState extends State<IosControlCenterSlider> {
  double _currentValue = 0;

  @override
  void didUpdateWidget(covariant IosControlCenterSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentValue != widget.currentValue) {
      setState(() {
        _currentValue = widget.currentValue;
      });
    }
  }

  @override
  void initState() {
    _currentValue = widget.currentValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        RotatedBox(
          quarterTurns: -1,
          child: SizedBox(
            width: 160,
            child: _CustomSlider(
              trackHeight: 73,
              currentValue: _currentValue,
              onChanged: (value) {
                setState(() {
                  _currentValue = value;
                });
                widget.onChanged?.call(value);
              },
            ),
          ),
        ),
        Positioned(
          bottom: 14,
          child: IgnorePointer(
            child: _currentValue == 0
                ? const Icon(Icons.volume_off, size: 24)
                : const Icon(Icons.volume_up, size: 24),
          ),
        ),
      ],
    );
  }
}

class _CustomSlider extends StatelessWidget {
  const _CustomSlider({
    this.trackHeight = 60,
    this.currentValue = 0.0,
    this.onChanged,
  });

  final double trackHeight;
  final double currentValue;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: trackHeight,
        overlayShape: SliderComponentShape.noOverlay,
        thumbShape: SliderComponentShape.noThumb,
        trackShape: const MyRoundedRectSliderTrackShape(),
      ),
      child: Slider(
        max: 10,
        value: currentValue,
        onChanged: (value) {
          onChanged?.call(value);
        },
        inactiveColor: Colors.transparent,
      ),
    );
  }
}

class MyRoundedRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const MyRoundedRectSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final ColorTween activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final ColorTween inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    );
    final Paint activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    activePaint.shader = ui.Gradient.linear(
      ui.Offset(trackRect.left, 0),
      ui.Offset(thumbCenter.dx, 0),
      [Colors.white, Colors.white],
    );

    final Radius trackRadius = Radius.circular(20);

    final Paint backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.55);

    context.canvas.drawRRect(
      RRect.fromLTRBR(
        trackRect.left,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
        trackRadius,
      ),
      backgroundPaint,
    );

    context.canvas.save();
    context.canvas.clipRRect(
      RRect.fromLTRBR(
        trackRect.left,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
        trackRadius,
      ),
    );

    context.canvas.drawRRect(
      RRect.fromLTRBR(
        trackRect.left,
        (textDirection == TextDirection.ltr)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        math.max(thumbCenter.dx, trackRect.left),
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        Radius.zero,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBR(
        math.min(thumbCenter.dx, trackRect.right),
        // Đảm bảo không lớn hơn trackRect.right
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        trackRadius,
      ),
      rightTrackPaint,
    );

    context.canvas.restore();
  }
}
