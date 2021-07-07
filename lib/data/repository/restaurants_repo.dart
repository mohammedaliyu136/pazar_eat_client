import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response2.dart';
import 'package:flutter_restaurant/data/model/response/restaurant_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class RestaurantsRepo {
  final DioClient dioClient;
  RestaurantsRepo({@required this.dioClient});

  getRestaurantsList() async {
    List<RestaurantModel> restaurants = [];
    await FirebaseFirestore.instance
        .collection('restaurants_v3')
        .get().then((value){
      for (var i = 0; i < value.docs.length; i++) {
        RestaurantModel restaurantModel = RestaurantModel.fromJson(json: value.docs[i].data(), id: value.docs[i].id);
        restaurants.add(restaurantModel);
      }
    });
    return FireBaseResponse.withSuccess(restaurants);
  }
}