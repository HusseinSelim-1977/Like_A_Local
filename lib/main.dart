import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LikeALocalApp());
}

class LikeALocalApp extends StatelessWidget {
  const LikeALocalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'LikeALocal | Premium Experience',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
        home: Consumer<AppState>(
          builder: (_, s, __) => s.isLoggedIn ? const HomeScreen() : const LoginScreen(),
        ),
      ),
    );
  }
}