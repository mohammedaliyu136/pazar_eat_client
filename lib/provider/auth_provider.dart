import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response2.dart';
import 'package:flutter_restaurant/data/model/response/base/error_response.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/model/response/signup_model.dart';
import 'package:flutter_restaurant/data/repository/auth_repo.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({@required this.authRepo});

  // for registration section
  bool _isLoading = false;

  String uid = '';
  var user;
  Map<String, dynamic> profile;


  bool get isLoading => _isLoading;
  String _registrationErrorMessage = '';

  String get registrationErrorMessage => _registrationErrorMessage;

  updateRegistrationErrorMessage(String message) {
    _registrationErrorMessage = message;
    notifyListeners();
  }

  Future<ResponseModel> registration(SignUpModel signUpModel) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();


    FireBaseResponse firebaseResponse = await authRepo.registration(signUpModel);

    ResponseModel responseModel;
    if(firebaseResponse.responseCode == 200){
      print('*******************');
      String uid = firebaseResponse.response.user.uid;
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      _prefs.then((value) => value.setString('uid', uid));
      _prefs.then((value) => print(value.getString('uid')+' *******************'));
      this.uid = uid;
      //await getUser(uid: uid);
      login(signUpModel.email, signUpModel.password);
      if(firebaseResponse.responseCode == 200){
        print('*******************');
        String uid = firebaseResponse.response.user.uid;
        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        _prefs.then((value) => value.setString('uid', uid));
        _prefs.then((value) => print(value.getString('uid')+' *******************'));
        this.uid = uid;
        //await getUser(uid: uid);
        user  = firebaseResponse.response.user;
      }
      responseModel = ResponseModel(true, 'successful');
    }else{
      responseModel = ResponseModel(false, firebaseResponse.error.toString());
    }
    _isLoading = false;
    notifyListeners();
    /*
    ApiResponse apiResponse = await authRepo.registration(signUpModel);
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      Map map = apiResponse.response.data;
      String token = map["token"];
      authRepo.saveUserToken(token);
      await authRepo.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.errors[0].message;
      }
      print(errorMessage);
      _registrationErrorMessage = errorMessage;
      responseModel = ResponseModel(false, errorMessage);
    }*/
    return responseModel;
  }

  // for login section
  String _loginErrorMessage = '';

  String get loginErrorMessage => _loginErrorMessage;

  Future<ResponseModel> login(String email, String password) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();


    FireBaseResponse firebaseResponse = await authRepo.login(email: email, password: password);
    ResponseModel responseModel;
    if(firebaseResponse.responseCode == 200){
      print('*******************');
      String uid = firebaseResponse.response.user.uid;
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      _prefs.then((value) => value.setString('uid', uid));
      this.uid = uid;
      //await getUser(uid: uid);
      user  = firebaseResponse.response.user;
      print('GGGGGGGGGGG');
      print(user);
      /*
      User(
          displayName: mohammed aliyu,
          email: kabir191@gmail.com,
          emailVerified: false,
          isAnonymous: false,
          metadata: UserMetadata(
              creationTime: 2021-07-03 20:19:48.124,
              lastSignInTime: 2021-07-06 22:27:24.178
          ),
          phoneNumber: null,
          photoURL: https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png,
          providerData, [
            UserInfo(displayName: mohammed aliyu, email: kabir191@gmail.com, phoneNumber: null,
                photoURL: https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png,
                providerId: password, uid: kabir191@gmail.com)],
          refreshToken: , tenantId: null, uid: tjkufxVEeISNjg6MlfavlZ8LTsJ2)
      */
      responseModel = ResponseModel(true, 'successful');
    }else{
      responseModel = ResponseModel(false, firebaseResponse.error.toString());
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  logout()async{
    await FirebaseAuth.instance.signOut();
    this.uid = null;
    //await getUser(uid: uid);
    user  = null;
  }

  Future<ResponseModel> passwordReset(email)async{
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    FireBaseResponse firebaseResponse = await authRepo.passwordReset(email: email);
    ResponseModel responseModel;
    _isLoading = false;
    _loginErrorMessage = '';
    notifyListeners();
    print('&&&&&&&&&&&&&&&&&&');
    print(firebaseResponse.response);
    if(firebaseResponse.responseCode == 200){
      responseModel = ResponseModel(true, 'successful');
      print("----------------********");
      print('000000000000000');
      print(responseModel.isSuccess);
      print(responseModel.message);
    }else{
      responseModel = ResponseModel(false, firebaseResponse.error.toString());
      print("----------------********");
      print(responseModel.isSuccess);
      print(responseModel.message);
    }
    return responseModel;
  }

  // for forgot password
  bool _isForgotPasswordLoading = false;

  bool get isForgotPasswordLoading => _isForgotPasswordLoading;

  Future<ResponseModel> forgetPassword(String email) async {
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.forgetPassword(email);
    _isForgotPasswordLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response.data["message"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  Future<void> updateToken() async {
    ApiResponse apiResponse = await authRepo.updateToken();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {

    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      print(errorMessage);
    }
  }

  Future<ResponseModel> verifyToken(String email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.verifyToken(email, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response.data["message"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String resetToken, String password, String confirmPassword) async {
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.resetPassword(resetToken, password, confirmPassword);
    _isForgotPasswordLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response.data["message"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  // for phone verification
  bool _isPhoneNumberVerificationButtonLoading = false;

  bool get isPhoneNumberVerificationButtonLoading => _isPhoneNumberVerificationButtonLoading;
  String _verificationMsg = '';

  String get verificationMessage => _verificationMsg;
  String _email = '';

  String get email => _email;

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void clearVerificationMessage() {
    _verificationMsg = '';
  }

  Future<ResponseModel> checkEmail(String email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.checkEmail(email);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response.data["token"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyEmail(String email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.verifyEmail(email, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response.data["message"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }


  // for verification Code
  String _verificationCode = '';

  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;

  bool get isEnableVerificationCode => _isEnableVerificationCode;

  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  // for Remember Me Section

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  bool isLoggedIn() {
    return uid.isNotEmpty;
  }
  bool isLoggedIn2() {
    return authRepo.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    _isLoading = true;
    notifyListeners();
    //bool _isSuccess = await authRepo.clearSharedData();
    bool _isSuccess = false;
    await FirebaseAuth.instance.signOut().then((value) => _isSuccess = true);
    this.uid = '';
    //await getUser(uid: uid);
    user  = null;
    _isLoading = false;
    notifyListeners();
    return _isSuccess;
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  String getUserNumber() {
    return authRepo.getUserNumber() ?? "";
  }
  String getUserPassword() {
    return authRepo.getUserPassword() ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  getUser({uid})async{
    await FirebaseFirestore.instance
        .collection('profiles').doc().get().then((value) => profile = value.data());
    /*
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get().then((value) => user = value.docs.first.data());
    */
    notifyListeners();

  }
  getProfile(){
    String uid = authRepo.getUserToken();
    print('-----------------------------');
    print(uid);

    /*
    FirebaseFirestore.instance
        .collection('profile').get()
        .where('uid', isEqualTo: '')
        .get().then((value) => print(value.docs[0].data()));
    */

  }


}
