import 'package:flutter_restaurant/data/model/response/order_model.dart';

class WishListModel {
  int id;
  int userId;
  Product product;
  String createdAt;
  String updatedAt;

  WishListModel(
      {this.id, this.userId, this.product, this.createdAt, this.updatedAt});

  WishListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    product = json['product'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product'] = this.product;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
