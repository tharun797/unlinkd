import 'package:flutter/material.dart';

class ShortenButton extends StatefulWidget {
  final String url;
  final VoidCallback? onTap;
  final bool isLoading;

  const ShortenButton({
    super.key,
    required this.url,
    this.onTap,
    this.isLoading = false,
  });

  @override
  State<ShortenButton> createState() => _ShortenButtonState();
}

class _ShortenButtonState extends State<ShortenButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.75)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF833AB4).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: GestureDetector(
        onTapDown: widget.isLoading
            ? null
            : (_) => setState(() => _pressed = true),
        onTapUp: widget.isLoading
            ? null
            : (_) => setState(() => _pressed = false),
        onTapCancel: widget.isLoading
            ? null
            : () => setState(() => _pressed = false),
        onTap: widget.isLoading ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFF833AB4), Color(0xFFE1306C), Color(0xFFF77737)],
            ),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      color: const Color(0xFFE1306C).withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color(0xFFE1306C).withOpacity(0.45),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: 6,
                      offset: const Offset(0, -2),
                    ),
                  ],
          ),
          transform: _pressed
              ? (Matrix4.identity()..scale(0.97))
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Shorten Url',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'PetitFormalScript',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
