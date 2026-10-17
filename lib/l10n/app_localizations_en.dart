// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'AgriSense';

  @override
  String get appTagline => 'Your farming adviser, in your pocket';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionSave => 'Save';

  @override
  String get actionNext => 'Next';

  @override
  String get actionBack => 'Go back';

  @override
  String get actionClose => 'Close';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionSeeAll => 'See all';

  @override
  String get actionReadAloud => 'Read aloud';

  @override
  String get actionStopReading => 'Stop reading';

  @override
  String get stateLoading => 'Just a moment…';

  @override
  String get stateEmptyTitle => 'Nothing here yet';

  @override
  String get stateEmptyBody => 'New items will show up here.';

  @override
  String get stateErrorTitle => 'Something went wrong';

  @override
  String get stateErrorBody =>
      'Try again. If it keeps happening, check back later.';

  @override
  String get statePermissionTitle => 'Permission needed';

  @override
  String get statePermissionBody =>
      'Turn the permission on in Settings to continue.';

  @override
  String get statePermissionAction => 'Open settings';

  @override
  String get offlineBanner => 'No internet. Photos will upload later.';

  @override
  String offlineQueued(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countText photos waiting',
      one: '1 photo waiting',
    );
    return '$_temp0';
  }

  @override
  String get aiBadge => 'AI';

  @override
  String get aiDisclaimer => 'This is guidance, not a final diagnosis.';

  @override
  String get aiMarksNotice => 'Orange items are produced by AI.';

  @override
  String get languageTitle => 'Choose your language';

  @override
  String get languageSubtitle => 'Pick the one you read most easily';

  @override
  String get languageBangla => 'বাংলা';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageContinue => 'Continue';

  @override
  String get languageSwitchLabel => 'Change language';

  @override
  String get consentTitle => 'Your permission is needed';

  @override
  String get consentSubtitle =>
      'We only use what you agree to, and you can change this any time.';

  @override
  String get consentPhotosTitle => 'Crop photos';

  @override
  String get consentPhotosBody =>
      'Photos are used to find the disease. Only you, an expert and an admin can see them.';

  @override
  String get consentLocationTitle => 'District';

  @override
  String get consentLocationBody =>
      'We need your district to match weather and news. We take the district only, never your address.';

  @override
  String get consentPhoneTitle => 'Mobile number';

  @override
  String get consentPhoneBody =>
      'Needed to keep your account and to tell you about orders.';

  @override
  String get consentVoiceTitle => 'Voice commands';

  @override
  String get consentVoiceBody =>
      'Speak in Bangla to control the app. Recordings are deleted once the command is understood.';

  @override
  String get consentAccept => 'I agree';

  @override
  String get consentDecline => 'Not now';

  @override
  String get obAccountTitle => 'Account';

  @override
  String get obAccountSubtitle =>
      'Log in if you already have an account, otherwise create one.';

  @override
  String get obLogin => 'Log in';

  @override
  String get obRegister => 'Create an account';

  @override
  String get loginTitle => 'Log in';

  @override
  String get loginSubtitle => 'Enter your mobile number and password';

  @override
  String get loginMobileLabel => 'Mobile number';

  @override
  String get loginMobileHint => '01XXXXXXXXX';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginSubmit => 'Log in';

  @override
  String get loginForgot => 'Forgot your password?';

  @override
  String get loginFailed => 'That number or password is not right.';

  @override
  String get roleTitle => 'Who are you?';

  @override
  String get roleSubtitle => 'Choose the one that matches your work';

  @override
  String get roleFarmer => 'Farmer';

  @override
  String get roleFarmerHint => 'To check crops and get advice';

  @override
  String get roleVendor => 'Vendor';

  @override
  String get roleVendorHint => 'To sell seeds, fertiliser and medicine';

  @override
  String get roleExpert => 'Agri expert';

  @override
  String get roleExpertHint => 'To advise and verify news';

  @override
  String get registerTitle => 'New account';

  @override
  String registerAs(String role) {
    return 'You are registering as: $role';
  }

  @override
  String get registerNameLabel => 'Your name';

  @override
  String get registerNameHint => 'Enter your full name';

  @override
  String get registerDistrictLabel => 'District';

  @override
  String get registerDistrictHint => 'Choose your district';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerPasswordHint => 'At least 8 characters';

  @override
  String get registerPasswordRule => 'Use at least 8 characters.';

  @override
  String get registerSubmit => 'Create account';

  @override
  String get registerShopNameLabel => 'Shop name';

  @override
  String get registerLicenseLabel => 'Trade licence number';

  @override
  String get registerSpecializationLabel => 'Your specialisation';

  @override
  String get registerCertificationLabel => 'Certificate number';

  @override
  String get registerAlreadyHave => 'Already have an account?';

  @override
  String get otpTitle => 'Enter the code';

  @override
  String otpBody(String mobile) {
    return 'Enter the 6-digit code sent to $mobile';
  }

  @override
  String get otpLabel => 'Code';

  @override
  String get otpHint => '6-digit code';

  @override
  String get otpSubmit => 'Verify';

  @override
  String get otpResend => 'Send the code again';

  @override
  String get otpInvalid => 'That code is not right. Please check it.';

  @override
  String get pendingTitle => 'Waiting for approval';

  @override
  String get pendingBody =>
      'Your application is being checked. We will tell you once it is approved.';

  @override
  String get pendingCheckStatus => 'Check status';

  @override
  String get accountStatusSuspendedTitle => 'Account suspended';

  @override
  String get accountStatusSuspendedBody => 'Contact support to find out more.';

  @override
  String get navHome => 'Home';

  @override
  String get navMarket => 'Market';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get navDiagnosis => 'Check crop';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navProducts => 'Products';

  @override
  String get navOrders => 'Orders';

  @override
  String get navReviews => 'Reviews';

  @override
  String get navNews => 'Krishi Barta';

  @override
  String get navKnowledge => 'Knowledge';

  @override
  String get navVendors => 'Vendors';

  @override
  String get navUsers => 'Users';

  @override
  String get navSources => 'Sources';

  @override
  String get navLogs => 'Logs';

  @override
  String homeGreeting(String name) {
    return 'Welcome, $name';
  }

  @override
  String get homeGreetingAnonymous => 'Welcome';

  @override
  String get homeSubtitle => 'What would you like to do?';

  @override
  String get homeWeatherUnavailable => 'Weather could not be loaded';

  @override
  String get homeWeatherReadAloud => 'Read the weather aloud';

  @override
  String get homeUrgentTitle => 'Urgent news';

  @override
  String get homeUrgentBody => 'There is an urgent alert for your crops.';

  @override
  String get homeUrgentAction => 'Read the news';

  @override
  String get homeTileCheckCrop => 'Check crop';

  @override
  String get homeTileCheckCropHint => 'Photograph a leaf to find the disease';

  @override
  String get homeTileAsk => 'Ask by voice';

  @override
  String get homeTileAskHint => 'Ask a question in Bangla';

  @override
  String get homeTileAdvice => 'Crop advice';

  @override
  String get homeTileAdviceHint => 'What to plant this season';

  @override
  String get homeTileWeather => 'Weather';

  @override
  String get homeTileWeatherHint => 'Rain and heat warnings';

  @override
  String get homeTileNews => 'Krishi Barta';

  @override
  String get homeTileNewsHint => 'News about new diseases and pests';

  @override
  String get homeTileMarket => 'Market';

  @override
  String get homeTileMarketHint => 'Products from verified vendors';

  @override
  String get homeContrastToggle => 'Sunlight mode';

  @override
  String get homeContrastToggleHint => 'Easier to read outdoors';

  @override
  String get homeRecentTitle => 'Recently checked';

  @override
  String get defaultUserName => 'Farmer';

  @override
  String get diagnosisCaptureTitle => 'Photograph the leaf';

  @override
  String get diagnosisCaptureSubtitle =>
      'Keep the affected leaf in the middle of the frame';

  @override
  String get diagnosisTipLight => 'Use good light';

  @override
  String get diagnosisTipCenter => 'One leaf, in the centre';

  @override
  String get diagnosisTipFocus => 'Retake if it looks blurry';

  @override
  String get diagnosisOpenCamera => 'Open camera';

  @override
  String get diagnosisFromGallery => 'Choose from gallery';

  @override
  String get diagnosisSelectCrop => 'Which crop?';

  @override
  String get diagnosisCropRice => 'Rice';

  @override
  String get diagnosisCropPotato => 'Potato';

  @override
  String get diagnosisCropTomato => 'Tomato';

  @override
  String get diagnosisCropUnknown => 'Not sure';

  @override
  String get diagnosisPreviewTitle => 'Check the photo';

  @override
  String get diagnosisPreviewBody =>
      'Send it if the photo is clear, otherwise take another.';

  @override
  String get diagnosisUsePhoto => 'Send this photo';

  @override
  String get diagnosisRetake => 'Take another';

  @override
  String get diagnosisProcessingTitle => 'AI is checking…';

  @override
  String get diagnosisProcessingBody =>
      'This takes a moment. Please keep the app open.';

  @override
  String get diagnosisQueuedTitle => 'Photo saved';

  @override
  String get diagnosisQueuedBody =>
      'It will be sent automatically once you are back online.';

  @override
  String get diagnosisResultTitle => 'Result';

  @override
  String get diagnosisConfidenceLabel => 'Confidence';

  @override
  String get diagnosisConfidenceHigh => 'Fairly confident';

  @override
  String get diagnosisConfidenceMedium => 'Somewhat confident';

  @override
  String get diagnosisConfidenceLow => 'Not confident';

  @override
  String get diagnosisTreatmentTitle => 'What to do';

  @override
  String get diagnosisReadAll => 'Read all steps aloud';

  @override
  String get diagnosisOrderMedicine => 'Order medicine';

  @override
  String get diagnosisAskQuestion => 'Ask a question';

  @override
  String get diagnosisSendToExpert => 'Send to an expert';

  @override
  String get diagnosisSentToExpert => 'Your photo has been sent to an expert.';

  @override
  String get diagnosisExpertReviewed => 'Verified by an expert';

  @override
  String get diagnosisLowTitle => 'Not sure enough';

  @override
  String get diagnosisLowBody =>
      'The disease could not be identified from this photo, so no name is shown. Take a new photo, or send it to an expert.';

  @override
  String get diagnosisMediumCaution =>
      'I am not fully sure. If in doubt, ask an expert.';

  @override
  String get diagnosisHealthyTitle => 'This plant looks healthy';

  @override
  String get diagnosisSafetyTitle => 'Safety';

  @override
  String get diagnosisSafetyBody =>
      'Cover your nose and mouth when spraying, wash your hands and face afterwards, and keep chemicals away from children.';

  @override
  String get diagnosisHistoryTitle => 'Your previous photos';

  @override
  String get diagnosisHistoryEmptyTitle => 'No photos yet';

  @override
  String get diagnosisHistoryEmptyBody =>
      'Press the camera button to check your first leaf.';

  @override
  String get diagnosisShowTop3 => 'What the AI also considered';

  @override
  String get diagnosisFeedbackThanks =>
      'Thank you! Your feedback helps it learn.';

  @override
  String get weatherTitle => 'Weather';

  @override
  String get weatherHumidity => 'Humidity';

  @override
  String get weatherWind => 'Wind';

  @override
  String get weatherRain => 'Rain';

  @override
  String get weatherForecastTitle => 'Next few days';

  @override
  String get weatherAlertsTitle => 'Alerts';

  @override
  String get weatherNoAlerts => 'No alerts right now';

  @override
  String weatherUpdated(String time) {
    return 'Last updated: $time';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileEditTitle => 'Edit details';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileContrast => 'Sunlight mode';

  @override
  String get profileVoiceMode => 'Voice mode';

  @override
  String get profileVoiceModeHint => 'Results are read aloud automatically';

  @override
  String get profileNotifications => 'News alerts';

  @override
  String get profileConsent => 'Your permissions';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileLogoutConfirm => 'Do you want to log out?';

  @override
  String get profileDeleteAccount => 'Request account deletion';

  @override
  String get profileDeleteAccountConfirm =>
      'A request to delete your data will be sent. Are you sure?';

  @override
  String profileVersion(String version) {
    return 'Version $version';
  }

  @override
  String get profileSaved => 'Saved';

  @override
  String get voiceListening => 'Speak, I am listening';

  @override
  String get voiceProcessing => 'Understanding…';

  @override
  String voiceUnderstood(String text) {
    return 'You said: $text';
  }

  @override
  String get voiceCouldNotUnderstand => 'I did not understand that';

  @override
  String get voiceAskAgain => 'Please say it again';

  @override
  String get voiceCancel => 'Stop';

  @override
  String get voiceUseTouch => 'Use the buttons';

  @override
  String get voiceNoInternet =>
      'No internet, so voice is unavailable. You can still use the buttons.';

  @override
  String get voiceMicLabel => 'Control the app by voice';

  @override
  String get voiceConfirmationTitle => 'Please confirm';

  @override
  String get voiceConfirmationBody => 'I am about to place this order';

  @override
  String get productDescription => 'Product details';

  @override
  String get selectQuantity => 'How many?';

  @override
  String get orderConfirmTitle => 'Confirm the order';

  @override
  String get orderTotal => 'Total';

  @override
  String get orderServerTotalNote =>
      'The final total is calculated by the server.';

  @override
  String get orderPaymentMode => 'Payment';

  @override
  String get orderPaymentCod => 'Cash on delivery';

  @override
  String get orderPaymentDirect => 'Pay the vendor';

  @override
  String get orderPlaced => 'Order placed';

  @override
  String get orderCannotCancel => 'This order can no longer be cancelled.';

  @override
  String get orderCancelTitle => 'Cancel this order?';

  @override
  String get orderOneVendorOnly =>
      'An order can only contain products from one vendor.';

  @override
  String get marketAllCategories => 'All categories';

  @override
  String get marketInStockOnly => 'In stock only';

  @override
  String get marketOutOfStock => 'Out of stock';

  @override
  String marketStockCount(String count) {
    return 'In stock: $count';
  }

  @override
  String get categorySeed => 'Seeds';

  @override
  String get categoryFertilizer => 'Fertiliser';

  @override
  String get categoryPesticide => 'Pesticide';

  @override
  String get categoryFungicide => 'Fungicide';

  @override
  String get categoryEquipment => 'Equipment';

  @override
  String get categoryOther => 'Other';

  @override
  String get vendorVerified => 'Verified vendor';

  @override
  String get vendorNotVerified => 'Not verified yet';

  @override
  String get severityLow => 'Low';

  @override
  String get severityMedium => 'Medium';

  @override
  String get severityHigh => 'High';

  @override
  String get severityUrgent => 'Urgent';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusConfirmed => 'Confirmed';

  @override
  String get orderStatusShipped => 'Shipped';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusRejected => 'Rejected';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get syncQueued => 'Waiting';

  @override
  String get syncUploading => 'Uploading';

  @override
  String get syncSynced => 'Uploaded';

  @override
  String get syncFailed => 'Upload failed';

  @override
  String get newsCategoryDisease => 'Disease';

  @override
  String get newsCategoryPest => 'Pest';

  @override
  String get newsCategoryVirus => 'Virus';

  @override
  String get newsCategoryNutrient => 'Nutrient deficiency';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get comingSoonBody => 'This part is still being built.';

  @override
  String get homeTileOrdersHint => 'Track what you bought';

  @override
  String get homeTileHistoryHint => 'Past photos and their advice';

  @override
  String get homeFieldPrompt => 'What\'s wrong in the field today?';

  @override
  String get homeFieldPromptHint => 'Photograph a leaf — advice in seconds';

  @override
  String get homeScanAction => 'Take a photo';

  @override
  String get homeRecentEmpty => 'No leaf checked yet';

  @override
  String get filterAll => 'All';

  @override
  String get filterUncertain => 'Not certain';

  @override
  String get profileAnimation => 'Animation';

  @override
  String get profileAnimationHint => 'The sky and crops move slowly';

  @override
  String get homeAnimationOn => 'Animation on';

  @override
  String get homeAnimationOff => 'Animation off';

  @override
  String get homeSkyRain => 'A rainy sky today';
}
