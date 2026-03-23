
import 'menu/MenuScreenResponseModel.dart';

class CartItemModel {
  String id;
  Products product;
  int quantity;
  String preference; // Regular / Jain
  String addOn;
  List<String> multipleAddonName;
  num price;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.preference,
    required this.addOn,
    required this.price,
    required this.multipleAddonName,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "product": product.toJson(),
      "quantity": quantity,
      "preference": preference,
      "addOn": addOn,
      "multipleAddonName": multipleAddonName,
      "price": price,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json["id"],
      product: Products.fromJson(json["product"]),
      quantity: json["quantity"],
      preference: json["preference"],
      addOn: json["addOn"],
      multipleAddonName: List<String>.from(json["multipleAddonName"] ?? []),
      price: json["price"],
    );
  }
}