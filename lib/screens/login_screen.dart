import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../l10n/app_localizations.dart';
import '../services/firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;
  bool _isAppleSignInAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkAppleSignInAvailability();
  }

  void _checkAppleSignInAvailability() async {
    if (!kIsWeb) {
      final isAvailable = await SignInWithApple.isAvailable();
      if (mounted) {
        setState(() => _isAppleSignInAvailable = isAvailable);
      }
    }
  }

  Future<void> _attemptLogin(Future<dynamic> loginMethod) async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final l10n = AppLocalizations.of(context)!;

    try {
      final user = await loginMethod;
      if (mounted) {
        if (user != null) {
          // Показываем сообщение об успехе
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.loginSuccess),
              backgroundColor: Colors.green.shade700,
            ),
          );
          // AuthGate сам перенаправит на главный экран
        } else {
          // Пользователь отменил вход
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.loginCancelled)),
          );
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      // Показываем сообщение об ошибке
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.loginError),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.welcome, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                icon: const Icon(Icons.g_mobiledata),
                label: Text(l10n.signInWithGoogle),
                onPressed: () => _attemptLogin(_firebaseService.signInWithGoogle()),
              ),
              const SizedBox(height: 16),
              if (_isAppleSignInAvailable)
                ElevatedButton.icon(
                  icon: const Icon(Icons.apple),
                  label: Text(l10n.signInWithApple),
                  onPressed: () => _attemptLogin(_firebaseService.signInWithApple()),
                ),
              if (_isAppleSignInAvailable) const SizedBox(height: 16),
              OutlinedButton(
                child: Text(l10n.continueAsGuest),
                onPressed: () => _attemptLogin(_firebaseService.signInAnonymously()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
