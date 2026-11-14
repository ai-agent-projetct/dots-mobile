import 'package:provider/config/app_env.dart';

class AppUrls {
  static String baseUrl = apiBaseUrl;

  static String v1 = '$baseUrl/api/v1';

  static String provider = '$v1/provider';

  static String getCategory = '$provider/getCategory';
  static String getSubCategory = '$provider/getSubCategory';
  static String updateproviderservices = '$provider/updateproviderservices';

  static String getprovidersubscription = '$provider/getprovidersubscription';
  static String createPayment = '$provider/createPayment';
  static String updatepayment = '$provider/updatepayment';
  static String createsubscriptions = '$provider/createsubscriptions';
  static String updateexpiredsubscription =
      '$provider/updateexpiredsubscriptions';
  static String addCashSubscription = '$provider/addCashSubscription';
  static String getprovidersubcriptions = '$provider/getprovidersubcriptions';

  static String fileUpload = '$provider/upload';
  static String checkUser = '$provider/check';
  static String signIn = '$provider/login';
  static String register = '$provider/register';
  static String logout = '$provider/logout';
  static String profileUpdate = '$provider/updateProviderDetails';

  static String createTrends = '$provider/createtrend';
  static String getAllTrends = '$provider/getalltrends';
  static String getTrendsById(String providerId) =>
      '$provider/gettrend/$providerId';
  static String updateTrends(String mediaId) =>
      '$provider/updatetrend/$mediaId';

  static String createOffers = '$provider/createalerts';
  static String getAllOffers = '$provider/getallalerts';
  static String updateOffer(String offerId) => '$provider/updatealert/$offerId';
  static String selectedservice = '$provider/providersubcategory-list';

  static String getappointments = '$provider/getappointments';
}
