import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/colors.dart';
import 'session_manager.dart';




void startActivity(BuildContext context, Widget navigatorScreenWidget) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return navigatorScreenWidget;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start from the right side
        const end = Offset.zero; // End at normal position
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}

apiFailed(BuildContext? context) {
  try {
    return ScaffoldMessenger.of(context!).showSnackBar(
      const SnackBar(
        content: Text("Something is not right from API, Please try again!"),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

String getFileNameWithExtension(String fileNameParam) {

  if((fileNameParam).isNotEmpty)
  {
    String fileName = fileNameParam;
    try {
      return fileName.split('/').last;
    } catch(e){
      return "";
    }
  }
  else
  {
    return "";
  }
}

String formatDate({
  DateTime? date,
  String? dateString,
  String inputFormat = "dd-MMM-yyyy",
  String outputFormat = "dd MMM, yyyy",
}) {
  try {
    DateTime parsedDate;

    if (date != null) {
      parsedDate = date;
    } else if (dateString != null && dateString.isNotEmpty) {
      parsedDate = DateFormat(inputFormat).parse(dateString);
    } else {
      return "-";
    }

    return DateFormat(outputFormat).format(parsedDate);
  } catch (e) {
    return "-";
  }
}

sendSMSCall(String conatctNo,String text,BuildContext? context)
async{
  String uri = 'sms:${conatctNo}?body=${text}';
  if (await canLaunchUrl(Uri.parse(uri))) {
    await launchUrl(Uri.parse(uri));
  } else {
    throw 'Could not launch $uri';
  }
}

String formatTimestamp(int timestamp) {
  // Convert seconds to DateTime
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true)
      .toLocal(); // Convert to local timezone

  // Format as yyyy-MM-ddTHH:mm
  String formatted =
      "${date.year.toString().padLeft(4, '0')}-"
      "${date.month.toString().padLeft(2, '0')}-"
      "${date.day.toString().padLeft(2, '0')}T"
      "${date.hour.toString().padLeft(2, '0')}:"
      "${date.minute.toString().padLeft(2, '0')}";

  return formatted;
}

closeAndStartActivity(BuildContext context, Widget screen){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => screen), (Route<dynamic> route) => false);
}

noInterNet(BuildContext? context) {
  try
  {
    return ScaffoldMessenger.of(context!).showSnackBar(
      const SnackBar(
        content: Text("Please check your internet connection!"),
        duration: Duration(seconds: 1),
      ),
    );
  }
  catch (e)
  {
    if (kDebugMode)
    {
      print(e);
    }
  }
}

showSnackBar(String? message,BuildContext? context) {
  try
  {
    return ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: black,
        content: Text(message!,style: const TextStyle(color: white,fontSize: 16,fontWeight: FontWeight.w400)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  catch (e)
  {
    if (kDebugMode)
    {
      print(e);
    }
  }
}

showToast(String? message,BuildContext? context){
  Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: black,
      textColor: white,
      fontSize: 16.0
  );
}

showToastLong(String? message,BuildContext? context){
  Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: black,
      textColor: white,
      fontSize: 16.0
  );
}


bool getIsLoggedIn(){
  SessionManager sessionManager = SessionManager();
  bool isLogin = false;
  if (sessionManager.checkIsLoggedIn() ?? false)
  {
    isLogin = true;
  }
  else
  {
    // sessionManager.setAuthToken(Access_Token_Static);
    isLogin = false;
  }
  return isLogin;
}

MaterialColor createMaterialColor(Color color) {
  try {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return const MaterialColor(0xFFFFFFFF, <int, Color>{});
  }
}


String capitalizeFirstLetter(String name) {
  if (name.isEmpty) return name;

  String firstChar = name[0];
  if (firstChar == firstChar.toLowerCase())
  {
    firstChar = firstChar.toUpperCase();
    return firstChar + name.substring(1);
  }

  return name;
}

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    currentFocus.unfocus();
  }
}

String toDisplayCase(String str) {
  try {
    if (str.isNotEmpty)
    {
      return str.toLowerCase().split(' ').where((word) => word.isNotEmpty).map((word)
      {
        return word[0].toUpperCase() + word.substring(1);
      }).join(' ');
    }
    else
    {
      return "";
    }
  }
  catch (e)
  {
    if (kDebugMode)
    {
      print(e);
    }
    return "";
  }
}

String getDateFromTimeStamp(int timeStamp, {bool isTimeOnly = false}){
  var dt = DateTime.fromMillisecondsSinceEpoch((timeStamp * 1000).toInt());
  var formatedDate = isTimeOnly ? DateFormat('hh:mm a').format(dt) : DateFormat('dd MMM, yyyy').format(dt);
  return formatedDate;
}

String universalDateConverter(String inputDateFormat,String outputDateFormat, String date) {
  String passDate = date;
  if (date.isNotEmpty)
  {
    try
    {
      var inputFormat = DateFormat(inputDateFormat);
      var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format
      var outputFormat = DateFormat(outputDateFormat);
      var outputDate = outputFormat.format(inputDate);
      print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format
      passDate = outputDate;
    }
    on Exception catch (e)
    {
      print("date converter error : $e");
    }
  }
  return passDate;
}

String timestampToDate(int timestampInSeconds) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInSeconds * 1000);
  return DateFormat('dd MMM, yyyy').format(dateTime);
}

String timestampToTime(int timestampInSeconds) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInSeconds * 1000);
  return DateFormat('hh:mm a').format(dateTime);
}
