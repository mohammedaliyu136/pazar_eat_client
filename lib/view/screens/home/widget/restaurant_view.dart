import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/restaurant_model.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/restaurants_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/base/restaurant_widget.dart';
import 'package:provider/provider.dart';

class RestaurantFullView extends StatelessWidget {
  final ScrollController scrollController;
  List<RestaurantModel> restaurants;
  RestaurantFullView({this.scrollController, this.restaurants});

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getProductList();

    int offset = 1;
    scrollController?.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Provider.of<ProductProvider>(context, listen: false).popularProductList != null
          && !Provider.of<ProductProvider>(context, listen: false).isLoading) {
        int pageSize;
        if (offset < pageSize) {
          offset++;
          print('end of the page');
          Provider.of<ProductProvider>(context, listen: false).showBottomLoader();
          Provider.of<ProductProvider>(context, listen: false).getPopularProductList(context, offset.toString());
        }
      }
    });
    return Consumer<RestaurantsProvider>(
      builder: (context, restProvider, child) {
        List<RestaurantModel> restaurantsList;
        restaurantsList = restProvider.restaurantsList;

        return Column(children: [
          restaurantsList != null ? restaurantsList.length > 0 ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 4,
                crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1),
            itemCount: restaurantsList.length,
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              //return ProductWidget(product: productList[index]);
              return RestaurantWidget(restaurant: restaurantsList[index]);
            },
          ) : NoDataScreen() : GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 4,
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return ProductShimmer(isEnabled: restaurantsList == null);
              },
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL)),

          restProvider.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox(),
        ]);
      },
    );
  }
}
