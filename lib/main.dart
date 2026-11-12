
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/audio_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioManager.instance.init();
  runApp(const SampaHoreApp());
}

class SampaHoreApp extends StatelessWidget {
  const SampaHoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SampaHore!',
      navigatorObservers: [audioRouteObserver],
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E8B57),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}