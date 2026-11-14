import 'package:user/config/app_env.dart';

class AppUrls {
  static String baseUrl = apiBaseUrl;

  static String v1 = '$baseUrl/api/v1';

  static String user = '$v1/user';

  static String configUrl = '$user/config';
  static String userRegister = '$user/register';
  static String profileUpdate = '$user/profileUpdate';
  static String userLogin = '$user/login';
  static String checkUser = '$user/check';
  static String pwdUpdate = '$user/pwdUpdate';
  static String profileView = '$user/profileView';
  static String fileUpload = '$user/upload';
  static String logout = '$user/logout';
  static String fcmUpdate = '$user/updateFcm';
  static String dashboard = '$user/dashboard';
  static String subcategorylist = '$user/subcategorylist';
  static String providerNearBy = '$user/nearby';
  static String providerDetails = '$user/getProviderData';
  static String pollsList = '$user/getallpolls';
  static String pollTopics = '$user/getalltopics';
  static String createPoll = '$user/createPoll';
  static String votePoll = '$user/votePoll';
  static String createTrade = '$user/createTrade';
  static String getAllTrades = '$user/getAllTrades';
  static String getTradeById(String userId) => '$user/getTradeById/$userId';

  // static String getAllTrends = '$user/getallmedia';

  static String getAllTrends(double latitude, double longitude) =>
      '$user/getallmedia?latitude=$latitude&longitude=$longitude';

  static String moretrends(String mediaId) => '$user/moretrends/$mediaId';

  // static String getAllOffers = '$user/getalloffers';
  static String getAllOffers(double latitude, double longitude) =>
      '$user/getalloffers?latitude=$latitude&longitude=$longitude';

  static String selectOffers = '$user/selectoffers';

  static String addappointments = '$user/addappointments';
  static String getappointments = '$user/getappointments';

  static String getusersubscriptions = '$user/getusersubscription';
  static String createusersubscriptions = '$user/usersubscriptions';

  static final String getUserNotifications =
      "$user/getusernotifications?user_type=user";

  static String createreviews = '$user/createreviews';
  static String getRatings(String providerId) => '$user/getratings/$providerId';
}
