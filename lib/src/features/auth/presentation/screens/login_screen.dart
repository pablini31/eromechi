import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../application/login_cubit.dart';
import '../../application/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const Scaffold(
        body: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  
  bool _isPasswordObscured = true;
  bool _emailHasFocus = false;
  bool _passwordHasFocus = false;
  
  late AnimationController _shakeController;
  late AnimationController _successController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _successController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _emailFocusNode.addListener(() {
      setState(() => _emailHasFocus = _emailFocusNode.hasFocus);
    });
    
    _passwordFocusNode.addListener(() {
      setState(() => _passwordHasFocus = _passwordFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _shakeController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Stack(
      children: [
        // Fondo con gradiente
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF0A0E27),
                      const Color(0xFF1a1f3a),
                      const Color(0xFF0F1419),
                    ]
                  : [
                      const Color(0xFF1A1D29),
                      const Color(0xFF2D3142),
                      const Color(0xFF1F2937),
                    ],
            ),
          ),
        ),
        // Estrellas animadas
        _AnimatedStarryBackground(size: size),
        // Contenido del login
        SafeArea(
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              HapticFeedback.mediumImpact();
              _successController.forward(from: 0);
              _showSuccessOverlay(context);
            } else if (state is LoginFailure) {
              HapticFeedback.heavyImpact();
              _shakeController.forward(from: 0);
              _showErrorOverlay(context, state.error);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
                vertical: 10,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo con efecto glassmorphism
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo_app.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Título
                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'Bienvenido de vuelta',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    FadeInDown(
                      delay: const Duration(milliseconds: 300),
                      child: Text(
                        'Inicia sesión para continuar',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Contenedor principal con glassmorphism
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 450),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2433).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 40,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _buildEmailField(isDark),
                            const SizedBox(height: 16),
                            _buildPasswordField(isDark),
                            const SizedBox(height: 12),
                            _buildRememberMeRow(isDark),
                            const SizedBox(height: 24),
                            _buildLoginButton(context, isDark),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Footer con link de registro
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿No tienes cuenta? ',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to sign up
                            },
                            child: Text(
                              'Regístrate aquí',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ),
      ],
    );
  }

  Widget _buildEmailField(bool isDark) {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final sineValue = math.sin(_shakeController.value * math.pi * 3);
        return Transform.translate(
          offset: Offset(sineValue * 10, 0),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: _emailHasFocus
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: TextFormField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            labelStyle: GoogleFonts.inter(
              color: _emailHasFocus
                  ? const Color(0xFF60A5FA)
                  : Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.email_rounded,
              color: _emailHasFocus
                  ? const Color(0xFF60A5FA)
                  : Colors.white.withOpacity(0.4),
              size: 22,
            ),
            filled: true,
            fillColor: const Color(0xFF2A2F3D).withOpacity(0.6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.15),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF60A5FA),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 2,
              ),
            ),
            errorStyle: GoogleFonts.inter(
              color: const Color(0xFFEF4444),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu correo';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Correo inválido';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildPasswordField(bool isDark) {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final sineValue = math.sin(_shakeController.value * math.pi * 3);
        return Transform.translate(
          offset: Offset(sineValue * 10, 0),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: _passwordHasFocus
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          obscureText: _isPasswordObscured,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: 'Contraseña',
            labelStyle: GoogleFonts.inter(
              color: _passwordHasFocus
                  ? const Color(0xFF60A5FA)
                  : Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.lock_rounded,
              color: _passwordHasFocus
                  ? const Color(0xFF60A5FA)
                  : Colors.white.withOpacity(0.4),
              size: 22,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordObscured
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: Colors.white.withOpacity(0.7),
                size: 24,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordObscured = !_isPasswordObscured;
                });
              },
            ),
            filled: true,
            fillColor: const Color(0xFF2A2F3D).withOpacity(0.4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.15),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF60A5FA),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 2,
              ),
            ),
            errorStyle: GoogleFonts.inter(
              color: const Color(0xFFEF4444),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu contraseña';
            }
            if (value.length < 6) {
              return 'Mínimo 6 caracteres';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildRememberMeRow(bool isDark) {
    return Column(
      children: [
        BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                    value: state.isRememberMeChecked,
                    onChanged: (value) {
                      context.read<LoginCubit>().toggleRememberMe(value ?? false);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    fillColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xFF60A5FA);
                      }
                      return Colors.transparent;
                    }),
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Recordarme',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              // Navigate to forgot password
            },
            child: Text(
              '¿Olvidaste tu contraseña?',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF60A5FA),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, bool isDark) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isLoading
                  ? [
                      const Color(0xFF4B5563),
                      const Color(0xFF374151),
                    ]
                  : [
                      const Color(0xFF3B82F6),
                      const Color(0xFF2563EB),
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: isLoading 
                    ? Colors.black.withOpacity(0.2)
                    : const Color(0xFF3B82F6).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              // Efecto de iluminación interior
              BoxShadow(
                color: isLoading
                    ? Colors.transparent
                    : const Color(0xFF60A5FA).withOpacity(0.6),
                blurRadius: 30,
                offset: const Offset(0, 0),
                spreadRadius: -5,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        HapticFeedback.mediumImpact();
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        context.read<LoginCubit>().login(email, password);
                      } else {
                        _shakeController.forward(from: 0);
                        HapticFeedback.heavyImpact();
                      }
                    },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  // Efecto de brillo desde el centro
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5,
                    colors: isLoading
                        ? [
                            Colors.transparent,
                            Colors.transparent,
                          ]
                        : [
                            Colors.white.withOpacity(0.15),
                            Colors.transparent,
                          ],
                  ),
                ),
                child: Center(
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Iniciando sesión...',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'INICIAR SESIÓN',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSuccessOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => ScaleTransition(
        scale: CurvedAnimation(
          parent: AnimationController(
            vsync: Navigator.of(context),
            duration: const Duration(milliseconds: 400),
          )..forward(),
          curve: Curves.elasticOut,
        ),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4CAF50),
                  Color(0xFF45B649),
                  Color(0xFF2E7D32),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 1500),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  '¡ÉXITO!',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Has iniciado sesión correctamente',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _showErrorOverlay(BuildContext context, String error) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => ElasticIn(
        duration: const Duration(milliseconds: 500),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFEE5A6F),
                  Color(0xFFC92A2A),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B6B).withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BounceInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_rounded,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '¡OOPS!',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF6B6B),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'INTENTAR DE NUEVO',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget de fondo animado con estrellas
class _AnimatedStarryBackground extends StatefulWidget {
  final Size size;
  
  const _AnimatedStarryBackground({required this.size});

  @override
  State<_AnimatedStarryBackground> createState() => _AnimatedStarryBackgroundState();
}

class _AnimatedStarryBackgroundState extends State<_AnimatedStarryBackground>
    with TickerProviderStateMixin {
  late List<Star> stars;
  late List<ShootingStar> shootingStars;
  late AnimationController _twinkleController;
  late AnimationController _shootingStarController;

  @override
  void initState() {
    super.initState();
    
    // Generar estrellas estáticas
    stars = List.generate(100, (index) {
      return Star(
        x: math.Random().nextDouble() * widget.size.width,
        y: math.Random().nextDouble() * widget.size.height,
        size: math.Random().nextDouble() * 2 + 0.5,
        opacity: math.Random().nextDouble() * 0.5 + 0.3,
      );
    });

    // Controlador para el parpadeo de estrellas
    _twinkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Controlador para estrellas fugaces
    _shootingStarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _shootingStarController.addListener(() {
      if (_shootingStarController.value == 0) {
        _generateShootingStars();
      }
    });

    _generateShootingStars();
  }

  void _generateShootingStars() {
    shootingStars = List.generate(2, (index) {
      return ShootingStar(
        startX: math.Random().nextDouble() * widget.size.width,
        startY: math.Random().nextDouble() * widget.size.height * 0.3,
        length: math.Random().nextDouble() * 80 + 60,
        angle: math.Random().nextDouble() * 0.5 + 0.3,
        delay: math.Random().nextDouble() * 0.5,
      );
    });
  }

  @override
  void dispose() {
    _twinkleController.dispose();
    _shootingStarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_twinkleController, _shootingStarController]),
      builder: (context, child) {
        return CustomPaint(
          size: widget.size,
          painter: StarryBackgroundPainter(
            stars: stars,
            shootingStars: shootingStars,
            twinkleValue: _twinkleController.value,
            shootingStarProgress: _shootingStarController.value,
          ),
        );
      },
    );
  }
}

class Star {
  final double x;
  final double y;
  final double size;
  final double opacity;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
  });
}

class ShootingStar {
  final double startX;
  final double startY;
  final double length;
  final double angle;
  final double delay;

  ShootingStar({
    required this.startX,
    required this.startY,
    required this.length,
    required this.angle,
    required this.delay,
  });
}

class StarryBackgroundPainter extends CustomPainter {
  final List<Star> stars;
  final List<ShootingStar> shootingStars;
  final double twinkleValue;
  final double shootingStarProgress;

  StarryBackgroundPainter({
    required this.stars,
    required this.shootingStars,
    required this.twinkleValue,
    required this.shootingStarProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Pintar estrellas estáticas con parpadeo
    final starPaint = Paint()..style = PaintingStyle.fill;

    for (var star in stars) {
      final twinkle = math.sin(twinkleValue * math.pi * 2 + star.x) * 0.3 + 0.7;
      starPaint.color = Colors.white.withOpacity(star.opacity * twinkle);
      
      // Estrellas con forma de círculo
      canvas.drawCircle(
        Offset(star.x, star.y),
        star.size,
        starPaint,
      );
      
      // Agregar brillo a algunas estrellas
      if (star.size > 1.5) {
        starPaint.color = Colors.white.withOpacity(star.opacity * twinkle * 0.3);
        canvas.drawCircle(
          Offset(star.x, star.y),
          star.size * 2,
          starPaint,
        );
      }
    }

    // Pintar estrellas fugaces
    final shootingStarPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var shootingStar in shootingStars) {
      final adjustedProgress = (shootingStarProgress - shootingStar.delay).clamp(0.0, 1.0);
      
      if (adjustedProgress > 0 && adjustedProgress < 0.8) {
        final startX = shootingStar.startX + (adjustedProgress * 200 * math.cos(shootingStar.angle));
        final startY = shootingStar.startY + (adjustedProgress * 200 * math.sin(shootingStar.angle));
        
        final endX = startX - shootingStar.length * math.cos(shootingStar.angle);
        final endY = startY - shootingStar.length * math.sin(shootingStar.angle);

        // Gradiente para la estrella fugaz
        final opacity = (1 - adjustedProgress) * 0.8;
        
        shootingStarPaint.shader = LinearGradient(
          colors: [
            Colors.white.withOpacity(opacity),
            Colors.blue.withOpacity(opacity * 0.5),
            Colors.transparent,
          ],
        ).createShader(Rect.fromPoints(
          Offset(startX, startY),
          Offset(endX, endY),
        ));
        
        shootingStarPaint.strokeWidth = 2;
        
        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          shootingStarPaint,
        );
        
        // Punto brillante al inicio
        final glowPaint = Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(Offset(startX, startY), 3, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(StarryBackgroundPainter oldDelegate) => true;
}
