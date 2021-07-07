import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response2.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/restaurant_model.dart';
import 'package:flutter_restaurant/data/repository/restaurants_repo.dart';
import 'package:flutter_restaurant/data/repository/set_menu_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';

class RestaurantsProvider extends ChangeNotifier {
  final RestaurantsRepo restaurantsRepo;

  RestaurantsProvider({@required this.restaurantsRepo});

  List<RestaurantModel> _restaurantsList;
  List<RestaurantModel> get restaurantsList => _restaurantsList;
  bool isLoading = false;

  Future<void> getRestaurantList(BuildContext context, bool reload) async {
    /*
    var apiResponse = await restaurantsRepo.getRestaurantsList();
    print('---------==========');
    _restaurantsList=[];
    apiResponse.forEach((restaurant) => _restaurantsList.add(RestaurantModel.fromJson(json: restaurant)));
    print(apiResponse);
    print(_restaurantsList);
    */

    FireBaseResponse fireBaseResponse = await restaurantsRepo.getRestaurantsList();
    print('88888888888888');
    isLoading = true;
    notifyListeners();
    if(fireBaseResponse.responseCode == 200){
      print('7777777777777');
      print(fireBaseResponse.response);
      _restaurantsList = fireBaseResponse.response;
      isLoading = false;
      notifyListeners();
    }else{

    }
    notifyListeners();
    if(_restaurantsList.isEmpty || reload) {

    }
  }
}