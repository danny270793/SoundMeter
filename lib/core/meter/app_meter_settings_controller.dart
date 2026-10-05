import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted measurement preferences: calibration offset and keep-screen-on.
class AppMeterSettingsController extends ChangeNotifier {
  AppMeterSettingsController();

  static const _calibrationKey = 'app_meter_calibration_db';
  static const _keepScreenOnKey = 'app_meter_keep_screen_on';

  /// Allowed calibration range, in dB.
  static const double minCalibration = -20;
  static const double maxCalibration = 20;

  double _calibrationDb = 0;
  bool _keepScreenOn = true;

  /// Added to every raw reading to compensate for the device microphone.
  double get calibrationDb => _calibrationDb;

  bool get keepScreenOn => _keepScreenOn;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _calibrationDb = (prefs.getDouble(_calibrationKey) ?? 0).clamp(
      minCalibration,
      maxCalibration,
    );
    _keepScreenOn = prefs.getBool(_keepScreenOnKey) ?? true;
    notifyListeners();
  }

  Future<void> setCalibrationDb(double value) async {
    final next = value.clamp(minCalibration, maxCalibration).toDouble();
    if (_calibrationDb == next) return;
    _calibrationDb = next;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_calibrationKey, next);
  }

  Future<void> setKeepScreenOn(bool value) async {
    if (_keepScreenOn == value) return;
    _keepScreenOn = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keepScreenOnKey, value);
  }
}
