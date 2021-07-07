import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/language_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/language_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/strings.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/main_app_bar.dart';
import 'package:flutter_restaurant/view/screens/language/widget/search_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ChooseLanguageScreen extends StatelessWidget {
  final bool isEnableUpdate = false;
  final bool fromCheckout = false;
  final bool fromMenu;
  GoogleMapController _controller;
  ChooseLanguageScreen({this.fromMenu = false});

  Future<void> getCategory() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print('----------------');
        print('----------------');
        print('----------------');
        print('----------------');
        print('----------------');
        print(doc);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LanguageProvider>(context, listen: false).initializeAllLanguages(context);
    Provider.of<LocationProvider>(context, listen: false).initializeAllAddressType(context: context);
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation(mapController: _controller);


    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)) : null,
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                child: Stack(
                  clipBehavior: Clip.none, children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(locationProvider.position.latitude, locationProvider.position.longitude),
                      zoom: 8,
                    ),
                    onTap: (latLng) {
                      if(ResponsiveHelper.isMobilePhone()) {
                        Navigator.pushNamed(context, Routes.getSelectLocationRoute());
                      }
                    },
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    indoorViewEnabled: true,
                    mapToolbarEnabled: false,
                    onCameraIdle: () {
                      locationProvider.dragableAddress();
                    },
                    onCameraMove: ((_position) => locationProvider.updatePosition(_position)),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      if (!isEnableUpdate && _controller != null) {
                        Provider.of<LocationProvider>(context, listen: false).getCurrentLocation(mapController: _controller);
                      }
                    },
                  ),
                  locationProvider.loading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme
                      .of(context).primaryColor))) : SizedBox(),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      child: Image.asset(
                        Images.marker,
                        width: 25,
                        height: 35,
                      )),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        locationProvider.getCurrentLocation(mapController: _controller);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                          color: ColorResources.COLOR_WHITE,
                        ),
                        child: Icon(
                          Icons.my_location,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
                ),
              ),
            );
  },
),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 1170,
                    padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE, top: Dimensions.PADDING_SIZE_LARGE),
                    child: Text(
                      Strings.choose_the_language,
                      style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 22, color: Colors.transparent),
                    ),
                  ),
                ),/*
                SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 1170,
                    padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_LARGE),
                    child: SearchWidget(),
                  ),
                ),
                SizedBox(height: 30),*/
              /*
                Consumer<LanguageProvider>(
                    builder: (context, languageProvider, child) => Expanded(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Center(
                              child: SizedBox(
                                width: 1170,
                                child: ListView.builder(
                                    itemCount: languageProvider.languages.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => _languageWidget(
                                        context: context, languageModel: languageProvider.languages[index], languageProvider: languageProvider, index: index)),
                              ),
                            ),
                          ),
                        ))),*/
                Spacer(),
                Consumer<LanguageProvider>(
                    builder: (context, languageProvider, child) => Center(
                      child: Container(
                        width: 1170,
                            padding: const EdgeInsets.only(
                                left: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_LARGE),
                            child: CustomButton(
                              btnTxt: getTranslated('LocationScreen', context),
                              onTap: () async{
                                //getOrdersList
                                //Provider.of<OrderProvider>(context, listen: false).getOrdersList(context);

                                if(languageProvider.languages.length > 0 && languageProvider.selectIndex != -1) {
                                  Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                                    AppConstants.languages[languageProvider.selectIndex].languageCode,
                                    AppConstants.languages[languageProvider.selectIndex].countryCode,
                                  ));
                                  if (fromMenu) {
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routes.getMainRoute(),
                                    );
                                  }
                                }else {
                                  showCustomSnackBar(getTranslated('select_a_language', context), context);
                                }

                                //Provider.of<ProductProvider>(context, listen: false).getProductList();
                              },
                            ),
                          ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageWidget({BuildContext context, LanguageModel languageModel, LanguageProvider languageProvider, int index}) {
    return InkWell(
      onTap: () {
        languageProvider.setSelectIndex(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: languageProvider.selectIndex == index ? Theme.of(context).primaryColor.withOpacity(.15) : null,
          border: Border(
              top: BorderSide(width: 1.0, color: languageProvider.selectIndex == index ? Theme.of(context).primaryColor : Colors.transparent),
              bottom: BorderSide(width: 1.0, color: languageProvider.selectIndex == index ? Theme.of(context).primaryColor : Colors.transparent)),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1.0,
                    color: languageProvider.selectIndex == index ? Colors.transparent : ColorResources.COLOR_GREY_CHATEAU.withOpacity(.3))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(languageModel.imageUrl, width: 34, height: 34),
                  SizedBox(width: 30),
                  Text(
                    languageModel.languageName,
                    style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                ],
              ),
              languageProvider.selectIndex == index ? Image.asset(Images.done, width: 17, height: 17, color: Theme.of(context).primaryColor)
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
