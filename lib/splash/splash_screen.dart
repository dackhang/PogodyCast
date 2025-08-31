import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:weatherapp_demo/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;
  late AnimationController _particleController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _particleAnimation;

  final List<_FloatingIcon> _floatingIcons = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    // Initialize floating icons
    _initializeFloatingIcons();
    
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    // Logo animations
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Text animations
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));
    
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Particle animation
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    ));

    // Start animations
    _startAnimations();
    
    // Navigate to home screen
    Timer(const Duration(seconds: 4), () {
      _fadeController.forward().then((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    });
  }

  void _initializeFloatingIcons() {
    final weatherIcons = [
      Icons.wb_sunny,
      Icons.cloud,
      Icons.grain,
      Icons.thunderstorm,
      Icons.ac_unit,
      Icons.wb_cloudy,
      Icons.umbrella,
      Icons.air,
      Icons.water_drop,
      Icons.visibility,
      Icons.thermostat,
      Icons.wb_iridescent,
      Icons.airplanemode_active,
      Icons.beach_access,
      Icons.nights_stay,
    ];

    for (int i = 0; i < 50; i++) {
      _floatingIcons.add(_FloatingIcon(
        icon: weatherIcons[_random.nextInt(weatherIcons.length)],
        x: _random.nextDouble() * 600 - 300,
        y: _random.nextDouble() * 1200 - 600,
        size: _random.nextDouble() * 20 + 12,
        speed: _random.nextDouble() * 4 + 0.3,
        delay: _random.nextDouble() * 4,
      ));
    }
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeController,
        builder: (context, child) {
          return Opacity(
            opacity: 1.0 - _fadeController.value,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/splash/bgimg_2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.4),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Stack(
                  children: [
                    // Floating weather icons
                    ..._floatingIcons.map((icon) => _buildFloatingIcon(icon)),
                    
                    // Animated background elements
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -100,
                      left: -100,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    
                    // Main content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo with animation
                          AnimatedBuilder(
                            animation: _logoController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _logoScale.value,
                                child: Opacity(
                                  opacity: _logoOpacity.value,
                                  child: Image.asset(
                                    'assets/icon_logo/wag.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // App name with animation
                          AnimatedBuilder(
                            animation: _textController,
                            builder: (context, child) {
                              return SlideTransition(
                                position: _textSlide,
                                child: FadeTransition(
                                  opacity: _textOpacity,
                                  child: Column(
                                    children: [
                                      const Text(
                                        'PogodyCast',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 3,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black54,
                                              offset: Offset(0, 3),
                                              blurRadius: 6,
                                            ),
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          const SizedBox(height: 60),
                          
                          // Loading indicator with glow effect
                          AnimatedBuilder(
                            animation: _textController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _textOpacity.value,
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.2),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingIcon(_FloatingIcon icon) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        final progress = (_particleAnimation.value + icon.delay) % 1.0;
        final y = icon.y + (progress * icon.speed * 200);
        
        return Positioned(
          left: icon.x,
          top: y,
          child: Opacity(
            opacity: 0.6,
            child: Icon(
              icon.icon,
              size: icon.size,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        );
      },
    );
  }
}

class _FloatingIcon {
  final IconData icon;
  final double x;
  final double y;
  final double size;
  final double speed;
  final double delay;

  _FloatingIcon({
    required this.icon,
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.delay,
  });
}
