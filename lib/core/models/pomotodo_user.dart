class PomotodoUser {
  final String userId;
  final String userMail;
  final String? userPhotoUrl;
  final bool? loginProviderData;

  PomotodoUser(
      {required this.userId,
      required this.userMail,
      this.userPhotoUrl,
      this.loginProviderData});
}
