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
  late AnimationController _contentController;
  late AnimationController _shimmerController;
  late AnimationController _floatController;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotate;
  late Animation<double> _logoOpacity;
  late Animation<double> _titleSlide;
  late Animation<double> _titleOpacity;
  late Animation<double> _subtitleSlide;
  late Animation<double> _subtitleOpacity;
  late Animation<double> _buttonSlide;
  late Animation<double> _buttonOpacity;
  late Animation<double> _shimmer;
  late Animation<double> _float;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotate = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _subtitleSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeIn),
      ),
    );

    _buttonSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _shimmer = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _float = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _contentController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    _shimmerController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D4A24), // deep forest green
              Color(0xFF1B7A3E), // primary green
              Color(0xFF25A355), // light green
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background circles
            Positioned(
              top: -80,
              right: -80,
              child: _buildDecorCircle(220, const Color(0x15F5C842)),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: _buildDecorCircle(120, const Color(0x10FFFFFF)),
            ),
            Positioned(
              bottom: -60,
              left: -60,
              child: _buildDecorCircle(200, const Color(0x15F5C842)),
            ),
            Positioned(
              bottom: 100,
              left: 30,
              child: _buildDecorCircle(80, const Color(0x10FFFFFF)),
            ),

            // Decorative geometric pattern (Islamic-inspired)
            Positioned.fill(
              child: CustomPaint(
                painter: IslamicPatternPainter(),
              ),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo section
                  AnimatedBuilder(
                    animation:
                        Listenable.merge([_logoController, _floatController]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _float.value),
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Transform.rotate(
                            angle: _logoRotate.value,
                            child: Opacity(
                              opacity: _logoOpacity.value.clamp(0.0, 1.0),
                              child: child,
                            ),
                          ),
                        ),
                      );
                    },
                    child: _buildLogoSection(),
                  ),

                  const Spacer(flex: 2),

                  // Text & button content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
                        // Arabic name
                        AnimatedBuilder(
                          animation: _contentController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _titleSlide.value),
                              child: Opacity(
                                opacity: _titleOpacity.value.clamp(0.0, 1.0),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              // Arabic text
                              const Text(
                                'نور الهدى',
                                style: TextStyle(
                                  fontSize: 42,
                                  color: Color(0xFFF5C842),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  shadows: [
                                    Shadow(
                                      color: Color(0x60000000),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(height: 6),
                              // Divider ornament
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildOrnamentLine(),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Icon(
                                      Icons.star,
                                      color: Color(0xFFF5C842),
                                      size: 14,
                                    ),
                                  ),
                                  _buildOrnamentLine(),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Latin name
                              const Text(
                                'NURUL HUDA',
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 6,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Subtitle
                        AnimatedBuilder(
                          animation: _contentController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _subtitleSlide.value),
                              child: Opacity(
                                opacity: _subtitleOpacity.value.clamp(0.0, 1.0),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0x60F5C842),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  'YAYASAN PONDOK PESANTREN',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xCCF5C842),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Mangunsari Tekung, Lumajang',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xAAFFFFFF),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Get Started Button
                        AnimatedBuilder(
                          animation: _contentController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _buttonSlide.value),
                              child: Opacity(
                                opacity: _buttonOpacity.value.clamp(0.0, 1.0),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              // Primary button
                              GestureDetector(
                                onTap: () {
                                  // Navigate to next screen
                                },
                                child: AnimatedBuilder(
                                  animation: _shimmerController,
                                  builder: (context, child) {
                                    return Container(
                                      width: double.infinity,
                                      height: 58,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFE8B830),
                                            Color(0xFFF5C842),
                                            Color(0xFFFFD966),
                                            Color(0xFFF5C842),
                                            Color(0xFFE8B830),
                                          ],
                                          stops: [0.0, 0.2, 0.5, 0.8, 1.0],
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x60E8B830),
                                            blurRadius: 20,
                                            offset: Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Shimmer overlay
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: ShaderMask(
                                              shaderCallback: (bounds) {
                                                return LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: const [
                                                    Colors.transparent,
                                                    Color(0x40FFFFFF),
                                                    Colors.transparent,
                                                  ],
                                                  stops: [
                                                    (_shimmer.value - 0.3)
                                                        .clamp(0.0, 1.0),
                                                    _shimmer.value
                                                        .clamp(0.0, 1.0),
                                                    (_shimmer.value + 0.3)
                                                        .clamp(0.0, 1.0),
                                                  ],
                                                ).createShader(bounds);
                                              },
                                              child: Container(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'Mulai Sekarang',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(0xFF0D4A24),
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                Icons.arrow_forward_rounded,
                                                color: Color(0xFF0D4A24),
                                                size: 22,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Secondary button
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: double.infinity,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0x60FFFFFF),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Masuk ke Akun',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Footer
                  AnimatedBuilder(
                    animation: _contentController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _buttonOpacity.value.clamp(0.0, 1.0),
                        child: child,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        '© 2024 Pondok Pesantren Nurul Huda',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.4),
                          letterSpacing: 0.5,
                        ),
                      ),
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

  Widget _buildLogoSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF5C842).withOpacity(0.3),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        // Gold ring border
        Container(
          width: 190,
          height: 190,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xFFE8B830),
                Color(0xFFFFD966),
                Color(0xFFE8B830),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // White ring
        Container(
          width: 178,
          height: 178,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        // Logo image
        ClipOval(
          child: Container(
              width: 170,
              height: 170,
              color: Colors.white,
              padding: const EdgeInsets.all(6),
              child: Center(
                child: Image.asset(
                  'images/logo.jpg',
                  width: 158,
                  height: 158,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.mosque_rounded,
                        size: 80,
                        color: Color(0xFF1B7A3E),
                      ),
                    );
                  },
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildDecorCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildOrnamentLine() {
    return Container(
      width: 60,
      height: 1.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Color(0xFFF5C842), Colors.transparent],
        ),
      ),
    );
  }
}

class IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x06FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final spacing = 60.0;
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        _drawStar(canvas, paint, Offset(x, y), 20);
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
