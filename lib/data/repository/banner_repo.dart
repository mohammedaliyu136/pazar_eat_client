import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class BannerRepo {
  final DioClient dioClient;
  BannerRepo({@required this.dioClient});

  Future<ApiResponse> getBannerList() async {
    FirebaseFirestore.instance
        .collection('banners')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['title']);
      });
    });
    try {
      final response = await dioClient.get(AppConstants.BANNER_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProductDetails(String productID) async {
    try {
      final response = await dioClient.get('${AppConstants.PRODUCT_DETAILS_URI}$productID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}