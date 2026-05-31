import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unlinkd/pages/home_page.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qoaxsrfzvfsobwnmphhe.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFvYXhzcmZ6dmZzb2J3bm1waGhlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAyMzM5MTMsImV4cCI6MjA5NTgwOTkxM30.OqcFlBEZ1zM5_gg0VNQD-MAY9VOzt5yd1EXEhcSZ2JY',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
