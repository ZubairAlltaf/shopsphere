import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../providers/auth_provider.dart';
import '../widgets/custom_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _usernameController = TextEditingController(text: 'zubairalltaf');
  final _passwordController = TextEditingController(text: 'password123');

  bool _isLoading = false;
  late AnimationController _backgroundAnimationController;
  late AnimationController _formAnimationController;
  late Animation<double> _formElementAnimation;

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _formAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _formElementAnimation = CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeOut,
    );
    _formAnimationController.forward();

    _usernameFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _backgroundAnimationController.dispose();
    _formAnimationController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (_isLoading) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 1500));

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (mounted) {
      if (authProvider.isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        CustomSnackBar.show(
          context: context,
          message: 'Invalid Credentials. The Abyss rejects you.',
          backgroundColor: const Color(0xFFD32F2F),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildLavaBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 60),
                  _buildAnimatedFormElement(
                    delay: 0.1,
                    child: _buildThemedTextField(
                      controller: _usernameController,
                      focusNode: _usernameFocus,
                      label: 'Username',
                      icon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildAnimatedFormElement(
                    delay: 0.2,
                    child: _buildThemedTextField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildAnimatedFormElement(
                    delay: 0.3,
                    child: _buildForgotPassword(),
                  ),
                  const SizedBox(height: 30),
                  _buildAnimatedFormElement(
                    delay: 0.4,
                    child: _buildLoginButton(),
                  ),
                  const SizedBox(height: 40),
                  _buildAnimatedFormElement(
                    delay: 0.5,
                    child: _buildSignUpLink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLavaBackground() {
    return CustomPaint(
      painter: LavaBackgroundPainter(animation: _backgroundAnimationController),
      child: Container(),
    );
  }

  Widget _buildHeader() {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
          .animate(_formElementAnimation),
      child: FadeTransition(
        opacity: _formElementAnimation,
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Text(
            'ENTER THE REALM',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedFormElement({required double delay, required Widget child}) {
    final animation = CurvedAnimation(
      parent: _formAnimationController,
      curve: Interval(delay, 1.0, curve: Curves.easeOut),
    );
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(animation),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  Widget _buildThemedTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    final bool hasFocus = focusNode.hasFocus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.orbitron(
            color: hasFocus ? Colors.red[400] : Colors.grey[400],
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            boxShadow: hasFocus
                ? [
              BoxShadow(
                color: const Color(0xFFD32F2F).withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ]
                : [],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: isPassword,
            style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: InputBorder.none,
              prefixIcon: Icon(icon, color: hasFocus ? Colors.red[300] : Colors.grey[500]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'Forgot Password?',
        style: GoogleFonts.orbitron(color: Colors.grey[500], fontSize: 12),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _login,
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.red.withOpacity(0.5),
        highlightColor: Colors.red.withOpacity(0.3),
        child: Ink(
          height: 55,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE53935).withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: _isLoading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
                : Text(
              'SIGN IN',
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.orbitron(color: Colors.grey[500], fontSize: 12),
        ),
        Text(
          'Sign Up',
          style: GoogleFonts.orbitron(
            color: Colors.red[300],
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class LavaBackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final Random random = Random();

  LavaBackgroundPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color.fromARGB(255, 15, 15, 15));

    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFE53935), Color(0xFFB71C1C), Colors.transparent],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 100))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20 + (animation.value * 10));

    final crackPaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    _drawCrack(canvas, size, crackPaint, glowPaint, seed: 1);
    _drawCrack(canvas, size, crackPaint, glowPaint, seed: 2);
    _drawCrack(canvas, size, crackPaint, glowPaint, seed: 3);
  }

  void _drawCrack(Canvas canvas, Size size, Paint crackPaint, Paint glowPaint, {required int seed}) {
    final random = Random(seed);
    Path path = Path();
    path.moveTo(random.nextDouble() * size.width, -5);

    for (double y = 0; y < size.height + 50; y += 20) {
      path.lineTo(
        path.getBounds().right + (random.nextDouble() * 40 - 20),
        y,
      );
    }

    canvas.drawPath(path, glowPaint..strokeWidth = 10 + (random.nextDouble() * 10));
    canvas.drawPath(path, crackPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}