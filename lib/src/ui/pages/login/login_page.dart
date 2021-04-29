import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_assets.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/login_response.dart';
import 'package:nia_app/src/model/result.dart';
import 'package:nia_app/src/services/auth_service.dart';
import 'package:nia_app/src/ui/pages/login/widgets/login_form.dart';
import 'package:nia_app/src/ui/pages/main_page.dart';
import 'package:nia_app/src/ui/spacers.dart';
import 'package:nia_app/src/util/secure_storage_util.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          FractionallySizedBox(
            heightFactor: 1.0,
            widthFactor: 1.0,
            child: Image.asset(
              AppAssets.loginScreenBackground,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.7,
              widthFactor: 1.0,
              child: LoginForm(),
            ),
          ),
        ],
      ),
    );
  }
}
