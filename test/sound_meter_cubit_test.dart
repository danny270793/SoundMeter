import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:soundmeter/features/sound_meter/sound_level.dart';
import 'package:soundmeter/features/sound_meter/sound_meter_cubit.dart';
import 'package:soundmeter/features/sound_meter/sound_meter_state.dart';
import 'package:soundmeter/features/sound_meter/sound_source.dart';

class _FakeSoundSource implements SoundSource {
  _FakeSoundSource({
    this.permission = MicPermission.granted,
    this.requestResult,
  });

  MicPermission permission;
  MicPermission? requestResult;
  StreamController<double> controller = StreamController<double>();
  int listens = 0;

  @override
  Future<MicPermission> checkPermission() async => permission;

  @override
  Future<MicPermission> requestPermission() async =>
      requestResult ?? permission;

  @override
  Stream<double> decibels() {
    listens++;
    controller = StreamController<double>();
    return controller.stream;
  }

  @override
  Future<bool> openAppSettings() async => true;
}

/// Clock that advances [step] each time it is read.
DateTime Function() _clock({
  Duration step = const Duration(milliseconds: 150),
}) {
  var t = DateTime(2026, 1, 1, 12);
  return () => t = t.add(step);
}

void main() {
  group('SoundMeterCubit', () {
    test('requests permission and reports permanent denial', () async {
      final cubit = SoundMeterCubit(
        _FakeSoundSource(
          permission: MicPermission.denied,
          requestResult: MicPermission.permanentlyDenied,
        ),
      );
      await cubit.start();
      expect(cubit.state.status, SoundMeterStatus.permissionDeniedForever);
      await cubit.close();
    });

    test('tracks current, min, max and energy average', () async {
      final source = _FakeSoundSource();
      final cubit = SoundMeterCubit(source, now: _clock());
      await cubit.start();
      expect(cubit.state.status, SoundMeterStatus.listening);

      for (final db in [40.0, 60.0, 50.0]) {
        source.controller.add(db);
      }
      await pumpEventQueue();

      final s = cubit.state;
      expect(s.currentDb, 50);
      expect(s.minDb, 40);
      expect(s.maxDb, 60);
      // Leq of 40/60/50 dB is dominated by the loudest reading.
      expect(s.averageDb, closeTo(55.68, 0.01));
      expect(s.history, hasLength(3));
      await cubit.close();
    });

    test('collapses fast readings into one bucket keeping the peak', () async {
      final source = _FakeSoundSource();
      final cubit = SoundMeterCubit(
        source,
        now: _clock(step: const Duration(milliseconds: 20)),
      );
      await cubit.start();

      // First reading emits immediately, the next four fall in one bucket.
      for (final db in [30.0, 45.0, 70.0, 50.0, 40.0, 35.0]) {
        source.controller.add(db);
      }
      await pumpEventQueue();

      expect(cubit.state.history.map((e) => e.db), [30, 70]);
      expect(cubit.state.maxDb, 70);
      await cubit.close();
    });

    test('pause releases the microphone and resume listens again', () async {
      final source = _FakeSoundSource();
      final cubit = SoundMeterCubit(source, now: _clock());
      await cubit.start();
      expect(source.listens, 1);

      cubit.togglePause();
      expect(cubit.state.paused, isTrue);
      expect(source.controller.hasListener, isFalse);

      cubit.togglePause();
      expect(cubit.state.paused, isFalse);
      expect(source.listens, 2);
      await cubit.close();
    });

    test('reset clears readings but keeps listening', () async {
      final source = _FakeSoundSource();
      final cubit = SoundMeterCubit(source, now: _clock());
      await cubit.start();
      source.controller.add(80);
      await pumpEventQueue();
      cubit.reset();

      expect(cubit.state.status, SoundMeterStatus.listening);
      expect(cubit.state.hasReadings, isFalse);
      expect(cubit.state.history, isEmpty);

      source.controller.add(42);
      await pumpEventQueue();
      expect(cubit.state.averageDb, closeTo(42, 1e-9));
      await cubit.close();
    });

    test('stream errors surface as an error state', () async {
      final source = _FakeSoundSource();
      final cubit = SoundMeterCubit(source, now: _clock());
      await cubit.start();
      source.controller.addError(Exception('mic busy'));
      await pumpEventQueue();
      expect(cubit.state.status, SoundMeterStatus.error);
      await cubit.close();
    });
  });

  group('SoundLevel', () {
    test('maps readings to loudness bands', () {
      expect(SoundLevel.of(-5), SoundLevel.silence);
      expect(SoundLevel.of(10), SoundLevel.silence);
      expect(SoundLevel.of(60), SoundLevel.normal);
      expect(SoundLevel.of(85), SoundLevel.veryLoud);
      expect(SoundLevel.of(130), SoundLevel.painful);
    });
  });
}
