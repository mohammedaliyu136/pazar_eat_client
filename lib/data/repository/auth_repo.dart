import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response2.dart';
import 'package:flutter_restaurant/data/model/response/signup_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;


class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<FireBaseResponse> registration(SignUpModel signUpModel) async {
    final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
    /*
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: signUpModel.email,
      password: signUpModel.password,
    ).then((UserCredential){
      UserCredential.user.updatePhotoURL('https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png');
      UserCredential.user.updateDisplayName(signUpModel.getFullName());
      FirebaseFirestore.instance
          .collection('profiles').add({
        'uid':UserCredential.user.uid,
        'phone_number':signUpModel.phoneNumber,
      });
      return FireBaseResponse.withSuccess(UserCredential);
    }).onError((error, stackTrace){
      return FireBaseResponse.withError(error);
    });
    */
    ///////--------------
    ///////--------------
    ///////--------------
    var user;
    var res;
    try {
      UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: signUpModel.email,
          password: signUpModel.password
      );
      user.user.updatePhotoURL('https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png');
      user.user.updateDisplayName(signUpModel.fName);
      if(user.additionalUserInfo.isNewUser){
        await FirebaseFirestore.instance.doc("profiles/"+user.user.uid)
            //.collection('profiles')
            .set({
          //'uid':user.user.uid,
          'phone_number':signUpModel.phone,
        }).then((value)=> res = FireBaseResponse.withSuccess(user))
            .onError((error, stackTrace) => res = FireBaseResponse.withError(error.toString()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return FireBaseResponse.withError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return FireBaseResponse.withError('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return res;
    //Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false)
    /*
    try {
      Response response = await dioClient.post(
        AppConstants.REGISTER_URI,
        data: signUpModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }*/
  }

  Future<FireBaseResponse> passwordReset({String email}) async {
    final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return FireBaseResponse.withSuccess('A password reset instruction have been sent to your email.');
    } on FirebaseAuthException catch (e) {
      return FireBaseResponse.withError('error.');
    } catch (e) {
      print(e);
    }
  }
  Future<FireBaseResponse> login({String email, String password}) async {
    final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
    FireBaseResponse fireBaseResponse;
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((UserCredential){
      fireBaseResponse = FireBaseResponse.withSuccess(UserCredential);
    }).onError((error, stackTrace){
      fireBaseResponse = FireBaseResponse.withError(error);
    });
    return fireBaseResponse;
  }

  Future<ApiResponse> updateToken() async {
    try {
      String _deviceToken;
      if (!Platform.isAndroid) {
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
          alert: true, announcement: false, badge: true, carPlay: false,
          criticalAlert: false, provisional: false, sound: true,
        );
        if(settings.authorizationStatus == AuthorizationStatus.authorized) {
          _deviceToken = await _saveDeviceToken();
        }
      }else {
        _deviceToken = await _saveDeviceToken();
      }
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
      Response response = await dioClient.post(
        AppConstants.TOKEN_URI,
        data: {"_method": "put", "cm_firebase_token": _deviceToken},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String> _saveDeviceToken() async {
    String _deviceToken = await FirebaseMessaging.instance.getToken();
    if (_deviceToken != null) {
      print('--------Device Token---------- '+_deviceToken);
    }
    return _deviceToken;
  }

  // for forgot password
  Future<ApiResponse> forgetPassword(String email) async {
    try {
      Response response = await dioClient.post(AppConstants.FORGET_PASSWORD_URI, data: {"email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyToken(String email, String token) async {
    try {
      Response response = await dioClient.post(AppConstants.VERIFY_TOKEN_URI, data: {"email": email, "reset_token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> resetPassword(String resetToken, String password, String confirmPassword) async {
    try {
      Response response = await dioClient.post(
        AppConstants.RESET_PASSWORD_URI,
        data: {"_method": "put", "reset_token": resetToken, "password": password, "confirm_password": confirmPassword},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for verify phone number
  Future<ApiResponse> checkEmail(String email) async {
    try {
      Response response = await dioClient.post(AppConstants.CHECK_EMAIL_URI, data: {"email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyEmail(String email, String token) async {
    try {
      Response response = await dioClient.post(AppConstants.VERIFY_EMAIL_URI, data: {"email": email, "token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient.token = token;
    dioClient.dio.options.headers = {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'};

    try {
      await sharedPreferences.setString(AppConstants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    //return sharedPreferences.containsKey(AppConstants.TOKEN);
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((value) => print(value.getString('uid') ?? ""+' 0000'));
    return sharedPreferences.containsKey('uid');
  }

  Future<bool> clearSharedData() async {
    if(!kIsWeb) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
    }
    await sharedPreferences.remove(AppConstants.TOKEN);
    await sharedPreferences.remove(AppConstants.CART_LIST);
    await sharedPreferences.remove(AppConstants.USER_ADDRESS);
    await sharedPreferences.remove(AppConstants.SEARCH_ADDRESS);
    return true;
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);
    } catch (e) {
      throw e;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.USER_NUMBER) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    return await sharedPreferences.remove(AppConstants.USER_NUMBER);
  }
}
