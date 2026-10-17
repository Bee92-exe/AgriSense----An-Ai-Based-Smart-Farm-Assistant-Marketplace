// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppL10nBn extends AppL10n {
  AppL10nBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'AgriSense';

  @override
  String get appTagline => 'পকেটে আপনার কৃষি উপদেষ্টা';

  @override
  String get actionRetry => 'আবার চেষ্টা করুন';

  @override
  String get actionCancel => 'বাতিল করুন';

  @override
  String get actionConfirm => 'নিশ্চিত করুন';

  @override
  String get actionSave => 'সংরক্ষণ করুন';

  @override
  String get actionNext => 'পরবর্তী';

  @override
  String get actionBack => 'পিছনে যান';

  @override
  String get actionClose => 'বন্ধ করুন';

  @override
  String get actionSearch => 'খুঁজুন';

  @override
  String get actionSeeAll => 'সব দেখুন';

  @override
  String get actionReadAloud => 'পড়ে শোনান';

  @override
  String get actionStopReading => 'পড়া থামান';

  @override
  String get stateLoading => 'একটু অপেক্ষা করুন…';

  @override
  String get stateEmptyTitle => 'এখন কিছু নেই';

  @override
  String get stateEmptyBody => 'নতুন কিছু এলে এখানে দেখা যাবে।';

  @override
  String get stateErrorTitle => 'কিছু একটা ভুল হয়েছে';

  @override
  String get stateErrorBody =>
      'আবার চেষ্টা করুন। সমস্যা থেকে গেলে পরে আবার দেখুন।';

  @override
  String get statePermissionTitle => 'অনুমতি দরকার';

  @override
  String get statePermissionBody => 'সেটিংসে গিয়ে অনুমতিটি চালু করে দিন।';

  @override
  String get statePermissionAction => 'সেটিংস খুলুন';

  @override
  String get offlineBanner => 'ইন্টারনেট নেই। ছবিগুলো পরে পাঠানো হবে।';

  @override
  String offlineQueued(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countTextটি ছবি অপেক্ষায় আছে',
      one: '১টি ছবি অপেক্ষায় আছে',
    );
    return '$_temp0';
  }

  @override
  String get aiBadge => 'AI';

  @override
  String get aiDisclaimer => 'এটি পরামর্শ, চূড়ান্ত রোগনির্ণয় নয়।';

  @override
  String get aiMarksNotice => 'সোনালি রঙের অংশগুলো AI তৈরি করেছে।';

  @override
  String get languageTitle => 'আপনার ভাষা বেছে নিন';

  @override
  String get languageSubtitle => 'যে ভাষায় আপনি সহজে বুঝতে পারেন';

  @override
  String get languageBangla => 'বাংলা';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageContinue => 'চালিয়ে যান';

  @override
  String get languageSwitchLabel => 'ভাষা বদলান';

  @override
  String get consentTitle => 'আপনার অনুমতি দরকার';

  @override
  String get consentSubtitle =>
      'আপনি যেটিতে রাজি, সেটিই নেওয়া হবে। যেকোনো সময় বন্ধ করতে পারবেন।';

  @override
  String get consentPhotosTitle => 'ফসলের ছবি';

  @override
  String get consentPhotosBody =>
      'রোগ খুঁজতে ছবি ব্যবহার হবে। ছবি শুধু আপনি, বিশেষজ্ঞ আর প্রশাসক দেখতে পাবেন।';

  @override
  String get consentLocationTitle => 'জেলা';

  @override
  String get consentLocationBody =>
      'আবহাওয়া আর খবর আপনার জেলার মতো করে দেখাতে দরকার। শুধু জেলা নেওয়া হয়, ঠিকানা নয়।';

  @override
  String get consentPhoneTitle => 'মোবাইল নম্বর';

  @override
  String get consentPhoneBody =>
      'অ্যাকাউন্ট চালাতে আর অর্ডারের খবর জানাতে দরকার।';

  @override
  String get consentVoiceTitle => 'ভয়েস কমান্ড';

  @override
  String get consentVoiceBody =>
      'বাংলায় কথা বলে অ্যাপ চালাতে পারবেন। রেকর্ডিং কমান্ড বোঝার পরে মুছে ফেলা হয়।';

  @override
  String get consentAccept => 'রাজি আছি';

  @override
  String get consentDecline => 'এখন নয়';

  @override
  String get obAccountTitle => 'অ্যাকাউন্ট';

  @override
  String get obAccountSubtitle =>
      'আগে থেকে অ্যাকাউন্ট থাকলে লগইন করুন, নাহলে নতুন খুলুন।';

  @override
  String get obLogin => 'লগইন করুন';

  @override
  String get obRegister => 'নতুন অ্যাকাউন্ট খুলুন';

  @override
  String get loginTitle => 'লগইন করুন';

  @override
  String get loginSubtitle => 'মোবাইল নম্বর আর পাসওয়ার্ড দিয়ে ঢুকুন';

  @override
  String get loginMobileLabel => 'মোবাইল নম্বর';

  @override
  String get loginMobileHint => '০১XXXXXXXXX';

  @override
  String get loginPasswordLabel => 'পাসওয়ার্ড';

  @override
  String get loginPasswordHint => 'পাসওয়ার্ড লিখুন';

  @override
  String get loginSubmit => 'লগইন';

  @override
  String get loginForgot => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get loginFailed => 'নম্বর বা পাসওয়ার্ড ঠিক নেই।';

  @override
  String get roleTitle => 'আপনি কে?';

  @override
  String get roleSubtitle => 'আপনার কাজ অনুযায়ী সঠিকটি বেছে নিন';

  @override
  String get roleFarmer => 'কৃষক';

  @override
  String get roleFarmerHint => 'ফসল দেখানো আর পরামর্শ নেওয়ার জন্য';

  @override
  String get roleVendor => 'বিক্রেতা';

  @override
  String get roleVendorHint => 'বীজ, সার আর ওষুধ বিক্রি করতে';

  @override
  String get roleExpert => 'কৃষি বিশেষজ্ঞ';

  @override
  String get roleExpertHint => 'পরামর্শ আর খবর যাচাই করতে';

  @override
  String get registerTitle => 'নতুন অ্যাকাউন্ট';

  @override
  String registerAs(String role) {
    return 'আপনি নিবন্ধন করছেন: $role';
  }

  @override
  String get registerNameLabel => 'আপনার নাম';

  @override
  String get registerNameHint => 'পুরো নাম লিখুন';

  @override
  String get registerDistrictLabel => 'জেলা';

  @override
  String get registerDistrictHint => 'জেলা বেছে নিন';

  @override
  String get registerPasswordLabel => 'পাসওয়ার্ড';

  @override
  String get registerPasswordHint => 'কমপক্ষে ৮টি অক্ষর';

  @override
  String get registerPasswordRule => 'কমপক্ষে ৮টি অক্ষর দিতে হবে।';

  @override
  String get registerSubmit => 'অ্যাকাউন্ট খুলুন';

  @override
  String get registerShopNameLabel => 'দোকানের নাম';

  @override
  String get registerLicenseLabel => 'ট্রেড লাইসেন্স নম্বর';

  @override
  String get registerSpecializationLabel => 'কোন বিষয়ে বিশেষজ্ঞ';

  @override
  String get registerCertificationLabel => 'সার্টিফিকেট নম্বর';

  @override
  String get registerAlreadyHave => 'আগে থেকেই অ্যাকাউন্ট আছে?';

  @override
  String get otpTitle => 'কোডটি লিখুন';

  @override
  String otpBody(String mobile) {
    return '$mobile নম্বরে পাঠানো ৬ সংখ্যার কোড দিন';
  }

  @override
  String get otpLabel => 'কোড';

  @override
  String get otpHint => '৬ সংখ্যার কোড';

  @override
  String get otpSubmit => 'যাচাই করুন';

  @override
  String get otpResend => 'আবার কোড পাঠান';

  @override
  String get otpInvalid => 'কোডটি ঠিক নেই। আবার দেখুন।';

  @override
  String get pendingTitle => 'অনুমতির অপেক্ষায়';

  @override
  String get pendingBody =>
      'আপনার আবেদন পরীক্ষা করা হচ্ছে। অনুমোদন পেলে জানানো হবে।';

  @override
  String get pendingCheckStatus => 'অবস্থা দেখুন';

  @override
  String get accountStatusSuspendedTitle => 'অ্যাকাউন্ট বন্ধ আছে';

  @override
  String get accountStatusSuspendedBody =>
      'বিস্তারিত জানতে সহায়তা কেন্দ্রে যোগাযোগ করুন।';

  @override
  String get navHome => 'হোম';

  @override
  String get navMarket => 'হাট বাজার';

  @override
  String get navHistory => 'ইতিহাস';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get navDiagnosis => 'ফসল দেখুন';

  @override
  String get navDashboard => 'ড্যাশবোর্ড';

  @override
  String get navProducts => 'পণ্য';

  @override
  String get navOrders => 'অর্ডার';

  @override
  String get navReviews => 'পর্যালোচনা';

  @override
  String get navNews => 'কৃষি বার্তা';

  @override
  String get navKnowledge => 'জ্ঞানভাণ্ডার';

  @override
  String get navVendors => 'বিক্রেতা';

  @override
  String get navUsers => 'ব্যবহারকারী';

  @override
  String get navSources => 'সূত্র';

  @override
  String get navLogs => 'লগ';

  @override
  String homeGreeting(String name) {
    return 'স্বাগতম, $name';
  }

  @override
  String get homeGreetingAnonymous => 'স্বাগতম';

  @override
  String get homeSubtitle => 'আজ কী করতে চান?';

  @override
  String get homeWeatherUnavailable => 'আবহাওয়া আনা যায়নি';

  @override
  String get homeWeatherReadAloud => 'আবহাওয়া পড়ে শোনান';

  @override
  String get homeUrgentTitle => 'জরুরি খবর';

  @override
  String get homeUrgentBody => 'আপনার ফসলের জন্য জরুরি একটি বার্তা আছে।';

  @override
  String get homeUrgentAction => 'খবরটি দেখুন';

  @override
  String get homeTileCheckCrop => 'ফসল দেখুন';

  @override
  String get homeTileCheckCropHint => 'পাতার ছবি তুলে রোগ জানুন';

  @override
  String get homeTileAsk => 'কথা বলুন';

  @override
  String get homeTileAskHint => 'বাংলায় প্রশ্ন করুন';

  @override
  String get homeTileAdvice => 'ফসল পরামর্শ';

  @override
  String get homeTileAdviceHint => 'কোন ফসল লাগাবেন';

  @override
  String get homeTileWeather => 'আবহাওয়া';

  @override
  String get homeTileWeatherHint => 'বৃষ্টি আর গরমের খবর';

  @override
  String get homeTileNews => 'কৃষি বার্তা';

  @override
  String get homeTileNewsHint => 'নতুন রোগ আর পোকার খবর';

  @override
  String get homeTileMarket => 'হাট বাজার';

  @override
  String get homeTileMarketHint => 'যাচাই করা বিক্রেতার পণ্য';

  @override
  String get homeContrastToggle => 'স্পষ্ট মোড';

  @override
  String get homeContrastToggleHint => 'রোদে ভালো দেখতে';

  @override
  String get homeRecentTitle => 'সাম্প্রতিক দেখা';

  @override
  String get defaultUserName => 'কৃষক';

  @override
  String get diagnosisCaptureTitle => 'পাতার ছবি তুলুন';

  @override
  String get diagnosisCaptureSubtitle => 'আক্রান্ত পাতাটি ছবির মাঝখানে রাখুন';

  @override
  String get diagnosisTipLight => 'ভালো আলোতে ছবি তুলুন';

  @override
  String get diagnosisTipCenter => 'একটি পাতা, মাঝখানে';

  @override
  String get diagnosisTipFocus => 'ঝাপসা হলে আবার তুলুন';

  @override
  String get diagnosisOpenCamera => 'ক্যামেরা খুলুন';

  @override
  String get diagnosisFromGallery => 'গ্যালারি থেকে নিন';

  @override
  String get diagnosisSelectCrop => 'কোন ফসল?';

  @override
  String get diagnosisCropRice => 'ধান';

  @override
  String get diagnosisCropPotato => 'আলু';

  @override
  String get diagnosisCropTomato => 'টমেটো';

  @override
  String get diagnosisCropUnknown => 'জানি না';

  @override
  String get diagnosisPreviewTitle => 'ছবিটি দেখে নিন';

  @override
  String get diagnosisPreviewBody =>
      'ছবি স্পষ্ট হলে পাঠিয়ে দিন, নাহলে আবার তুলুন।';

  @override
  String get diagnosisUsePhoto => 'এই ছবি পাঠান';

  @override
  String get diagnosisRetake => 'আবার তুলুন';

  @override
  String get diagnosisProcessingTitle => 'AI ছবি দেখছে…';

  @override
  String get diagnosisProcessingBody => 'একটু সময় লাগবে। অ্যাপ বন্ধ করবেন না।';

  @override
  String get diagnosisQueuedTitle => 'ছবি সংরক্ষণ করা হয়েছে';

  @override
  String get diagnosisQueuedBody => 'ইন্টারনেট এলে ছবিটি নিজে থেকে পাঠানো হবে।';

  @override
  String get diagnosisResultTitle => 'ফলাফল';

  @override
  String get diagnosisConfidenceLabel => 'নিশ্চয়তা';

  @override
  String get diagnosisConfidenceHigh => 'বেশ নিশ্চিত';

  @override
  String get diagnosisConfidenceMedium => 'মোটামুটি নিশ্চিত';

  @override
  String get diagnosisConfidenceLow => 'নিশ্চিত নই';

  @override
  String get diagnosisTreatmentTitle => 'কী করবেন';

  @override
  String get diagnosisReadAll => 'সব পড়ে শোনান';

  @override
  String get diagnosisOrderMedicine => 'ওষুধ অর্ডার করুন';

  @override
  String get diagnosisAskQuestion => 'প্রশ্ন করুন';

  @override
  String get diagnosisSendToExpert => 'বিশেষজ্ঞকে পাঠান';

  @override
  String get diagnosisSentToExpert =>
      'আপনার ছবিটি বিশেষজ্ঞের কাছে পাঠানো হয়েছে।';

  @override
  String get diagnosisExpertReviewed => 'বিশেষজ্ঞ যাচাই করেছেন';

  @override
  String get diagnosisLowTitle => 'নিশ্চিত হওয়া যায়নি';

  @override
  String get diagnosisLowBody =>
      'ছবিটি দেখে সঠিক রোগ বোঝা যাচ্ছে না, তাই রোগের নাম দেখানো হচ্ছে না। নতুন ছবি নিন বা বিশেষজ্ঞকে পাঠান।';

  @override
  String get diagnosisMediumCaution =>
      'আমি পুরোপুরি নিশ্চিত নই। সন্দেহ থাকলে বিশেষজ্ঞকে দেখান।';

  @override
  String get diagnosisHealthyTitle => 'গাছটি সুস্থ';

  @override
  String get diagnosisSafetyTitle => 'নিরাপত্তা';

  @override
  String get diagnosisSafetyBody =>
      'ওষুধ ব্যবহারের সময় মুখে-নাকে কাপড় দিন, পরে হাত-মুখ ধুয়ে ফেলুন। শিশুদের নাগালের বাইরে রাখুন।';

  @override
  String get diagnosisHistoryTitle => 'আপনার আগের ছবি';

  @override
  String get diagnosisHistoryEmptyTitle => 'এখনো কোনো ছবি নেই';

  @override
  String get diagnosisHistoryEmptyBody =>
      'প্রথম পাতা দেখতে ক্যামেরা বাটনে চাপ দিন।';

  @override
  String get diagnosisShowTop3 => 'AI-এর সন্দেহের তালিকা';

  @override
  String get diagnosisFeedbackThanks =>
      'ধন্যবাদ! আপনার মতামত শেখাতে সাহায্য করবে।';

  @override
  String get weatherTitle => 'আবহাওয়া';

  @override
  String get weatherHumidity => 'আর্দ্রতা';

  @override
  String get weatherWind => 'বাতাস';

  @override
  String get weatherRain => 'বৃষ্টি';

  @override
  String get weatherForecastTitle => 'আগামী দিনগুলো';

  @override
  String get weatherAlertsTitle => 'সতর্কতা';

  @override
  String get weatherNoAlerts => 'এখন কোনো সতর্কতা নেই';

  @override
  String weatherUpdated(String time) {
    return 'সর্বশেষ হালনাগাদ: $time';
  }

  @override
  String get profileTitle => 'প্রোফাইল';

  @override
  String get profileSettings => 'সেটিংস';

  @override
  String get profileEditTitle => 'তথ্য সম্পাদনা';

  @override
  String get profileLanguage => 'ভাষা';

  @override
  String get profileContrast => 'স্পষ্ট মোড';

  @override
  String get profileVoiceMode => 'ভয়েস মোড';

  @override
  String get profileVoiceModeHint => 'ফলাফল নিজে থেকে পড়ে শোনানো হবে';

  @override
  String get profileNotifications => 'খবরের বিজ্ঞপ্তি';

  @override
  String get profileConsent => 'আপনার অনুমতিপত্র';

  @override
  String get profileLogout => 'লগ আউট';

  @override
  String get profileLogoutConfirm => 'আপনি কি লগ আউট করতে চান?';

  @override
  String get profileDeleteAccount => 'অ্যাকাউন্ট মুছতে বলুন';

  @override
  String get profileDeleteAccountConfirm =>
      'আপনার তথ্য মুছে ফেলার অনুরোধ পাঠানো হবে। নিশ্চিত?';

  @override
  String profileVersion(String version) {
    return 'সংস্করণ $version';
  }

  @override
  String get profileSaved => 'সংরক্ষণ হয়েছে';

  @override
  String get voiceListening => 'বলুন, আমি শুনছি';

  @override
  String get voiceProcessing => 'বুঝছি…';

  @override
  String voiceUnderstood(String text) {
    return 'আপনি বলেছেন: $text';
  }

  @override
  String get voiceCouldNotUnderstand => 'আমি বুঝতে পারিনি';

  @override
  String get voiceAskAgain => 'আবার বলুন';

  @override
  String get voiceCancel => 'থামান';

  @override
  String get voiceUseTouch => 'হাতে চালান';

  @override
  String get voiceNoInternet =>
      'ইন্টারনেট নেই, তাই কথা শোনা যাচ্ছে না। হাতেই চালাতে পারবেন।';

  @override
  String get voiceMicLabel => 'কথা বলে অ্যাপ চালান';

  @override
  String get voiceConfirmationTitle => 'নিশ্চিত করুন';

  @override
  String get voiceConfirmationBody => 'আমি এই অর্ডারটি দিতে যাচ্ছি';

  @override
  String get productDescription => 'পণ্যের বিবরণ';

  @override
  String get selectQuantity => 'কতটি লাগবে';

  @override
  String get orderConfirmTitle => 'অর্ডার নিশ্চিত করুন';

  @override
  String get orderTotal => 'সর্বমোট';

  @override
  String get orderServerTotalNote => 'চূড়ান্ত হিসাব সার্ভার থেকে আসবে।';

  @override
  String get orderPaymentMode => 'পরিশোধের ধরন';

  @override
  String get orderPaymentCod => 'হাতে পেয়ে টাকা';

  @override
  String get orderPaymentDirect => 'সরাসরি বিক্রেতাকে';

  @override
  String get orderPlaced => 'অর্ডার দেওয়া হয়েছে';

  @override
  String get orderCannotCancel => 'এই অর্ডারটি আর বাতিল করা যাবে না।';

  @override
  String get orderCancelTitle => 'অর্ডার বাতিল করবেন?';

  @override
  String get orderOneVendorOnly => 'একটি অর্ডারে একই বিক্রেতার পণ্য থাকতে হবে।';

  @override
  String get marketAllCategories => 'সব ধরনের';

  @override
  String get marketInStockOnly => 'শুধু মজুদ থাকা পণ্য';

  @override
  String get marketOutOfStock => 'মজুদ নেই';

  @override
  String marketStockCount(String count) {
    return 'মজুদ: $count';
  }

  @override
  String get categorySeed => 'বীজ';

  @override
  String get categoryFertilizer => 'সার';

  @override
  String get categoryPesticide => 'কীটনাশক';

  @override
  String get categoryFungicide => 'ছত্রাকনাশক';

  @override
  String get categoryEquipment => 'যন্ত্রপাতি';

  @override
  String get categoryOther => 'অন্যান্য';

  @override
  String get vendorVerified => 'যাচাইকৃত বিক্রেতা';

  @override
  String get vendorNotVerified => 'এখনো যাচাই হয়নি';

  @override
  String get severityLow => 'কম';

  @override
  String get severityMedium => 'মাঝারি';

  @override
  String get severityHigh => 'বেশি';

  @override
  String get severityUrgent => 'জরুরি';

  @override
  String get orderStatusPending => 'অপেক্ষায়';

  @override
  String get orderStatusConfirmed => 'নিশ্চিত হয়েছে';

  @override
  String get orderStatusShipped => 'পাঠানো হয়েছে';

  @override
  String get orderStatusDelivered => 'পৌঁছে দেওয়া হয়েছে';

  @override
  String get orderStatusRejected => 'বাতিল করা হয়েছে';

  @override
  String get orderStatusCancelled => 'বাতিল';

  @override
  String get syncQueued => 'অপেক্ষায় আছে';

  @override
  String get syncUploading => 'পাঠানো হচ্ছে';

  @override
  String get syncSynced => 'পাঠানো হয়েছে';

  @override
  String get syncFailed => 'পাঠানো যায়নি';

  @override
  String get newsCategoryDisease => 'রোগ';

  @override
  String get newsCategoryPest => 'পোকা';

  @override
  String get newsCategoryVirus => 'ভাইরাস';

  @override
  String get newsCategoryNutrient => 'পুষ্টির অভাব';

  @override
  String get comingSoon => 'শীঘ্রই আসছে';

  @override
  String get comingSoonBody => 'এই অংশটি এখনো তৈরি হচ্ছে।';

  @override
  String get homeTileOrdersHint => 'কেনা-বেচার হিসাব দেখুন';

  @override
  String get homeTileHistoryHint => 'আগের ছবি আর পরামর্শ';

  @override
  String get homeFieldPrompt => 'আজ মাঠে কী সমস্যা?';

  @override
  String get homeFieldPromptHint => 'পাতার ছবি তুলুন — কয়েক সেকেন্ডেই পরামর্শ';

  @override
  String get homeScanAction => 'ছবি তুলুন';

  @override
  String get homeRecentEmpty => 'এখনো কোনো পাতা দেখা হয়নি';

  @override
  String get filterAll => 'সব';

  @override
  String get filterUncertain => 'নিশ্চিত নয়';

  @override
  String get profileAnimation => 'অ্যানিমেশন';

  @override
  String get profileAnimationHint => 'আকাশ আর ফসল ধীরে নড়বে';

  @override
  String get homeAnimationOn => 'অ্যানিমেশন চালু';

  @override
  String get homeAnimationOff => 'অ্যানিমেশন বন্ধ';

  @override
  String get homeSkyRain => 'আজ বৃষ্টির আকাশ';
}
