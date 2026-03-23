import 'dart:convert';
/// success : 1
/// message : "Order placed successfully"
/// order_no : "ATF000053"
/// total_amount : 680

PlaceOrderResponseModel placeOrderResponseModelFromJson(String str) => PlaceOrderResponseModel.fromJson(json.decode(str));
String placeOrderResponseModelToJson(PlaceOrderResponseModel data) => json.encode(data.toJson());
class PlaceOrderResponseModel {
  PlaceOrderResponseModel({
      num? success, 
      String? message, 
      String? orderNo, 
      num? totalAmount,}){
    _success = success;
    _message = message;
    _orderNo = orderNo;
    _totalAmount = totalAmount;
}

  PlaceOrderResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _orderNo = json['order_no'];
    _totalAmount = json['total_amount'];
  }
  num? _success;
  String? _message;
  String? _orderNo;
  num? _totalAmount;
PlaceOrderResponseModel copyWith({  num? success,
  String? message,
  String? orderNo,
  num? totalAmount,
}) => PlaceOrderResponseModel(  success: success ?? _success,
  message: message ?? _message,
  orderNo: orderNo ?? _orderNo,
  totalAmount: totalAmount ?? _totalAmount,
);
  num? get success => _success;
  String? get message => _message;
  String? get orderNo => _orderNo;
  num? get totalAmount => _totalAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['order_no'] = _orderNo;
    map['total_amount'] = _totalAmount;
    return map;
  }

}