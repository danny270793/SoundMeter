import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound meter'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @meterPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get meterPause;

  /// No description provided for @meterResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get meterResume;

  /// No description provided for @meterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get meterReset;

  /// No description provided for @meterResetDone.
  ///
  /// In en, this message translates to:
  /// **'Readings were reset.'**
  String get meterResetDone;

  /// No description provided for @meterPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get meterPaused;

  /// No description provided for @statMin.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get statMin;

  /// No description provided for @statAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get statAverage;

  /// No description provided for @statMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get statMax;

  /// No description provided for @statPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get statPeak;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Last {seconds} seconds'**
  String historyTitle(int seconds);

  /// No description provided for @unitDecibel.
  ///
  /// In en, this message translates to:
  /// **'dB'**
  String get unitDecibel;

  /// No description provided for @levelSilence.
  ///
  /// In en, this message translates to:
  /// **'Near silence'**
  String get levelSilence;

  /// No description provided for @levelSilenceExample.
  ///
  /// In en, this message translates to:
  /// **'Threshold of human hearing'**
  String get levelSilenceExample;

  /// No description provided for @levelQuiet.
  ///
  /// In en, this message translates to:
  /// **'Quiet'**
  String get levelQuiet;

  /// No description provided for @levelQuietExample.
  ///
  /// In en, this message translates to:
  /// **'Whisper, rustling leaves'**
  String get levelQuietExample;

  /// No description provided for @levelModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get levelModerate;

  /// No description provided for @levelModerateExample.
  ///
  /// In en, this message translates to:
  /// **'Quiet office, light rain'**
  String get levelModerateExample;

  /// No description provided for @levelNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get levelNormal;

  /// No description provided for @levelNormalExample.
  ///
  /// In en, this message translates to:
  /// **'Normal conversation'**
  String get levelNormalExample;

  /// No description provided for @levelLoud.
  ///
  /// In en, this message translates to:
  /// **'Loud'**
  String get levelLoud;

  /// No description provided for @levelLoudExample.
  ///
  /// In en, this message translates to:
  /// **'Heavy traffic, vacuum cleaner'**
  String get levelLoudExample;

  /// No description provided for @levelVeryLoud.
  ///
  /// In en, this message translates to:
  /// **'Very loud'**
  String get levelVeryLoud;

  /// No description provided for @levelVeryLoudExample.
  ///
  /// In en, this message translates to:
  /// **'Lawnmower, motorcycle'**
  String get levelVeryLoudExample;

  /// No description provided for @levelDangerous.
  ///
  /// In en, this message translates to:
  /// **'Dangerous'**
  String get levelDangerous;

  /// No description provided for @levelDangerousExample.
  ///
  /// In en, this message translates to:
  /// **'Night club, concert'**
  String get levelDangerousExample;

  /// No description provided for @levelPainful.
  ///
  /// In en, this message translates to:
  /// **'Painful'**
  String get levelPainful;

  /// No description provided for @levelPainfulExample.
  ///
  /// In en, this message translates to:
  /// **'Jet engine at 100 m'**
  String get levelPainfulExample;

  /// No description provided for @hearingWarning.
  ///
  /// In en, this message translates to:
  /// **'Prolonged exposure above 85 dB can damage your hearing.'**
  String get hearingWarning;

  /// No description provided for @micStartingTitle.
  ///
  /// In en, this message translates to:
  /// **'Starting microphone'**
  String get micStartingTitle;

  /// No description provided for @micStartingBody.
  ///
  /// In en, this message translates to:
  /// **'Hold on while we start listening.'**
  String get micStartingBody;

  /// No description provided for @micDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone access needed'**
  String get micDeniedTitle;

  /// No description provided for @micDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'Sound meter uses the microphone only on this device to measure sound levels. Nothing is recorded.'**
  String get micDeniedBody;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow microphone'**
  String get grantPermission;

  /// No description provided for @micDeniedForeverTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone access blocked'**
  String get micDeniedForeverTitle;

  /// No description provided for @micDeniedForeverBody.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission was permanently denied. Enable it from the app settings to continue.'**
  String get micDeniedForeverBody;

  /// No description provided for @openAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Open app settings'**
  String get openAppSettings;

  /// No description provided for @micErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not read the microphone'**
  String get micErrorTitle;

  /// No description provided for @micErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Another app may be using it. Close other recording apps and try again.'**
  String get micErrorBody;

  /// No description provided for @settingsMeasurementSection.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get settingsMeasurementSection;

  /// No description provided for @settingsCalibration.
  ///
  /// In en, this message translates to:
  /// **'Calibration'**
  String get settingsCalibration;

  /// No description provided for @settingsCalibrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Offset added to every reading: {offset} dB'**
  String settingsCalibrationSubtitle(String offset);

  /// No description provided for @settingsCalibrationHint.
  ///
  /// In en, this message translates to:
  /// **'Compare against a reference meter and adjust until both read the same.'**
  String get settingsCalibrationHint;

  /// No description provided for @settingsCalibrationReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to 0'**
  String get settingsCalibrationReset;

  /// No description provided for @settingsKeepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Keep screen on'**
  String get settingsKeepScreenOn;

  /// No description provided for @settingsKeepScreenOnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prevents the display from sleeping while measuring.'**
  String get settingsKeepScreenOnSubtitle;

  /// No description provided for @settingsAboutTagline.
  ///
  /// In en, this message translates to:
  /// **'Measure the sound around you in decibels.'**
  String get settingsAboutTagline;

  /// No description provided for @settingsAboutBulletLive.
  ///
  /// In en, this message translates to:
  /// **'See the live sound level on a clear gauge with a description of how loud it is.'**
  String get settingsAboutBulletLive;

  /// No description provided for @settingsAboutBulletHistory.
  ///
  /// In en, this message translates to:
  /// **'Follow the last minute of readings on a chart with min, average and max.'**
  String get settingsAboutBulletHistory;

  /// No description provided for @settingsAboutBulletCalibrate.
  ///
  /// In en, this message translates to:
  /// **'Calibrate readings to match a reference sound level meter.'**
  String get settingsAboutBulletCalibrate;

  /// No description provided for @settingsAboutDataBody.
  ///
  /// In en, this message translates to:
  /// **'Audio from the microphone is processed in real time on your device to compute sound levels. It is never recorded, stored or uploaded.'**
  String get settingsAboutDataBody;

  /// No description provided for @settingsPrivacyTagline.
  ///
  /// In en, this message translates to:
  /// **'Your microphone audio stays on your device.'**
  String get settingsPrivacyTagline;

  /// No description provided for @settingsPrivacyDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get settingsPrivacyDataTitle;

  /// No description provided for @settingsPrivacyDataBody.
  ///
  /// In en, this message translates to:
  /// **'Sound meter listens to the microphone only while the app is open to compute sound levels. Audio is processed in memory and is never recorded, saved or sent anywhere.'**
  String get settingsPrivacyDataBody;

  /// No description provided for @settingsPrivacyInfraTitle.
  ///
  /// In en, this message translates to:
  /// **'What we store'**
  String get settingsPrivacyInfraTitle;

  /// No description provided for @settingsPrivacyInfraBody.
  ///
  /// In en, this message translates to:
  /// **'Only your preferences (language, theme, calibration, keep screen on and biometric unlock) are saved on this device. There are no accounts and no servers.'**
  String get settingsPrivacyInfraBody;

  /// No description provided for @settingsPrivacySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'Sharing and ads'**
  String get settingsPrivacySharingTitle;

  /// No description provided for @settingsPrivacySharingBody.
  ///
  /// In en, this message translates to:
  /// **'We do not sell your personal information, show ads or use analytics.'**
  String get settingsPrivacySharingBody;

  /// No description provided for @settingsPrivacyNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Changes'**
  String get settingsPrivacyNoticeTitle;

  /// No description provided for @settingsPrivacyNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'This policy may be updated from time to time. Continuing to use the app after changes are published means you accept the updated policy.'**
  String get settingsPrivacyNoticeBody;

  /// No description provided for @settingsTermsTagline.
  ///
  /// In en, this message translates to:
  /// **'Rules for using this app.'**
  String get settingsTermsTagline;

  /// No description provided for @settingsTermsAcceptanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Acceptance'**
  String get settingsTermsAcceptanceTitle;

  /// No description provided for @settingsTermsAcceptanceBody.
  ///
  /// In en, this message translates to:
  /// **'By accessing or using Sound meter, you agree to these terms. If you do not agree, do not use the app.'**
  String get settingsTermsAcceptanceBody;

  /// No description provided for @settingsTermsDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Not a certified instrument'**
  String get settingsTermsDisclaimerTitle;

  /// No description provided for @settingsTermsDisclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'Phone microphones are not calibrated measuring devices. Readings are approximate and must not be used for legal, medical or occupational safety decisions.'**
  String get settingsTermsDisclaimerBody;

  /// No description provided for @settingsTermsLiabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Limitation of liability'**
  String get settingsTermsLiabilityTitle;

  /// No description provided for @settingsTermsLiabilityBody.
  ///
  /// In en, this message translates to:
  /// **'To the fullest extent permitted by law, the authors and contributors are not liable for any indirect, incidental, special, consequential or punitive damages, or any loss resulting from your use of the app or reliance on its readings.'**
  String get settingsTermsLiabilityBody;

  /// No description provided for @settingsTermsResponsibilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your responsibilities'**
  String get settingsTermsResponsibilitiesTitle;

  /// No description provided for @settingsTermsResponsibilitiesBody.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for using the app in compliance with the laws that apply to you, including laws about recording or monitoring sound.'**
  String get settingsTermsResponsibilitiesBody;

  /// No description provided for @settingsTermsNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Changes'**
  String get settingsTermsNoticeTitle;

  /// No description provided for @settingsTermsNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'These terms may be updated from time to time. If you continue to use the app after changes are posted, that indicates you accept the revised terms.'**
  String get settingsTermsNoticeBody;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get settingsLanguageSpanish;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsSecuritySection.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecuritySection;

  /// No description provided for @settingsBiometricUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Face ID & fingerprint'**
  String get settingsBiometricUnlockTitle;

  /// No description provided for @settingsBiometricUnlockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics to unlock the app.'**
  String get settingsBiometricUnlockSubtitle;

  /// No description provided for @settingsBiometricUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric unlock is not available on this device.'**
  String get settingsBiometricUnavailable;

  /// No description provided for @settingsBiometricAuthReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm to enable biometric unlock.'**
  String get settingsBiometricAuthReason;

  /// No description provided for @settingsBiometricResumeReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to continue.'**
  String get settingsBiometricResumeReason;

  /// No description provided for @biometricLockTitle.
  ///
  /// In en, this message translates to:
  /// **'App locked'**
  String get biometricLockTitle;

  /// No description provided for @biometricLockBody.
  ///
  /// In en, this message translates to:
  /// **'Use Face ID or fingerprint to continue.'**
  String get biometricLockBody;

  /// No description provided for @biometricLockUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get biometricLockUnlockButton;

  /// No description provided for @settingsAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutSection;

  /// No description provided for @settingsAboutApp.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutApp;

  /// No description provided for @settingsRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate on Google Play'**
  String get settingsRateApp;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get settingsTermsOfUse;

  /// No description provided for @settingsAboutVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsAboutVersionLabel;

  /// No description provided for @settingsAboutFeaturesHeading.
  ///
  /// In en, this message translates to:
  /// **'What you can do'**
  String get settingsAboutFeaturesHeading;

  /// No description provided for @settingsAboutDataHeading.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get settingsAboutDataHeading;

  /// No description provided for @settingsAboutDeveloperHeading.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get settingsAboutDeveloperHeading;

  /// No description provided for @settingsAboutDeveloperGithub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get settingsAboutDeveloperGithub;

  /// No description provided for @settingsAboutDeveloperWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get settingsAboutDeveloperWebsite;

  /// No description provided for @settingsAboutDeveloperYoutube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get settingsAboutDeveloperYoutube;

  /// No description provided for @settingsAboutDeveloperLinkedin.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get settingsAboutDeveloperLinkedin;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
