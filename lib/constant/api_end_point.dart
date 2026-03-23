
import 'package:pretty_http_logger/pretty_http_logger.dart';

///live base url
const String apiUrl = "https://www.atfsquare.com/api/";

// LogLevel.BODY to set none when upload in play store
logger() => HttpWithMiddleware.build(middlewares: [
  HttpLogger(logLevel: LogLevel.BODY)
]);

//auth
String apiMenuItems = "${apiUrl}services/menu_items";
String apiPlaceOrder = "${apiUrl}services/place_order";




