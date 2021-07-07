import 'package:flutter_restaurant/data/model/response/product_model.dart';

class CartModel {
  double _price;
  double _discountedPrice;
  double _discountAmount;
  int _quantity;
  double _taxAmount;
  List<AddOn> _addOnIds;
  Product _product;

  CartModel(
        double price,
        double discountedPrice,
        List<Variation> variation,
        double discountAmount,
        int quantity,
        double taxAmount,
        List<AddOn> addOnIds,
        Product product) {
    this._price = price;
    this._discountedPrice = discountedPrice;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._addOnIds = addOnIds;
    this._product = product;
  }

  double get price => _price;
  double get discountedPrice => _discountedPrice;
  double get discountAmount => _discountAmount;
  // ignore: unnecessary_getters_setters
  int get quantity => _quantity;
  // ignore: unnecessary_getters_setters
  set quantity(int qty) => _quantity = qty;
  double get taxAmount => _taxAmount;
  List<AddOn> get addOnIds => _addOnIds;
  Product get product => _product;

  CartModel.fromJson(Map<String, dynamic> json) {
    _price = json['price'].toDouble();
    _discountedPrice = json['discounted_price'].toDouble();
    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
    if (json['add_on_ids'] != null) {
      _addOnIds = [];
      json['add_on_ids'].forEach((v) {
        _addOnIds.add(new AddOn.fromJson(v));
      });
    }
    if (json['product'] != null) {
      _product = Product.fromJson(json: json['product']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this._price;
    data['discounted_price'] = this._discountedPrice;
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    if (this._addOnIds != null) {
      data['add_on_ids'] = this._addOnIds.map((v) => v.toJson()).toList();
    }
    data['product'] = this._product.toJson();
    return data;
  }
}

class AddOn {
  int _id;
  String _name;
  int _quantity;
  double _price;

  AddOn({int id, String name, int quantity, double price}) {
    this._id = id;
    this._name = name;
    this._quantity = quantity;
    this._price = price;
  }

  int get id => _id;
  String get name => _name;
  int get quantity => _quantity;
  double get price => _price;

  AddOn.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _quantity = json['quantity'];
    _price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['quantity'] = this._quantity;
    data['price'] = this._price;
    return data;
  }
}
