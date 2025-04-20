import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/controllers/home/user_controller.dart';
import 'package:kertasinapp/routes/page_route.dart';
import 'package:kertasinapp/routes/route_name.dart';
import 'package:kertasinapp/utilities/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Get.put(UserController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _getInitialRoute() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        return RoutesName.mainPage;
      } else {
        return RoutesName.loginPage;
      }
    }
    return RoutesName.loginPage;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return GetMaterialApp(
            title: 'Kertasin App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: kColorPureWhite,
            ),
            initialRoute: snapshot.data!,
            getPages: PagesRoute.pages,
          );
        }
        return MaterialApp(
          home: Scaffold(
            backgroundColor: kColorPureWhite,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
