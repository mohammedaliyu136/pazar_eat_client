import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response2.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({@required this.dioClient, @required this.sharedPreferences});

  getOrdersList()async{
    List<OrderModel> orders = [];
    await FirebaseFirestore.instance
        .collection('orders_v3')
        .get().then((value){
      for (var i = 0; i < value.docs.length; i++) {
        print('---------------');
        print(value.docs[i].data()['products']);
        print('---------------');
        OrderModel order = OrderModel.fromJson(json: value.docs[i].data(), id: value.docs[i].id);
        orders.add(order);
         /*
        [
          {
            tax_amount: 0.0,
            quantity: 1,
            add_on_qtys: [1, 1],
            price: 640.0,
            discount_amount: 160.0,
            product_id: 0y2CpkgNNLGcls8IRwCs,
            variant: ,
            add_on_ids: [null, null]
          },
          {
            tax_amount: 0.0,
            quantity: 1,
            add_on_qtys: [1, 1],
            discount_amount: 30.0,
            price: 270.0,
            product_id: PxGf2PmJnBN7p4F8qs6o,
            variant: ,
            add_on_ids: [null, null]
          },
          {
            tax_amount: 0.0,
            quantity: 1,
            add_on_qtys: [1],
            discount_amount: 400.0, price: -200.0, product_id: brB4Dc7ZaocSeM05m0kL, variant: , add_on_ids: [null]}]

        */

        //print(DateConverter.isoStringToLocalDateOnly(order.dateTime.toDate().toIso8601String()));
      }
      //print(orders[0].foodItemsCount);
    });
    return FireBaseResponse.withSuccess(orders);
  }

  Future<ApiResponse> getOrderList() async {
    try {
      final response = await dioClient.get(AppConstants.ORDER_LIST_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOrderDetails(String orderID) async {
    try {
      final response = await dioClient.get('${AppConstants.ORDER_DETAILS_URI}$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> cancelOrder(String orderID) async {
    try {
      Map<String, dynamic> data = Map<String, dynamic>();
      data['order_id'] = orderID;
      data['_method'] = 'put';
      final response = await dioClient.post(AppConstants.ORDER_CANCEL_URI, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<FireBaseResponse> cancelOrderFire({String orderID}) async {
    try {
      var collection = FirebaseFirestore.instance.collection('orders_v3');
      await collection
          .doc(orderID) // <-- Doc ID where data should be updated.
          .update({'order_status': 'canceled'});
      return FireBaseResponse.withSuccess('Order canceled successfully.');
    } on FirebaseAuthException catch (e) {
      return FireBaseResponse.withError('error.');
    } catch (e) {
      print(e);
    }
  }

  Future<ApiResponse> updatePaymentMethod(String orderID) async {
    try {
      Map<String, dynamic> data = Map<String, dynamic>();
      data['order_id'] = orderID;
      data['_method'] = 'put';
      data['payment_method'] = 'cash_on_delivery';
      final response = await dioClient.post(AppConstants.UPDATE_METHOD_URI, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<FireBaseResponse> trackOrder(String orderID) async {
    try {
      var collection = FirebaseFirestore.instance.collection('orders_v3');
      DocumentSnapshot<Map<String, dynamic>> order = await collection
          .doc(orderID) // <-- Doc ID where data should be updated.
          .get();
      //order.id;
      //order.data();
      return FireBaseResponse.withSuccess(OrderModel.fromJson(json:order.data(), id: order.id));
    } catch (e) {
      print(e);
      return FireBaseResponse.withError(e.toString());
    }
    /*
    try {
      final response = await dioClient.get('${AppConstants.TRACK_URI}$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
    */
  }

  Future<ApiResponse> placeOrder(PlaceOrderBody orderBody) async {
    try {
      final response = await dioClient.post(AppConstants.PLACE_ORDER_URI, data: orderBody.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeliveryManData(String orderID) async {
    try {
      final response = await dioClient.get('${AppConstants.LAST_LOCATION_URI}$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}