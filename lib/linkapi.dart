class applink {
  static const String server = "http://10.0.2.2/taxiapp";
  static const String linkImageRoot = "http://10.0.2.2/taxiapp/upload";

  static const String test = "$server/test.php";

  //auth
  static const String signup = "$server/auth/signup.php";
  static const String verifycodesignup = "$server/auth/verifycode.php";
  static const String login = "$server/auth/login.php";

  //forget password
  static const String checkemail = "$server/forgetpassword/checkemail.php";
  static const String resetpassword =
      "$server/forgetpassword/resetpassword.php";
  static const String verifycodeforgetpassword =
      "$server/forgetpassword/verifycode.php";

  //home
  static const String history = "$server/ride_history.php"; //ride history

  static const String viewHistory = "$server/view_history.php"; //view history
  static const String profile = "$server/update_profile.php"; //profile
  static const String UploadImage = "$server/updateImage.php"; //upload image

  static const String Card = "$server/card.php"; //card
  static const String viewCard = "$server/view_cards.php"; //view Cards

  //driver
  static const String driverSignUp =
      "$server/driver/driver_signup.php"; //driver signUp
  static const String viewDrivers =
      "$server/driver/view_drivers.php"; //Get all drivers data

  //comment
  static const String addingComment =
      "$server/comments/addingComment.php"; //adding comments api
  static const String viewComments =
      "$server/comments/view_comments.php"; //view comments api
}
/*
i have a problem when i do hot reload and the problem because iam working on the localhost i should put it on the server 
and then update the server link here
*/