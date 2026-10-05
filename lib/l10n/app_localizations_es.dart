// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Sonómetro';

  @override
  String get settings => 'Ajustes';

  @override
  String get retry => 'Reintentar';

  @override
  String get meterPause => 'Pausar';

  @override
  String get meterResume => 'Reanudar';

  @override
  String get meterReset => 'Reiniciar';

  @override
  String get meterResetDone => 'Se reiniciaron las lecturas.';

  @override
  String get meterPaused => 'En pausa';

  @override
  String get statMin => 'Mín';

  @override
  String get statAverage => 'Promedio';

  @override
  String get statMax => 'Máx';

  @override
  String get statPeak => 'Pico';

  @override
  String historyTitle(int seconds) {
    return 'Últimos $seconds segundos';
  }

  @override
  String get unitDecibel => 'dB';

  @override
  String get levelSilence => 'Casi silencio';

  @override
  String get levelSilenceExample => 'Umbral de la audición humana';

  @override
  String get levelQuiet => 'Tranquilo';

  @override
  String get levelQuietExample => 'Susurro, hojas moviéndose';

  @override
  String get levelModerate => 'Moderado';

  @override
  String get levelModerateExample => 'Oficina tranquila, lluvia ligera';

  @override
  String get levelNormal => 'Normal';

  @override
  String get levelNormalExample => 'Conversación normal';

  @override
  String get levelLoud => 'Fuerte';

  @override
  String get levelLoudExample => 'Tráfico pesado, aspiradora';

  @override
  String get levelVeryLoud => 'Muy fuerte';

  @override
  String get levelVeryLoudExample => 'Cortadora de césped, motocicleta';

  @override
  String get levelDangerous => 'Peligroso';

  @override
  String get levelDangerousExample => 'Discoteca, concierto';

  @override
  String get levelPainful => 'Doloroso';

  @override
  String get levelPainfulExample => 'Motor de avión a 100 m';

  @override
  String get hearingWarning =>
      'La exposición prolongada a más de 85 dB puede dañar tu audición.';

  @override
  String get micStartingTitle => 'Iniciando micrófono';

  @override
  String get micStartingBody => 'Espera mientras empezamos a escuchar.';

  @override
  String get micDeniedTitle => 'Se necesita acceso al micrófono';

  @override
  String get micDeniedBody =>
      'Sonómetro usa el micrófono solo en este dispositivo para medir el nivel de sonido. No se graba nada.';

  @override
  String get grantPermission => 'Permitir micrófono';

  @override
  String get micDeniedForeverTitle => 'Acceso al micrófono bloqueado';

  @override
  String get micDeniedForeverBody =>
      'El permiso del micrófono fue denegado permanentemente. Actívalo desde los ajustes de la app para continuar.';

  @override
  String get openAppSettings => 'Abrir ajustes de la app';

  @override
  String get micErrorTitle => 'No se pudo leer el micrófono';

  @override
  String get micErrorBody =>
      'Puede que otra app lo esté usando. Cierra otras apps de grabación e inténtalo de nuevo.';

  @override
  String get settingsMeasurementSection => 'Medición';

  @override
  String get settingsCalibration => 'Calibración';

  @override
  String settingsCalibrationSubtitle(String offset) {
    return 'Ajuste sumado a cada lectura: $offset dB';
  }

  @override
  String get settingsCalibrationHint =>
      'Compara con un medidor de referencia y ajusta hasta que ambos coincidan.';

  @override
  String get settingsCalibrationReset => 'Restablecer a 0';

  @override
  String get settingsKeepScreenOn => 'Mantener pantalla encendida';

  @override
  String get settingsKeepScreenOnSubtitle =>
      'Evita que la pantalla se apague mientras mides.';

  @override
  String get settingsAboutTagline =>
      'Mide el sonido a tu alrededor en decibelios.';

  @override
  String get settingsAboutBulletLive =>
      'Ve el nivel de sonido en vivo en un indicador claro con una descripción de su intensidad.';

  @override
  String get settingsAboutBulletHistory =>
      'Sigue el último minuto de lecturas en un gráfico con mínimo, promedio y máximo.';

  @override
  String get settingsAboutBulletCalibrate =>
      'Calibra las lecturas para que coincidan con un sonómetro de referencia.';

  @override
  String get settingsAboutDataBody =>
      'El audio del micrófono se procesa en tiempo real en tu dispositivo para calcular el nivel de sonido. Nunca se graba, guarda ni sube.';

  @override
  String get settingsPrivacyTagline =>
      'El audio de tu micrófono se queda en tu dispositivo.';

  @override
  String get settingsPrivacyDataTitle => 'Micrófono';

  @override
  String get settingsPrivacyDataBody =>
      'Sonómetro escucha el micrófono solo mientras la app está abierta para calcular el nivel de sonido. El audio se procesa en memoria y nunca se graba, guarda ni envía.';

  @override
  String get settingsPrivacyInfraTitle => 'Qué guardamos';

  @override
  String get settingsPrivacyInfraBody =>
      'Solo se guardan tus preferencias (idioma, tema, calibración, pantalla encendida y desbloqueo biométrico) en este dispositivo. No hay cuentas ni servidores.';

  @override
  String get settingsPrivacySharingTitle => 'Compartir y anuncios';

  @override
  String get settingsPrivacySharingBody =>
      'No vendemos tu información personal, no mostramos anuncios ni usamos analíticas.';

  @override
  String get settingsPrivacyNoticeTitle => 'Cambios';

  @override
  String get settingsPrivacyNoticeBody =>
      'Esta política puede actualizarse ocasionalmente. Si sigues usando la app después de publicarse los cambios, aceptas la política actualizada.';

  @override
  String get settingsTermsTagline => 'Reglas para usar esta app.';

  @override
  String get settingsTermsAcceptanceTitle => 'Aceptación';

  @override
  String get settingsTermsAcceptanceBody =>
      'Al acceder o usar Sonómetro, aceptas estos términos. Si no estás de acuerdo, no uses la app.';

  @override
  String get settingsTermsDisclaimerTitle => 'No es un instrumento certificado';

  @override
  String get settingsTermsDisclaimerBody =>
      'Los micrófonos de los teléfonos no son instrumentos de medición calibrados. Las lecturas son aproximadas y no deben usarse para decisiones legales, médicas o de seguridad laboral.';

  @override
  String get settingsTermsLiabilityTitle => 'Limitación de responsabilidad';

  @override
  String get settingsTermsLiabilityBody =>
      'En la máxima medida permitida por la ley, los autores y colaboradores no son responsables de daños indirectos, incidentales, especiales, consecuentes o punitivos, ni de pérdidas derivadas del uso de la app o de la confianza en sus lecturas.';

  @override
  String get settingsTermsResponsibilitiesTitle => 'Tus responsabilidades';

  @override
  String get settingsTermsResponsibilitiesBody =>
      'Eres responsable de usar la app conforme a las leyes que te apliquen, incluidas las leyes sobre grabación o monitoreo de sonido.';

  @override
  String get settingsTermsNoticeTitle => 'Cambios';

  @override
  String get settingsTermsNoticeBody =>
      'Estos términos pueden actualizarse ocasionalmente. Si sigues usando la app después de publicarse los cambios, aceptas los términos revisados.';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Predeterminado del sistema';

  @override
  String get settingsLanguageEnglish => 'Inglés';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Predeterminado del sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsSecuritySection => 'Seguridad';

  @override
  String get settingsBiometricUnlockTitle => 'Face ID y huella digital';

  @override
  String get settingsBiometricUnlockSubtitle =>
      'Usa biometría para desbloquear la app.';

  @override
  String get settingsBiometricUnavailable =>
      'El desbloqueo biométrico no está disponible en este dispositivo.';

  @override
  String get settingsBiometricAuthReason =>
      'Confirma para activar el desbloqueo biométrico.';

  @override
  String get settingsBiometricResumeReason => 'Autentícate para continuar.';

  @override
  String get biometricLockTitle => 'App bloqueada';

  @override
  String get biometricLockBody =>
      'Usa Face ID o tu huella digital para continuar.';

  @override
  String get biometricLockUnlockButton => 'Desbloquear';

  @override
  String get settingsAboutSection => 'Acerca de';

  @override
  String get settingsAboutApp => 'Acerca de';

  @override
  String get settingsRateApp => 'Calificar en Google Play';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidad';

  @override
  String get settingsTermsOfUse => 'Términos de uso';

  @override
  String get settingsAboutVersionLabel => 'Versión';

  @override
  String get settingsAboutFeaturesHeading => 'Qué puedes hacer';

  @override
  String get settingsAboutDataHeading => 'Tus datos';

  @override
  String get settingsAboutDeveloperHeading => 'Desarrollador';

  @override
  String get settingsAboutDeveloperGithub => 'GitHub';

  @override
  String get settingsAboutDeveloperWebsite => 'Sitio web';

  @override
  String get settingsAboutDeveloperYoutube => 'YouTube';

  @override
  String get settingsAboutDeveloperLinkedin => 'LinkedIn';
}
