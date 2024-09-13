class Urlsclass {
  static String baseUrl = " ";//"https://namami-infotech.com/EvaraBackend/";

  //Login & Registration Page baseUrl
  static String login = "${baseUrl}src/auth/login.php";
  static String registration = "${baseUrl}src/auth/register.php";

  //HomePage baseUrl
  static String trendingOfferProductsUrl = "${baseUrl}src/sku/offers_sku.php";
  static String topSellingProductsUrl = "${baseUrl}src/sku/top_selling.php";
  static String fetchBannersUrl = "${baseUrl}src/banner/get_banner.php";
  static String fetchProductDetailsUrl = "${baseUrl}src/sku/get_sku.php?medicine_id=";

  //SearchPage baseUrl
  static String searchPageUrl = "${baseUrl}src/sku/list_sku.php";

  //SupportPage baseUrl
  static String supportPageUrl = "${baseUrl}src/support/get_support.php";

  //OrderPage baseUrl
  static String orderPageUrl = "${baseUrl}src/order/get_orders.php?user_id=";

  //OrderSummaryPage baseUrl
  static String orderSummaryPageUrl = "${baseUrl}src/order/order_product.php";

  // Method to update the baseUrl
  static void updateBaseUrl(String newUrl) {
    baseUrl = newUrl;
    // Update other URLs based on the new baseUrl
    login = "${baseUrl}src/auth/login.php";
    registration = "${baseUrl}src/auth/register.php";
    trendingOfferProductsUrl = "${baseUrl}src/sku/offers_sku.php";
    topSellingProductsUrl = "${baseUrl}src/sku/top_selling.php";
    fetchBannersUrl = "${baseUrl}src/banner/get_banner.php";
    fetchProductDetailsUrl = "${baseUrl}src/sku/get_sku.php?medicine_id=";
    searchPageUrl = "${baseUrl}src/sku/list_sku.php";
    supportPageUrl = "${baseUrl}src/support/get_support.php";
    orderPageUrl = "${baseUrl}src/order/get_orders.php?user_id=";
    orderSummaryPageUrl = "${baseUrl}src/order/order_product.php";
  }
}


// class Urlsclass{
//   static const String baseUrl = "https://namami-infotech.com/EvaraBackend/";
//
//   //Login & Registration Page baseUrl
//   static const String login = "${baseUrl}src/auth/login.php";
//   static const String registration = "${baseUrl}src/auth/register.php";
//
//   //HomePage baseUrl
//   static const String trendingOfferProductsUrl = "${baseUrl}src/sku/offers_sku.php";
//   static const String topSellingProductsUrl = "${baseUrl}src/sku/top_selling.php";
//   static const String fetchBannersUrl = "${baseUrl}src/banner/get_banner.php";
//   static const String fetchProductDetailsUrl = "${baseUrl}src/sku/get_sku.php?medicine_id=";
//
//   //SearchPage baseUrl
//   static const String searchPageUrl = "${baseUrl}src/sku/list_sku.php";
//
//   //SupportPage baseUrl
//   static const String supportPageUrl = "${baseUrl}src/support/get_support.php";
//
//   //OrderPage baseUrl
//   static const String orderPageUrl = "${baseUrl}src/order/get_orders.php?user_id=";
//
//   //OrderSummaryPage baseUrl
//   static const String orderSummaryPageUrl = "${baseUrl}src/order/order_product.php";
// }
//
