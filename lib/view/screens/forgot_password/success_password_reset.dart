import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class SuccessPasswordResetScreen extends StatelessWidget {
  final String emailAddress;
  final bool fromSignUp;
  SuccessPasswordResetScreen({@required this.emailAddress, this.fromSignUp = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Password Reset'),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 115),
            Image.asset(
              Images.email_with_background,
              width: 142,
              height: 142,
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Center(
                  child: Text(
                    'Please check your email for password reset instruction sent to\n $emailAddress',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                  )),
            ),
            SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
              child: CustomButton(
                btnTxt: getTranslated('login', context),
                onTap: () {
                  Navigator.pushNamed(context, Routes.LOGIN_SCREEN);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
