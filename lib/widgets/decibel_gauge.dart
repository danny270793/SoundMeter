import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Radial sound level gauge: a 270° arc filled with a green → amber → red
/// sweep, major/minor ticks, a marker for the session's max level and the
/// current value in the middle. Value changes animate smoothly between buffers.
class DecibelGauge extends StatelessWidget {
  const DecibelGauge({
    super.key,
    required this.value,
    required this.maxValue,
    required this.unitLabel,
    this.maximum = 120,
    this.caption,
    this.dimmed = false,
  });

  final double value;
  final double? maxValue;
  final double maximum;
  final String unitLabel;

  /// Short label under the unit (e.g. "Paused").
  final String? caption;

  /// Greys out the arc while paused.
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AspectRatio(
      aspectRatio: 1,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: value.clamp(0, maximum)),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        builder: (context, animated, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.biggest.shortestSide;
              return CustomPaint(
                painter: _GaugePainter(
                  value: animated,
                  peak: (maxValue ?? 0).clamp(0, maximum),
                  dimmed: dimmed,
                  maximum: maximum,
                  trackColor: scheme.surfaceContainerHighest,
                  tickColor: scheme.onSurfaceVariant,
                  labelStyle: theme.textTheme.labelMedium!.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontSize: size * 0.04,
                  ),
                  markerColor: scheme.primary,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: size * 0.06),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          animated.round().toString(),
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: size * 0.24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -2,
                            height: 1,
                            color: scheme.onSurface,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        SizedBox(height: size * 0.01),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: size * 0.035,
                            vertical: size * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            unitLabel,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: size * 0.045,
                              fontWeight: FontWeight.w700,
                              color: scheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        if (caption != null) ...[
                          SizedBox(height: size * 0.02),
                          Text(
                            caption!,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontSize: size * 0.04,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.value,
    required this.peak,
    required this.maximum,
    required this.trackColor,
    required this.tickColor,
    required this.labelStyle,
    required this.markerColor,
    required this.dimmed,
  });

  final double value;
  final double peak;
  final double maximum;
  final Color trackColor;
  final Color tickColor;
  final TextStyle labelStyle;
  final Color markerColor;
  final bool dimmed;

  static const double _startAngle = math.pi * 0.75;
  static const double _sweepAngle = math.pi * 1.5;

  static const _zoneColors = [
    Color(0xFF26A69A),
    Color(0xFF43A047),
    Color(0xFFC0CA33),
    Color(0xFFFFB300),
    Color(0xFFFB8C00),
    Color(0xFFE53935),
  ];

  double _angleFor(double v) => _startAngle + _sweepAngle * (v / maximum);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final stroke = radius * 0.11;
    final arcRadius = radius - stroke / 2 - radius * 0.02;
    final arcRect = Rect.fromCircle(center: center, radius: arcRadius);

    // Track.
    canvas.drawArc(
      arcRect,
      _startAngle,
      _sweepAngle,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = trackColor,
    );

    // Active sweep. The gradient spans the whole scale so colors stay tied to
    // speed zones rather than stretching with the current value.
    if (value > 0) {
      final gradient = SweepGradient(
        startAngle: 0,
        endAngle: _sweepAngle,
        colors: dimmed
            ? [for (final c in _zoneColors) c.withValues(alpha: 0.35)]
            : _zoneColors,
        transform: const GradientRotation(_startAngle),
      );
      final activePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt
        ..shader = gradient.createShader(arcRect);
      canvas.drawArc(
        arcRect,
        _startAngle,
        _sweepAngle * (value / maximum),
        false,
        activePaint,
      );

      // Round caps drawn by hand: a stroke cap would extend past the
      // gradient's 0° and pick up its wrapped-around (red) end color.
      final tip = _pointOn(center, arcRadius, _angleFor(value));
      canvas.drawCircle(
        _pointOn(center, arcRadius, _startAngle),
        stroke / 2,
        Paint()..color = _zoneColors.first,
      );
      canvas.drawCircle(
        tip,
        stroke / 2,
        Paint()..color = _colorAt(value / maximum),
      );

      // Soft glow behind the leading edge.
      canvas.drawCircle(
        tip,
        stroke * 0.9,
        Paint()
          ..color = _colorAt(value / maximum).withValues(alpha: 0.35)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, stroke * 0.6),
      );
      canvas.drawCircle(tip, stroke * 0.32, Paint()..color = Colors.white);
    }

    // Ticks and labels.
    const majorStep = 20.0;
    const minorStep = majorStep / 4;
    final tickOuter = arcRadius - stroke * 0.85;
    for (double v = 0; v <= maximum + 0.001; v += minorStep) {
      final isMajor = (v % majorStep).abs() < 0.001;
      final angle = _angleFor(v);
      final length = isMajor ? radius * 0.07 : radius * 0.035;
      final paint = Paint()
        ..color = tickColor.withValues(alpha: isMajor ? 0.9 : 0.4)
        ..strokeWidth = isMajor ? radius * 0.014 : radius * 0.008
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        _pointOn(center, tickOuter, angle),
        _pointOn(center, tickOuter - length, angle),
        paint,
      );
      if (isMajor) {
        final tp = TextPainter(
          text: TextSpan(text: v.round().toString(), style: labelStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        final labelPos = _pointOn(
          center,
          tickOuter - length - radius * 0.08,
          angle,
        );
        tp.paint(canvas, labelPos - Offset(tp.width / 2, tp.height / 2));
      }
    }

    // Top-speed marker: small triangle pointing at the arc.
    if (peak > 0) {
      final angle = _angleFor(peak);
      final outer = arcRadius + stroke * 0.5 + radius * 0.015;
      final tipPoint = _pointOn(center, outer, angle);
      final base = radius * 0.045;
      final back = _pointOn(center, outer + base * 1.4, angle);
      final perp = Offset(-math.sin(angle), math.cos(angle)) * base * 0.7;
      final path = Path()
        ..moveTo(tipPoint.dx, tipPoint.dy)
        ..lineTo(back.dx + perp.dx, back.dy + perp.dy)
        ..lineTo(back.dx - perp.dx, back.dy - perp.dy)
        ..close();
      canvas.drawPath(path, Paint()..color = markerColor);
    }
  }

  Offset _pointOn(Offset center, double r, double angle) =>
      center + Offset(math.cos(angle) * r, math.sin(angle) * r);

  Color _colorAt(double t) {
    final scaled = (t.clamp(0, 1) * (_zoneColors.length - 1)).toDouble();
    final i = scaled.floor().clamp(0, _zoneColors.length - 2);
    return Color.lerp(_zoneColors[i], _zoneColors[i + 1], scaled - i)!;
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.value != value ||
      old.peak != peak ||
      old.maximum != maximum ||
      old.trackColor != trackColor ||
      old.tickColor != tickColor ||
      old.markerColor != markerColor ||
      old.dimmed != dimmed ||
      old.labelStyle != labelStyle;
}
