import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/restaurants_provider.dart';
import 'package:flutter_restaurant/provider/set_menu_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SetMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Provider.of<SetMenuProvider>(context, listen: false).getSetMenuList(context, true);
    Provider.of<RestaurantsProvider>(context, listen: false).getRestaurantList(context, false);

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('set_menu', context)),
      body: Consumer<RestaurantsProvider>(
        builder: (context, restaurants, child) {
          print('^^^^^^^^^^^^^^^^^');
          print(restaurants.restaurantsList);
          print('^^^^^^^^^^^^^^^^^');
          return restaurants.restaurantsList != null ? restaurants.restaurantsList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<RestaurantsProvider>(context, listen: false).getRestaurantList(context, true);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: restaurants.restaurantsList.length,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio:  1/1.2,
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 4 : 2),
                      itemBuilder: (context, index) {
                        double _startingPrice;
                        double _endingPrice;
                        //_startingPrice = setMenu.setMenuList[index].price;
                        _startingPrice = 200;
                        /*
                        if(setMenu.setMenuList[index].choiceOptions.length != 0) {
                          List<double> _priceList = [];
                          setMenu.setMenuList[index].variations.forEach((variation) => _priceList.add(variation.price));
                          _priceList.sort((a, b) => a.compareTo(b));
                          _startingPrice = _priceList[0];
                          if(_priceList[0] < _priceList[_priceList.length-1]) {
                            _endingPrice = _priceList[_priceList.length-1];
                          }
                        }else {
                          _startingPrice = setMenu.setMenuList[index].price;
                        }
                        */


                        /*
                        double _discount = restaurants.restaurantsList[index].price - PriceConverter.convertWithDiscount(context,
                            setMenu.setMenuList[index].price, setMenu.setMenuList[index].discount, setMenu.setMenuList[index].discountType);
*/
                        //bool _isAvailable = DateConverter.isAvailable(setMenu.setMenuList[index].availableTimeStarts, setMenu.setMenuList[index].availableTimeEnds, context);
                        bool _isAvailable = restaurants.restaurantsList[index].available;//DateConverter.isAvailable(setMenu.setMenuList[index].availableTimeStarts, setMenu.setMenuList[index].availableTimeEnds, context);

                        return InkWell(
                          onTap: () {
                            /*
                           ResponsiveHelper.isMobile(context) ? showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => CartBottomSheet(
                             product: setMenu.setMenuList[index], fromSetMenu: true,
                             callback: (CartModel cartModel) {
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('added_to_cart', context)), backgroundColor: Colors.green));
                             },
                           )
                           ): showDialog(context: context, builder: (con) => Dialog(
                             child: CartBottomSheet(
                               product: setMenu.setMenuList[index], fromSetMenu: true,
                               callback: (CartModel cartModel) {
                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('added_to_cart', context)), backgroundColor: Colors.green));
                               },
                             ),
                           ));
                           */
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)]
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder_rectangle,
                                      image: '${restaurants.restaurantsList[index].imageURL}',
                                      height: 110, width: MediaQuery.of(context).size.width/2, fit: BoxFit.cover,
                                    ),
                                  ),
                                  _isAvailable ? SizedBox() : Positioned(
                                    top: 0, left: 0, bottom: 0, right: 0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                      child: Text(getTranslated('not_available_now', context), textAlign: TextAlign.center, style: rubikRegular.copyWith(
                                        color: Colors.white, fontSize: Dimensions.FONT_SIZE_SMALL,
                                      )),
                                    ),
                                  ),
                                ],
                              ),

                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text(
                                      restaurants.restaurantsList[index].name,
                                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                      maxLines: 2, overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                    RatingBar(
                                      //Todo: fix rating
                                      rating: 5,//restaurants.restaurantsList[index].rating,
                                      size: 12,
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                    /*
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${PriceConverter.convertPrice(context, _startingPrice, discount: setMenu.setMenuList[index].discount,
                                              discountType: setMenu.setMenuList[index].discountType, asFixed: 1)}''${_endingPrice!= null
                                              ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: setMenu.setMenuList[index].discount,
                                              discountType: setMenu.setMenuList[index].discountType, asFixed: 1)}' : ''}',
                                          style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                        ),
                                        _discount > 0 ? SizedBox() : Icon(Icons.add, color: Theme.of(context).textTheme.bodyText1.color),
                                      ],
                                    ),
                                    */
                                    /*
                                    _discount > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text(
                                        '${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}'
                                            '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}',
                                        style: rubikBold.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                          color: ColorResources.getGreyColor(context),
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Icon(Icons.add, color: Theme.of(context).textTheme.bodyText1.color),
                                    ]) : SizedBox(),
                                    */
                                  ]),
                                ),
                              ),

                            ]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ) : NoDataScreen() : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
