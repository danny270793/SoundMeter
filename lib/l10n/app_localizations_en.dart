// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sound meter';

  @override
  String get settings => 'Settings';

  @override
  String get retry => 'Try again';

  @override
  String get meterPause => 'Pause';

  @override
  String get meterResume => 'Resume';

  @override
  String get meterReset => 'Reset';

  @override
  String get meterResetDone => 'Readings were reset.';

  @override
  String get meterPaused => 'Paused';

  @override
  String get statMin => 'Min';

  @override
  String get statAverage => 'Average';

  @override
  String get statMax => 'Max';

  @override
  String get statPeak => 'Peak';

  @override
  String historyTitle(int seconds) {
    return 'Last $seconds seconds';
  }

  @override
  String get unitDecibel => 'dB';

  @override
  String get levelSilence => 'Near silence';

  @override
  String get levelSilenceExample => 'Threshold of human hearing';

  @override
  String get levelQuiet => 'Quiet';

  @override
  String get levelQuietExample => 'Whisper, rustling leaves';

  @override
  String get levelModerate => 'Moderate';

  @override
  String get levelModerateExample => 'Quiet office, light rain';

  @override
  String get levelNormal => 'Normal';

  @override
  String get levelNormalExample => 'Normal conversation';

  @override
  String get levelLoud => 'Loud';

  @override
  String get levelLoudExample => 'Heavy traffic, vacuum cleaner';

  @override
  String get levelVeryLoud => 'Very loud';

  @override
  String get levelVeryLoudExample => 'Lawnmower, motorcycle';

  @override
  String get levelDangerous => 'Dangerous';

  @override
  String get levelDangerousExample => 'Night club, concert';

  @override
  String get levelPainful => 'Painful';

  @override
  String get levelPainfulExample => 'Jet engine at 100 m';

  @override
  String get hearingWarning =>
      'Prolonged exposure above 85 dB can damage your hearing.';

  @override
  String get micStartingTitle => 'Starting microphone';

  @override
  String get micStartingBody => 'Hold on while we start listening.';

  @override
  String get micDeniedTitle => 'Microphone access needed';

  @override
  String get micDeniedBody =>
      'Sound meter uses the microphone only on this device to measure sound levels. Nothing is recorded.';

  @override
  String get grantPermission => 'Allow microphone';

  @override
  String get micDeniedForeverTitle => 'Microphone access blocked';

  @override
  String get micDeniedForeverBody =>
      'Microphone permission was permanently denied. Enable it from the app settings to continue.';

  @override
  String get openAppSettings => 'Open app settings';

  @override
  String get micErrorTitle => 'Could not read the microphone';

  @override
  String get micErrorBody =>
      'Another app may be using it. Close other recording apps and try again.';

  @override
  String get settingsMeasurementSection => 'Measurement';

  @override
  String get settingsCalibration => 'Calibration';

  @override
  String settingsCalibrationSubtitle(String offset) {
    return 'Offset added to every reading: $offset dB';
  }

  @override
  String get settingsCalibrationHint =>
      'Compare against a reference meter and adjust until both read the same.';

  @override
  String get settingsCalibrationReset => 'Reset to 0';

  @override
  String get settingsKeepScreenOn => 'Keep screen on';

  @override
  String get settingsKeepScreenOnSubtitle =>
      'Prevents the display from sleeping while measuring.';

  @override
  String get settingsAboutTagline =>
      'Measure the sound around you in decibels.';

  @override
  String get settingsAboutBulletLive =>
      'See the live sound level on a clear gauge with a description of how loud it is.';

  @override
  String get settingsAboutBulletHistory =>
      'Follow the last minute of readings on a chart with min, average and max.';

  @override
  String get settingsAboutBulletCalibrate =>
      'Calibrate readings to match a reference sound level meter.';

  @override
  String get settingsAboutDataBody =>
      'Audio from the microphone is processed in real time on your device to compute sound levels. It is never recorded, stored or uploaded.';

  @override
  String get settingsPrivacyTagline =>
      'Your microphone audio stays on your device.';

  @override
  String get settingsPrivacyDataTitle => 'Microphone';

  @override
  String get settingsPrivacyDataBody =>
      'Sound meter listens to the microphone only while the app is open to compute sound levels. Audio is processed in memory and is never recorded, saved or sent anywhere.';

  @override
  String get settingsPrivacyInfraTitle => 'What we store';

  @override
  String get settingsPrivacyInfraBody =>
      'Only your preferences (language, theme, calibration, keep screen on and biometric unlock) are saved on this device. There are no accounts and no servers.';

  @override
  String get settingsPrivacySharingTitle => 'Sharing and ads';

  @override
  String get settingsPrivacySharingBody =>
      'We do not sell your personal information, show ads or use analytics.';

  @override
  String get settingsPrivacyNoticeTitle => 'Changes';

  @override
  String get settingsPrivacyNoticeBody =>
      'This policy may be updated from time to time. Continuing to use the app after changes are published means you accept the updated policy.';

  @override
  String get settingsTermsTagline => 'Rules for using this app.';

  @override
  String get settingsTermsAcceptanceTitle => 'Acceptance';

  @override
  String get settingsTermsAcceptanceBody =>
      'By accessing or using Sound meter, you agree to these terms. If you do not agree, do not use the app.';

  @override
  String get settingsTermsDisclaimerTitle => 'Not a certified instrument';

  @override
  String get settingsTermsDisclaimerBody =>
      'Phone microphones are not calibrated measuring devices. Readings are approximate and must not be used for legal, medical or occupational safety decisions.';

  @override
  String get settingsTermsLiabilityTitle => 'Limitation of liability';

  @override
  String get settingsTermsLiabilityBody =>
      'To the fullest extent permitted by law, the authors and contributors are not liable for any indirect, incidental, special, consequential or punitive damages, or any loss resulting from your use of the app or reliance on its readings.';

  @override
  String get settingsTermsResponsibilitiesTitle => 'Your responsibilities';

  @override
  String get settingsTermsResponsibilitiesBody =>
      'You are responsible for using the app in compliance with the laws that apply to you, including laws about recording or monitoring sound.';

  @override
  String get settingsTermsNoticeTitle => 'Changes';

  @override
  String get settingsTermsNoticeBody =>
      'These terms may be updated from time to time. If you continue to use the app after changes are posted, that indicates you accept the revised terms.';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSpanish => 'Spanish';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System default';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsSecuritySection => 'Security';

  @override
  String get settingsBiometricUnlockTitle => 'Face ID & fingerprint';

  @override
  String get settingsBiometricUnlockSubtitle =>
      'Use biometrics to unlock the app.';

  @override
  String get settingsBiometricUnavailable =>
      'Biometric unlock is not available on this device.';

  @override
  String get settingsBiometricAuthReason =>
      'Confirm to enable biometric unlock.';

  @override
  String get settingsBiometricResumeReason => 'Authenticate to continue.';

  @override
  String get biometricLockTitle => 'App locked';

  @override
  String get biometricLockBody => 'Use Face ID or fingerprint to continue.';

  @override
  String get biometricLockUnlockButton => 'Unlock';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsAboutApp => 'About';

  @override
  String get settingsRateApp => 'Rate on Google Play';

  @override
  String get settingsPrivacyPolicy => 'Privacy policy';

  @override
  String get settingsTermsOfUse => 'Terms of use';

  @override
  String get settingsAboutVersionLabel => 'Version';

  @override
  String get settingsAboutFeaturesHeading => 'What you can do';

  @override
  String get settingsAboutDataHeading => 'Your data';

  @override
  String get settingsAboutDeveloperHeading => 'Developer';

  @override
  String get settingsAboutDeveloperGithub => 'GitHub';

  @override
  String get settingsAboutDeveloperWebsite => 'Website';

  @override
  String get settingsAboutDeveloperYoutube => 'YouTube';

  @override
  String get settingsAboutDeveloperLinkedin => 'LinkedIn';
}
