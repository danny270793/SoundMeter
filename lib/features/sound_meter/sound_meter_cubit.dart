import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'sound_meter_state.dart';
import 'sound_source.dart';

class SoundMeterCubit extends Cubit<SoundMeterState> {
  SoundMeterCubit(this._source, {DateTime Function()? now})
    : _now = now ?? DateTime.now,
      super(const SoundMeterState());

  final SoundSource _source;
  final DateTime Function() _now;
  StreamSubscription<double>? _sub;

  /// Readings arrive per audio buffer (tens per second); the UI and history
  /// are updated once per bucket with the loudest reading in it.
  static const bucket = Duration(milliseconds: 100);

  /// How much history the chart keeps.
  static const historyWindow = Duration(seconds: 60);

  DateTime? _bucketStart;
  double? _bucketMax;
  double _energySum = 0;
  int _count = 0;

  Future<void> start() async {
    var permission = await _source.checkPermission();
    if (permission == MicPermission.denied) {
      permission = await _source.requestPermission();
    }
    if (isClosed) return;

    switch (permission) {
      case MicPermission.denied:
        emit(state.copyWith(status: SoundMeterStatus.permissionDenied));
      case MicPermission.permanentlyDenied:
        emit(state.copyWith(status: SoundMeterStatus.permissionDeniedForever));
      case MicPermission.granted:
        emit(state.copyWith(status: SoundMeterStatus.listening));
        if (!state.paused) _listen();
    }
  }

  void _listen() {
    if (_sub != null) return;
    _sub = _source.decibels().listen(
      _onReading,
      onError: (_) {
        _stopListening();
        if (!isClosed) emit(state.copyWith(status: SoundMeterStatus.error));
      },
    );
  }

  void _stopListening() {
    unawaited(_sub?.cancel());
    _sub = null;
    _bucketStart = null;
    _bucketMax = null;
  }

  void _onReading(double db) {
    final level = db.clamp(0, 194).toDouble();
    _energySum += math.pow(10, level / 10);
    _count++;

    final now = _now();
    _bucketStart ??= now;
    _bucketMax = math.max(_bucketMax ?? level, level);
    if (now.difference(_bucketStart!) < bucket && state.hasReadings) return;

    final peak = _bucketMax!;
    _bucketStart = now;
    _bucketMax = null;

    final cutoff = now.subtract(historyWindow);
    final history = [
      for (final s in state.history)
        if (s.at.isAfter(cutoff)) s,
      SoundSample(now, peak),
    ];

    emit(
      state.copyWith(
        currentDb: peak,
        minDb: math.min(state.minDb ?? peak, peak),
        maxDb: math.max(state.maxDb ?? peak, peak),
        averageDb: 10 * math.log(_energySum / _count) / math.ln10,
        history: history,
      ),
    );
  }

  /// Pauses or resumes listening; paused releases the microphone.
  void togglePause() {
    if (state.paused) {
      emit(state.copyWith(paused: false));
      if (state.status == SoundMeterStatus.listening) _listen();
    } else {
      _stopListening();
      emit(state.copyWith(paused: true));
    }
  }

  /// Releases the microphone while the app is in the background.
  void suspend() => _stopListening();

  void resumeIfActive() {
    if (state.status == SoundMeterStatus.listening && !state.paused) _listen();
  }

  void reset() {
    _energySum = 0;
    _count = 0;
    _bucketStart = null;
    _bucketMax = null;
    emit(SoundMeterState(status: state.status, paused: state.paused));
  }

  Future<void> openAppSettings() => _source.openAppSettings();

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
