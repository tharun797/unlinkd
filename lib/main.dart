import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unlinkd/pages/home_page.dart';
import 'package:unlinkd/pages/redirect_page.dart';
import 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qoaxsrfzvfsobwnmphhe.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFvYXhzcmZ6dmZzb2J3bm1waGhlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAyMzM5MTMsImV4cCI6MjA5NTgwOTkxM30.OqcFlBEZ1zM5_gg0VNQD-MAY9VOzt5yd1EXEhcSZ2JY',
  );

  String? initialCode;
 if (kIsWeb) {
  final hash = html.window.location.hash;
  final code = hash.replaceFirst('#', '').trim();
  if (code.isNotEmpty) {
    initialCode = code;
  }
}

  runApp(MainApp(initialCode: initialCode));
}

class MainApp extends StatelessWidget {
  final String? initialCode;
  const MainApp({super.key, this.initialCode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialCode != null
          ? RedirectPage(code: initialCode!)
          : const HomePage(),
    );
  }
}