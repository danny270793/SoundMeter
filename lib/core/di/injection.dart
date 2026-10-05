import 'package:get_it/get_it.dart';

import '../locale/app_locale_controller.dart';
import '../meter/app_meter_settings_controller.dart';
import '../security/app_biometric_unlock_controller.dart';
import '../theme/app_theme_controller.dart';
import '../../features/sound_meter/sound_meter_cubit.dart';
import '../../features/sound_meter/sound_source.dart';

final getIt = GetIt.instance;

void setupDi() {
  getIt.registerLazySingleton<AppLocaleController>(AppLocaleController.new);
  getIt.registerLazySingleton<AppThemeController>(AppThemeController.new);
  getIt.registerLazySingleton<AppMeterSettingsController>(
    AppMeterSettingsController.new,
  );
  getIt.registerLazySingleton<AppBiometricUnlockController>(
    AppBiometricUnlockController.new,
  );

  // sound meter
  getIt.registerLazySingleton<SoundSource>(MicrophoneSoundSource.new);
  getIt.registerFactory<SoundMeterCubit>(
    () => SoundMeterCubit(getIt<SoundSource>()),
  );
}
