import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unlinkd/pages/home_page.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qoaxsrfzvfsobwnmphhe.supabase.co',
    anonKey: 'sb_publishable_5kOBAuGcmD2Y0-88-rvFTg_vTAsQM4R',
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
