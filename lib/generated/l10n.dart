// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Citio`
  String get page1Title {
    return Intl.message(
      'Welcome to Citio',
      name: 'page1Title',
      desc: '',
      args: [],
    );
  }

  /// `Your smart app for an easier life in your city.`
  String get page1Subtitle {
    return Intl.message(
      'Your smart app for an easier life in your city.',
      name: 'page1Subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Report a Problem`
  String get page2Title {
    return Intl.message(
      'Report a Problem',
      name: 'page2Title',
      desc: '',
      args: [],
    );
  }

  /// `Take a picture of any issue in the city and we'll send it immediately to the concerned authority.\nTrack the response, rate the solution, and share it on social media!`
  String get page2Subtitle {
    return Intl.message(
      'Take a picture of any issue in the city and we\'ll send it immediately to the concerned authority.\nTrack the response, rate the solution, and share it on social media!',
      name: 'page2Subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Government Services at Your Fingertips`
  String get page3Title {
    return Intl.message(
      'Government Services at Your Fingertips',
      name: 'page3Title',
      desc: '',
      args: [],
    );
  }

  /// `Everything you need from governmental transactions and services is now available in one place, easily.`
  String get page3Subtitle {
    return Intl.message(
      'Everything you need from governmental transactions and services is now available in one place, easily.',
      name: 'page3Subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Explore Vendors and Services`
  String get page4Title {
    return Intl.message(
      'Explore Vendors and Services',
      name: 'page4Title',
      desc: '',
      args: [],
    );
  }

  /// `Discover all shops, companies, and services in your city and order from them directly through the app.`
  String get page4Subtitle {
    return Intl.message(
      'Discover all shops, companies, and services in your city and order from them directly through the app.',
      name: 'page4Subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Connect with Your Community`
  String get page5Title {
    return Intl.message(
      'Connect with Your Community',
      name: 'page5Title',
      desc: '',
      args: [],
    );
  }

  /// `Follow the latest news, share your opinion, and be part of your city's social life.`
  String get page5Subtitle {
    return Intl.message(
      'Follow the latest news, share your opinion, and be part of your city\'s social life.',
      name: 'page5Subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Ready to Start?`
  String get page6Title {
    return Intl.message(
      'Ready to Start?',
      name: 'page6Title',
      desc: '',
      args: [],
    );
  }

  /// `Let’s change city life together!`
  String get page6Subtitle {
    return Intl.message(
      'Let’s change city life together!',
      name: 'page6Subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Service Details`
  String get vendorProfileTitle {
    return Intl.message(
      'Service Details',
      name: 'vendorProfileTitle',
      desc: '',
      args: [],
    );
  }

  /// `ratings`
  String get ratingText {
    return Intl.message(
      'ratings',
      name: 'ratingText',
      desc: '',
      args: [],
    );
  }

  /// `Track Order`
  String get trackOrderTitle {
    return Intl.message(
      'Track Order',
      name: 'trackOrderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load order`
  String get failedToLoadOrder {
    return Intl.message(
      'Failed to load order',
      name: 'failedToLoadOrder',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pendingStatus {
    return Intl.message(
      'Pending',
      name: 'pendingStatus',
      desc: '',
      args: [],
    );
  }

  /// `Est. delivery`
  String get estimatedDelivery {
    return Intl.message(
      'Est. delivery',
      name: 'estimatedDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Not Available`
  String get noEstimation {
    return Intl.message(
      'Not Available',
      name: 'noEstimation',
      desc: '',
      args: [],
    );
  }

  /// `Contact the Vendor`
  String get contactVendor {
    return Intl.message(
      'Contact the Vendor',
      name: 'contactVendor',
      desc: '',
      args: [],
    );
  }

  /// `Qty:`
  String get quantity {
    return Intl.message(
      'Qty:',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get services {
    return Intl.message(
      'Services',
      name: 'services',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred:`
  String get errorOccurred {
    return Intl.message(
      'An error occurred:',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `No sub-services available`
  String get noSubServices {
    return Intl.message(
      'No sub-services available',
      name: 'noSubServices',
      desc: '',
      args: [],
    );
  }

  /// `No products available`
  String get noProducts {
    return Intl.message(
      'No products available',
      name: 'noProducts',
      desc: '',
      args: [],
    );
  }

  /// `Latest Posts`
  String get latestPosts {
    return Intl.message(
      'Latest Posts',
      name: 'latestPosts',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get postShared {
    return Intl.message(
      'Post',
      name: 'postShared',
      desc: '',
      args: [],
    );
  }

  /// `https://cdn-icons-png.flaticon.com/128/11820/11820229.png`
  String get noAvatarUrl {
    return Intl.message(
      'https://cdn-icons-png.flaticon.com/128/11820/11820229.png',
      name: 'noAvatarUrl',
      desc: '',
      args: [],
    );
  }

  /// `Citio`
  String get appGalleryTitle {
    return Intl.message(
      'Citio',
      name: 'appGalleryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing...`
  String get refreshLoading {
    return Intl.message(
      'Refreshing...',
      name: 'refreshLoading',
      desc: '',
      args: [],
    );
  }

  /// `Press again to exit`
  String get pressAgainToExit {
    return Intl.message(
      'Press again to exit',
      name: 'pressAgainToExit',
      desc: '',
      args: [],
    );
  }

  /// `Service Request`
  String get serviceOrder {
    return Intl.message(
      'Service Request',
      name: 'serviceOrder',
      desc: '',
      args: [],
    );
  }

  /// `What are you looking for?`
  String get searchHint {
    return Intl.message(
      'What are you looking for?',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Error loading categories`
  String get categoryLoadError {
    return Intl.message(
      'Error loading categories',
      name: 'categoryLoadError',
      desc: '',
      args: [],
    );
  }

  /// `❌ Failed to load banners`
  String get bannerLoadError {
    return Intl.message(
      '❌ Failed to load banners',
      name: 'bannerLoadError',
      desc: '',
      args: [],
    );
  }

  /// `No categories available`
  String get noCategories {
    return Intl.message(
      'No categories available',
      name: 'noCategories',
      desc: '',
      args: [],
    );
  }

  /// `Error loading subcategories`
  String get subCategoryLoadError {
    return Intl.message(
      'Error loading subcategories',
      name: 'subCategoryLoadError',
      desc: '',
      args: [],
    );
  }

  /// `No subcategories available`
  String get noSubCategories {
    return Intl.message(
      'No subcategories available',
      name: 'noSubCategories',
      desc: '',
      args: [],
    );
  }

  /// `Top Rated`
  String get bestRated {
    return Intl.message(
      'Top Rated',
      name: 'bestRated',
      desc: '',
      args: [],
    );
  }

  /// `No products currently available.`
  String get noProductsAvailable {
    return Intl.message(
      'No products currently available.',
      name: 'noProductsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `❌ Error loading products: `
  String get errorLoadingProducts {
    return Intl.message(
      '❌ Error loading products: ',
      name: 'errorLoadingProducts',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred 😢`
  String get unexpectedError {
    return Intl.message(
      'An unexpected error occurred 😢',
      name: 'unexpectedError',
      desc: '',
      args: [],
    );
  }

  /// `❌ Error loading products:`
  String get productLoadError {
    return Intl.message(
      '❌ Error loading products:',
      name: 'productLoadError',
      desc: '',
      args: [],
    );
  }

  /// `No products currently available.`
  String get noProductshere {
    return Intl.message(
      'No products currently available.',
      name: 'noProductshere',
      desc: '',
      args: [],
    );
  }

  /// `Search Results`
  String get searchResults {
    return Intl.message(
      'Search Results',
      name: 'searchResults',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get noResults {
    return Intl.message(
      'No results found',
      name: 'noResults',
      desc: '',
      args: [],
    );
  }

  /// `❌ Error`
  String get error {
    return Intl.message(
      '❌ Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `No name`
  String get noName {
    return Intl.message(
      'No name',
      name: 'noName',
      desc: '',
      args: [],
    );
  }

  /// `No category`
  String get noCategory {
    return Intl.message(
      'No category',
      name: 'noCategory',
      desc: '',
      args: [],
    );
  }

  /// `LE`
  String get currency {
    return Intl.message(
      'LE',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get resetPasswordTitle {
    return Intl.message(
      'Forgot Password',
      name: 'resetPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email to reset your password`
  String get enterEmailToChangePassword {
    return Intl.message(
      'Enter your email to reset your password',
      name: 'enterEmailToChangePassword',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message(
      'Email',
      name: 'emailLabel',
      desc: '',
      args: [],
    );
  }

  /// `example@email.com`
  String get emailHint {
    return Intl.message(
      'example@email.com',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get emailRequired {
    return Intl.message(
      'Please enter your email',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get emailInvalid {
    return Intl.message(
      'Please enter a valid email',
      name: 'emailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `✅ Code sent successfully`
  String get otpSentSuccess {
    return Intl.message(
      '✅ Code sent successfully',
      name: 'otpSentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `❌ Failed to send code`
  String get otpSendFailed {
    return Intl.message(
      '❌ Failed to send code',
      name: 'otpSendFailed',
      desc: '',
      args: [],
    );
  }

  /// `Remembered your password?`
  String get rememberPassword {
    return Intl.message(
      'Remembered your password?',
      name: 'rememberPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Powered by Citio`
  String get poweredBy {
    return Intl.message(
      'Powered by Citio',
      name: 'poweredBy',
      desc: '',
      args: [],
    );
  }

  /// `Version 2.1.0`
  String get version {
    return Intl.message(
      'Version 2.1.0',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get register {
    return Intl.message(
      'Create Account',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Join Citio to manage your city services`
  String get registerSubtitle {
    return Intl.message(
      'Join Citio to manage your city services',
      name: 'registerSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone {
    return Intl.message(
      'Phone Number',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Building Number`
  String get buildingNumber {
    return Intl.message(
      'Building Number',
      name: 'buildingNumber',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get floorNumber {
    return Intl.message(
      'Floor',
      name: 'floorNumber',
      desc: '',
      args: [],
    );
  }

  /// `Register Now`
  String get registerNow {
    return Intl.message(
      'Register Now',
      name: 'registerNow',
      desc: '',
      args: [],
    );
  }

  /// `Registering...`
  String get registering {
    return Intl.message(
      'Registering...',
      name: 'registering',
      desc: '',
      args: [],
    );
  }

  /// `Account created successfully`
  String get accountCreated {
    return Intl.message(
      'Account created successfully',
      name: 'accountCreated',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create account`
  String get accountFailed {
    return Intl.message(
      'Failed to create account',
      name: 'accountFailed',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get enterName {
    return Intl.message(
      'Please enter your name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get enterPhone {
    return Intl.message(
      'Please enter your phone number',
      name: 'enterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get enterEmail {
    return Intl.message(
      'Please enter your email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get enterPassword {
    return Intl.message(
      'Please enter your password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordTooShort {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your address`
  String get enterAddress {
    return Intl.message(
      'Please enter your address',
      name: 'enterAddress',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTitle {
    return Intl.message(
      'Profile',
      name: 'profileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit Information`
  String get editData {
    return Intl.message(
      'Edit Information',
      name: 'editData',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Building Number`
  String get building {
    return Intl.message(
      'Building Number',
      name: 'building',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get floor {
    return Intl.message(
      'Floor',
      name: 'floor',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `✅ Account deleted successfully`
  String get accountDeleted {
    return Intl.message(
      '✅ Account deleted successfully',
      name: 'accountDeleted',
      desc: '',
      args: [],
    );
  }

  /// `❌ Failed to delete account`
  String get deleteFailed {
    return Intl.message(
      '❌ Failed to delete account',
      name: 'deleteFailed',
      desc: '',
      args: [],
    );
  }

  /// `Product Details`
  String get productDetails {
    return Intl.message(
      'Product Details',
      name: 'productDetails',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message(
      'Add to Cart',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `Added`
  String get added {
    return Intl.message(
      'Added',
      name: 'added',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get failed {
    return Intl.message(
      'Failed',
      name: 'failed',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Product not found`
  String get notFound {
    return Intl.message(
      'Product not found',
      name: 'notFound',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get ratingText1 {
    return Intl.message(
      'Rating',
      name: 'ratingText1',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get otpCode {
    return Intl.message(
      'Verification Code',
      name: 'otpCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code`
  String get enterOtp {
    return Intl.message(
      'Enter the code',
      name: 'enterOtp',
      desc: '',
      args: [],
    );
  }

  /// `We have sent a 4-digit code to your email`
  String get sentOtpToEmail {
    return Intl.message(
      'We have sent a 4-digit code to your email',
      name: 'sentOtpToEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the 4-digit code`
  String get enter4Digits {
    return Intl.message(
      'Please enter the 4-digit code',
      name: 'enter4Digits',
      desc: '',
      args: [],
    );
  }

  /// `✅ Code verified successfully`
  String get otpVerifiedSuccess {
    return Intl.message(
      '✅ Code verified successfully',
      name: 'otpVerifiedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Verify the code`
  String get verifyOtpError {
    return Intl.message(
      'Verify the code',
      name: 'verifyOtpError',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resendOtp {
    return Intl.message(
      'Resend Code',
      name: 'resendOtp',
      desc: '',
      args: [],
    );
  }

  /// `Resend in`
  String get resendIn {
    return Intl.message(
      'Resend in',
      name: 'resendIn',
      desc: '',
      args: [],
    );
  }

  /// `s`
  String get seconds {
    return Intl.message(
      's',
      name: 'seconds',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the code?`
  String get didNotReceiveOtp {
    return Intl.message(
      'Didn\'t receive the code?',
      name: 'didNotReceiveOtp',
      desc: '',
      args: [],
    );
  }

  /// `✅ Code resent successfully`
  String get otpResentSuccess {
    return Intl.message(
      '✅ Code resent successfully',
      name: 'otpResentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `❌ Failed to resend code`
  String get otpResentFailed {
    return Intl.message(
      '❌ Failed to resend code',
      name: 'otpResentFailed',
      desc: '',
      args: [],
    );
  }

  /// `❌ An error occurred during sending`
  String get errorOccurred1 {
    return Intl.message(
      '❌ An error occurred during sending',
      name: 'errorOccurred1',
      desc: '',
      args: [],
    );
  }

  /// `Order Details`
  String get orderDetails {
    return Intl.message(
      'Order Details',
      name: 'orderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Order Number:`
  String get orderNumber {
    return Intl.message(
      'Order Number:',
      name: 'orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `Store Name`
  String get vendorName {
    return Intl.message(
      'Store Name',
      name: 'vendorName',
      desc: '',
      args: [],
    );
  }

  /// `Order Status`
  String get orderStatus {
    return Intl.message(
      'Order Status',
      name: 'orderStatus',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount:`
  String get totalAmount {
    return Intl.message(
      'Total Amount:',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Order Date:`
  String get orderDate {
    return Intl.message(
      'Order Date:',
      name: 'orderDate',
      desc: '',
      args: [],
    );
  }

  /// `Ordered Products`
  String get orderedProducts {
    return Intl.message(
      'Ordered Products',
      name: 'orderedProducts',
      desc: '',
      args: [],
    );
  }

  /// `Quantity:`
  String get quantity1 {
    return Intl.message(
      'Quantity:',
      name: 'quantity1',
      desc: '',
      args: [],
    );
  }

  /// `Already rated`
  String get alreadyRated {
    return Intl.message(
      'Already rated',
      name: 'alreadyRated',
      desc: '',
      args: [],
    );
  }

  /// `Failed to submit rating`
  String get rateFailed {
    return Intl.message(
      'Failed to submit rating',
      name: 'rateFailed',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Details`
  String get deliveryDetails {
    return Intl.message(
      'Delivery Details',
      name: 'deliveryDetails',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get location {
    return Intl.message(
      'Address',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Delivery Time`
  String get estimatedTime {
    return Intl.message(
      'Estimated Delivery Time',
      name: 'estimatedTime',
      desc: '',
      args: [],
    );
  }

  /// `Track Order`
  String get trackOrder {
    return Intl.message(
      'Track Order',
      name: 'trackOrder',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred:`
  String get error1 {
    return Intl.message(
      'An error occurred:',
      name: 'error1',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get noData {
    return Intl.message(
      'No data available',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `EGP`
  String get egp {
    return Intl.message(
      'EGP',
      name: 'egp',
      desc: '',
      args: [],
    );
  }

  /// `Stars`
  String get ratingUnit {
    return Intl.message(
      'Stars',
      name: 'ratingUnit',
      desc: '',
      args: [],
    );
  }

  /// `https://cdn-icons-png.flaticon.com/512/13434/13434972.png`
  String get fallbackImage {
    return Intl.message(
      'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
      name: 'fallbackImage',
      desc: '',
      args: [],
    );
  }

  /// `LE`
  String get currencyLE {
    return Intl.message(
      'LE',
      name: 'currencyLE',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Delete`
  String get confirmDelete {
    return Intl.message(
      'Confirm Delete',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete`
  String get deleteMessage {
    return Intl.message(
      'Are you sure you want to delete',
      name: 'deleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Delete Failed`
  String get deleteFailed1 {
    return Intl.message(
      'Delete Failed',
      name: 'deleteFailed1',
      desc: '',
      args: [],
    );
  }

  /// `https://cdn-icons-png.flaticon.com/512/13434/13434972.png`
  String get defaultImage {
    return Intl.message(
      'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
      name: 'defaultImage',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationsTitle {
    return Intl.message(
      'Notifications',
      name: 'notificationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get filterAll {
    return Intl.message(
      'All',
      name: 'filterAll',
      desc: '',
      args: [],
    );
  }

  /// `Updates`
  String get filterUpdates {
    return Intl.message(
      'Updates',
      name: 'filterUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Offers`
  String get filterOffers {
    return Intl.message(
      'Offers',
      name: 'filterOffers',
      desc: '',
      args: [],
    );
  }

  /// `Alerts`
  String get filterAlerts {
    return Intl.message(
      'Alerts',
      name: 'filterAlerts',
      desc: '',
      args: [],
    );
  }

  /// `Mark all as read`
  String get markAllAsRead {
    return Intl.message(
      'Mark all as read',
      name: 'markAllAsRead',
      desc: '',
      args: [],
    );
  }

  /// `No notifications available`
  String get noNotifications {
    return Intl.message(
      'No notifications available',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Add Post`
  String get newPostTitle {
    return Intl.message(
      'Add Post',
      name: 'newPostTitle',
      desc: '',
      args: [],
    );
  }

  /// `https://via.placeholder.com/150`
  String get placeholderImage {
    return Intl.message(
      'https://via.placeholder.com/150',
      name: 'placeholderImage',
      desc: '',
      args: [],
    );
  }

  /// `Add Image`
  String get addImage {
    return Intl.message(
      'Add Image',
      name: 'addImage',
      desc: '',
      args: [],
    );
  }

  /// `Add Another Image`
  String get addAnotherImage {
    return Intl.message(
      'Add Another Image',
      name: 'addAnotherImage',
      desc: '',
      args: [],
    );
  }

  /// `Tap to select image`
  String get tapToSelectImage {
    return Intl.message(
      'Tap to select image',
      name: 'tapToSelectImage',
      desc: '',
      args: [],
    );
  }

  /// `Publish`
  String get publish {
    return Intl.message(
      'Publish',
      name: 'publish',
      desc: '',
      args: [],
    );
  }

  /// `You can add up to 5 images only`
  String get maxImageLimitMessage {
    return Intl.message(
      'You can add up to 5 images only',
      name: 'maxImageLimitMessage',
      desc: '',
      args: [],
    );
  }

  /// `Caption is too short!`
  String get captionTooShort {
    return Intl.message(
      'Caption is too short!',
      name: 'captionTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Caption cannot exceed 1000 characters`
  String get captionTooLong {
    return Intl.message(
      'Caption cannot exceed 1000 characters',
      name: 'captionTooLong',
      desc: '',
      args: [],
    );
  }

  /// `✅ Post published successfully`
  String get postSuccess {
    return Intl.message(
      '✅ Post published successfully',
      name: 'postSuccess',
      desc: '',
      args: [],
    );
  }

  /// `❌ Error occurred while publishing. Please try again`
  String get postError {
    return Intl.message(
      '❌ Error occurred while publishing. Please try again',
      name: 'postError',
      desc: '',
      args: [],
    );
  }

  /// `❌ An unexpected error occurred. Please try again`
  String get unexpectedError1 {
    return Intl.message(
      '❌ An unexpected error occurred. Please try again',
      name: 'unexpectedError1',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Take a photo`
  String get camera {
    return Intl.message(
      'Take a photo',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Choose from gallery`
  String get gallery {
    return Intl.message(
      'Choose from gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPasswordTitle {
    return Intl.message(
      'New Password',
      name: 'newPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPasswordHint {
    return Intl.message(
      'New Password',
      name: 'newPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPasswordHint {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `✅ Password changed successfully`
  String get passwordChangedSuccess {
    return Intl.message(
      '✅ Password changed successfully',
      name: 'passwordChangedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `❌ Failed to change password`
  String get passwordChangedFailed {
    return Intl.message(
      '❌ Failed to change password',
      name: 'passwordChangedFailed',
      desc: '',
      args: [],
    );
  }

  /// `❌ Error: `
  String get passwordError {
    return Intl.message(
      '❌ Error: ',
      name: 'passwordError',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Log in to manage your city services`
  String get loginSubText {
    return Intl.message(
      'Log in to manage your city services',
      name: 'loginSubText',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordHint {
    return Intl.message(
      'Password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginButton {
    return Intl.message(
      'Login',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  /// `Verifying...`
  String get loggingIn {
    return Intl.message(
      'Verifying...',
      name: 'loggingIn',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get noAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get loginEmailRequired {
    return Intl.message(
      'Please enter your email',
      name: 'loginEmailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get loginPasswordRequired {
    return Intl.message(
      'Please enter your password',
      name: 'loginPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get loginPasswordTooShort {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'loginPasswordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Powered by Citio\nversion 2.1.0`
  String get loginPoweredBy {
    return Intl.message(
      'Powered by Citio\nversion 2.1.0',
      name: 'loginPoweredBy',
      desc: '',
      args: [],
    );
  }

  /// `Add Post`
  String get addPostTitle {
    return Intl.message(
      'Add Post',
      name: 'addPostTitle',
      desc: '',
      args: [],
    );
  }

  /// `https://via.placeholder.com/150`
  String get placeholderImageUrl {
    return Intl.message(
      'https://via.placeholder.com/150',
      name: 'placeholderImageUrl',
      desc: '',
      args: [],
    );
  }

  /// `What’s on your mind...`
  String get hintText {
    return Intl.message(
      'What’s on your mind...',
      name: 'hintText',
      desc: '',
      args: [],
    );
  }

  /// `You can add up to 5 images only`
  String get maxImagesWarning {
    return Intl.message(
      'You can add up to 5 images only',
      name: 'maxImagesWarning',
      desc: '',
      args: [],
    );
  }

  /// `Caption is too short!`
  String get postTooShort {
    return Intl.message(
      'Caption is too short!',
      name: 'postTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Caption cannot exceed 1000 characters`
  String get postTooLong {
    return Intl.message(
      'Caption cannot exceed 1000 characters',
      name: 'postTooLong',
      desc: '',
      args: [],
    );
  }

  /// `Tap to select image`
  String get tapToChoose {
    return Intl.message(
      'Tap to select image',
      name: 'tapToChoose',
      desc: '',
      args: [],
    );
  }

  /// `Take a photo`
  String get takePhoto {
    return Intl.message(
      'Take a photo',
      name: 'takePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Choose from gallery`
  String get pickFromGallery {
    return Intl.message(
      'Choose from gallery',
      name: 'pickFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Add Post`
  String get addPost {
    return Intl.message(
      'Add Post',
      name: 'addPost',
      desc: '',
      args: [],
    );
  }

  /// `What’s on your mind...`
  String get captionHint {
    return Intl.message(
      'What’s on your mind...',
      name: 'captionHint',
      desc: '',
      args: [],
    );
  }

  /// `❌ Error occurred while publishing. Please try again`
  String get postFail {
    return Intl.message(
      '❌ Error occurred while publishing. Please try again',
      name: 'postFail',
      desc: '',
      args: [],
    );
  }

  /// `Tap to select image`
  String get tapToPickImage {
    return Intl.message(
      'Tap to select image',
      name: 'tapToPickImage',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get myOrdersTitle {
    return Intl.message(
      'My Orders',
      name: 'myOrdersTitle',
      desc: '',
      args: [],
    );
  }

  /// `No orders found`
  String get noOrdersFound {
    return Intl.message(
      'No orders found',
      name: 'noOrdersFound',
      desc: '',
      args: [],
    );
  }

  /// `Order #: #`
  String get orderNumberPrefix {
    return Intl.message(
      'Order #: #',
      name: 'orderNumberPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get productUnit {
    return Intl.message(
      'Product',
      name: 'productUnit',
      desc: '',
      args: [],
    );
  }

  /// `EGP`
  String get currency1 {
    return Intl.message(
      'EGP',
      name: 'currency1',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get categoryAll {
    return Intl.message(
      'All',
      name: 'categoryAll',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get categoryPending {
    return Intl.message(
      'Pending',
      name: 'categoryPending',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get categoryProcessing {
    return Intl.message(
      'Processing',
      name: 'categoryProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get categoryDelivered {
    return Intl.message(
      'Delivered',
      name: 'categoryDelivered',
      desc: '',
      args: [],
    );
  }

  /// `Add Complaint`
  String get addComplaint {
    return Intl.message(
      'Add Complaint',
      name: 'addComplaint',
      desc: '',
      args: [],
    );
  }

  /// `Ambulance`
  String get ambulance {
    return Intl.message(
      'Ambulance',
      name: 'ambulance',
      desc: '',
      args: [],
    );
  }

  /// `Fire Department`
  String get firefighter {
    return Intl.message(
      'Fire Department',
      name: 'firefighter',
      desc: '',
      args: [],
    );
  }

  /// `Police`
  String get police {
    return Intl.message(
      'Police',
      name: 'police',
      desc: '',
      args: [],
    );
  }

  /// `Press again to exit`
  String get tapAgainToExit {
    return Intl.message(
      'Press again to exit',
      name: 'tapAgainToExit',
      desc: '',
      args: [],
    );
  }

  /// `Government Services`
  String get governmentServices {
    return Intl.message(
      'Government Services',
      name: 'governmentServices',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Vendors`
  String get vendors {
    return Intl.message(
      'Vendors',
      name: 'vendors',
      desc: '',
      args: [],
    );
  }

  /// `What do you want`
  String get whatDoYouWant {
    return Intl.message(
      'What do you want',
      name: 'whatDoYouWant',
      desc: '',
      args: [],
    );
  }

  /// `Add Complaint`
  String get addComplaint1 {
    return Intl.message(
      'Add Complaint',
      name: 'addComplaint1',
      desc: '',
      args: [],
    );
  }

  /// `Ambulance`
  String get ambulance1 {
    return Intl.message(
      'Ambulance',
      name: 'ambulance1',
      desc: '',
      args: [],
    );
  }

  /// `Police`
  String get police1 {
    return Intl.message(
      'Police',
      name: 'police1',
      desc: '',
      args: [],
    );
  }

  /// `Fire Department`
  String get fireFighter1 {
    return Intl.message(
      'Fire Department',
      name: 'fireFighter1',
      desc: '',
      args: [],
    );
  }

  /// `Press again to exit`
  String get pressAgainToExit1 {
    return Intl.message(
      'Press again to exit',
      name: 'pressAgainToExit1',
      desc: '',
      args: [],
    );
  }

  /// `What do you want`
  String get whatDoYouWant1 {
    return Intl.message(
      'What do you want',
      name: 'whatDoYouWant1',
      desc: '',
      args: [],
    );
  }

  /// `Government Services`
  String get governmentServices1 {
    return Intl.message(
      'Government Services',
      name: 'governmentServices1',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products1 {
    return Intl.message(
      'Products',
      name: 'products1',
      desc: '',
      args: [],
    );
  }

  /// `Vendors`
  String get vendors1 {
    return Intl.message(
      'Vendors',
      name: 'vendors1',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Government Services`
  String get govServices {
    return Intl.message(
      'Government Services',
      name: 'govServices',
      desc: '',
      args: [],
    );
  }

  /// `Search for a government service`
  String get searchGovService {
    return Intl.message(
      'Search for a government service',
      name: 'searchGovService',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred: `
  String get errorOccurred5 {
    return Intl.message(
      'An error occurred: ',
      name: 'errorOccurred5',
      desc: '',
      args: [],
    );
  }

  /// `No service data available`
  String get noData5 {
    return Intl.message(
      'No service data available',
      name: 'noData5',
      desc: '',
      args: [],
    );
  }

  /// `Service Details`
  String get serviceDetailsTitle {
    return Intl.message(
      'Service Details',
      name: 'serviceDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `No required documents`
  String get noDocumentsRequired {
    return Intl.message(
      'No required documents',
      name: 'noDocumentsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Execution Duration`
  String get executionDuration {
    return Intl.message(
      'Execution Duration',
      name: 'executionDuration',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Time to Complete`
  String get expectedTime {
    return Intl.message(
      'Estimated Time to Complete',
      name: 'expectedTime',
      desc: '',
      args: [],
    );
  }

  /// `Duration not available`
  String get durationUnavailable {
    return Intl.message(
      'Duration not available',
      name: 'durationUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Request this service`
  String get requestService {
    return Intl.message(
      'Request this service',
      name: 'requestService',
      desc: '',
      args: [],
    );
  }

  /// `My Government Requests`
  String get myGovernmentRequests {
    return Intl.message(
      'My Government Requests',
      name: 'myGovernmentRequests',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Under Review`
  String get pending {
    return Intl.message(
      'Under Review',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get rejected {
    return Intl.message(
      'Rejected',
      name: 'rejected',
      desc: '',
      args: [],
    );
  }

  /// `Edited`
  String get edited {
    return Intl.message(
      'Edited',
      name: 'edited',
      desc: '',
      args: [],
    );
  }

  /// `Issues`
  String get issues {
    return Intl.message(
      'Issues',
      name: 'issues',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message(
      'Active',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  /// `Under Review`
  String get inReview {
    return Intl.message(
      'Under Review',
      name: 'inReview',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get accepted {
    return Intl.message(
      'Accepted',
      name: 'accepted',
      desc: '',
      args: [],
    );
  }

  /// `🚨 A server error occurred. It will be resolved soon.`
  String get serverError {
    return Intl.message(
      '🚨 A server error occurred. It will be resolved soon.',
      name: 'serverError',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get deleteImageConfirmTitle {
    return Intl.message(
      'Are you sure?',
      name: 'deleteImageConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete your current profile picture?`
  String get deleteImageConfirmContent {
    return Intl.message(
      'Do you want to delete your current profile picture?',
      name: 'deleteImageConfirmContent',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Delete`
  String get delete {
    return Intl.message(
      'Yes, Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Profile picture deleted ✅`
  String get imageDeleted {
    return Intl.message(
      'Profile picture deleted ✅',
      name: 'imageDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Please fill out this field`
  String get fillField {
    return Intl.message(
      'Please fill out this field',
      name: 'fillField',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get nameHint {
    return Intl.message(
      'Name',
      name: 'nameHint',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneHint {
    return Intl.message(
      'Phone Number',
      name: 'phoneHint',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get addressHint {
    return Intl.message(
      'Address',
      name: 'addressHint',
      desc: '',
      args: [],
    );
  }

  /// `Building`
  String get buildingHint {
    return Intl.message(
      'Building',
      name: 'buildingHint',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get floorHint {
    return Intl.message(
      'Floor',
      name: 'floorHint',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `✅ Changes saved successfully`
  String get saveSuccess {
    return Intl.message(
      '✅ Changes saved successfully',
      name: 'saveSuccess',
      desc: '',
      args: [],
    );
  }

  /// `❌ Failed to save changes`
  String get saveFail {
    return Intl.message(
      '❌ Failed to save changes',
      name: 'saveFail',
      desc: '',
      args: [],
    );
  }

  /// `Remove Image`
  String get removeImage {
    return Intl.message(
      'Remove Image',
      name: 'removeImage',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Edit Address`
  String get editAddress {
    return Intl.message(
      'Edit Address',
      name: 'editAddress',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `✅ Order sent successfully`
  String get orderSentSuccess {
    return Intl.message(
      '✅ Order sent successfully',
      name: 'orderSentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `❌ Failed to send order:`
  String get orderFailed {
    return Intl.message(
      '❌ Failed to send order:',
      name: 'orderFailed',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Order`
  String get confirmOrder {
    return Intl.message(
      'Confirm Order',
      name: 'confirmOrder',
      desc: '',
      args: [],
    );
  }

  /// `Enter card information`
  String get enterCardInfo {
    return Intl.message(
      'Enter card information',
      name: 'enterCardInfo',
      desc: '',
      args: [],
    );
  }

  /// `Pay Now`
  String get payNow {
    return Intl.message(
      'Pay Now',
      name: 'payNow',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Address`
  String get deliveryAddress {
    return Intl.message(
      'Delivery Address',
      name: 'deliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Requested Items`
  String get requestedItems {
    return Intl.message(
      'Requested Items',
      name: 'requestedItems',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Credit/Debit Card`
  String get creditCard {
    return Intl.message(
      'Credit/Debit Card',
      name: 'creditCard',
      desc: '',
      args: [],
    );
  }

  /// `Cash on Delivery`
  String get cashOnDelivery {
    return Intl.message(
      'Cash on Delivery',
      name: 'cashOnDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Order Summary`
  String get orderSummary {
    return Intl.message(
      'Order Summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get subTotal {
    return Intl.message(
      'Subtotal',
      name: 'subTotal',
      desc: '',
      args: [],
    );
  }

  /// `Tax`
  String get tax {
    return Intl.message(
      'Tax',
      name: 'tax',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message(
      'Delivery',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `✅ Order sent successfully`
  String get successOrder {
    return Intl.message(
      '✅ Order sent successfully',
      name: 'successOrder',
      desc: '',
      args: [],
    );
  }

  /// `✅ Payment successful`
  String get paymentSuccess {
    return Intl.message(
      '✅ Payment successful',
      name: 'paymentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `❌ Payment failed:`
  String get paymentFailed {
    return Intl.message(
      '❌ Payment failed:',
      name: 'paymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `❌ Failed to send order:`
  String get failOrder {
    return Intl.message(
      '❌ Failed to send order:',
      name: 'failOrder',
      desc: '',
      args: [],
    );
  }

  /// `Please enter full card details`
  String get enterCardDataSnack {
    return Intl.message(
      'Please enter full card details',
      name: 'enterCardDataSnack',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelText {
    return Intl.message(
      'Cancel',
      name: 'cancelText',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Shopping List`
  String get shoppingList {
    return Intl.message(
      'Shopping List',
      name: 'shoppingList',
      desc: '',
      args: [],
    );
  }

  /// `Activate`
  String get activate {
    return Intl.message(
      'Activate',
      name: 'activate',
      desc: '',
      args: [],
    );
  }

  /// `Enter discount code`
  String get enterDiscountCode {
    return Intl.message(
      'Enter discount code',
      name: 'enterDiscountCode',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message(
      'Subtotal',
      name: 'subtotal',
      desc: '',
      args: [],
    );
  }

  /// `Discount Value`
  String get discountValue {
    return Intl.message(
      'Discount Value',
      name: 'discountValue',
      desc: '',
      args: [],
    );
  }

  /// `Pay`
  String get pay {
    return Intl.message(
      'Pay',
      name: 'pay',
      desc: '',
      args: [],
    );
  }

  /// `Cart is empty`
  String get cartEmpty {
    return Intl.message(
      'Cart is empty',
      name: 'cartEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Discount applied successfully`
  String get discountApplied {
    return Intl.message(
      'Discount applied successfully',
      name: 'discountApplied',
      desc: '',
      args: [],
    );
  }

  /// `Invalid discount code`
  String get invalidDiscount {
    return Intl.message(
      'Invalid discount code',
      name: 'invalidDiscount',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
