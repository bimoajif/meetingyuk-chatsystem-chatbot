import 'package:chatbot_meetingyuk/common/widgets/error_screen.dart';
import 'package:chatbot_meetingyuk/common/widgets/splash_screen.dart';
import 'package:chatbot_meetingyuk/features/auth/controller/auth_controller.dart';
import 'package:chatbot_meetingyuk/features/auth/screens/login_screen.dart';
import 'package:chatbot_meetingyuk/firebase_options.dart';
import 'package:chatbot_meetingyuk/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screen/home_chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

// ignore: must_be_immutable
class MyApp extends ConsumerWidget {
  MaterialColor meetingyukColor = const MaterialColor(
    0xFF3880A4,
    <int, Color>{
      50: Color(0xFFE4F6F9),
      100: Color(0xFFBAE8F1),
      200: Color(0xFF91D9E8),
      300: Color(0xFF70C9E0),
      400: Color(0xFF5CBDDC),
      500: Color(0xFF4EB2D8),
      600: Color(0xFF46A4CA),
      700: Color(0xFF3C91B8),
      800: Color(0xFF3880A4),
      900: Color(0xFF2C6082),
    },
  );
  MyApp({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: meetingyukColor, fontFamily: 'Figtree'),
        // home: const ChatScreen(),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: ref.watch(userDataAuthProvider).when(
              data: (user) {
                if (user == null) {
                  return const LoginScreen();
                }
                return const HomeChat();
              },
              error: (err, trace) {
                return ErrorScreen(error: err.toString());
              },
              loading: () => const SplashScreen(loading: false,),
            ));
  }
}
