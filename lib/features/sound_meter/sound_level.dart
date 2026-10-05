import 'package:flutter/material.dart';
import 'package:soundmeter/l10n/app_localizations.dart';

/// Loudness bands with an everyday example, used to describe a reading.
enum SoundLevel {
  silence(0, Color(0xFF26A69A)),
  quiet(20, Color(0xFF43A047)),
  moderate(40, Color(0xFF7CB342)),
  normal(55, Color(0xFFC0CA33)),
  loud(70, Color(0xFFFFB300)),
  veryLoud(85, Color(0xFFFB8C00)),
  dangerous(100, Color(0xFFE53935)),
  painful(120, Color(0xFFB71C1C));

  const SoundLevel(this.fromDb, this.color);

  /// Lower bound of the band, inclusive.
  final double fromDb;
  final Color color;

  /// Readings at or above this level can damage hearing over time.
  static const double hearingRiskDb = 85;

  static SoundLevel of(double db) {
    for (final level in values.reversed) {
      if (db >= level.fromDb) return level;
    }
    return silence;
  }

  String name(AppLocalizations l10n) => switch (this) {
    silence => l10n.levelSilence,
    quiet => l10n.levelQuiet,
    moderate => l10n.levelModerate,
    normal => l10n.levelNormal,
    loud => l10n.levelLoud,
    veryLoud => l10n.levelVeryLoud,
    dangerous => l10n.levelDangerous,
    painful => l10n.levelPainful,
  };

  String example(AppLocalizations l10n) => switch (this) {
    silence => l10n.levelSilenceExample,
    quiet => l10n.levelQuietExample,
    moderate => l10n.levelModerateExample,
    normal => l10n.levelNormalExample,
    loud => l10n.levelLoudExample,
    veryLoud => l10n.levelVeryLoudExample,
    dangerous => l10n.levelDangerousExample,
    painful => l10n.levelPainfulExample,
  };

  IconData get icon => switch (this) {
    silence => Icons.volume_off_rounded,
    quiet => Icons.volume_mute_rounded,
    moderate || normal => Icons.volume_down_rounded,
    loud || veryLoud => Icons.volume_up_rounded,
    dangerous || painful => Icons.hearing_disabled_rounded,
  };
}
