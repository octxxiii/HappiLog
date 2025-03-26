import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:happilog/services/firebase_service.dart';
import 'package:happilog/utils/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // 익명 로그인 자동 처리
  await FirebaseService.signInAnonymously();
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: '행복 기록 (Happilog)',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0C1D),
        primaryColor: Colors.amber,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
          background: const Color(0xFF0D0C1D),
        ),
        textTheme: GoogleFonts.nanumGothicCodingTextTheme(
          Theme.of(context).textTheme.copyWith(
                bodyLarge: TextStyle(color: Colors.white.withOpacity(0.9)),
                bodyMedium: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            minimumSize: const Size(160, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // 픽셀 스타일 직각 모서리
              side: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}
