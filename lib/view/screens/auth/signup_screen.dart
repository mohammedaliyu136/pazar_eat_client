import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/model/response/signup_model.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/main_app_bar.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  UserCredential user;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();



  @override
  void initState() {
    super.initState();

    Provider.of<AuthProvider>(context, listen: false).clearVerificationMessage();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)) : null,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SafeArea(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                physics: BouncingScrollPhysics(),
                child: Center(
                  child: Container(
                    width: 1170,
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          /*
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ResponsiveHelper.isWeb() ? Consumer<SplashProvider>(
                            builder:(context, splash, child) => FadeInImage.assetNetwork(
                              placeholder: Images.placeholder_rectangle,
                              image: splash.baseUrls != null ? '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}' : '',
                              height: MediaQuery.of(context).size.height / 4.5,
                            ),
                          ) : Image.asset(Images.logo, matchTextDirection: true, height: MediaQuery.of(context).size.height / 4.5),
                        ),
                      ),*/
                          SizedBox(height: 20),
                          Center(
                              child: Text(
                                getTranslated('signup', context),
                                style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 24, color: ColorResources.getGreyBunkerColor(context)),
                              )),
                          SizedBox(height: 35),
                          Text(
                            getTranslated('email', context),
                            style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: getTranslated('demo_gmail', context),
                            isShowBorder: true,
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.emailAddress,
                            controller: _emailController,
                            focusNode: _emailFocus,
                            nextFocus: _fullNameFocus,
                          ),
                          SizedBox(height: 6),
                          //todo:start
                          // for first name section
                          Text(
                            'Full Name',
                            style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: 'John',
                            isShowBorder: true,
                            controller: _fullNameController,
                            focusNode: _fullNameFocus,
                            nextFocus: _numberFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                          // for email section
                          Text(
                            getTranslated('mobile_number', context),
                            style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: getTranslated('number_hint', context),
                            isShowBorder: true,
                            controller: _numberController,
                            focusNode: _numberFocus,
                            nextFocus: _passwordFocus,
                            inputType: TextInputType.phone,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // for password section
                          Text(
                            getTranslated('password', context),
                            style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: getTranslated('password_hint', context),
                            isShowBorder: true,
                            isPassword: true,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            nextFocus: _confirmPasswordFocus,
                            isShowSuffixIcon: true,
                          ),
                          SizedBox(height: 22),

                          // for confirm password section
                          Text(
                            getTranslated('confirm_password', context),
                            style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: getTranslated('password_hint', context),
                            isShowBorder: true,
                            isPassword: true,
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            isShowSuffixIcon: true,
                            inputAction: TextInputAction.done,
                          ),

                          SizedBox(height: 22),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              authProvider.registrationErrorMessage.length > 0
                                  ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                  : SizedBox.shrink(),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authProvider.registrationErrorMessage ?? "",
                                  style: Theme.of(context).textTheme.headline2.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          //todo:end
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              authProvider.verificationMessage.length > 0
                                  ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                  : SizedBox.shrink(),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authProvider.verificationMessage ?? "",
                                  style: Theme.of(context).textTheme.headline2.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          // for continue button
                          SizedBox(height: 12),
                          !authProvider.isPhoneNumberVerificationButtonLoading
                              ? CustomButton(
                            btnTxt: getTranslated('signup', context),
                            onTap: () async{
                              String _email = _emailController.text.trim();
                              String _fullName = _fullNameController.text.trim();
                              String _number = _numberController.text.trim();
                              String _password = _passwordController.text.trim();
                              String _confirmPassword = _confirmPasswordController.text.trim();
                              if (_email.isEmpty) {
                                showCustomSnackBar(getTranslated('enter_first_name', context), context);
                              }else if (_fullName.isEmpty) {
                                showCustomSnackBar(getTranslated('enter_last_name', context), context);
                              }else if (_number.isEmpty) {
                                showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                              }else if (_password.isEmpty) {
                                showCustomSnackBar(getTranslated('enter_password', context), context);
                              }else if (_password.length < 6) {
                                showCustomSnackBar(getTranslated('password_should_be', context), context);
                              }else if (_confirmPassword.isEmpty) {
                                showCustomSnackBar(getTranslated('enter_confirm_password', context), context);
                              }else if(_password != _confirmPassword) {
                                showCustomSnackBar(getTranslated('password_did_not_match', context), context);
                              }else {
                                SignUpModel signUpModel = SignUpModel(
                                    fName: _fullName,
                                    email: _email,
                                    phone: _number,
                                    password: _password
                                );
                                ResponseModel responseModel = await authProvider.registration(signUpModel);
                                if(responseModel.isSuccess){
                                  Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                }else{
                                  print('------------------------');
                                  print(responseModel.message);
                                  showCustomSnackBar(responseModel.message, context);
                                }

                              }
                              /*
                                final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .get().then((value) => print('==================${value.docs}'));
                                */
                              /*
                                await _firebaseAuth.createUserWithEmailAndPassword(
                                  email: 'mohammedaliyu13888999@gmail.com',
                                  password: 'pass1234',
                                ).then((user) => setState(() {this.user = user;}));
                                this.user.user.updatePhotoURL('https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png');
                                this.user.user.updateDisplayName('Mohammed Aliyu');
                                print(this.user.user);
                                print(this.user.user.uid);
                                print(this.user.additionalUserInfo.isNewUser);
                                if(this.user.additionalUserInfo.isNewUser){
                                  FirebaseFirestore.instance
                                      .collection('profiles').add({
                                    'uid':this.user.user.uid,
                                    'phone_number':'08034902025',
                                  });
                                }
                                 */
                              /*
                                String _email = _emailController.text.trim();
                                if (_email.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_email_address', context), context);
                                }else if (EmailChecker.isNotValid(_email)) {
                                  showCustomSnackBar(getTranslated('enter_valid_email', context), context);
                                }else {
                                  authProvider.checkEmail(_email).then((value) async {
                                    if (value.isSuccess) {
                                      authProvider.updateEmail(_email);
                                      if (value.message == 'active') {
                                        Navigator.pushNamed(context, Routes.getVerifyRoute('sign-up', _email));
                                      } else {
                                        Navigator.pushNamed(context, Routes.getCreateAccountRoute(_email));
                                      }
                                    }
                                  });
                                }
                                */
                            },
                          )
                              : Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                              )),

                          // for create an account
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, Routes.getLoginRoute());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    getTranslated('already_have_account', context),
                                    style: Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyColor(context)),
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                  Text(
                                    getTranslated('login', context),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        .copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyBunkerColor(context)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
