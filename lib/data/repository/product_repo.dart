
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response2.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class ProductRepo {
  final DioClient dioClient;

  ProductRepo({@required this.dioClient});

  Future<FireBaseResponse> getProductList(String restaurantId) async {
    List<Product> products = [];
    await FirebaseFirestore.instance
        .collection('meals_v3')
        .get().then((value){
      for (var i = 0; i < value.docs.length; i++) {
        Product product = Product.fromJson(json: value.docs[i].data(), id: value.docs[i].id);
        products.add(product);
      }
    });
    return FireBaseResponse.withSuccess(products);
  }

  Future<ApiResponse> getPopularProductList(String offset) async {
    try {
      final response = await dioClient.get('${AppConstants.POPULAR_PRODUCT_URI}?limit=10&&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> searchProduct(String productId) async {
    try {
      final response = await dioClient.get('${AppConstants.SEARCH_PRODUCT_URI}$productId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitReview(ReviewBody reviewBody) async {
    try {
      final response = await dioClient.post(AppConstants.REVIEW_URI, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitDeliveryManReview(ReviewBody reviewBody) async {
    try {
      final response = await dioClient.post(AppConstants.DELIVER_MAN_REVIEW_URI, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
