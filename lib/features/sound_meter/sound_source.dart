import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

enum MicPermission { granted, denied, permanentlyDenied }

/// Thin seam over the microphone so the cubit can be tested without a device.
abstract class SoundSource {
  Future<MicPermission> checkPermission();
  Future<MicPermission> requestPermission();

  /// Raw sound levels in dB (before calibration), one per audio buffer.
  Stream<double> decibels();

  Future<bool> openAppSettings();
}

class MicrophoneSoundSource implements SoundSource {
  final NoiseMeter _meter = NoiseMeter();

  static MicPermission _map(ph.PermissionStatus s) {
    if (s.isGranted || s.isLimited) return MicPermission.granted;
    if (s.isPermanentlyDenied || s.isRestricted) {
      return MicPermission.permanentlyDenied;
    }
    return MicPermission.denied;
  }

  @override
  Future<MicPermission> checkPermission() async =>
      _map(await ph.Permission.microphone.status);

  @override
  Future<MicPermission> requestPermission() async =>
      _map(await ph.Permission.microphone.request());

  @override
  Stream<double> decibels() => _meter.noise
      .map((reading) => reading.maxDecibel)
      .where((db) => db.isFinite);

  @override
  Future<bool> openAppSettings() => ph.openAppSettings();
}
