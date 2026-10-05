import 'package:flutter/material.dart';

import '../features/sound_meter/sound_level.dart';
import '../features/sound_meter/sound_meter_state.dart';

/// Scrolling area chart of recent readings. The line and fill are tinted by
/// loudness band, with dashed min / max guides and a hearing-risk threshold.
class DecibelHistoryChart extends StatelessWidget {
  const DecibelHistoryChart({
    super.key,
    required this.samples,
    required this.window,
    required this.offsetDb,
    this.minDb,
    this.maxDb,
  });

  final List<SoundSample> samples;
  final Duration window;

  /// Calibration offset applied to every sample.
  final double offsetDb;
  final double? minDb;
  final double? maxDb;

  static const double floorDb = 0;
  static const double ceilingDb = 120;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return CustomPaint(
      painter: _HistoryPainter(
        samples: samples,
        window: window,
        offsetDb: offsetDb,
        minDb: minDb,
        maxDb: maxDb,
        gridColor: scheme.outlineVariant.withValues(alpha: 0.5),
        labelStyle: theme.textTheme.labelSmall!.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        minColor: SoundLevel.quiet.color,
        maxColor: SoundLevel.dangerous.color,
      ),
      size: Size.infinite,
    );
  }
}

class _HistoryPainter extends CustomPainter {
  _HistoryPainter({
    required this.samples,
    required this.window,
    required this.offsetDb,
    required this.minDb,
    required this.maxDb,
    required this.gridColor,
    required this.labelStyle,
    required this.minColor,
    required this.maxColor,
  });

  final List<SoundSample> samples;
  final Duration window;
  final double offsetDb;
  final double? minDb;
  final double? maxDb;
  final Color gridColor;
  final TextStyle labelStyle;
  final Color minColor;
  final Color maxColor;

  static const _gridStep = 20.0;
  static const _labelGutter = 28.0;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTRB(_labelGutter, 6, size.width, size.height - 6);
    double yFor(double db) {
      final t =
          ((db - DecibelHistoryChart.floorDb) /
                  (DecibelHistoryChart.ceilingDb - DecibelHistoryChart.floorDb))
              .clamp(0.0, 1.0);
      return plot.bottom - t * plot.height;
    }

    // Grid with labels.
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (
      double db = DecibelHistoryChart.floorDb;
      db <= DecibelHistoryChart.ceilingDb;
      db += _gridStep
    ) {
      final y = yFor(db);
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), grid);
      final tp = TextPainter(
        text: TextSpan(text: db.round().toString(), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // Hearing-risk threshold.
    _dashed(
      canvas,
      plot,
      yFor(SoundLevel.hearingRiskDb),
      SoundLevel.veryLoud.color.withValues(alpha: 0.7),
      dash: 2,
      gap: 4,
    );

    if (samples.isEmpty) return;

    final end = samples.last.at;
    final windowMs = window.inMilliseconds.toDouble();
    double xFor(DateTime at) {
      final ago = end.difference(at).inMilliseconds.toDouble();
      return plot.right - (ago / windowMs) * plot.width;
    }

    final line = Path();
    for (var i = 0; i < samples.length; i++) {
      final p = Offset(xFor(samples[i].at), yFor(samples[i].db + offsetDb));
      i == 0 ? line.moveTo(p.dx, p.dy) : line.lineTo(p.dx, p.dy);
    }
    final firstX = xFor(samples.first.at);
    final area = Path.from(line)
      ..lineTo(plot.right, plot.bottom)
      ..lineTo(firstX, plot.bottom)
      ..close();

    // Vertical gradient keyed to loudness bands so color matches level.
    final bandStops = <double>[];
    final bandColors = <Color>[];
    for (final level in SoundLevel.values.reversed) {
      final t = ((yFor(level.fromDb) - plot.top) / plot.height).clamp(0.0, 1.0);
      bandStops.add(t);
      bandColors.add(level.color);
    }
    final lineShader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: bandColors,
      stops: bandStops,
    ).createShader(plot);
    final fillShader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [for (final c in bandColors) c.withValues(alpha: 0.28)],
      stops: bandStops,
    ).createShader(plot);

    canvas.save();
    canvas.clipRect(plot);
    canvas.drawPath(area, Paint()..shader = fillShader);
    canvas.drawPath(
      line,
      Paint()
        ..shader = lineShader
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();

    if (minDb != null) {
      _dashed(canvas, plot, yFor(minDb! + offsetDb), minColor);
    }
    if (maxDb != null) {
      _dashed(canvas, plot, yFor(maxDb! + offsetDb), maxColor);
    }
  }

  void _dashed(
    Canvas canvas,
    Rect plot,
    double y,
    Color color, {
    double dash = 6,
    double gap = 4,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4;
    for (double x = plot.left; x < plot.right; x += dash + gap) {
      canvas.drawLine(
        Offset(x, y),
        Offset((x + dash).clamp(plot.left, plot.right), y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_HistoryPainter old) =>
      old.samples != samples ||
      old.offsetDb != offsetDb ||
      old.minDb != minDb ||
      old.maxDb != maxDb ||
      old.gridColor != gridColor ||
      old.labelStyle != labelStyle;
}
