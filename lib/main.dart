import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/commons/widgets/error.dart';
import 'package:whatsapp/commons/widgets/loader.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/landing/screens/landing_screen.dart';
import 'package:whatsapp/firebase_options.dart';
import 'package:whatsapp/home_screen.dart';
import 'package:whatsapp/router.dart';
import 'package:whatsapp/utils/responsive_layout.dart';
import 'package:whatsapp/screens/mobile_screen_layout.dart';
import 'package:whatsapp/screens/web_screen_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Whatsapp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            primaryColorDark: tabColor,
            scaffoldBackgroundColor: backgroundColor,
            inputDecorationTheme: const InputDecorationTheme(
                hintStyle: TextStyle(color: tabColor),
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: tabColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: tabColor,
                ))),
            focusColor: tabColor,
            appBarTheme: const AppBarTheme(color: appBarColor)),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileScreenLayout();
            },
            error: (error, trace) {
              return ErrorScreen(error: error.toString()+'error aa gya');
            },
            loading: () => const Loader()));
  }
}
