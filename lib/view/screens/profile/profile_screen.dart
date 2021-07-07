
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FocusNode _fullNameFocus;
  FocusNode _emailFocus;
  FocusNode _phoneNumberFocus;
  FocusNode _passwordFocus;
  FocusNode _confirmPasswordFocus;
  TextEditingController _fullNameController;
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  String phone = '0';

  File file;
  PickedFile data;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  bool _isLoggedIn;

  void _choose() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _pickImage() async {
    data = await picker.getImage(source: ImageSource.gallery, maxHeight: 100, maxWidth: 100, imageQuality: 20);
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();

    //Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    _fullNameFocus = FocusNode();
    _emailFocus = FocusNode();
    _phoneNumberFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    var user = Provider.of<AuthProvider>(context,listen: false).user;
    getProfile();

    setState(() {
      _fullNameController.text = user.displayName;//Provider.of<AuthProvider>(context, listen: false).user['displayName'];
      //_fullNameController.text = Provider.of<AuthProvider>(context, listen: false).user['displayName'];
      _emailController.text = user.email;//Provider.of<AuthProvider>(context, listen: false).user['email'];
      //_phoneNumberController.text = '08066687798899';//Provider.of<AuthProvider>(context, listen: false).user['displayName'];
    });

    /*
    if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null) {
      UserInfoModel _userInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
      _firstNameController.text = _userInfoModel.fullName ?? '';
      _lastNameController.text = _userInfoModel.fullName ?? '';
      _phoneNumberController.text = _userInfoModel.phone ?? '';
      _emailController.text = _userInfoModel.email ?? '';
    }
    */
  }
  getProfile(){
    FirebaseFirestore.instance
        .collection('profiles').doc(Provider.of<AuthProvider>(context,listen: false).uid).get().then((value) {

          print('------------------');
          print(value.data()['phone_number']);

          setState(() {
            phone = value.data()['phone_number'];
            _phoneNumberController.text =value.data()['phone_number'];
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: getTranslated('my_profile', context)),
      body: _isLoggedIn ? Consumer<AuthProvider>(
        builder: (context, profileProvider, child) {
          return Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // for profile image
                            Container(
                              margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_LARGE),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ColorResources.BORDER_COLOR,
                                border: Border.all(color: ColorResources.COLOR_GREY_CHATEAU, width: 3),
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                onTap: ResponsiveHelper.isMobilePhone() ? _choose : _pickImage,
                                child: Stack(
                                  clipBehavior: Clip.none, children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: file != null ? Image.file(file, width: 80, height: 80, fit: BoxFit.fill) : data != null
                                          ? Image.network(data.path, width: 80, height: 80, fit: BoxFit.fill)
                                          : FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder_user,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        image:
                                        '${profileProvider.user}',
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 15,
                                      right: -10,
                                      child: InkWell(onTap: _choose, child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorResources.BORDER_COLOR,
                                          border: Border.all(width: 2, color: ColorResources.COLOR_GREY_CHATEAU),
                                        ),
                                        child: Icon(Icons.edit, size: 13),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // for name
                            Center(
                                child: Text(
                                  '',//'${profileProvider.user['displayName']}',
                                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                                )),

                            SizedBox(height: 28),
                            // for first name section
                            Text(
                              'Full Name',
                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: 'John Doe',
                              isShowBorder: true,
                              controller: _fullNameController,
                              focusNode: _fullNameFocus,
                              nextFocus: _phoneNumberFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                            // for email section
                            Text(
                              getTranslated('email', context),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated('demo_gmail', context),
                              isShowBorder: true,
                              controller: _emailController,
                              isEnabled: false,
                              readOnly: true,
                              focusNode: _emailFocus,
                              nextFocus: _phoneNumberFocus,

                              inputType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            // for phone Number section
                            Text(
                              getTranslated('mobile_number', context),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated('number_hint', context),
                              isShowBorder: true,
                              controller: _phoneNumberController,
                              focusNode: _phoneNumberFocus,
                              nextFocus: _passwordFocus,
                              inputType: TextInputType.phone,
                              inputAction: TextInputAction.done,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            /*
                            Text(
                              getTranslated('password', context),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated('password_hint', context),
                              isShowBorder: true,
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              nextFocus: _confirmPasswordFocus,
                              isPassword: true,
                              isShowSuffixIcon: true,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            Text(
                              getTranslated('confirm_password', context),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated('password_hint', context),
                              isShowBorder: true,
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocus,
                              isPassword: true,
                              isShowSuffixIcon: true,
                              inputAction: TextInputAction.done,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            */

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              !profileProvider.isLoading ? Center(
                child: Container(
                  width: 1170,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: CustomButton(
                    btnTxt: getTranslated('update_profile', context),
                    onTap: () async {
                      String _fullName = _fullNameController.text.trim();
                      String _phoneNumber = _phoneNumberController.text.trim();
                      /*
                      String _password = _passwordController.text.trim();
                      String _confirmPassword = _confirmPasswordController.text.trim();
                      */
                      if(_fullName!=Provider.of<AuthProvider>(context,listen: false).user.displayName){
                        await FirebaseAuth.instance.currentUser.updateDisplayName(_fullName);
                      }
                      if(_phoneNumber!=phone){}
                      await FirebaseFirestore.instance
                          .collection('profiles').doc(Provider.of<AuthProvider>(context,listen: false).uid).update({
                        'phone_number':_phoneNumber
                      });
                      Navigator.pop(context);
                      /*
                      await FirebaseFirestore.instance
                          .collection('profiles').where(field).update({
                        'phone_number':_phoneNumber,
                      }).then((value)=> Navigator.pop(context));
                      */
                          //.onError((error, stackTrace) => );
                      //await FirebaseAuth.instance.currentUser.updateDisplayName(displayName);

                      /*
                      if (profileProvider.userInfoModel.fullName == _firstName &&
                          profileProvider.userInfoModel.phone == _phoneNumber &&
                          profileProvider.userInfoModel.email == _emailController.text && file == null && data == null
                          && _password.isEmpty && _confirmPassword.isEmpty) {
                        showCustomSnackBar(getTranslated('change_something_to_update', context), context);
                      }else if (_firstName.isEmpty) {
                        showCustomSnackBar(getTranslated('enter_first_name', context), context);
                      }else if (_phoneNumber.isEmpty) {
                        showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                      } else if((_password.isNotEmpty && _password.length < 6)
                          || (_confirmPassword.isNotEmpty && _confirmPassword.length < 6)) {
                        showCustomSnackBar(getTranslated('password_should_be', context), context);
                      } else if(_password != _confirmPassword) {
                        showCustomSnackBar(getTranslated('password_did_not_match', context), context);
                      } else {
                        UserInfoModel updateUserInfoModel = UserInfoModel();
                        updateUserInfoModel.fullName = _firstName ?? "";
                        updateUserInfoModel.phone = _phoneNumber ?? '';
                        String _pass = _password ?? '';

                        ResponseModel _responseModel = await profileProvider.updateUserInfo(
                          updateUserInfoModel, _pass, file, data,
                          Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                        );

                        if(_responseModel.isSuccess) {
                          profileProvider.getUserInfo(context);
                          showCustomSnackBar(getTranslated('updated_successfully', context), context, isError: false);
                        }else {
                          showCustomSnackBar(_responseModel.message, context);
                        }
                        setState(() {});
                      }*/
                    },
                  ),
                ),
              ) : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),

            ],
          );// : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : NotLoggedInScreen(),
    );
  }
}
