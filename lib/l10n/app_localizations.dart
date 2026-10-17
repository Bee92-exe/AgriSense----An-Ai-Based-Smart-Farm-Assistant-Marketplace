import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
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
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

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
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In bn, this message translates to:
  /// **'AgriSense'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In bn, this message translates to:
  /// **'পকেটে আপনার কৃষি উপদেষ্টা'**
  String get appTagline;

  /// No description provided for @actionRetry.
  ///
  /// In bn, this message translates to:
  /// **'আবার চেষ্টা করুন'**
  String get actionRetry;

  /// No description provided for @actionCancel.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল করুন'**
  String get actionCancel;

  /// No description provided for @actionConfirm.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিত করুন'**
  String get actionConfirm;

  /// No description provided for @actionSave.
  ///
  /// In bn, this message translates to:
  /// **'সংরক্ষণ করুন'**
  String get actionSave;

  /// No description provided for @actionNext.
  ///
  /// In bn, this message translates to:
  /// **'পরবর্তী'**
  String get actionNext;

  /// No description provided for @actionBack.
  ///
  /// In bn, this message translates to:
  /// **'পিছনে যান'**
  String get actionBack;

  /// No description provided for @actionClose.
  ///
  /// In bn, this message translates to:
  /// **'বন্ধ করুন'**
  String get actionClose;

  /// No description provided for @actionSearch.
  ///
  /// In bn, this message translates to:
  /// **'খুঁজুন'**
  String get actionSearch;

  /// No description provided for @actionSeeAll.
  ///
  /// In bn, this message translates to:
  /// **'সব দেখুন'**
  String get actionSeeAll;

  /// No description provided for @actionReadAloud.
  ///
  /// In bn, this message translates to:
  /// **'পড়ে শোনান'**
  String get actionReadAloud;

  /// No description provided for @actionStopReading.
  ///
  /// In bn, this message translates to:
  /// **'পড়া থামান'**
  String get actionStopReading;

  /// No description provided for @stateLoading.
  ///
  /// In bn, this message translates to:
  /// **'একটু অপেক্ষা করুন…'**
  String get stateLoading;

  /// No description provided for @stateEmptyTitle.
  ///
  /// In bn, this message translates to:
  /// **'এখন কিছু নেই'**
  String get stateEmptyTitle;

  /// No description provided for @stateEmptyBody.
  ///
  /// In bn, this message translates to:
  /// **'নতুন কিছু এলে এখানে দেখা যাবে।'**
  String get stateEmptyBody;

  /// No description provided for @stateErrorTitle.
  ///
  /// In bn, this message translates to:
  /// **'কিছু একটা ভুল হয়েছে'**
  String get stateErrorTitle;

  /// No description provided for @stateErrorBody.
  ///
  /// In bn, this message translates to:
  /// **'আবার চেষ্টা করুন। সমস্যা থেকে গেলে পরে আবার দেখুন।'**
  String get stateErrorBody;

  /// No description provided for @statePermissionTitle.
  ///
  /// In bn, this message translates to:
  /// **'অনুমতি দরকার'**
  String get statePermissionTitle;

  /// No description provided for @statePermissionBody.
  ///
  /// In bn, this message translates to:
  /// **'সেটিংসে গিয়ে অনুমতিটি চালু করে দিন।'**
  String get statePermissionBody;

  /// No description provided for @statePermissionAction.
  ///
  /// In bn, this message translates to:
  /// **'সেটিংস খুলুন'**
  String get statePermissionAction;

  /// No description provided for @offlineBanner.
  ///
  /// In bn, this message translates to:
  /// **'ইন্টারনেট নেই। ছবিগুলো পরে পাঠানো হবে।'**
  String get offlineBanner;

  /// No description provided for @offlineQueued.
  ///
  /// In bn, this message translates to:
  /// **'{count, plural, =1{১টি ছবি অপেক্ষায় আছে} other{{countText}টি ছবি অপেক্ষায় আছে}}'**
  String offlineQueued(int count, String countText);

  /// No description provided for @aiBadge.
  ///
  /// In bn, this message translates to:
  /// **'AI'**
  String get aiBadge;

  /// No description provided for @aiDisclaimer.
  ///
  /// In bn, this message translates to:
  /// **'এটি পরামর্শ, চূড়ান্ত রোগনির্ণয় নয়।'**
  String get aiDisclaimer;

  /// No description provided for @aiMarksNotice.
  ///
  /// In bn, this message translates to:
  /// **'সোনালি রঙের অংশগুলো AI তৈরি করেছে।'**
  String get aiMarksNotice;

  /// No description provided for @languageTitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনার ভাষা বেছে নিন'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'যে ভাষায় আপনি সহজে বুঝতে পারেন'**
  String get languageSubtitle;

  /// No description provided for @languageBangla.
  ///
  /// In bn, this message translates to:
  /// **'বাংলা'**
  String get languageBangla;

  /// No description provided for @languageEnglish.
  ///
  /// In bn, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageContinue.
  ///
  /// In bn, this message translates to:
  /// **'চালিয়ে যান'**
  String get languageContinue;

  /// No description provided for @languageSwitchLabel.
  ///
  /// In bn, this message translates to:
  /// **'ভাষা বদলান'**
  String get languageSwitchLabel;

  /// No description provided for @consentTitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনার অনুমতি দরকার'**
  String get consentTitle;

  /// No description provided for @consentSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনি যেটিতে রাজি, সেটিই নেওয়া হবে। যেকোনো সময় বন্ধ করতে পারবেন।'**
  String get consentSubtitle;

  /// No description provided for @consentPhotosTitle.
  ///
  /// In bn, this message translates to:
  /// **'ফসলের ছবি'**
  String get consentPhotosTitle;

  /// No description provided for @consentPhotosBody.
  ///
  /// In bn, this message translates to:
  /// **'রোগ খুঁজতে ছবি ব্যবহার হবে। ছবি শুধু আপনি, বিশেষজ্ঞ আর প্রশাসক দেখতে পাবেন।'**
  String get consentPhotosBody;

  /// No description provided for @consentLocationTitle.
  ///
  /// In bn, this message translates to:
  /// **'জেলা'**
  String get consentLocationTitle;

  /// No description provided for @consentLocationBody.
  ///
  /// In bn, this message translates to:
  /// **'আবহাওয়া আর খবর আপনার জেলার মতো করে দেখাতে দরকার। শুধু জেলা নেওয়া হয়, ঠিকানা নয়।'**
  String get consentLocationBody;

  /// No description provided for @consentPhoneTitle.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল নম্বর'**
  String get consentPhoneTitle;

  /// No description provided for @consentPhoneBody.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকাউন্ট চালাতে আর অর্ডারের খবর জানাতে দরকার।'**
  String get consentPhoneBody;

  /// No description provided for @consentVoiceTitle.
  ///
  /// In bn, this message translates to:
  /// **'ভয়েস কমান্ড'**
  String get consentVoiceTitle;

  /// No description provided for @consentVoiceBody.
  ///
  /// In bn, this message translates to:
  /// **'বাংলায় কথা বলে অ্যাপ চালাতে পারবেন। রেকর্ডিং কমান্ড বোঝার পরে মুছে ফেলা হয়।'**
  String get consentVoiceBody;

  /// No description provided for @consentAccept.
  ///
  /// In bn, this message translates to:
  /// **'রাজি আছি'**
  String get consentAccept;

  /// No description provided for @consentDecline.
  ///
  /// In bn, this message translates to:
  /// **'এখন নয়'**
  String get consentDecline;

  /// No description provided for @obAccountTitle.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকাউন্ট'**
  String get obAccountTitle;

  /// No description provided for @obAccountSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'আগে থেকে অ্যাকাউন্ট থাকলে লগইন করুন, নাহলে নতুন খুলুন।'**
  String get obAccountSubtitle;

  /// No description provided for @obLogin.
  ///
  /// In bn, this message translates to:
  /// **'লগইন করুন'**
  String get obLogin;

  /// No description provided for @obRegister.
  ///
  /// In bn, this message translates to:
  /// **'নতুন অ্যাকাউন্ট খুলুন'**
  String get obRegister;

  /// No description provided for @loginTitle.
  ///
  /// In bn, this message translates to:
  /// **'লগইন করুন'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল নম্বর আর পাসওয়ার্ড দিয়ে ঢুকুন'**
  String get loginSubtitle;

  /// No description provided for @loginMobileLabel.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল নম্বর'**
  String get loginMobileLabel;

  /// No description provided for @loginMobileHint.
  ///
  /// In bn, this message translates to:
  /// **'০১XXXXXXXXX'**
  String get loginMobileHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In bn, this message translates to:
  /// **'পাসওয়ার্ড'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In bn, this message translates to:
  /// **'পাসওয়ার্ড লিখুন'**
  String get loginPasswordHint;

  /// No description provided for @loginSubmit.
  ///
  /// In bn, this message translates to:
  /// **'লগইন'**
  String get loginSubmit;

  /// No description provided for @loginForgot.
  ///
  /// In bn, this message translates to:
  /// **'পাসওয়ার্ড ভুলে গেছেন?'**
  String get loginForgot;

  /// No description provided for @loginFailed.
  ///
  /// In bn, this message translates to:
  /// **'নম্বর বা পাসওয়ার্ড ঠিক নেই।'**
  String get loginFailed;

  /// No description provided for @roleTitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনি কে?'**
  String get roleTitle;

  /// No description provided for @roleSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনার কাজ অনুযায়ী সঠিকটি বেছে নিন'**
  String get roleSubtitle;

  /// No description provided for @roleFarmer.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক'**
  String get roleFarmer;

  /// No description provided for @roleFarmerHint.
  ///
  /// In bn, this message translates to:
  /// **'ফসল দেখানো আর পরামর্শ নেওয়ার জন্য'**
  String get roleFarmerHint;

  /// No description provided for @roleVendor.
  ///
  /// In bn, this message translates to:
  /// **'বিক্রেতা'**
  String get roleVendor;

  /// No description provided for @roleVendorHint.
  ///
  /// In bn, this message translates to:
  /// **'বীজ, সার আর ওষুধ বিক্রি করতে'**
  String get roleVendorHint;

  /// No description provided for @roleExpert.
  ///
  /// In bn, this message translates to:
  /// **'কৃষি বিশেষজ্ঞ'**
  String get roleExpert;

  /// No description provided for @roleExpertHint.
  ///
  /// In bn, this message translates to:
  /// **'পরামর্শ আর খবর যাচাই করতে'**
  String get roleExpertHint;

  /// No description provided for @registerTitle.
  ///
  /// In bn, this message translates to:
  /// **'নতুন অ্যাকাউন্ট'**
  String get registerTitle;

  /// No description provided for @registerAs.
  ///
  /// In bn, this message translates to:
  /// **'আপনি নিবন্ধন করছেন: {role}'**
  String registerAs(String role);

  /// No description provided for @registerNameLabel.
  ///
  /// In bn, this message translates to:
  /// **'আপনার নাম'**
  String get registerNameLabel;

  /// No description provided for @registerNameHint.
  ///
  /// In bn, this message translates to:
  /// **'পুরো নাম লিখুন'**
  String get registerNameHint;

  /// No description provided for @registerDistrictLabel.
  ///
  /// In bn, this message translates to:
  /// **'জেলা'**
  String get registerDistrictLabel;

  /// No description provided for @registerDistrictHint.
  ///
  /// In bn, this message translates to:
  /// **'জেলা বেছে নিন'**
  String get registerDistrictHint;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In bn, this message translates to:
  /// **'পাসওয়ার্ড'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordHint.
  ///
  /// In bn, this message translates to:
  /// **'কমপক্ষে ৮টি অক্ষর'**
  String get registerPasswordHint;

  /// No description provided for @registerPasswordRule.
  ///
  /// In bn, this message translates to:
  /// **'কমপক্ষে ৮টি অক্ষর দিতে হবে।'**
  String get registerPasswordRule;

  /// No description provided for @registerSubmit.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকাউন্ট খুলুন'**
  String get registerSubmit;

  /// No description provided for @registerShopNameLabel.
  ///
  /// In bn, this message translates to:
  /// **'দোকানের নাম'**
  String get registerShopNameLabel;

  /// No description provided for @registerLicenseLabel.
  ///
  /// In bn, this message translates to:
  /// **'ট্রেড লাইসেন্স নম্বর'**
  String get registerLicenseLabel;

  /// No description provided for @registerSpecializationLabel.
  ///
  /// In bn, this message translates to:
  /// **'কোন বিষয়ে বিশেষজ্ঞ'**
  String get registerSpecializationLabel;

  /// No description provided for @registerCertificationLabel.
  ///
  /// In bn, this message translates to:
  /// **'সার্টিফিকেট নম্বর'**
  String get registerCertificationLabel;

  /// No description provided for @registerAlreadyHave.
  ///
  /// In bn, this message translates to:
  /// **'আগে থেকেই অ্যাকাউন্ট আছে?'**
  String get registerAlreadyHave;

  /// No description provided for @otpTitle.
  ///
  /// In bn, this message translates to:
  /// **'কোডটি লিখুন'**
  String get otpTitle;

  /// No description provided for @otpBody.
  ///
  /// In bn, this message translates to:
  /// **'{mobile} নম্বরে পাঠানো ৬ সংখ্যার কোড দিন'**
  String otpBody(String mobile);

  /// No description provided for @otpLabel.
  ///
  /// In bn, this message translates to:
  /// **'কোড'**
  String get otpLabel;

  /// No description provided for @otpHint.
  ///
  /// In bn, this message translates to:
  /// **'৬ সংখ্যার কোড'**
  String get otpHint;

  /// No description provided for @otpSubmit.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই করুন'**
  String get otpSubmit;

  /// No description provided for @otpResend.
  ///
  /// In bn, this message translates to:
  /// **'আবার কোড পাঠান'**
  String get otpResend;

  /// No description provided for @otpInvalid.
  ///
  /// In bn, this message translates to:
  /// **'কোডটি ঠিক নেই। আবার দেখুন।'**
  String get otpInvalid;

  /// No description provided for @pendingTitle.
  ///
  /// In bn, this message translates to:
  /// **'অনুমতির অপেক্ষায়'**
  String get pendingTitle;

  /// No description provided for @pendingBody.
  ///
  /// In bn, this message translates to:
  /// **'আপনার আবেদন পরীক্ষা করা হচ্ছে। অনুমোদন পেলে জানানো হবে।'**
  String get pendingBody;

  /// No description provided for @pendingCheckStatus.
  ///
  /// In bn, this message translates to:
  /// **'অবস্থা দেখুন'**
  String get pendingCheckStatus;

  /// No description provided for @accountStatusSuspendedTitle.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকাউন্ট বন্ধ আছে'**
  String get accountStatusSuspendedTitle;

  /// No description provided for @accountStatusSuspendedBody.
  ///
  /// In bn, this message translates to:
  /// **'বিস্তারিত জানতে সহায়তা কেন্দ্রে যোগাযোগ করুন।'**
  String get accountStatusSuspendedBody;

  /// No description provided for @navHome.
  ///
  /// In bn, this message translates to:
  /// **'হোম'**
  String get navHome;

  /// No description provided for @navMarket.
  ///
  /// In bn, this message translates to:
  /// **'হাট বাজার'**
  String get navMarket;

  /// No description provided for @navHistory.
  ///
  /// In bn, this message translates to:
  /// **'ইতিহাস'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল'**
  String get navProfile;

  /// No description provided for @navDiagnosis.
  ///
  /// In bn, this message translates to:
  /// **'ফসল দেখুন'**
  String get navDiagnosis;

  /// No description provided for @navDashboard.
  ///
  /// In bn, this message translates to:
  /// **'ড্যাশবোর্ড'**
  String get navDashboard;

  /// No description provided for @navProducts.
  ///
  /// In bn, this message translates to:
  /// **'পণ্য'**
  String get navProducts;

  /// No description provided for @navOrders.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার'**
  String get navOrders;

  /// No description provided for @navReviews.
  ///
  /// In bn, this message translates to:
  /// **'পর্যালোচনা'**
  String get navReviews;

  /// No description provided for @navNews.
  ///
  /// In bn, this message translates to:
  /// **'কৃষি বার্তা'**
  String get navNews;

  /// No description provided for @navKnowledge.
  ///
  /// In bn, this message translates to:
  /// **'জ্ঞানভাণ্ডার'**
  String get navKnowledge;

  /// No description provided for @navVendors.
  ///
  /// In bn, this message translates to:
  /// **'বিক্রেতা'**
  String get navVendors;

  /// No description provided for @navUsers.
  ///
  /// In bn, this message translates to:
  /// **'ব্যবহারকারী'**
  String get navUsers;

  /// No description provided for @navSources.
  ///
  /// In bn, this message translates to:
  /// **'সূত্র'**
  String get navSources;

  /// No description provided for @navLogs.
  ///
  /// In bn, this message translates to:
  /// **'লগ'**
  String get navLogs;

  /// No description provided for @homeGreeting.
  ///
  /// In bn, this message translates to:
  /// **'স্বাগতম, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeGreetingAnonymous.
  ///
  /// In bn, this message translates to:
  /// **'স্বাগতম'**
  String get homeGreetingAnonymous;

  /// No description provided for @homeSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'আজ কী করতে চান?'**
  String get homeSubtitle;

  /// No description provided for @homeWeatherUnavailable.
  ///
  /// In bn, this message translates to:
  /// **'আবহাওয়া আনা যায়নি'**
  String get homeWeatherUnavailable;

  /// No description provided for @homeWeatherReadAloud.
  ///
  /// In bn, this message translates to:
  /// **'আবহাওয়া পড়ে শোনান'**
  String get homeWeatherReadAloud;

  /// No description provided for @homeUrgentTitle.
  ///
  /// In bn, this message translates to:
  /// **'জরুরি খবর'**
  String get homeUrgentTitle;

  /// No description provided for @homeUrgentBody.
  ///
  /// In bn, this message translates to:
  /// **'আপনার ফসলের জন্য জরুরি একটি বার্তা আছে।'**
  String get homeUrgentBody;

  /// No description provided for @homeUrgentAction.
  ///
  /// In bn, this message translates to:
  /// **'খবরটি দেখুন'**
  String get homeUrgentAction;

  /// No description provided for @homeTileCheckCrop.
  ///
  /// In bn, this message translates to:
  /// **'ফসল দেখুন'**
  String get homeTileCheckCrop;

  /// No description provided for @homeTileCheckCropHint.
  ///
  /// In bn, this message translates to:
  /// **'পাতার ছবি তুলে রোগ জানুন'**
  String get homeTileCheckCropHint;

  /// No description provided for @homeTileAsk.
  ///
  /// In bn, this message translates to:
  /// **'কথা বলুন'**
  String get homeTileAsk;

  /// No description provided for @homeTileAskHint.
  ///
  /// In bn, this message translates to:
  /// **'বাংলায় প্রশ্ন করুন'**
  String get homeTileAskHint;

  /// No description provided for @homeTileAdvice.
  ///
  /// In bn, this message translates to:
  /// **'ফসল পরামর্শ'**
  String get homeTileAdvice;

  /// No description provided for @homeTileAdviceHint.
  ///
  /// In bn, this message translates to:
  /// **'কোন ফসল লাগাবেন'**
  String get homeTileAdviceHint;

  /// No description provided for @homeTileWeather.
  ///
  /// In bn, this message translates to:
  /// **'আবহাওয়া'**
  String get homeTileWeather;

  /// No description provided for @homeTileWeatherHint.
  ///
  /// In bn, this message translates to:
  /// **'বৃষ্টি আর গরমের খবর'**
  String get homeTileWeatherHint;

  /// No description provided for @homeTileNews.
  ///
  /// In bn, this message translates to:
  /// **'কৃষি বার্তা'**
  String get homeTileNews;

  /// No description provided for @homeTileNewsHint.
  ///
  /// In bn, this message translates to:
  /// **'নতুন রোগ আর পোকার খবর'**
  String get homeTileNewsHint;

  /// No description provided for @homeTileMarket.
  ///
  /// In bn, this message translates to:
  /// **'হাট বাজার'**
  String get homeTileMarket;

  /// No description provided for @homeTileMarketHint.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই করা বিক্রেতার পণ্য'**
  String get homeTileMarketHint;

  /// No description provided for @homeContrastToggle.
  ///
  /// In bn, this message translates to:
  /// **'স্পষ্ট মোড'**
  String get homeContrastToggle;

  /// No description provided for @homeContrastToggleHint.
  ///
  /// In bn, this message translates to:
  /// **'রোদে ভালো দেখতে'**
  String get homeContrastToggleHint;

  /// No description provided for @homeRecentTitle.
  ///
  /// In bn, this message translates to:
  /// **'সাম্প্রতিক দেখা'**
  String get homeRecentTitle;

  /// No description provided for @defaultUserName.
  ///
  /// In bn, this message translates to:
  /// **'কৃষক'**
  String get defaultUserName;

  /// No description provided for @diagnosisCaptureTitle.
  ///
  /// In bn, this message translates to:
  /// **'পাতার ছবি তুলুন'**
  String get diagnosisCaptureTitle;

  /// No description provided for @diagnosisCaptureSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'আক্রান্ত পাতাটি ছবির মাঝখানে রাখুন'**
  String get diagnosisCaptureSubtitle;

  /// No description provided for @diagnosisTipLight.
  ///
  /// In bn, this message translates to:
  /// **'ভালো আলোতে ছবি তুলুন'**
  String get diagnosisTipLight;

  /// No description provided for @diagnosisTipCenter.
  ///
  /// In bn, this message translates to:
  /// **'একটি পাতা, মাঝখানে'**
  String get diagnosisTipCenter;

  /// No description provided for @diagnosisTipFocus.
  ///
  /// In bn, this message translates to:
  /// **'ঝাপসা হলে আবার তুলুন'**
  String get diagnosisTipFocus;

  /// No description provided for @diagnosisOpenCamera.
  ///
  /// In bn, this message translates to:
  /// **'ক্যামেরা খুলুন'**
  String get diagnosisOpenCamera;

  /// No description provided for @diagnosisFromGallery.
  ///
  /// In bn, this message translates to:
  /// **'গ্যালারি থেকে নিন'**
  String get diagnosisFromGallery;

  /// No description provided for @diagnosisSelectCrop.
  ///
  /// In bn, this message translates to:
  /// **'কোন ফসল?'**
  String get diagnosisSelectCrop;

  /// No description provided for @diagnosisCropRice.
  ///
  /// In bn, this message translates to:
  /// **'ধান'**
  String get diagnosisCropRice;

  /// No description provided for @diagnosisCropPotato.
  ///
  /// In bn, this message translates to:
  /// **'আলু'**
  String get diagnosisCropPotato;

  /// No description provided for @diagnosisCropTomato.
  ///
  /// In bn, this message translates to:
  /// **'টমেটো'**
  String get diagnosisCropTomato;

  /// No description provided for @diagnosisCropUnknown.
  ///
  /// In bn, this message translates to:
  /// **'জানি না'**
  String get diagnosisCropUnknown;

  /// No description provided for @diagnosisPreviewTitle.
  ///
  /// In bn, this message translates to:
  /// **'ছবিটি দেখে নিন'**
  String get diagnosisPreviewTitle;

  /// No description provided for @diagnosisPreviewBody.
  ///
  /// In bn, this message translates to:
  /// **'ছবি স্পষ্ট হলে পাঠিয়ে দিন, নাহলে আবার তুলুন।'**
  String get diagnosisPreviewBody;

  /// No description provided for @diagnosisUsePhoto.
  ///
  /// In bn, this message translates to:
  /// **'এই ছবি পাঠান'**
  String get diagnosisUsePhoto;

  /// No description provided for @diagnosisRetake.
  ///
  /// In bn, this message translates to:
  /// **'আবার তুলুন'**
  String get diagnosisRetake;

  /// No description provided for @diagnosisProcessingTitle.
  ///
  /// In bn, this message translates to:
  /// **'AI ছবি দেখছে…'**
  String get diagnosisProcessingTitle;

  /// No description provided for @diagnosisProcessingBody.
  ///
  /// In bn, this message translates to:
  /// **'একটু সময় লাগবে। অ্যাপ বন্ধ করবেন না।'**
  String get diagnosisProcessingBody;

  /// No description provided for @diagnosisQueuedTitle.
  ///
  /// In bn, this message translates to:
  /// **'ছবি সংরক্ষণ করা হয়েছে'**
  String get diagnosisQueuedTitle;

  /// No description provided for @diagnosisQueuedBody.
  ///
  /// In bn, this message translates to:
  /// **'ইন্টারনেট এলে ছবিটি নিজে থেকে পাঠানো হবে।'**
  String get diagnosisQueuedBody;

  /// No description provided for @diagnosisResultTitle.
  ///
  /// In bn, this message translates to:
  /// **'ফলাফল'**
  String get diagnosisResultTitle;

  /// No description provided for @diagnosisConfidenceLabel.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চয়তা'**
  String get diagnosisConfidenceLabel;

  /// No description provided for @diagnosisConfidenceHigh.
  ///
  /// In bn, this message translates to:
  /// **'বেশ নিশ্চিত'**
  String get diagnosisConfidenceHigh;

  /// No description provided for @diagnosisConfidenceMedium.
  ///
  /// In bn, this message translates to:
  /// **'মোটামুটি নিশ্চিত'**
  String get diagnosisConfidenceMedium;

  /// No description provided for @diagnosisConfidenceLow.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিত নই'**
  String get diagnosisConfidenceLow;

  /// No description provided for @diagnosisTreatmentTitle.
  ///
  /// In bn, this message translates to:
  /// **'কী করবেন'**
  String get diagnosisTreatmentTitle;

  /// No description provided for @diagnosisReadAll.
  ///
  /// In bn, this message translates to:
  /// **'সব পড়ে শোনান'**
  String get diagnosisReadAll;

  /// No description provided for @diagnosisOrderMedicine.
  ///
  /// In bn, this message translates to:
  /// **'ওষুধ অর্ডার করুন'**
  String get diagnosisOrderMedicine;

  /// No description provided for @diagnosisAskQuestion.
  ///
  /// In bn, this message translates to:
  /// **'প্রশ্ন করুন'**
  String get diagnosisAskQuestion;

  /// No description provided for @diagnosisSendToExpert.
  ///
  /// In bn, this message translates to:
  /// **'বিশেষজ্ঞকে পাঠান'**
  String get diagnosisSendToExpert;

  /// No description provided for @diagnosisSentToExpert.
  ///
  /// In bn, this message translates to:
  /// **'আপনার ছবিটি বিশেষজ্ঞের কাছে পাঠানো হয়েছে।'**
  String get diagnosisSentToExpert;

  /// No description provided for @diagnosisExpertReviewed.
  ///
  /// In bn, this message translates to:
  /// **'বিশেষজ্ঞ যাচাই করেছেন'**
  String get diagnosisExpertReviewed;

  /// No description provided for @diagnosisLowTitle.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিত হওয়া যায়নি'**
  String get diagnosisLowTitle;

  /// No description provided for @diagnosisLowBody.
  ///
  /// In bn, this message translates to:
  /// **'ছবিটি দেখে সঠিক রোগ বোঝা যাচ্ছে না, তাই রোগের নাম দেখানো হচ্ছে না। নতুন ছবি নিন বা বিশেষজ্ঞকে পাঠান।'**
  String get diagnosisLowBody;

  /// No description provided for @diagnosisMediumCaution.
  ///
  /// In bn, this message translates to:
  /// **'আমি পুরোপুরি নিশ্চিত নই। সন্দেহ থাকলে বিশেষজ্ঞকে দেখান।'**
  String get diagnosisMediumCaution;

  /// No description provided for @diagnosisHealthyTitle.
  ///
  /// In bn, this message translates to:
  /// **'গাছটি সুস্থ'**
  String get diagnosisHealthyTitle;

  /// No description provided for @diagnosisSafetyTitle.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপত্তা'**
  String get diagnosisSafetyTitle;

  /// No description provided for @diagnosisSafetyBody.
  ///
  /// In bn, this message translates to:
  /// **'ওষুধ ব্যবহারের সময় মুখে-নাকে কাপড় দিন, পরে হাত-মুখ ধুয়ে ফেলুন। শিশুদের নাগালের বাইরে রাখুন।'**
  String get diagnosisSafetyBody;

  /// No description provided for @diagnosisHistoryTitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনার আগের ছবি'**
  String get diagnosisHistoryTitle;

  /// No description provided for @diagnosisHistoryEmptyTitle.
  ///
  /// In bn, this message translates to:
  /// **'এখনো কোনো ছবি নেই'**
  String get diagnosisHistoryEmptyTitle;

  /// No description provided for @diagnosisHistoryEmptyBody.
  ///
  /// In bn, this message translates to:
  /// **'প্রথম পাতা দেখতে ক্যামেরা বাটনে চাপ দিন।'**
  String get diagnosisHistoryEmptyBody;

  /// No description provided for @diagnosisShowTop3.
  ///
  /// In bn, this message translates to:
  /// **'AI-এর সন্দেহের তালিকা'**
  String get diagnosisShowTop3;

  /// No description provided for @diagnosisFeedbackThanks.
  ///
  /// In bn, this message translates to:
  /// **'ধন্যবাদ! আপনার মতামত শেখাতে সাহায্য করবে।'**
  String get diagnosisFeedbackThanks;

  /// No description provided for @weatherTitle.
  ///
  /// In bn, this message translates to:
  /// **'আবহাওয়া'**
  String get weatherTitle;

  /// No description provided for @weatherHumidity.
  ///
  /// In bn, this message translates to:
  /// **'আর্দ্রতা'**
  String get weatherHumidity;

  /// No description provided for @weatherWind.
  ///
  /// In bn, this message translates to:
  /// **'বাতাস'**
  String get weatherWind;

  /// No description provided for @weatherRain.
  ///
  /// In bn, this message translates to:
  /// **'বৃষ্টি'**
  String get weatherRain;

  /// No description provided for @weatherForecastTitle.
  ///
  /// In bn, this message translates to:
  /// **'আগামী দিনগুলো'**
  String get weatherForecastTitle;

  /// No description provided for @weatherAlertsTitle.
  ///
  /// In bn, this message translates to:
  /// **'সতর্কতা'**
  String get weatherAlertsTitle;

  /// No description provided for @weatherNoAlerts.
  ///
  /// In bn, this message translates to:
  /// **'এখন কোনো সতর্কতা নেই'**
  String get weatherNoAlerts;

  /// No description provided for @weatherUpdated.
  ///
  /// In bn, this message translates to:
  /// **'সর্বশেষ হালনাগাদ: {time}'**
  String weatherUpdated(String time);

  /// No description provided for @profileTitle.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল'**
  String get profileTitle;

  /// No description provided for @profileSettings.
  ///
  /// In bn, this message translates to:
  /// **'সেটিংস'**
  String get profileSettings;

  /// No description provided for @profileEditTitle.
  ///
  /// In bn, this message translates to:
  /// **'তথ্য সম্পাদনা'**
  String get profileEditTitle;

  /// No description provided for @profileLanguage.
  ///
  /// In bn, this message translates to:
  /// **'ভাষা'**
  String get profileLanguage;

  /// No description provided for @profileContrast.
  ///
  /// In bn, this message translates to:
  /// **'স্পষ্ট মোড'**
  String get profileContrast;

  /// No description provided for @profileVoiceMode.
  ///
  /// In bn, this message translates to:
  /// **'ভয়েস মোড'**
  String get profileVoiceMode;

  /// No description provided for @profileVoiceModeHint.
  ///
  /// In bn, this message translates to:
  /// **'ফলাফল নিজে থেকে পড়ে শোনানো হবে'**
  String get profileVoiceModeHint;

  /// No description provided for @profileNotifications.
  ///
  /// In bn, this message translates to:
  /// **'খবরের বিজ্ঞপ্তি'**
  String get profileNotifications;

  /// No description provided for @profileConsent.
  ///
  /// In bn, this message translates to:
  /// **'আপনার অনুমতিপত্র'**
  String get profileConsent;

  /// No description provided for @profileLogout.
  ///
  /// In bn, this message translates to:
  /// **'লগ আউট'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In bn, this message translates to:
  /// **'আপনি কি লগ আউট করতে চান?'**
  String get profileLogoutConfirm;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকাউন্ট মুছতে বলুন'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteAccountConfirm.
  ///
  /// In bn, this message translates to:
  /// **'আপনার তথ্য মুছে ফেলার অনুরোধ পাঠানো হবে। নিশ্চিত?'**
  String get profileDeleteAccountConfirm;

  /// No description provided for @profileVersion.
  ///
  /// In bn, this message translates to:
  /// **'সংস্করণ {version}'**
  String profileVersion(String version);

  /// No description provided for @profileSaved.
  ///
  /// In bn, this message translates to:
  /// **'সংরক্ষণ হয়েছে'**
  String get profileSaved;

  /// No description provided for @voiceListening.
  ///
  /// In bn, this message translates to:
  /// **'বলুন, আমি শুনছি'**
  String get voiceListening;

  /// No description provided for @voiceProcessing.
  ///
  /// In bn, this message translates to:
  /// **'বুঝছি…'**
  String get voiceProcessing;

  /// No description provided for @voiceUnderstood.
  ///
  /// In bn, this message translates to:
  /// **'আপনি বলেছেন: {text}'**
  String voiceUnderstood(String text);

  /// No description provided for @voiceCouldNotUnderstand.
  ///
  /// In bn, this message translates to:
  /// **'আমি বুঝতে পারিনি'**
  String get voiceCouldNotUnderstand;

  /// No description provided for @voiceAskAgain.
  ///
  /// In bn, this message translates to:
  /// **'আবার বলুন'**
  String get voiceAskAgain;

  /// No description provided for @voiceCancel.
  ///
  /// In bn, this message translates to:
  /// **'থামান'**
  String get voiceCancel;

  /// No description provided for @voiceUseTouch.
  ///
  /// In bn, this message translates to:
  /// **'হাতে চালান'**
  String get voiceUseTouch;

  /// No description provided for @voiceNoInternet.
  ///
  /// In bn, this message translates to:
  /// **'ইন্টারনেট নেই, তাই কথা শোনা যাচ্ছে না। হাতেই চালাতে পারবেন।'**
  String get voiceNoInternet;

  /// No description provided for @voiceMicLabel.
  ///
  /// In bn, this message translates to:
  /// **'কথা বলে অ্যাপ চালান'**
  String get voiceMicLabel;

  /// No description provided for @voiceConfirmationTitle.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিত করুন'**
  String get voiceConfirmationTitle;

  /// No description provided for @voiceConfirmationBody.
  ///
  /// In bn, this message translates to:
  /// **'আমি এই অর্ডারটি দিতে যাচ্ছি'**
  String get voiceConfirmationBody;

  /// No description provided for @productDescription.
  ///
  /// In bn, this message translates to:
  /// **'পণ্যের বিবরণ'**
  String get productDescription;

  /// No description provided for @selectQuantity.
  ///
  /// In bn, this message translates to:
  /// **'কতটি লাগবে'**
  String get selectQuantity;

  /// No description provided for @orderConfirmTitle.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার নিশ্চিত করুন'**
  String get orderConfirmTitle;

  /// No description provided for @orderTotal.
  ///
  /// In bn, this message translates to:
  /// **'সর্বমোট'**
  String get orderTotal;

  /// No description provided for @orderServerTotalNote.
  ///
  /// In bn, this message translates to:
  /// **'চূড়ান্ত হিসাব সার্ভার থেকে আসবে।'**
  String get orderServerTotalNote;

  /// No description provided for @orderPaymentMode.
  ///
  /// In bn, this message translates to:
  /// **'পরিশোধের ধরন'**
  String get orderPaymentMode;

  /// No description provided for @orderPaymentCod.
  ///
  /// In bn, this message translates to:
  /// **'হাতে পেয়ে টাকা'**
  String get orderPaymentCod;

  /// No description provided for @orderPaymentDirect.
  ///
  /// In bn, this message translates to:
  /// **'সরাসরি বিক্রেতাকে'**
  String get orderPaymentDirect;

  /// No description provided for @orderPlaced.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার দেওয়া হয়েছে'**
  String get orderPlaced;

  /// No description provided for @orderCannotCancel.
  ///
  /// In bn, this message translates to:
  /// **'এই অর্ডারটি আর বাতিল করা যাবে না।'**
  String get orderCannotCancel;

  /// No description provided for @orderCancelTitle.
  ///
  /// In bn, this message translates to:
  /// **'অর্ডার বাতিল করবেন?'**
  String get orderCancelTitle;

  /// No description provided for @orderOneVendorOnly.
  ///
  /// In bn, this message translates to:
  /// **'একটি অর্ডারে একই বিক্রেতার পণ্য থাকতে হবে।'**
  String get orderOneVendorOnly;

  /// No description provided for @marketAllCategories.
  ///
  /// In bn, this message translates to:
  /// **'সব ধরনের'**
  String get marketAllCategories;

  /// No description provided for @marketInStockOnly.
  ///
  /// In bn, this message translates to:
  /// **'শুধু মজুদ থাকা পণ্য'**
  String get marketInStockOnly;

  /// No description provided for @marketOutOfStock.
  ///
  /// In bn, this message translates to:
  /// **'মজুদ নেই'**
  String get marketOutOfStock;

  /// No description provided for @marketStockCount.
  ///
  /// In bn, this message translates to:
  /// **'মজুদ: {count}'**
  String marketStockCount(String count);

  /// No description provided for @categorySeed.
  ///
  /// In bn, this message translates to:
  /// **'বীজ'**
  String get categorySeed;

  /// No description provided for @categoryFertilizer.
  ///
  /// In bn, this message translates to:
  /// **'সার'**
  String get categoryFertilizer;

  /// No description provided for @categoryPesticide.
  ///
  /// In bn, this message translates to:
  /// **'কীটনাশক'**
  String get categoryPesticide;

  /// No description provided for @categoryFungicide.
  ///
  /// In bn, this message translates to:
  /// **'ছত্রাকনাশক'**
  String get categoryFungicide;

  /// No description provided for @categoryEquipment.
  ///
  /// In bn, this message translates to:
  /// **'যন্ত্রপাতি'**
  String get categoryEquipment;

  /// No description provided for @categoryOther.
  ///
  /// In bn, this message translates to:
  /// **'অন্যান্য'**
  String get categoryOther;

  /// No description provided for @vendorVerified.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত বিক্রেতা'**
  String get vendorVerified;

  /// No description provided for @vendorNotVerified.
  ///
  /// In bn, this message translates to:
  /// **'এখনো যাচাই হয়নি'**
  String get vendorNotVerified;

  /// No description provided for @severityLow.
  ///
  /// In bn, this message translates to:
  /// **'কম'**
  String get severityLow;

  /// No description provided for @severityMedium.
  ///
  /// In bn, this message translates to:
  /// **'মাঝারি'**
  String get severityMedium;

  /// No description provided for @severityHigh.
  ///
  /// In bn, this message translates to:
  /// **'বেশি'**
  String get severityHigh;

  /// No description provided for @severityUrgent.
  ///
  /// In bn, this message translates to:
  /// **'জরুরি'**
  String get severityUrgent;

  /// No description provided for @orderStatusPending.
  ///
  /// In bn, this message translates to:
  /// **'অপেক্ষায়'**
  String get orderStatusPending;

  /// No description provided for @orderStatusConfirmed.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিত হয়েছে'**
  String get orderStatusConfirmed;

  /// No description provided for @orderStatusShipped.
  ///
  /// In bn, this message translates to:
  /// **'পাঠানো হয়েছে'**
  String get orderStatusShipped;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In bn, this message translates to:
  /// **'পৌঁছে দেওয়া হয়েছে'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusRejected.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল করা হয়েছে'**
  String get orderStatusRejected;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল'**
  String get orderStatusCancelled;

  /// No description provided for @syncQueued.
  ///
  /// In bn, this message translates to:
  /// **'অপেক্ষায় আছে'**
  String get syncQueued;

  /// No description provided for @syncUploading.
  ///
  /// In bn, this message translates to:
  /// **'পাঠানো হচ্ছে'**
  String get syncUploading;

  /// No description provided for @syncSynced.
  ///
  /// In bn, this message translates to:
  /// **'পাঠানো হয়েছে'**
  String get syncSynced;

  /// No description provided for @syncFailed.
  ///
  /// In bn, this message translates to:
  /// **'পাঠানো যায়নি'**
  String get syncFailed;

  /// No description provided for @newsCategoryDisease.
  ///
  /// In bn, this message translates to:
  /// **'রোগ'**
  String get newsCategoryDisease;

  /// No description provided for @newsCategoryPest.
  ///
  /// In bn, this message translates to:
  /// **'পোকা'**
  String get newsCategoryPest;

  /// No description provided for @newsCategoryVirus.
  ///
  /// In bn, this message translates to:
  /// **'ভাইরাস'**
  String get newsCategoryVirus;

  /// No description provided for @newsCategoryNutrient.
  ///
  /// In bn, this message translates to:
  /// **'পুষ্টির অভাব'**
  String get newsCategoryNutrient;

  /// No description provided for @comingSoon.
  ///
  /// In bn, this message translates to:
  /// **'শীঘ্রই আসছে'**
  String get comingSoon;

  /// No description provided for @comingSoonBody.
  ///
  /// In bn, this message translates to:
  /// **'এই অংশটি এখনো তৈরি হচ্ছে।'**
  String get comingSoonBody;

  /// No description provided for @homeTileOrdersHint.
  ///
  /// In bn, this message translates to:
  /// **'কেনা-বেচার হিসাব দেখুন'**
  String get homeTileOrdersHint;

  /// No description provided for @homeTileHistoryHint.
  ///
  /// In bn, this message translates to:
  /// **'আগের ছবি আর পরামর্শ'**
  String get homeTileHistoryHint;

  /// No description provided for @homeFieldPrompt.
  ///
  /// In bn, this message translates to:
  /// **'আজ মাঠে কী সমস্যা?'**
  String get homeFieldPrompt;

  /// No description provided for @homeFieldPromptHint.
  ///
  /// In bn, this message translates to:
  /// **'পাতার ছবি তুলুন — কয়েক সেকেন্ডেই পরামর্শ'**
  String get homeFieldPromptHint;

  /// No description provided for @homeScanAction.
  ///
  /// In bn, this message translates to:
  /// **'ছবি তুলুন'**
  String get homeScanAction;

  /// No description provided for @homeRecentEmpty.
  ///
  /// In bn, this message translates to:
  /// **'এখনো কোনো পাতা দেখা হয়নি'**
  String get homeRecentEmpty;

  /// No description provided for @filterAll.
  ///
  /// In bn, this message translates to:
  /// **'সব'**
  String get filterAll;

  /// No description provided for @filterUncertain.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিত নয়'**
  String get filterUncertain;

  /// No description provided for @profileAnimation.
  ///
  /// In bn, this message translates to:
  /// **'অ্যানিমেশন'**
  String get profileAnimation;

  /// No description provided for @profileAnimationHint.
  ///
  /// In bn, this message translates to:
  /// **'আকাশ আর ফসল ধীরে নড়বে'**
  String get profileAnimationHint;

  /// No description provided for @homeAnimationOn.
  ///
  /// In bn, this message translates to:
  /// **'অ্যানিমেশন চালু'**
  String get homeAnimationOn;

  /// No description provided for @homeAnimationOff.
  ///
  /// In bn, this message translates to:
  /// **'অ্যানিমেশন বন্ধ'**
  String get homeAnimationOff;

  /// No description provided for @homeSkyRain.
  ///
  /// In bn, this message translates to:
  /// **'আজ বৃষ্টির আকাশ'**
  String get homeSkyRain;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppL10nBn();
    case 'en':
      return AppL10nEn();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
