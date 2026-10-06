import 'package:flutter/material.dart';

import 'pages/detail_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/sample_page.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const RoutingDemoApp());
}

class RoutingDemoApp extends StatelessWidget {
  const RoutingDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Routing Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFFBF9FF),
      ),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.sample: (_) => const SamplePage(),
        AppRoutes.profile: (_) => const ProfilePage(),
        AppRoutes.details: (_) => const DetailPage(),
      },
    );
  }
}
