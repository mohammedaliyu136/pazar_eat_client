import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response2.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  LocationRepo({this.dioClient, this.sharedPreferences});

  Future<FireBaseResponse> getAllAddress() async {
    /*
    try {
      final response = await dioClient.get(AppConstants.ADDRESS_LIST_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
    */
    ///
    try {
      var collection = FirebaseFirestore.instance.collection('address_v3');
      var res = await collection.get();
      List<AddressModel> addresses = [];
      for (var i = 0; i < res.docs.length; i++) {
        addresses.add(AddressModel.fromJson(json:res.docs[i].data(), id:res.docs[i].id));
      }
      return FireBaseResponse.withSuccess(addresses);
    } catch (e) {
      return FireBaseResponse.withError(e.toString());
    }
  }

  Future<FireBaseResponse> removeAddressByID(String id) async {
    try {
      var res;
      var collection = FirebaseFirestore.instance.collection('address_v3');
      collection
          .doc(id)
          .delete()
          .then((value) => res = FireBaseResponse.withSuccess('Address Deleted'))
          .catchError((error) => res = FireBaseResponse.withError(error.toString()));
      return res;
    } catch (e) {
      return FireBaseResponse.withError(e.toString());
    }
  }

  Future<FireBaseResponse> addAddress(AddressModel addressModel) async {
    /*
    try {
      Response response = await dioClient.post(
        AppConstants.ADD_ADDRESS_URI,
        data: addressModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
    */
    try {
      var res;
      var collection = FirebaseFirestore.instance.collection('address_v3');
      await collection.add(addressModel.toJson())
        .then((value) => res = FireBaseResponse.withSuccess('Address Added'))
        .catchError((error) => res = FireBaseResponse.withError(error.toString()));
      return res;
    } catch (e) {
      return FireBaseResponse.withError(e.toString());
    }
  }

  Future<FireBaseResponse> updateAddress(AddressModel addressModel, String addressId) async {
    print('zzzzzzzzzzzzzzzzzzzzzzzz');
    print(addressModel.id);
    print(addressId);
    try {
      var res;
      var collection = FirebaseFirestore.instance.collection('address_v3');
      await collection.doc(addressId)
          .update(addressModel.toJson())
          .then((value) => print('value'))
          .catchError((error) => print(error.toString()));
      //res = FireBaseResponse.withSuccess('Address Updated');
      //res = FireBaseResponse.withError(error.toString()
      return res;
    } catch (e) {
      return FireBaseResponse.withError(e.toString());
    }
    /*
    try {
      Response response = await dioClient.post(
        '${AppConstants.UPDATE_ADDRESS_URI}$addressId',
        data: addressModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
    */
  }

  List<String> getAllAddressType({BuildContext context}) {
    return [
      getTranslated('home', context),
      getTranslated('workplace', context),
      getTranslated('other', context),
    ];
  }
}
