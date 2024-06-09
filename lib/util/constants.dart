class Constants {
  static String authTokenK = "auth-token";
  static String authTokenV = "ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa";

  static String courseFlagK = "course-flag";
  static String courseFlagV = "fa";

  static headers() {
    Map<String, dynamic> header = {
      Constants.authTokenK: Constants.authTokenV,
      Constants.courseFlagK: Constants.courseFlagV
    };

    return header;
  }
}
