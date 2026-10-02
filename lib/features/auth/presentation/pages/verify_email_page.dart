import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _verifyEmail();
  }

  void _verifyEmail() async {
    setState(() => _isVerifying = true);
    final uri = Uri.base;
    final token = uri.queryParameters['token'];
    if (token != null) {
      context.read<AuthBloc>().add(AuthVerifyEmailRequested(token: token));
    } else {
      setState(() => _isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthEmailVerified) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email verified successfully!')),
              );
              Future.delayed(const Duration(seconds: 1), () {
                context.go('/login');
              });
            } else if (state is AuthError) {
              setState(() => _isVerifying = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isVerifying) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(
                      'Verifying your email...',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ] else ...[
                    const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 80,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Invalid or expired verification link',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'The verification link is invalid or has expired. Please request a new one.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    AuthButton(
                      text: 'Resend Verification Email',
                      onPressed: () => context.go('/login'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}