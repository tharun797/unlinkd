import 'package:flutter/material.dart';
import 'package:unlinkd/services/supabase_service.dart';
import 'dart:html' as html;

class RedirectPage extends StatefulWidget {
  final String code;
  const RedirectPage({super.key, required this.code});

  @override
  State<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  String _status = 'Finding your link...';
  bool _error = false;

  Widget _blob(double size, Color color, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withOpacity(opacity), Colors.transparent],
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    try {
      final originalUrl = await SupabaseService.resolveCode(widget.code);
      if (originalUrl == null) {
        setState(() {
          _status = 'Link not found.';
          _error = true;
        });
        return;
      }
      setState(() => _status = 'Redirecting...');
      await Future.delayed(const Duration(milliseconds: 600));
      html.window.location.href = originalUrl;
    } catch (e) {
      setState(() {
        _status = 'Something went wrong.';
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFf5f0ff),
                  Color(0xFFfff0f5),
                  Color(0xFFfff5ee),
                ],
              ),
            ),
          ),

          // Blobs
          Positioned(top: -60, left: -40,
              child: _blob(320, const Color(0xFF833AB4), 0.22)),
          Positioned(top: 160, right: -80,
              child: _blob(300, const Color(0xFFE1306C), 0.17)),
          Positioned(bottom: 100, left: 10,
              child: _blob(280, const Color(0xFFF77737), 0.15)),

          // Frosted overlay
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05)),
          ),

          // Content
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Unlinkd',
                  style: TextStyle(
                    fontFamily: 'PetitFormalScript',
                    fontSize: 52,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
                const SizedBox(height: 48),

                // Spinner or error icon
                if (!_error)
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF833AB4).withOpacity(0.6),
                      ),
                    ),
                  )
                else
                  Icon(Icons.link_off_rounded,
                      size: 36, color: Colors.black.withOpacity(0.3)),

                const SizedBox(height: 24),

                Text(
                  _status,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.4),
                    letterSpacing: 0.3,
                  ),
                ),

                if (_error) ...[
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      html.window.location.href = '/';
                    },
                    child: Text(
                      'Go to Unlinkd →',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: const Color(0xFF833AB4).withOpacity(0.7),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}