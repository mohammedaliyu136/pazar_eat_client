import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  ProductWidget({@required this.product});
  bool _isLoggedIn;

  @override
  Widget build(BuildContext context) {
    double _startingPrice;
    double _endingPrice;
    _startingPrice = product.price;

    double _discountedPrice = PriceConverter.convertWithDiscount(context, product.price, product.discount, product.discountType);

    bool _isAvailable = true;//DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds, context);

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: InkWell(
        onTap: () {
         ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (con) => CartBottomSheet(
                product: product,
                callback: (CartModel cartModel) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('added_to_cart', context)), backgroundColor: Colors.green));
                },
              ),
          ): showDialog(context: context, builder: (con) => Dialog(
             child: CartBottomSheet(
               product: product,
               callback: (CartModel cartModel) {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('added_to_cart', context)), backgroundColor: Colors.green));
               },
             ),
         )) ;
        },
        child: Container(
          height: 85,
          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(
              color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
              blurRadius: 5, spreadRadius: 1,
            )],
          ),
          child: Row(children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder_image,
                    image: '${product.image}',
                    height: 70,
                    width: 85,
                    fit: BoxFit.cover,
                  ),
                ),
                _isAvailable ? SizedBox() : Positioned(
                  top: 0, left: 0, bottom: 0, right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withOpacity(0.6)),
                    child: Text(getTranslated('not_available_now_break', context), textAlign: TextAlign.center, style: rubikRegular.copyWith(
                      color: Colors.white, fontSize: 8,
                    )),
                  ),
                ),
              ],
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(product.name, style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                SizedBox(height: 5),
                RatingBar(rating: product.rating, size: 10),
                SizedBox(height: 5),
                Text(
                  '${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType, asFixed: 1)}'
                      '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount,
                      discountType: product.discountType, asFixed: 1)}' : ''}',
                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, fontFamily: 'RobotoMono',),
                ),
                product.price > _discountedPrice ? Text('${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}'
                    '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}', style: rubikMedium.copyWith(
                  color: ColorResources.COLOR_GREY,
                  decoration: TextDecoration.lineThrough,
                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  fontFamily: 'RobotoMono',
                )) : SizedBox(),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              _isLoggedIn?Consumer<WishListProvider>(builder:
                  (context, wishList, child) {
                return InkWell(
                  onTap: () {
                    wishList.wishIdList.contains(product.id)
                        ? wishList.removeFromWishList(product, (message) {})
                        : wishList.addToWishList(product, (message) {});
                    },
                  child: Icon(
                    wishList.wishIdList.contains(product.id) ? Icons.favorite : Icons.favorite_border,
                    color: wishList.wishIdList.contains(product.id) ? Theme.of(context).primaryColor : ColorResources.COLOR_GREY,
                  ),
                );
              }):InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Login'), backgroundColor: Colors.red));
                },
                child: Icon(
                  Icons.favorite_border,
                  color: ColorResources.COLOR_GREY,
                ),
              ),
              Expanded(child: SizedBox()),
              Icon(Icons.add),
            ]),
          ]),
        ),
      ),
    );
  }
}
