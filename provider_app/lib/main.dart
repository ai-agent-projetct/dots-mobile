import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/config/app_env.dart';
import 'package:provider/config/app_routes.dart';
import 'package:provider/config/app_theme.dart';
import 'package:provider/di/di.dart';
import 'package:provider/firebase_options.dart';
import 'package:provider/utils/services/prefs.dart';
import 'package:provider/utils/services/push_notification_service.dart';
import 'package:provider/widgets/change_language.dart';
import 'package:resize/resize.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

StreamController<String> didReceiveLocalNotificationStream =
    StreamController<String>.broadcast();
Future<void> main() async {
  setEnvironment(Environment.dev);
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: ChangeLanguage.fallbackLocale,
    supportedLocales: ChangeLanguage.supportedLocales,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs().instance();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotificationService().setupNotification();

  runApp(ProviderScope(child: LocalizedApp(delegate, DotsProviderApp())));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DotsProviderApp extends ConsumerStatefulWidget {
  const DotsProviderApp({super.key});

  @override
  DotsProviderAppState createState() => DotsProviderAppState();
}

class DotsProviderAppState extends ConsumerState<DotsProviderApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var mInternetProvider = ref.watch(internetProvider);
    var localizationDelegate = LocalizedApp.of(context).delegate;
    debugPrint('screen heigth -----> ${MediaQuery.of(context).size.height}');
    debugPrint('screen width------>${MediaQuery.of(context).size.width}');
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: Resize(
        builder:
            () => MaterialApp(
              title: 'Dots',
              theme: AppTheme().themeData,
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutes.splash,
              onGenerateRoute: AppRoutes.onGenerateRoute,
              navigatorKey: navigatorKey,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                localizationDelegate,
              ],
              supportedLocales: localizationDelegate.supportedLocales,
              locale: Locale(ChangeLanguage.selectedLanguage),
            ),
        size: getResponsiveSize(context),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

Size getResponsiveSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  if (width < 450 && height > 690) return const Size(360, 690);
  return Size(width, height);
}
