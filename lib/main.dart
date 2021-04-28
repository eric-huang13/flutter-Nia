import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nia_app/src/data/app_assets.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/ui/pages/earn_pavement_points.dart';
import 'package:nia_app/src/ui/pages/login_page.dart';
import 'package:nia_app/src/ui/pages/main_page.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesUtil sharedPreferencesUtil = SharedPreferencesUtil();
  bool isThisUsersFirstTime =
      await sharedPreferencesUtil.isThisUsersFirstTime();

  bool isUserLoggedIn = await sharedPreferencesUtil.isUserLoggedIn();
  runApp(MyApp(
    loginStatus: isUserLoggedIn,
    firstTimeStatus: isThisUsersFirstTime,
  ));
}

class MyApp extends StatelessWidget {
  final bool loginStatus;
  final bool firstTimeStatus;

  MyApp({@required this.loginStatus, @required this.firstTimeStatus});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: AppStrings.appTitle,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
        ),
        home: firstTimeStatus
            ? OnboardingPage()
            : loginStatus
                ? MainPage(
                    initialPageIndex: 1,
                  )
                : LoginPage());
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    Key key,
  }) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            _buildWelcomeOnboarding(),
            _buildConnectOnboarding(),
            _buildEarnOnboarding(),
            _buildBuildOnboarding(),
          ],
        ),
      ),
    );
  }

  Center _buildBuildOnboarding() => Center(
        child: Column(
          children: <Widget>[
            Expanded(
                child: FractionallySizedBox(
              widthFactor: 0.4,
              child: Image.asset(
                AppAssets.app_logo,
              ),
            )),
            Expanded(
                child: SvgPicture.asset(
              AppAssets.onboarding_build,
            )),
            Expanded(
                child: Column(
              children: <Widget>[
                Expanded(
                    child: Center(
                        child: Text(
                  'Build',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ))),
                Expanded(
                    child: Center(
                        child: Text(
                  'Whether it\'s a one on one or creating\na connection, our new app makes building\n relationships easier than ever.',
                  textAlign: TextAlign.center,
                ))),
                Expanded(
                    child: Row(children: [
                  FlatButton(
                    child: Text('Skip'),
                    onPressed: () {
                      _exitOnboarding();
                    },
                  ),
                  Flexible(fit: FlexFit.tight, child: Text('')),
                  FlatButton(
                    child: Text('Next'),
                    onPressed: () {
                      _exitOnboarding();
                    },
                  )
                ]))
              ],
            )),
          ],
        ),
      );

  Future<void> _exitOnboarding() async {
    await SharedPreferencesUtil().setUsersFirstTimeAsFalse();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Center _buildEarnOnboarding() => Center(
        child: Column(
          children: <Widget>[
            Expanded(
                child: FractionallySizedBox(
              widthFactor: 0.4,
              child: Image.asset(
                AppAssets.app_logo,
              ),
            )),
            Expanded(
                child: SvgPicture.asset(
              AppAssets.onboarding_earn,
            )),
            Expanded(
                child: Column(
              children: <Widget>[
                Expanded(
                    child: Center(
                        child: Text(
                  'Earn',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ))),
                Expanded(
                    child: Center(
                        child: Text(
                  'Keep track of your activity with our easy to use\nsystem Pavement Points system.',
                  textAlign: TextAlign.center,
                ))),
                Expanded(
                    child: Row(children: [
                  FlatButton(
                    child: Text('Skip'),
                    onPressed: () {
                      _exitOnboarding();
                    },
                  ),
                  Flexible(fit: FlexFit.tight, child: Text('')),
                  FlatButton(
                    child: Text('Next'),
                    onPressed: () {
                      _pageController.animateToPage(
                        3,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                ]))
              ],
            )),
          ],
        ),
      );

  Center _buildConnectOnboarding() => Center(
        child: Column(
          children: <Widget>[
            Expanded(
                child: FractionallySizedBox(
              widthFactor: 0.4,
              child: Image.asset(
                AppAssets.app_logo,
              ),
            )),
            Expanded(
                child: SvgPicture.asset(
              AppAssets.onboarding_connection,
            )),
            Expanded(
                child: Column(
              children: <Widget>[
                Expanded(
                    child: Center(
                        child: Text(
                  'Connect',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ))),
                Expanded(
                    child: Center(
                        child: Text(
                  'Connect with valued members from your local\nNetwork in Action members!',
                  textAlign: TextAlign.center,
                ))),
                Expanded(
                    child: Row(children: [
                  FlatButton(
                    child: Text('Skip'),
                    onPressed: () {
                      _exitOnboarding();
                    },
                  ),
                  Flexible(fit: FlexFit.tight, child: Text('')),
                  FlatButton(
                    child: Text('Next'),
                    onPressed: () {
                      _pageController.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                ]))
              ],
            )),
          ],
        ),
      );

  Center _buildWelcomeOnboarding() => Center(
        child: Column(
          children: <Widget>[
            Expanded(
                child: FractionallySizedBox(
              widthFactor: 0.4,
              child: Image.asset(
                AppAssets.app_logo,
              ),
            )),
            Expanded(
                child: SvgPicture.asset(
              AppAssets.onboarding_welcome,
            )),
            Expanded(
                child: Column(
              children: <Widget>[
                Expanded(
                    child: Center(
                        child: Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ))),
                Expanded(
                    child: Center(
                        child: Text(
                  'Welcome to our new \nNetwork in Action app!',
                  textAlign: TextAlign.center,
                ))),
                Flexible(
                    child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      color: AppColors.primaryColor,
                      child: Text(
                        'Let\'s Go!',
                        style: TextStyle(color: AppColors.white),
                      ),
                      onPressed: () {
                        _pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                )),
              ],
            )),
          ],
        ),
      );
}
