import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/features/nav_bar/presentation/view/main_navigation_screen.dart';

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baqalty Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
      ),
      home: const MainNavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
