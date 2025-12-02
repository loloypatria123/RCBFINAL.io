import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/animated_robot_logo.dart';
import 'password_reset_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.neutralDark,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.08),
                
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.primaryLightBlue,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Robot Logo with Lock Icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryDarkBlue.withOpacity(0.3),
                        border: Border.all(
                          color: AppColors.primaryLightBlue.withOpacity(0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const AnimatedRobotLogo(
                        size: 70,
                        enableCursorTracking: true,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.warningColor,
                          border: Border.all(
                            color: AppColors.neutralDark,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_reset_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Title
                Text(
                  'Forgot Password?',
                  style: GoogleFonts.orbitron(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'No worries! Enter your email address and we\'ll send you a verification code to reset your password.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[400],
                      height: 1.5,
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Email Input
                _buildEmailField(),
                
                const SizedBox(height: 32),
                
                // Send Code Button
                _buildSendCodeButton(),
                
                const SizedBox(height: 24),
                
                // Back to Sign In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back_rounded,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Back to Sign In',
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryLightBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Security Notice
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDarkBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: AppColors.successColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your security is our priority. We\'ll never ask for your password via email.',
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Colors.grey[400],
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryDarkBlue,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Enter your email address',
          hintStyle: GoogleFonts.roboto(
            color: Colors.grey[600],
            fontSize: 15,
          ),
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: AppColors.primaryLightBlue,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSendCodeButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: _isLoading
            ? null
            : const LinearGradient(
                colors: [
                  AppColors.primaryBlue,
                  AppColors.primaryDarkBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: _isLoading ? Colors.grey[700] : null,
        boxShadow: _isLoading
            ? null
            : [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSendCode,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.accentYellow,
                  ),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'SEND VERIFICATION CODE',
                    style: GoogleFonts.orbitron(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleSendCode() async {
    final email = _emailController.text.trim();

    // Validation
    if (email.isEmpty) {
      _showErrorSnackBar('Please enter your email address');
      return;
    }

    if (!_isValidEmail(email)) {
      _showErrorSnackBar('Please enter a valid email address');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.sendPasswordResetCode(email);

      setState(() => _isLoading = false);

      if (success && mounted) {
        // Navigate to verification page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordResetVerificationPage(
              email: email,
            ),
          ),
        );
      } else if (mounted) {
        _showErrorSnackBar(
          authProvider.errorMessage ?? 'Failed to send verification code',
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('An error occurred. Please try again.');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

