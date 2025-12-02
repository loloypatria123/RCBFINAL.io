import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/animated_robot_logo.dart';
import 'sign_in_page.dart';

class PasswordResetVerificationPage extends StatefulWidget {
  final String email;

  const PasswordResetVerificationPage({
    super.key,
    required this.email,
  });

  @override
  State<PasswordResetVerificationPage> createState() =>
      _PasswordResetVerificationPageState();
}

class _PasswordResetVerificationPageState
    extends State<PasswordResetVerificationPage> {
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  int _currentStep = 1; // 1: Enter code, 2: Set new password

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                
                // Robot Logo with Shield Icon
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
                          color: _currentStep == 1
                              ? AppColors.warningColor
                              : AppColors.successColor,
                          border: Border.all(
                            color: AppColors.neutralDark,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          _currentStep == 1
                              ? Icons.verified_user_outlined
                              : Icons.check_circle_outline,
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
                  _currentStep == 1 ? 'Verify Your Identity' : 'Set New Password',
                  style: GoogleFonts.orbitron(
                    fontSize: 26,
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
                    _currentStep == 1
                        ? 'We\'ve sent a verification code to\n${widget.email}'
                        : 'Password reset link will be sent to your email',
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
                
                // Step Content
                if (_currentStep == 1) ...[
                  _buildCodeInput(),
                  const SizedBox(height: 24),
                  _buildVerifyButton(),
                  const SizedBox(height: 24),
                  _buildResendCodeSection(),
                ] else ...[
                  _buildSuccessInfo(),
                  const SizedBox(height: 32),
                  _buildContinueButton(),
                ],
                
                const SizedBox(height: 32),
                
                // Progress Indicator
                _buildProgressIndicator(),
                
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInput() {
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
        controller: _codeController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: GoogleFonts.orbitron(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 8,
        ),
        maxLength: 6,
        decoration: InputDecoration(
          hintText: '000000',
          hintStyle: GoogleFonts.orbitron(
            color: Colors.grey[700],
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          ),
          counterText: '',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.successColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.successColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.successColor.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.mark_email_read_rounded,
              color: AppColors.successColor,
              size: 48,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Verification Successful!',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'A password reset link has been sent to your email address. Please check your inbox and follow the instructions to complete your password reset.',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[300],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryDarkBlue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.accentYellow,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'The link expires in 1 hour. Check spam folder if you don\'t see it.',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey[400],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
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
        onPressed: _isLoading ? null : _handleVerifyCode,
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
            : Text(
                'VERIFY CODE',
                style: GoogleFonts.orbitron(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryDarkBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const SignInPage(),
            ),
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GO TO SIGN IN',
              style: GoogleFonts.orbitron(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildResendCodeSection() {
    return Column(
      children: [
        Text(
          'Didn\'t receive the code?',
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _isResending ? null : _handleResendCode,
          child: Text(
            _isResending ? 'Sending...' : 'Resend Code',
            style: GoogleFonts.roboto(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _isResending
                  ? Colors.grey[600]
                  : AppColors.accentYellow,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildProgressDot(1),
        Container(
          width: 40,
          height: 2,
          color: _currentStep > 1
              ? AppColors.successColor
              : Colors.grey[800],
        ),
        _buildProgressDot(2),
      ],
    );
  }

  Widget _buildProgressDot(int step) {
    final isActive = step == _currentStep;
    final isCompleted = step < _currentStep;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? AppColors.primaryBlue
            : (isCompleted ? AppColors.successColor : Colors.grey[800]),
        border: Border.all(
          color: isActive
              ? AppColors.primaryLightBlue
              : (isCompleted ? AppColors.successColor : Colors.grey[700]!),
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : Text(
                step.toString(),
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _handleVerifyCode() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      _showErrorSnackBar('Please enter the verification code');
      return;
    }

    if (code.length != 6) {
      _showErrorSnackBar('Verification code must be 6 digits');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.verifyPasswordResetCode(
        widget.email,
        code,
      );

      setState(() => _isLoading = false);

      if (success && mounted) {
        // After verification, send password reset email
        final resetSuccess = await authProvider.completePasswordReset(
          widget.email,
          '', // Password not needed for email-based reset
        );
        
        if (resetSuccess && mounted) {
          setState(() => _currentStep = 2);
          _showSuccessSnackBar('Password reset email sent! Check your inbox.');
        } else if (mounted) {
          _showErrorSnackBar(
            authProvider.errorMessage ?? 'Failed to send reset email',
          );
        }
      } else if (mounted) {
        _showErrorSnackBar(
          authProvider.errorMessage ?? 'Invalid verification code',
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('An error occurred. Please try again.');
    }
  }


  Future<void> _handleResendCode() async {
    setState(() => _isResending = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.sendPasswordResetCode(widget.email);

      setState(() => _isResending = false);

      if (success && mounted) {
        _showSuccessSnackBar('Verification code sent successfully!');
      } else if (mounted) {
        _showErrorSnackBar('Failed to resend code. Please try again.');
      }
    } catch (e) {
      setState(() => _isResending = false);
      _showErrorSnackBar('An error occurred. Please try again.');
    }
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
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
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

