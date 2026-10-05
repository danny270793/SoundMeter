import 'package:equatable/equatable.dart';

enum SoundMeterStatus {
  checking,
  permissionDenied,
  permissionDeniedForever,
  error,
  listening,
}

/// One point on the history chart: the loudest reading within its time bucket.
class SoundSample extends Equatable {
  const SoundSample(this.at, this.db);

  final DateTime at;
  final double db;

  @override
  List<Object?> get props => [at, db];
}

/// All levels are raw dB; the calibration offset is applied at display time
/// so changing it shifts every value (including history) consistently.
class SoundMeterState extends Equatable {
  const SoundMeterState({
    this.status = SoundMeterStatus.checking,
    this.paused = false,
    this.currentDb,
    this.minDb,
    this.maxDb,
    this.averageDb,
    this.history = const [],
  });

  final SoundMeterStatus status;
  final bool paused;
  final double? currentDb;
  final double? minDb;
  final double? maxDb;

  /// Energy average (Leq) of every reading since the last reset.
  final double? averageDb;
  final List<SoundSample> history;

  bool get hasReadings => currentDb != null;

  SoundMeterState copyWith({
    SoundMeterStatus? status,
    bool? paused,
    double? currentDb,
    double? minDb,
    double? maxDb,
    double? averageDb,
    List<SoundSample>? history,
  }) => SoundMeterState(
    status: status ?? this.status,
    paused: paused ?? this.paused,
    currentDb: currentDb ?? this.currentDb,
    minDb: minDb ?? this.minDb,
    maxDb: maxDb ?? this.maxDb,
    averageDb: averageDb ?? this.averageDb,
    history: history ?? this.history,
  );

  @override
  List<Object?> get props => [
    status,
    paused,
    currentDb,
    minDb,
    maxDb,
    averageDb,
    history,
  ];
}
