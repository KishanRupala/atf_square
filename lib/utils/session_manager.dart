import 'dart:convert';
import '../model/common_model.dart';
import 'session_manager_methods.dart';

class SessionManager {
  final String isLoggedIn = "isLoggedIn";
   String cartKey = "cart";


  Future createLoginSession() async
  {
    await SessionManagerMethods.setBool(isLoggedIn, true);
  }

  bool? checkIsLoggedIn() {
    return SessionManagerMethods.getBool(isLoggedIn);
  }

  Future<void> setCartList(List<CartItemModel> list) async {
    final jsonList = list.map((perm) => perm.toJson()).toList();
    await SessionManagerMethods.setString(cartKey, jsonEncode(jsonList));
  }

  List<CartItemModel> getCartList() {
    final jsonString = SessionManagerMethods.getString(cartKey);
    if (jsonString != null && jsonString.isNotEmpty)
    {
      try
      {
        List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((item) => CartItemModel.fromJson(item)).toList();
      }
      catch (e)
      {
        print("Error decoding cart list: $e");
        return [];
      }
    }
    return [];
  }

  }
