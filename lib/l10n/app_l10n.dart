import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_l10n_en.dart';
import 'app_l10n_tr.dart';

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
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
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n? of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @firstSignIn.
  ///
  /// In en, this message translates to:
  /// **'Please login first👋'**
  String get firstSignIn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @emailText.
  ///
  /// In en, this message translates to:
  /// **'abc@xyz.com'**
  String get emailText;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Password'**
  String get enterPassword;

  /// No description provided for @loginWithAccount.
  ///
  /// In en, this message translates to:
  /// **'Login with your account'**
  String get loginWithAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t you have an account yet?'**
  String get dontHaveAccount;

  /// No description provided for @emailAlert.
  ///
  /// In en, this message translates to:
  /// **'E-mail field cannot be empty!'**
  String get emailAlert;

  /// No description provided for @emailAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your e-mail.'**
  String get emailAlertSubtitle;

  /// No description provided for @passwordAlert.
  ///
  /// In en, this message translates to:
  /// **'Password field cannot be empty!'**
  String get passwordAlert;

  /// No description provided for @passwordAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get passwordAlertSubtitle;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found!'**
  String get userNotFound;

  /// No description provided for @userNotFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If you don\'t have an account, you can register using the register button below.'**
  String get userNotFoundSubtitle;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password!'**
  String get wrongPassword;

  /// No description provided for @wrongPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You entered your password incorrectly, please try again...'**
  String get wrongPasswordSubtitle;

  /// No description provided for @enterEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your e-mail address.'**
  String get enterEmailHint;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter the e-mail address of the account whose password you want to reset:'**
  String get enterEmail;

  /// No description provided for @checkEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your e-mail address.'**
  String get checkEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid E-Mail Address!'**
  String get invalidEmail;

  /// No description provided for @invalidEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalidEmailSubtitle;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register!'**
  String get register;

  /// No description provided for @subtitle2.
  ///
  /// In en, this message translates to:
  /// **'You can register by filling out the fields below.'**
  String get subtitle2;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get yourName;

  /// No description provided for @yourSurname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get yourSurname;

  /// No description provided for @yourBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get yourBirthday;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Weak Password!'**
  String get weakPassword;

  /// No description provided for @weakPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The password you enter must contain at least 6 digits!'**
  String get weakPasswordSubtitle;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email!'**
  String get emailAlreadyInUse;

  /// No description provided for @emailAlreadyInUseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The Email address you entered is linked to another account!'**
  String get emailAlreadyInUseSubtitle;

  /// No description provided for @nameAlert.
  ///
  /// In en, this message translates to:
  /// **'Name Field Cannot Be Empty!'**
  String get nameAlert;

  /// No description provided for @nameAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get nameAlertSubtitle;

  /// No description provided for @surnameAlert.
  ///
  /// In en, this message translates to:
  /// **'Surname Field Cannot Be Empty!'**
  String get surnameAlert;

  /// No description provided for @surnameAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your surname.'**
  String get surnameAlertSubtitle;

  /// No description provided for @birthdayAlert.
  ///
  /// In en, this message translates to:
  /// **'Birthday Field Cannot Be Empty!'**
  String get birthdayAlert;

  /// No description provided for @birthdayAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth.'**
  String get birthdayAlertSubtitle;

  /// No description provided for @confirmButtonText.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get confirmButtonText;

  /// No description provided for @trashAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'The task will be moved to the trash!'**
  String get trashAlertTitle;

  /// No description provided for @trashAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to move task to trash?'**
  String get trashAlertSubtitle;

  /// No description provided for @alertApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get alertApprove;

  /// No description provided for @alertReject.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get alertReject;

  /// No description provided for @alertTitleLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log out!'**
  String get alertTitleLogOut;

  /// No description provided for @alertSubtitleLogOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get alertSubtitleLogOut;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @rePassword.
  ///
  /// In en, this message translates to:
  /// **'You can reset your password by filling in the fields below 🙂'**
  String get rePassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @oldPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Old Password'**
  String get oldPasswordHint;

  /// No description provided for @newPasswordText.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordText;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Your New Password'**
  String get passwordHint;

  /// No description provided for @oldPasswordAlert.
  ///
  /// In en, this message translates to:
  /// **'Old Password Field Cannot Be Empty!'**
  String get oldPasswordAlert;

  /// No description provided for @oldPasswordAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your old password.'**
  String get oldPasswordAlertSubtitle;

  /// No description provided for @newPasswordAlert.
  ///
  /// In en, this message translates to:
  /// **'New Password Field Cannot Be Empty!'**
  String get newPasswordAlert;

  /// No description provided for @newPasswordAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password.'**
  String get newPasswordAlertSubtitle;

  /// No description provided for @passwordConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your Password Has Been Changed Successfully.'**
  String get passwordConfirmed;

  /// No description provided for @passwordConfirmedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please login again using your new password.'**
  String get passwordConfirmedSubtitle;

  /// No description provided for @taskPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Editing Page'**
  String get taskPageTitle;

  /// No description provided for @taskPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can edit the name, type and information of the task👋'**
  String get taskPageSubtitle;

  /// No description provided for @taskPageTaskName.
  ///
  /// In en, this message translates to:
  /// **'Task Name'**
  String get taskPageTaskName;

  /// No description provided for @taskPageTaskType.
  ///
  /// In en, this message translates to:
  /// **'Task Type'**
  String get taskPageTaskType;

  /// No description provided for @taskPageTaskInfo.
  ///
  /// In en, this message translates to:
  /// **'Task Information'**
  String get taskPageTaskInfo;

  /// No description provided for @isTaskDone.
  ///
  /// In en, this message translates to:
  /// **'Is the task completed?'**
  String get isTaskDone;

  /// No description provided for @isTaskArchive.
  ///
  /// In en, this message translates to:
  /// **'Do you want to archive the task?'**
  String get isTaskArchive;

  /// No description provided for @taskMovedIntoArchive.
  ///
  /// In en, this message translates to:
  /// **'The task has been moved to the archive!'**
  String get taskMovedIntoArchive;

  /// No description provided for @taskMovedIntoCompleted.
  ///
  /// In en, this message translates to:
  /// **'The task has been moved to the completed task page!'**
  String get taskMovedIntoCompleted;

  /// No description provided for @updateButtonText.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButtonText;

  /// No description provided for @pomodoroTitle.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Settings'**
  String get pomodoroTitle;

  /// No description provided for @pomodoroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can set the pomodoro timer from the fields below.🙂'**
  String get pomodoroSubtitle;

  /// No description provided for @workTimer.
  ///
  /// In en, this message translates to:
  /// **'Working Time Duration'**
  String get workTimer;

  /// No description provided for @breakTimer.
  ///
  /// In en, this message translates to:
  /// **'Break Time'**
  String get breakTimer;

  /// No description provided for @longBreakTimer.
  ///
  /// In en, this message translates to:
  /// **'Long Break Time'**
  String get longBreakTimer;

  /// No description provided for @longBreakNumber.
  ///
  /// In en, this message translates to:
  /// **'The break at which the long break will be given'**
  String get longBreakNumber;

  /// No description provided for @workTimerSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Working Time Duration'**
  String get workTimerSelect;

  /// No description provided for @breakTimerSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Break Time'**
  String get breakTimerSelect;

  /// No description provided for @longBreakTimerSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Long Break Time'**
  String get longBreakTimerSelect;

  /// No description provided for @longBreakNumberSelect.
  ///
  /// In en, this message translates to:
  /// **'Select the break at which the long break will be given'**
  String get longBreakNumberSelect;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @noResult.
  ///
  /// In en, this message translates to:
  /// **'No Result!'**
  String get noResult;

  /// No description provided for @moveIntoTrash.
  ///
  /// In en, this message translates to:
  /// **'MOVE TO TRASH BIN'**
  String get moveIntoTrash;

  /// No description provided for @editText.
  ///
  /// In en, this message translates to:
  /// **'EDIT'**
  String get editText;

  /// No description provided for @noActiveTask.
  ///
  /// In en, this message translates to:
  /// **'No active task found!'**
  String get noActiveTask;

  /// No description provided for @noTask.
  ///
  /// In en, this message translates to:
  /// **'Task not found!'**
  String get noTask;

  /// No description provided for @addButtonText.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButtonText;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Editing'**
  String get editProfileTitle;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can edit your personal information👋'**
  String get editProfileSubtitle;

  /// No description provided for @buttonText.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonText;

  /// No description provided for @statisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTitle;

  /// No description provided for @taskFound.
  ///
  /// In en, this message translates to:
  /// **'Task found!'**
  String get taskFound;

  /// No description provided for @taskFoundDetailed.
  ///
  /// In en, this message translates to:
  /// **'There is another task with the same name, please change the task name.'**
  String get taskFoundDetailed;

  /// No description provided for @loginSpotify.
  ///
  /// In en, this message translates to:
  /// **'You must be logged into Spotify.'**
  String get loginSpotify;

  /// No description provided for @noSpotify.
  ///
  /// In en, this message translates to:
  /// **'Spotify app not found.'**
  String get noSpotify;

  /// No description provided for @reSignIn.
  ///
  /// In en, this message translates to:
  /// **'Please try logging in again.'**
  String get reSignIn;

  /// No description provided for @noSignIn.
  ///
  /// In en, this message translates to:
  /// **'Login failed, please try again.'**
  String get noSignIn;

  /// No description provided for @noArchiveTask.
  ///
  /// In en, this message translates to:
  /// **'Archived task not found!'**
  String get noArchiveTask;

  /// No description provided for @moveDonePage.
  ///
  /// In en, this message translates to:
  /// **'task has been moved to the completed task page!'**
  String get moveDonePage;

  /// No description provided for @moveTaskPage.
  ///
  /// In en, this message translates to:
  /// **'task moved to tasks page!'**
  String get moveTaskPage;

  /// No description provided for @moveArchive.
  ///
  /// In en, this message translates to:
  /// **'Unarchive selected tasks'**
  String get moveArchive;

  /// No description provided for @archivedTask.
  ///
  /// In en, this message translates to:
  /// **'Archived Tasks'**
  String get archivedTask;

  /// No description provided for @errorText.
  ///
  /// In en, this message translates to:
  /// **'There was an error'**
  String get errorText;

  /// No description provided for @moveTrashBin.
  ///
  /// In en, this message translates to:
  /// **'The task has been moved to the trash!'**
  String get moveTrashBin;

  /// No description provided for @noDoneTask.
  ///
  /// In en, this message translates to:
  /// **'Completed task not found!'**
  String get noDoneTask;

  /// No description provided for @selectUndone.
  ///
  /// In en, this message translates to:
  /// **'Mark selected tasks as incomplete'**
  String get selectUndone;

  /// No description provided for @doneTask.
  ///
  /// In en, this message translates to:
  /// **'Completed Tasks'**
  String get doneTask;

  /// No description provided for @noTaskTrash.
  ///
  /// In en, this message translates to:
  /// **'Task not found in trash!'**
  String get noTaskTrash;

  /// No description provided for @activeButton.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activeButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @trash.
  ///
  /// In en, this message translates to:
  /// **'Trash Bin'**
  String get trash;

  /// No description provided for @somethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWrong;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @noPic.
  ///
  /// In en, this message translates to:
  /// **'No picture selected!'**
  String get noPic;

  /// No description provided for @selectPic.
  ///
  /// In en, this message translates to:
  /// **'Choose Profile Picture'**
  String get selectPic;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// No description provided for @uSelectPic.
  ///
  /// In en, this message translates to:
  /// **'You can select a profile picture from the account settings page'**
  String get uSelectPic;

  /// No description provided for @accSettings.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get accSettings;

  /// No description provided for @uEditProfile.
  ///
  /// In en, this message translates to:
  /// **'You can edit your profile.'**
  String get uEditProfile;

  /// No description provided for @uChangePassword.
  ///
  /// In en, this message translates to:
  /// **'You can change your password.'**
  String get uChangePassword;

  /// No description provided for @uAppSettings.
  ///
  /// In en, this message translates to:
  /// **'You can adjust application settings.'**
  String get uAppSettings;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'Application Settings'**
  String get appSettings;

  /// No description provided for @uEditPomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro timer etc. you can make settings.'**
  String get uEditPomodoro;

  /// No description provided for @logOutAcc.
  ///
  /// In en, this message translates to:
  /// **'Sign out of the account.'**
  String get logOutAcc;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @taskBeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Tasks to Complete'**
  String get taskBeCompleted;

  /// No description provided for @passingTime.
  ///
  /// In en, this message translates to:
  /// **'Time spent on tasks today'**
  String get passingTime;

  /// No description provided for @pomoTodo.
  ///
  /// In en, this message translates to:
  /// **'Pomo2do'**
  String get pomoTodo;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @longBreak1.
  ///
  /// In en, this message translates to:
  /// **'Long break at the 1st break'**
  String get longBreak1;

  /// No description provided for @longBreak5.
  ///
  /// In en, this message translates to:
  /// **'Long break at the 5th break'**
  String get longBreak5;

  /// No description provided for @failConnect.
  ///
  /// In en, this message translates to:
  /// **'Could not connect!'**
  String get failConnect;

  /// No description provided for @connectSpotify.
  ///
  /// In en, this message translates to:
  /// **'Connect to Spotify'**
  String get connectSpotify;

  /// No description provided for @selectDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get selectDone;

  /// No description provided for @resetPomodoro.
  ///
  /// In en, this message translates to:
  /// **'Reset Pomodoro Counter'**
  String get resetPomodoro;

  /// No description provided for @pomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro'**
  String get pomodoro;

  /// No description provided for @uSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get uSure;

  /// No description provided for @pomodoroWillReset.
  ///
  /// In en, this message translates to:
  /// **'The Pomodoro counter will be reset!'**
  String get pomodoroWillReset;

  /// No description provided for @shortBreak.
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get shortBreak;

  /// No description provided for @longBreak.
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get longBreak;

  /// No description provided for @openSong.
  ///
  /// In en, this message translates to:
  /// **'Connected to Spotify, open the song from the app.'**
  String get openSong;

  /// No description provided for @errorPic.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while retrieving the photo.'**
  String get errorPic;

  /// No description provided for @takingPic.
  ///
  /// In en, this message translates to:
  /// **'Taking photo...'**
  String get takingPic;

  /// No description provided for @failedSignIn.
  ///
  /// In en, this message translates to:
  /// **'Login Failed!'**
  String get failedSignIn;

  /// No description provided for @workTime.
  ///
  /// In en, this message translates to:
  /// **'Weekly Working Time'**
  String get workTime;

  /// No description provided for @few.
  ///
  /// In en, this message translates to:
  /// **'Few'**
  String get few;

  /// No description provided for @much.
  ///
  /// In en, this message translates to:
  /// **'Much'**
  String get much;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'STOP'**
  String get stop;

  /// No description provided for @languagePreference.
  ///
  /// In en, this message translates to:
  /// **'Language Preference:'**
  String get languagePreference;

  /// No description provided for @themePreference.
  ///
  /// In en, this message translates to:
  /// **'Theme Preference:'**
  String get themePreference;

  /// No description provided for @shortBreakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shall we take a short break?'**
  String get shortBreakSubtitle;

  /// No description provided for @longBreakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shall we take a long break?'**
  String get longBreakSubtitle;

  /// No description provided for @shortBreakDone.
  ///
  /// In en, this message translates to:
  /// **'Short break has ended.'**
  String get shortBreakDone;

  /// No description provided for @shortBreakDoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shall we move on to the next Pomodoro timer?'**
  String get shortBreakDoneSubtitle;

  /// No description provided for @pomodoroCycleDone.
  ///
  /// In en, this message translates to:
  /// **'The Pomodoro cycle has been completed.'**
  String get pomodoroCycleDone;

  /// No description provided for @pomodoroCycleDoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Should we move on to the next cycle?'**
  String get pomodoroCycleDoneSubtitle;

  /// No description provided for @nextPomodoro.
  ///
  /// In en, this message translates to:
  /// **'You can start the next pomodoro.'**
  String get nextPomodoro;

  /// No description provided for @longBreakDone.
  ///
  /// In en, this message translates to:
  /// **'Long break has ended.'**
  String get longBreakDone;

  /// No description provided for @pomodoroNextCycle.
  ///
  /// In en, this message translates to:
  /// **'You can start the next cycle.'**
  String get pomodoroNextCycle;

  /// No description provided for @pomodoroDone.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro timer has ended.'**
  String get pomodoroDone;

  /// No description provided for @nextBreak.
  ///
  /// In en, this message translates to:
  /// **'You can start the next break.'**
  String get nextBreak;

  /// No description provided for @stopAlarm.
  ///
  /// In en, this message translates to:
  /// **'Stop the alarm'**
  String get stopAlarm;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightMode;

  /// No description provided for @appSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can set the application settings using the fields below.'**
  String get appSettingsSubtitle;

  /// No description provided for @setAlarm.
  ///
  /// In en, this message translates to:
  /// **'Should an alarm be set when the timer ends?'**
  String get setAlarm;

  /// No description provided for @setNotification.
  ///
  /// In en, this message translates to:
  /// **'Should a notification be sent when the timer ends?'**
  String get setNotification;

  /// No description provided for @resetPomodoroWarn.
  ///
  /// In en, this message translates to:
  /// **'Should a warning be shown when resetting the timer?'**
  String get resetPomodoroWarn;

  /// No description provided for @spotifyPlayer.
  ///
  /// In en, this message translates to:
  /// **'Should the Spotify player be displayed?'**
  String get spotifyPlayer;

  /// No description provided for @stopMusic.
  ///
  /// In en, this message translates to:
  /// **'Should music be stopped during breaks?'**
  String get stopMusic;

  /// No description provided for @onWeeklyPlacement.
  ///
  /// In en, this message translates to:
  /// **'Weekly Rank'**
  String get onWeeklyPlacement;

  /// No description provided for @tasksWorkedOn.
  ///
  /// In en, this message translates to:
  /// **'Tasks worked on '**
  String get tasksWorkedOn;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return L10nEn();
    case 'tr': return L10nTr();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
