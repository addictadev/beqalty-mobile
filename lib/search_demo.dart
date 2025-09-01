import 'package:flutter/material.dart';
import 'package:baqalty/features/search/index.dart';
import 'package:baqalty/core/theme/app_theme.dart';

void main() {
  runApp(const SearchDemoApp());
}

class SearchDemoApp extends StatelessWidget {
  const SearchDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Results Demo',
      theme: AppTheme.lightTheme,
      home: const SearchResultsScreen(searchQuery: "Milk"),
    );
  }
}
