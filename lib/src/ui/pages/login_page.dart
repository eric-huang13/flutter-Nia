import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_assets.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/login_response.dart';
import 'package:nia_app/src/model/result.dart';
import 'package:nia_app/src/services/auth_service.dart';
import 'package:nia_app/src/ui/pages/main_page.dart';
import 'package:nia_app/src/ui/spacers.dart';
import 'package:nia_app/src/util/secure_storage_util.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController userNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _showLoginErrorSnackbar({@required message}) {
      final snackBar = SnackBar(
        content: Text(message),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

    _validateAndLogin() async {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });

        Result<LoginResponse> userLoginResponseResult = await _logInUser();
        LoginResponse loginResponse = userLoginResponseResult.result;

        if (loginResponse.error == false) {
          String authenticationToken = loginResponse.data.token;
          await SecureStorageUtil()
              .storeAuthenticationToken(authenticationToken);
          await SharedPreferencesUtil().setUserLogInStatus(loginStatus: true);
          await SharedPreferencesUtil()
              .setUserId(userId: loginResponse.data.userid);

          setState(() {
            _isLoading = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MainPage(
                      initialPageIndex: 1,
                    )),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          _showLoginErrorSnackbar(message: userLoginResponseResult.message);
        }
      }
    }

    Widget _buildLoginForm() {
      return Container(
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            )),
        padding: EdgeInsets.all(32.0),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.signIn,
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AppSpacers.largeVerticalSpacer,
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: userNameController,
                          decoration: InputDecoration(
                            filled: true,
                            border: InputBorder.none,
                            hintText: AppStrings.userName,
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter user name';
                            }
                            return null;
                          },
                        ),
                        AppSpacers.mediumVerticalSpacer,
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            filled: true,
                            border: InputBorder.none,
                            hintText: AppStrings.password,
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                        ),
                        AppSpacers.largeVerticalSpacer,
                        FractionallySizedBox(
                          widthFactor: 1.0,
                          child: FlatButton(
                            onPressed: () {
                              _validateAndLogin();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(AppStrings.signIn.toUpperCase(),
                                  style: TextStyle(color: AppColors.white)),
                            ),
                            color: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox.shrink(),
          ],
        ),
      );
    }

    return  Scaffold(
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
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
                  child: _buildLoginForm(),
                ),
              ),
            ],
          ),
        );
  }

  Future<Result<LoginResponse>> _logInUser() async {
    Result<LoginResponse> loginResponseResult = await AuthService().login(
      username: userNameController.text,
      password: passwordController.text,
    );

    return loginResponseResult;
  }
}
