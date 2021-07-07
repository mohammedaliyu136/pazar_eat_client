import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';

class PlaceOrderBody {
  List<CartModel> _products;
  List<Cart> _cart;
  //double _couponDiscountAmount;
  //String _couponDiscountTitle;
  double _orderAmount;
  String _orderType;
  AddressModel _deliveryAddress;
  String _paymentMethod;
  String _orderNote;
  String _couponCode;
  int _branchId;
  String _uid;
  String _restaurantId;

  String id;
  Coupon coupon;
  String paymentStatus;
  String orderStatus;
  String _transactionReference = '';
  String _createdAt;
  //String _updatedAt;
  String _deliveryId;
  String _deliveryCharge;
  //String _orderNote;
  //String _orderType


  PlaceOrderBody(
      {
        List<CartModel> products,
        @required List<Cart> cart,
        @required double couponDiscountAmount,
        @required String couponDiscountTitle,
        @required String couponCode,
        @required double orderAmount,
        @required AddressModel deliveryAddress,
        @required String orderType,
        @required String paymentMethod,
        @required int branchId,
        @required String orderNote,
        @required String uid,

        String transactionReference = '',
        @required String createdAt,
        @required String deliveryCharge,
        @required String id,
        @required Coupon coupon,
      }) {
    this._products = products;
    this._cart = cart;
    //this._couponDiscountAmount = couponDiscountAmount;
    //this._couponDiscountTitle = couponDiscountTitle;
    this._orderAmount = orderAmount;
    this._orderType = orderType;
    this._deliveryAddress = deliveryAddress;
    this._paymentMethod = paymentMethod;
    this._orderNote = orderNote;
    this._couponCode = couponCode;
    this._branchId = branchId;
    this._uid = uid;
  }

  List<Cart> get cart => _cart;
  List<CartModel> get products => _products;
  //double get couponDiscountAmount => _couponDiscountAmount;
  //String get couponDiscountTitle => _couponDiscountTitle;
  double get orderAmount => _orderAmount;
  String get orderType => _orderType;
  AddressModel get deliveryAddress => _deliveryAddress;
  String get paymentMethod => _paymentMethod;
  String get orderNote => _orderNote;
  String get couponCode => _couponCode;
  int get branchId => _branchId;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart.add(new Cart.fromJson(v));
      });
    }
    //_couponDiscountAmount = json['coupon_discount_amount'];
    //_couponDiscountTitle = json['coupon_discount_title'];
    _orderAmount = json['order_amount'];
    _orderType = json['order_type'];
    _deliveryAddress = json['delivery_address'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _branchId = json['branch_id'];
    _uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._products != null) {
      data['products'] = this._products.map((v) => v.toJson()).toList();
    }
    if (this._cart != null) {
      data['cart'] = this._cart.map((v) => v.toJson()).toList();
    }
    //data['coupon_discount_amount'] = this._couponDiscountAmount;
    //data['coupon_discount_title'] = this._couponDiscountTitle;
    data['order_amount'] = this._orderAmount;
    data['order_type'] = this._orderType;
    data['order_status'] = 'pending';
    data['payment_status'] = 'paid';
    //data['details_count'] = this._cart.length;
    data['delivery_address'] = _deliveryAddress.toJson();
    data['details_count'] = this._products.length;
    data['date'] = FieldValue.serverTimestamp();
    data['payment_method'] = this._paymentMethod;
    data['order_note'] = this._orderNote;
    data['coupon_code'] = this._couponCode;
    data['branch_id'] = this._branchId;
    data['uid'] = this._uid;
    return data;
  }

  setUserInfo({userID, restaurantID}){
    this._uid=userID;
    this._restaurantId=restaurantID;
  }
}

class Cart {
  String _productId;
  String _price;
  String _variant;
  //List<Variation> _variation;
  double _discountAmount;
  int _quantity;
  double _taxAmount;
  List<int> _addOnIds;
  List<int> _addOnQtys;

  Cart(
      String productId,
        String price,
        String variant,
        //List<Variation> variation,
        double discountAmount,
        int quantity,
        double taxAmount,
        List<int> addOnIds,
        List<int> addOnQtys) {
    this._productId = productId;
    this._price = price;
    this._variant = variant;
    //this._variation = variation;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._addOnIds = addOnIds;
    this._addOnQtys = addOnQtys;
  }

  String get productId => _productId;
  String get price => _price;
  String get variant => _variant;
  //List<Variation> get variation => _variation;
  double get discountAmount => _discountAmount;
  int get quantity => _quantity;
  double get taxAmount => _taxAmount;
  List<int> get addOnIds => _addOnIds;
  List<int> get addOnQtys => _addOnQtys;

  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _price = json['price'];
    _variant = json['variant'];
    /*
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation.add(new Variation.fromJson(v));
      });
    }
    */
    _discountAmount = json['discount_amount'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'];
    _addOnIds = json['add_on_ids'].cast<int>();
    _addOnQtys = json['add_on_qtys'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this._productId;
    data['product_id'] = this._productId;
    data['price'] = this._price;
    data['variant'] = this._variant;
    /*
    if (this._variation != null) {
      data['variation'] = this._variation.map((v) => v.toJson()).toList();
    }
    */
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['add_on_ids'] = this._addOnIds;
    data['add_on_qtys'] = this._addOnQtys;
    return data;
  }
}
