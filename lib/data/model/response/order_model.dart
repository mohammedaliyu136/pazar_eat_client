import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';

class OrderModel {
  String _id;
  String _userId;
  int _foodItemsCount;
  String _orderStatus;
  Timestamp _createdAt;
  String _paymentStatus;
  String _paymentMethod;
  double _orderAmount;
  String _orderType;
  List<Product> _products;

  OrderModel(
      { String id,
        String userId,
        int foodItemsCount,
        String orderStatus,
        Timestamp createdAt,
        String paymentStatus,
        String paymentMethod,
        double orderAmount,
        String orderType,
        List<Product> products,
      }) {
    this._id = id;
    this._userId = userId;
    this._foodItemsCount = foodItemsCount;
    this._orderStatus = orderStatus;
    this._orderType = orderType;
    this._createdAt = createdAt;
    this._paymentStatus = paymentStatus;
    this._paymentMethod = paymentMethod;
    this._orderAmount = orderAmount;
    this._products = products;
    //this._cartModel = cartModel;
  }

  String get id => _id;
  String get userId => _userId;
  int get foodItemsCount => _foodItemsCount;
  String get orderStatus => _orderStatus;
  String get orderType => _orderType;
  Timestamp get createdAt => _createdAt;
  String get paymentStatus => _paymentStatus;
  String get paymentMethod => _paymentMethod;
  double get orderAmount => _orderAmount;
  List<Product> get products => _products;


  OrderModel.fromJson({Map<String, dynamic> json, id = ''}) {
    _id = id;
    _userId = json['uid'];
    _foodItemsCount = json['details_count'];
    _orderStatus = json['order_status'];
    _orderType = json['order_type'];
    _createdAt = json['date'];
    _paymentStatus = json['payment_status'];
    _paymentMethod = json['payment_method'];
    _orderAmount = json['order_amount'].toDouble();
    _products = [];
    print('**************');
    for (var i = 0; i < json['products'].length; i++) {
      //print(json['products'][i]);
      //print(Product.fromJson(json: json['products'][i]));
      //print(Product.fromJson(json: json['products'][i]).name);
      //print(Product.fromJson(json: json['products'][i]).price);
      //print(Product.fromJson(json: json['products'][i]).quantity);
      //print(Product.fromJson(json: json['products'][i]).image);
      _products.add(Product.fromJson(json: json['products'][i]));
    }
    print('**************');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    return data;
  }
}

class Product{
  String _id;
  String _image;
  String _name;
  int _quantity;
  double _price;
  double _discount;
  List<AddOn> _add_on;
  Product({
    String id,
    String image,
    String name,
    int quantity,
    double price,
    double discount,
    List<AddOn> add_on,
  }){
    this._id = id;
    this._name = name;
    this._quantity = quantity;
    this._price = price;
    this._add_on = add_on;
    this._discount = discount;
  }

  String get id => _id;
  String get image => _image;
  String get name => _name;
  int get quantity => _quantity;
  double get price => _price;
  double get discount => _discount;
  List<AddOn> get addOn => _add_on;

  Product.fromJson({Map<String, dynamic> json}) {
    _id = json['product']['id'];
    _image = json['product']['image'];
    _name = json['product']['name'];
    _quantity = json['quantity'];
    _price = json['product']['price'];
    _discount = json['discount'];
    _add_on = [];
    for (var i = 0; i < json['product']['add_ons'].length; i++){
      _add_on.add(AddOn.fromJson(json['product']['add_ons'][i]));
    }
  }

}

class Details {
  String _id;
  String _productId;
  String _orderId;
  double _price;
  String _productDetails;
  String _variation;
  double _discountOnProduct;
  String _discountType;
  int _quantity;
  //double _taxAmount;
  String _createdAt;
  String _updatedAt;
  String _addOnIds;
  String _variant;

  Details(
      {String id,
        String productId,
        String orderId,
        double price,
        String productDetails,
        String variation,
        double discountOnProduct,
        String discountType,
        int quantity,
        double taxAmount,
        String createdAt,
        String updatedAt,
        String addOnIds,
        String variant}) {
    this._id = id;
    this._productId = productId;
    this._orderId = orderId;
    this._price = price;
    this._productDetails = productDetails;
    this._variation = variation;
    this._discountOnProduct = discountOnProduct;
    this._discountType = discountType;
    this._quantity = quantity;
    //this._taxAmount = taxAmount;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._addOnIds = addOnIds;
    this._variant = variant;
  }

  String get id => _id;
  String get productId => _productId;
  String get orderId => _orderId;
  double get price => _price;
  String get productDetails => _productDetails;
  String get variation => _variation;
  double get discountOnProduct => _discountOnProduct;
  String get discountType => _discountType;
  int get quantity => _quantity;
  //double get taxAmount => _taxAmount;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get addOnIds => _addOnIds;
  String get variant => _variant;

  Details.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _orderId = json['order_id'];
    _price = json['price'].toDouble();
    _productDetails = json['product_details'];
    _variation = json['variation'];
    _discountOnProduct = json['discount_on_product'].toDouble();
    _discountType = json['discount_type'];
    _quantity = json['quantity'];
    //_taxAmount = json['tax_amount'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _addOnIds = json['add_on_ids'];
    _variant = json['variant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['product_id'] = this._productId;
    data['order_id'] = this._orderId;
    data['price'] = this._price;
    data['product_details'] = this._productDetails;
    data['variation'] = this._variation;
    data['discount_on_product'] = this._discountOnProduct;
    data['discount_type'] = this._discountType;
    data['quantity'] = this._quantity;
    //data['tax_amount'] = this._taxAmount;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['add_on_ids'] = this._addOnIds;
    data['variant'] = this._variant;
    return data;
  }
}

class DeliveryMan {
  String _id;
  String _fName;
  String _lName;
  String _phone;
  String _email;
  String _identityNumber;
  String _identityType;
  String _identityImage;
  String _image;
  String _password;
  String _createdAt;
  String _updatedAt;
  String _authToken;
  List<Rating> _rating;

  DeliveryMan(
      {String id,
        String fName,
        String lName,
        String phone,
        String email,
        String identityNumber,
        String identityType,
        String identityImage,
        String image,
        String password,
        String createdAt,
        String updatedAt,
        String authToken,
        List<Rating> rating}) {
    this._id = id;
    this._fName = fName;
    this._lName = lName;
    this._phone = phone;
    this._email = email;
    this._identityNumber = identityNumber;
    this._identityType = identityType;
    this._identityImage = identityImage;
    this._image = image;
    this._password = password;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._authToken = authToken;
    this._rating = rating;
  }

  String get id => _id;
  String get fName => _fName;
  String get lName => _lName;
  String get phone => _phone;
  String get email => _email;
  String get identityNumber => _identityNumber;
  String get identityType => _identityType;
  String get identityImage => _identityImage;
  String get image => _image;
  String get password => _password;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get authToken => _authToken;
  List<Rating> get rating => _rating;

  DeliveryMan.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _phone = json['phone'];
    _email = json['email'];
    _identityNumber = json['identity_number'];
    _identityType = json['identity_type'];
    _identityImage = json['identity_image'];
    _image = json['image'];
    _password = json['password'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _authToken = json['auth_token'];
    if (json['rating'] != null) {
      _rating = [];
      json['rating'].forEach((v) {
        _rating.add(new Rating.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['f_name'] = this._fName;
    data['l_name'] = this._lName;
    data['phone'] = this._phone;
    data['email'] = this._email;
    data['identity_number'] = this._identityNumber;
    data['identity_type'] = this._identityType;
    data['identity_image'] = this._identityImage;
    data['image'] = this._image;
    data['password'] = this._password;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['auth_token'] = this._authToken;
    if (this._rating != null) {
      data['rating'] = this._rating.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coupon {
  String _id;
  String _title;
  String _amount;
  String _owner;

  Coupon(
      {String id,
        String title,
        String amount,
        String owner}) {
    this._id = id;
    this._title = title;
    this._amount = amount;
    this._owner = owner;
  }

  String get id => _id;
  String get title => _title;
  String get amount => _amount;
  String get owner => _owner;

  Coupon.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _amount = json['amount'];
    _owner = json['owner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['amount'] = this._amount;
    data['owner'] = this._owner;
  }
}