import 'dart:async';
import 'dart:io';
import 'package:dhahar_lib_driver/feature/language/controllers/localization_controller.dart';
import 'package:dhahar_lib_driver/feature/splash/controllers/splash_controller.dart';
import 'package:dhahar_lib_driver/common/controllers/theme_controller.dart';
import 'package:dhahar_lib_driver/feature/notification/domain/models/notification_body_model.dart';
import 'package:dhahar_lib_driver/helper/notification_helper.dart';
import 'package:dhahar_lib_driver/helper/route_helper.dart';
import 'package:dhahar_lib_driver/theme/dark_theme.dart';
import 'package:dhahar_lib_driver/theme/light_theme.dart';
import 'package:dhahar_lib_driver/util/app_constants.dart';
import 'package:dhahar_lib_driver/util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  if(!GetPlatform.isWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> languages = await di.init();

  if(GetPlatform.isAndroid) {
    if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB4yq-rdrZPjf6-2YhL0tsP53gkP0rD6Gw",
        authDomain: "dhahar-id.firebaseapp.com",
        databaseURL: "https://dhahar-id-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "dhahar-id",
        storageBucket: "dhahar-id.firebasestorage.app",
        messagingSenderId: "1063100312311",
        appId: "1:1063100312311:android:26a5d07ba79c159406c1f2",
        measurementId: "G-1M4JERDWCG"
      ),
    );
    }
  } else {
    await Firebase.initializeApp();
  }

  NotificationBodyModel? body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
      if(remoteMessage != null){
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  }catch(_) {}

  runApp(MyApp(languages: languages, body: body));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBodyModel? body;
  const MyApp({super.key, required this.languages, required this.body});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            theme: themeController.darkTheme ? dark : light,
            locale: localizeController.locale,
            translations: Messages(languages: languages),
            fallbackLocale: Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode),
            initialRoute: RouteHelper.getSplashRoute(body),
            getPages: RouteHelper.routes,
            defaultTransition: Transition.topLevel,
            transitionDuration: const Duration(milliseconds: 500),
            builder: (BuildContext context, widget) {
              return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)), child: Material(
                child: SafeArea(
                  top: false, bottom: GetPlatform.isAndroid,
                  child: Stack(children: [
                    widget!,
                  ]),
                ),
              ));
            },
          );
        });
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}