import 'package:flutter/material.dart';
import 'package:pinterest_clone/screens/splash_screen.dart';
import 'package:pinterest_clone/services/api_service.dart';
import 'package:provider/provider.dart';

void main() {

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<ImageListProvider>( // Updated to ImageListProvider
          create: (_) => ImageListProvider(),
        ),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

