import 'dart:async';
import 'dart:isolate';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' as prod;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/config/app_env.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/config/app_theme.dart';
import 'package:user/di/di.dart';
import 'package:user/firebase_options.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/utils/services/push_notification_service.dart';
import 'package:user/widgets/change_language.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:device_preview/device_preview.dart';

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
  if (!prod.kDebugMode) {
    const fatalError = true;
    FlutterError.onError = (errorDetails) {
      if (fatalError) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        // ignore: dead_code
      } else {
        FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      }
    };
    prod.PlatformDispatcher.instance.onError = (error, stack) {
      if (fatalError) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        // ignore: dead_code
      } else {
        FirebaseCrashlytics.instance.recordError(error, stack);
      }
      return true;
    };

    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
          fatal: true,
        );
      }).sendPort,
    );
  }

  runApp(ProviderScope(child: LocalizedApp(delegate, DotsUserApp())));
  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     builder:
  //         (context) =>
  //             ProviderScope(child: LocalizedApp(delegate, DotsUserApp())),
  //   ),
  // );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DotsUserApp extends ConsumerStatefulWidget {
  const DotsUserApp({super.key});

  @override
  DotsUserAppState createState() => DotsUserAppState();
}

class DotsUserAppState extends ConsumerState<DotsUserApp> {
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
              // builder: DevicePreview.appBuilder,
              // useInheritedMediaQuery: true,
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
        size:
            MediaQuery.of(context).size.width < 450 &&
                    MediaQuery.of(context).size.height < 690
                ? Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                )
                : MediaQuery.of(context).size.width < 450 &&
                    MediaQuery.of(context).size.height > 690
                ? const Size(360, 690)
                : Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
