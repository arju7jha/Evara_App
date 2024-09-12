

class Urlsclass{
  static const String baseUrl="https://namami-infotech.com/EvaraBackend/";

  //Login & Registration Page baseUrl
  static const String login = baseUrl+"src/auth/login.php";
  static const String registration = baseUrl+"src/auth/register.php";

  //HomePage baseUrl
  static const String trendingOfferProductsUrl = baseUrl+"src/sku/offers_sku.php";
  static const String topSellingProductsUrl = baseUrl+"src/sku/top_selling.php";
  static const String fetchBannersUrl = baseUrl+"src/banner/get_banner.php";
  static const String fetchProductDetailsUrl = baseUrl + "src/sku/get_sku.php?medicine_id=";

  //SearchPage baseUrl
  static const String searchPageUrl = baseUrl + "src/sku/list_sku.php";

  //SupportPage baseUrl
  static const String supportPageUrl = baseUrl + "src/support/get_support.php";

  //OrderPage baseUrl
  static const String orderPageUrl = baseUrl + "src/order/get_orders.php?user_id=";

  //OrderSummaryPage baseUrl
  static const String orderSummaryPageUrl = baseUrl + "src/order/order_product.php";
}


// class Urlsclass{
//   static const String baseUrl="https://namami-infotech.com/HR-SMILE-BACKEND/src/";
//   static const  String deviceInfoUrl =baseUrl+"auth/devices.php";
//   static const String login=baseUrl+"auth/login.php";
//   static const String attendanceMarkurl=baseUrl+"attendance/mark_attendance.php";
// }