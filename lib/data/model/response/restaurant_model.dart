import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  String _id;
  String _name;
  String _address;
  String _deliveryTime;
  String _distance;
  String _imageURL;
  bool _available;

  String _openTime;
  String _closeTime;
  String _phone;
  String _email;
  String _deliveryCharge;
  bool _cashOnDelivery;
  bool _digitalPayment;
  String _aboutUs;

  List<CategoryModel> categories;

  RestaurantModel(
      {String id,
        String name,
        String address,
        String deliveryTime,
        String distance,
        String imageURL,
        bool available,

        String openingTime,
        String closingTime,
        String phone,
        String email,
        String deliveryCharge,
        bool cashOnDelivery,
        bool digitalPayment,
        String aboutUs,
      }) {
    this._id = id;
    this._name = name;
    this._address = address;
    this._deliveryTime = deliveryTime;
    this._distance = distance;
    this._imageURL = imageURL;
    this._available = available;

    this._openTime = openingTime;
    this._closeTime = closingTime;
    this._phone = phone;
    this._email = email;
    this._deliveryCharge = deliveryCharge;
    this._cashOnDelivery = cashOnDelivery;
    this._digitalPayment = digitalPayment;
    this._aboutUs = aboutUs;
  }

  String get id => _id;
  String get name => _name;
  String get address => _address;
  String get deliveryTime => _deliveryTime;
  String get distance => _distance;
  String get imageURL => _imageURL;
  bool get available => _available;

  String get openingTime => _openTime;
  String get closingTime => _closeTime;
  String get phone => _phone;
  String get email => _email;
  String get deliveryCharge => _deliveryCharge;
  bool get cashOnDelivery => _cashOnDelivery;
  bool get digitalPayment => _digitalPayment;
  String get aboutUs => _aboutUs;

  RestaurantModel.fromJson({Map<String, dynamic> json, String id=''}) {
    _id = id;
    _name = json['name'];
    _address = json['address'];
    _deliveryTime = json['delivery_time'];
    _distance = json['distance'];
    _imageURL = json['image_url'];
    _available = json['available'];

    _openTime = json['opening_time'];
    _closeTime = json['closing_time'];
    _phone = json['phone'];
    _email = json['email'];
    _deliveryCharge = json['delivery_charge'].toString();
    _cashOnDelivery = json['cash_on_delivery'];
    _digitalPayment = json['digital_payment'];
    _aboutUs = json['about_us'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['address'] = this._address;
    data['delivery_time'] = this._deliveryTime;
    data['distance'] = this._distance;
    data['image_url'] = this._imageURL;
    data['available'] = this._available;

    data['opening_time'] = this._openTime;
    data['closing_time'] = this._closeTime;
    data['phone'] = this._phone;
    data['email'] = this._email;
    data['delivery_charge'] = this._deliveryCharge;
    data['cash_on_delivery'] = this._cashOnDelivery;
    data['digital_payment'] = this._digitalPayment;
    data['about_us'] = this._aboutUs;
    return data;
  }
}

class CategoryModel{
  String _id;
  String _name;
  bool _available;
  String _restaurantId;

  CategoryModel({String id, String name, bool available, String restaurantId}){
    this._id = id;
    this._name = name;
    this._available = available;
    this._restaurantId = restaurantId;
  }

  String get id => _id;
  String get name => _name;
  bool get available => _available;
  String get restaurantId => _restaurantId;

  CategoryModel.fromJson(Map<String, dynamic> json, String id){
    _id = id;
    _name = json['name'];
    _available = json['available'];
    _restaurantId = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['available'] = this._available;
    data['restaurant_id'] = this._restaurantId;
    return data;
  }
}
