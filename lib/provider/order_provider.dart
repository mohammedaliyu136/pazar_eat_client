import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response2.dart';
import 'package:flutter_restaurant/data/model/response/base/error_response.dart';
import 'package:flutter_restaurant/data/model/response/delivery_man_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/repository/order_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepo orderRepo;
  OrderProvider({@required this.orderRepo});

  List<OrderModel> _runningOrderList;
  List<OrderModel> _historyOrderList;
  List<OrderDetailsModel> _orderDetails;
  int _paymentMethodIndex = 0;
  OrderModel _trackModel;
  ResponseModel _responseModel;
  int _addressIndex = -1;
  bool _isLoading = false;
  bool _showCancelled = false;
  DeliveryManModel _deliveryManModel;
  String _orderType = 'delivery';
  int _branchIndex = 0;

  AddressModel _addressModel;

  List<OrderModel> get runningOrderList => _runningOrderList;
  List<OrderModel> get historyOrderList => _historyOrderList;
  List<OrderDetailsModel> get orderDetails => _orderDetails;
  int get paymentMethodIndex => _paymentMethodIndex;
  AddressModel get addressModel => _addressModel;
  OrderModel get trackModel => _trackModel;
  ResponseModel get responseModel => _responseModel;
  int get addressIndex => _addressIndex;
  bool get isLoading => _isLoading;
  bool get showCancelled => _showCancelled;
  DeliveryManModel get deliveryManModel => _deliveryManModel;
  String get orderType => _orderType;
  int get branchIndex => _branchIndex;

  Future<void> getOrdersList(BuildContext context) async {
    _runningOrderList = [];
    _historyOrderList = [];
    FireBaseResponse fireBaseResponse = await orderRepo.getOrdersList();
    if(fireBaseResponse.responseCode == 200){
      List<OrderModel> orders = fireBaseResponse.response;
      for( var i = 0 ; i < orders.length; i++ ) {
        if(orders[i].orderStatus == 'pending' || orders[i].orderStatus == 'processing'
            || orders[i].orderStatus == 'out_for_delivery' || orders[i].orderStatus == 'confirmed') {
          _runningOrderList.add(orders[i]);
        }else if(orders[i].orderStatus == 'delivered' || orders[i].orderStatus == 'canceled') {
          _historyOrderList.add(orders[i]);
        }
      }
      notifyListeners();
    }else{

    }
    notifyListeners();
  }

  Future<void> getOrderList(BuildContext context) async {
    var orders = [];
    _runningOrderList = [];
    _historyOrderList = [];
    await FirebaseFirestore.instance
        .collection('orders_v2')
        .get().then((value){
      print('@@@@@@@@@@@@@@@@@@');
      print(value.docs);
      orders = value.docs;
      for( var i = 0 ; i < orders.length; i++ ) {
        print(orders[i]['order_amount']);
      }
      for( var i = 0 ; i < orders.length; i++ ) {
        OrderModel orderModel = OrderModel.fromJson(json:orders[i]);
        if(orderModel.orderStatus == 'pending' || orderModel.orderStatus == 'processing'
            || orderModel.orderStatus == 'out_for_delivery' || orderModel.orderStatus == 'confirmed') {
          _runningOrderList.add(orderModel);
        }else if(orderModel.orderStatus == 'delivered' || orderModel.orderStatus == 'canceled') {
          _historyOrderList.add(orderModel);
        }
      }
    });
    /*
    ApiResponse apiResponse = await orderRepo.getOrderList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _runningOrderList = [];
      _historyOrderList = [];
      apiResponse.response.data.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        if(orderModel.orderStatus == 'pending' || orderModel.orderStatus == 'processing'
            || orderModel.orderStatus == 'out_for_delivery' || orderModel.orderStatus == 'confirmed') {
          _runningOrderList.add(orderModel);
        }else if(orderModel.orderStatus == 'delivered') {
          _historyOrderList.add(orderModel);
        }
      });
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    */
    notifyListeners();
  }

  Future<List<OrderDetailsModel>> getOrderDetails(String orderID, BuildContext context) async {
    _orderDetails = null;
    _isLoading = true;
    _showCancelled = false;

    ApiResponse apiResponse = await orderRepo.getOrderDetails(orderID);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response.data.forEach((orderDetail) => _orderDetails.add(OrderDetailsModel.fromJson(orderDetail)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _orderDetails;
  }

  Future<void> getDeliveryManData(String orderID, BuildContext context) async {
    ApiResponse apiResponse = await orderRepo.getDeliveryManData(orderID);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _deliveryManModel = DeliveryManModel.fromJson(apiResponse.response.data);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void setPaymentMethod(int index) {
    _paymentMethodIndex = index;
    notifyListeners();
  }

  Future<ResponseModel> trackOrder(String orderID, OrderModel orderModel, BuildContext context, bool fromTracking) async {
    _trackModel = null;
    _responseModel = null;
    if(!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    if(orderModel == null) {
      _isLoading = true;
      ///--------------------------
      ///--------------------------
      FireBaseResponse fireBaseResponse = await orderRepo.trackOrder(orderID);
      if(fireBaseResponse.responseCode == 200){
        //OrderModel order = fireBaseResponse.response;
        print('------------------------------');
        print(fireBaseResponse.response.id);
        _trackModel = fireBaseResponse.response;
        _responseModel = ResponseModel(true, 'track order');
        notifyListeners();
      }else{

      }
      ///--------------------------
      /*
      ApiResponse apiResponse = await orderRepo.trackOrder(orderID);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _trackModel = OrderModel.fromJson(json:apiResponse.response.data);
        _responseModel = ResponseModel(true, apiResponse.response.data.toString());
      } else {
        _responseModel = ResponseModel(false, apiResponse.error.errors[0].message);
        ApiChecker.checkApi(context, apiResponse);
      }
      */
      _isLoading = false;
      notifyListeners();
    }else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
    }
    return _responseModel;
  }

  Future<void> placeOrder(PlaceOrderBody placeOrderBody, Function callback) async {
    _isLoading = true;
    bool success = false;
    String orderID = '';
    notifyListeners();
    print(placeOrderBody.toJson());
    //ApiResponse apiResponse = await orderRepo.placeOrder(placeOrderBody);
     await FirebaseFirestore.instance
        .collection('orders_v3').add(placeOrderBody.toJson())
         .then((value){success=true; orderID = value.id;})
         .catchError((error)=>success=false);
    _isLoading = false;
    /*
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      String message = apiResponse.response.data['message'];
      String orderID = apiResponse.response.data['order_id'].toString();
      callback(true, message, orderID, placeOrderBody.deliveryAddressId);
      print('-------- Order placed successfully $orderID ----------');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage, '-1', -1);
    }
    */
    if(success){
      callback(true, 'success', orderID);
    }else{
      callback(false, 'error', '-1');
    }

    notifyListeners();
  }

  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setAddressIndex(int index) {
    _addressIndex = index;
    notifyListeners();
  }
  void setAddress(AddressModel addressModel) {
    _addressModel = addressModel;
    notifyListeners();
  }

  void clearPrevData() {
    _addressIndex = -1;
    _branchIndex = 0;
    _paymentMethodIndex = 0;
  }

  void cancelOrder(String orderID, Function callback) async {
    _isLoading = true;
    notifyListeners();
    //ApiResponse apiResponse = await orderRepo.cancelOrder(orderID);
    FireBaseResponse firebaseResponse = await orderRepo.cancelOrderFire(orderID: orderID);
    ResponseModel responseModel;
    if(firebaseResponse.responseCode == 200){
      OrderModel orderModel;
      _runningOrderList.forEach((order) {
        if(order.id.toString() == orderID) {
          orderModel = order;
        }
      });
      _runningOrderList.remove(orderModel);
      _showCancelled = true;
      _isLoading = false;
      callback(firebaseResponse.response, true, orderID);
    } else {
      callback(firebaseResponse.error.toString(), false, '-1');
    }
    notifyListeners();

    /*
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      OrderModel orderModel;
      _runningOrderList.forEach((order) {
        if(order.id.toString() == orderID) {
          orderModel = order;
        }
      });
      _runningOrderList.remove(orderModel);
      _showCancelled = true;
      callback(apiResponse.response.data['message'], true, orderID);
    } else {
      print(apiResponse.error.errors[0].message);
      callback(apiResponse.error.errors[0].message, false, '-1');
    }
    notifyListeners();
     */
  }

  Future<void> updatePaymentMethod(String orderID, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo.updatePaymentMethod(orderID);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      int orderIndex;
      for(int index=0; index<_runningOrderList.length; index++) {
        if(_runningOrderList[index].id.toString() == orderID) {
          orderIndex = index;
          break;
        }
      }
      if(orderIndex != null) {
        //_runningOrderList[orderIndex].paymentMethod = 'cash_on_delivery';
      }
      //_trackModel.paymentMethod = 'cash_on_delivery';
      callback(apiResponse.response.data['message'], true);
    } else {
      print(apiResponse.error.errors[0].message);
      callback(apiResponse.error.errors[0].message, false);
    }
    notifyListeners();
  }

  void setOrderType(String type, {bool notify = true}) {
    _orderType = type;
    if(notify) {
      notifyListeners();
    }
  }

  void setBranchIndex(int index) {
    _branchIndex = index;
    _addressIndex = -1;
    notifyListeners();
  }

}