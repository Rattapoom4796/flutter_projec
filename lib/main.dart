import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterpro/provider/admin_provider.dart';
import 'package:flutterpro/page/admin_page.dart';
import 'package:flutterpro/page/guest_page.dart';
import 'package:flutterpro/page/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminProviders(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 142, 223, 248)),
          useMaterial3: true,
        ),
        home: const GuestPage(),
      ),
    );
  }
}
