import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unlinkd/components/shorten_button.dart';
import 'package:unlinkd/services/supabase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;
  String? _shortUrl;
  String? _errorMessage;

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

  Future<void> _handleShorten() async {
    final url = _urlController.text.trim();

    if (url.isEmpty) {
      setState(() => _errorMessage = 'Please paste a link first.');
      return;
    }

    if (!Uri.tryParse(url)!.hasScheme ?? true) {
      setState(() => _errorMessage = 'Please enter a valid URL.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _shortUrl = null;
    });

    // try {
    //   final shortUrl = await SupabaseService.shortenUrl(url);
    //   await Clipboard.setData(ClipboardData(text: shortUrl));
    //   setState(() => _shortUrl = shortUrl);
    // } catch (e) {
    //   setState(() => _errorMessage = 'Something went wrong. Try again.');
    // } finally {
    //   setState(() => _isLoading = false);
    // }

    try {
  final shortUrl = await SupabaseService.shortenUrl(url);
  setState(() {
    _shortUrl = shortUrl;
    _urlController.clear();
  });
  
  // Separate try/catch so clipboard failure doesn't affect the result
  try {
    await Clipboard.setData(ClipboardData(text: shortUrl));
  } catch (_) {
    // Safari blocks auto-copy, that's fine
  }
} catch (e) {
  setState(() => _errorMessage = 'Something went wrong. Try again.');
} finally {
  setState(() => _isLoading = false);
}
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
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
            Positioned(
              top: -60,
              left: -40,
              child: _blob(320, const Color(0xFF833AB4), 0.22),
            ),
            Positioned(
              top: 160,
              right: -80,
              child: _blob(300, const Color(0xFFE1306C), 0.17),
            ),
            Positioned(
              bottom: 100,
              left: 10,
              child: _blob(280, const Color(0xFFF77737), 0.15),
            ),
            Positioned(
              bottom: -40,
              right: 60,
              child: _blob(200, const Color(0xFF833AB4), 0.10),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05)),
            ),
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
                  const SizedBox(height: 8),
                  Text(
                    'Shorten any link, instantly.',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.black.withOpacity(0.35),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Input card
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.75),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF833AB4).withOpacity(0.08),
                              blurRadius: 32,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.link_rounded,
                                color: Colors.black.withOpacity(0.28),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _urlController,
                                style: const TextStyle(
                                  color: Color(0xFF1a1a1a),
                                  fontSize: 14.5,
                                ),
                                onTapOutside: (_) =>
                                    FocusScope.of(context).unfocus(),
                                onChanged: (_) => setState(() {
                                  _errorMessage = null;
                                  _shortUrl = null;
                                }),
                                decoration: InputDecoration(
                                  hintText: 'Paste your link here...',
                                  hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.28),
                                    fontSize: 14.5,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            // Clear button
                            if (_urlController.text.isNotEmpty)
                              GestureDetector(
                                onTap: () => setState(() {
                                  _urlController.clear();
                                  _shortUrl = null;
                                  _errorMessage = null;
                                }),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.black.withOpacity(0.28),
                                    size: 18,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Shorten button
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ShortenButton(
                        url: _urlController.text,
                        isLoading: _isLoading,
                        onTap: _handleShorten,
                      ),
                    ),
                  ),

                  // Result / error
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _shortUrl != null || _errorMessage != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 420),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _shortUrl != null
                                        ? Colors.white.withOpacity(0.6)
                                        : Colors.red.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: _shortUrl != null
                                          ? Colors.white.withOpacity(0.8)
                                          : Colors.red.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _shortUrl != null
                                            ? Icons.check_circle_outline_rounded
                                            : Icons.error_outline_rounded,
                                        size: 16,
                                        color: _shortUrl != null
                                            ? const Color(0xFF833AB4)
                                            : Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _shortUrl ?? _errorMessage!,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: _shortUrl != null
                                                ? const Color(0xFF1a1a1a)
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                      if (_shortUrl != null)
                                        Text(
                                          'Copied!',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: const Color(
                                              0xFF833AB4,
                                            ).withOpacity(0.7),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 48),
                  Text(
                    'Free · No sign-up required',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.black.withOpacity(0.25),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
