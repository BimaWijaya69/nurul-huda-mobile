import 'package:nurul_huda_mobile/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _floatController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _float;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _textSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _float = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    _textController.forward();
    // Auto redirect setelah semua animasi selesai
    await Future.delayed(const Duration(milliseconds: 2000));
    Get.offAllNamed(Routes.LAYOUT);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Subtle pattern background
          Positioned.fill(
            child: CustomPaint(painter: _SubtlePatternPainter()),
          ),

          // Accent circle top right
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1B7A3E).withOpacity(0.04),
              ),
            ),
          ),

          // Accent circle bottom left
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF5C842).withOpacity(0.07),
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                AnimatedBuilder(
                  animation:
                      Listenable.merge([_logoController, _floatController]),
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _float.value),
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Opacity(
                          opacity: _logoOpacity.value.clamp(0.0, 1.0),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: _buildLogo(),
                ),

                const SizedBox(height: 36),

                // Text
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: Opacity(
                        opacity: _textOpacity.value.clamp(0.0, 1.0),
                        child: child,
                      ),
                    );
                  },
                  child: _buildText(),
                ),
              ],
            ),
          ),

          // Loading indicator bottom
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Opacity(
                  opacity: _textOpacity.value.clamp(0.0, 1.0),
                  child: child,
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: const Color(0xFF1B7A3E).withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Memuat aplikasi...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Soft glow
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B7A3E).withOpacity(0.12),
                blurRadius: 32,
                spreadRadius: 8,
              ),
            ],
          ),
        ),
        // Gold ring
        Container(
          width: 172,
          height: 172,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFE8B830), Color(0xFFFFD966), Color(0xFFE8B830)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // White inner circle
        Container(
          width: 160,
          height: 160,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        // Logo image
        ClipOval(
          child: Container(
            width: 152,
            height: 152,
            color: Colors.white,
            padding: const EdgeInsets.all(6),
            child: Center(
              child: Image.asset(
                'images/logo.jpg',
                width: 140,
                height: 140,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.mosque_rounded,
                  size: 72,
                  color: Color(0xFF1B7A3E),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildText() {
    return Column(
      children: [
        // Arabic
        const Text(
          'نور الهدى',
          style: TextStyle(
            fontSize: 36,
            color: Color(0xFF1B7A3E),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          textDirection: TextDirection.rtl,
        ),

        const SizedBox(height: 8),

        // Ornament divider
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ornamentLine(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF5C842),
                ),
              ),
            ),
            _ornamentLine(),
          ],
        ),

        const SizedBox(height: 10),

        // Latin name
        const Text(
          'NURUL HUDA',
          style: TextStyle(
            fontSize: 22,
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w900,
            letterSpacing: 5,
          ),
        ),

        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Yayasan Pondok Pesantren',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          'Mangunsari Tekung, Lumajang',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade400,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _ornamentLine() {
    return Container(
      width: 48,
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Color(0xFFF5C842), Colors.transparent],
        ),
      ),
    );
  }
}

class _SubtlePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x04000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const spacing = 70.0;
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        _drawStar(canvas, paint, Offset(x, y), 16);
      }
    }
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    const points = 8;
    const innerRadius = 0.5;
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi) / points - math.pi / 2;
      final r = i.isEven ? radius : radius * innerRadius;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
