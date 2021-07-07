import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/restaurant_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/main_app_bar.dart';
import 'package:flutter_restaurant/view/screens/cart/cart_screen.dart';
import 'package:flutter_restaurant/view/screens/home/widget/product_view.dart';
import 'package:provider/provider.dart';

class RestaurantScreen extends StatelessWidget {
  RestaurantScreen({this.restaurant});
  RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    // TODO: implement build
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)): CustomAppBar(title: restaurant.name),
      backgroundColor: ColorResources.getBackgroundColor(context),
      body: Stack(
        children: [
          ClipRRect(
            //borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: FadeInImage.assetNetwork(
              placeholder: Images.placeholder_rectangle,
              image: '${restaurant.imageURL}',
              height: 210, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
            ),
          ),
          ListView(
            controller: _scrollController,
            children: [
            Container(color: Colors.transparent,height: 180,),
            Container(
              //height: 400,
              decoration: BoxDecoration(
                color: ColorResources.getBackgroundColor(context),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    //bottomRight: Radius.circular(40.0),
                    topLeft: Radius.circular(30.0),
                    //bottomLeft: Radius.circular(40.0)),
              ),
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 18,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:18.0),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(restaurant.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                      Icon(Icons.bookmark)
                    ],
                ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:18.0),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber,),
                        SizedBox(width: 4,),
                        Text('4.9', style: TextStyle(fontSize: 12),),
                        SizedBox(width: 10,),
                        Text('200+0 Ratings', style: TextStyle(fontSize: 12),)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:18.0),
                    child: Row(children: [
                      Icon(Icons.attach_money),
                      SizedBox(width: 4,),
                      Text('Free Delivery', style: TextStyle(fontSize: 12),),
                      Spacer(),
                      Icon(Icons.timer_rounded),
                      SizedBox(width: 4,),
                      Text('30 min', style: TextStyle(fontSize: 12),),
                      Spacer(),
                      Container(
                        color: Colors.orange.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Take Away', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),),
                        ),)
                    ],),
                  ),
                  /*
                  Container(
                    height: 100,
                    child: Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:18.0, bottom: 18.0,left: 8, right: 28),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0)
                                ),
                              ),
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    children: [
                                      Text('All', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 5,width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.9),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30.0),
                                              bottomRight: Radius.circular(30.0),
                                              topLeft: Radius.circular(30.0),
                                              bottomLeft: Radius.circular(30.0)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    children: [
                                      Text('Burgers', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.7),),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 5,width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30.0),
                                              bottomRight: Radius.circular(30.0),
                                              topLeft: Radius.circular(30.0),
                                              bottomLeft: Radius.circular(30.0)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    children: [
                                      Text('Meals', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.7),),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 5,width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30.0),
                                              bottomRight: Radius.circular(30.0),
                                              topLeft: Radius.circular(30.0),
                                              bottomLeft: Radius.circular(30.0)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    children: [
                                      Text('Chicken',  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.7),),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 5,width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30.0),
                                              bottomRight: Radius.circular(30.0),
                                              topLeft: Radius.circular(30.0),
                                              bottomLeft: Radius.circular(30.0)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    children: [
                                      Text('Salad',  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.7),),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 5,width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30.0),
                                              bottomRight: Radius.circular(30.0),
                                              topLeft: Radius.circular(30.0),
                                              bottomLeft: Radius.circular(30.0)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    children: [
                                      Text('Traditional',  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.7),),),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 5,width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30.0),
                                              bottomRight: Radius.circular(30.0),
                                              topLeft: Radius.circular(30.0),
                                              bottomLeft: Radius.circular(30.0)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  */
                  SizedBox(height: 30,),

                  /*
                  Expanded(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top:2.0, bottom: 2, left: 10, right: 10),
                        child: Card(child: Row(
                          children: [
                            Container(height: 100,color: Colors.cyan, width: 100,),
                          ],
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:2.0, bottom: 2, left: 10, right: 10),
                        child: Card(child: Row(
                          children: [
                            Container(height: 100,color: Colors.cyan, width: 100,),
                          ],
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:2.0, bottom: 2, left: 10, right: 10),
                        child: Card(child: Row(
                          children: [
                            Container(height: 100,color: Colors.cyan, width: 100,),
                          ],
                        )),
                      ),
                    ],),
                  )
                  */

              ],),
            ),
            Container(
              color: ColorResources.getBackgroundColor(context),
              child: ProductView(productType: ProductType.POPULAR_PRODUCT, scrollController: _scrollController),
            ),

            SizedBox(height: 60,)


          ],),
          Provider.of<CartProvider>(context).cartList.length>0?
          Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(from_restaurant_page:true),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width-16,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text('Count ${Provider.of<CartProvider>(context).cartList.length.toString()}',style: rubikMedium.copyWith(
                          fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Colors.white,
                        )),
                        Text('Total ${PriceConverter.convertPrice(context, Provider.of<CartProvider>(context).amount)}', style: rubikMedium.copyWith(
                          fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Colors.white,fontFamily: 'RobotoMono',
                        ))
                      ],),
                    ),
                  ),
                ),
              ))
          : SizedBox(),
        ],
      ),
    );
  }
}
