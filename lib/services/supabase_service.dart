import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class SupabaseService {
  static final _client = Supabase.instance.client;
  static const _baseUrl =
      'https://yourdomain.com'; // replace with your Vercel domain later

  static String _generateCode(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(
      length,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  /// Shortens a URL and returns the short link
  static Future<String> shortenUrl(String originalUrl) async {
    final code = _generateCode(6);

    await _client.from('links').insert({
      'code': code,
      'original_url': originalUrl,
    });

    return '$_baseUrl/$code';
  }

  /// Looks up the original URL from a short code
  static Future<String?> resolveCode(String code) async {
    final response = await _client
        .from('links')
        .select('original_url')
        .eq('code', code)
        .maybeSingle();

    return response?['original_url'] as String?;
  }
}
