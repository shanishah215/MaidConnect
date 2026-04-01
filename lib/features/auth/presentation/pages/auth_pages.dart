import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/router/auth_state.dart';
import '../../../../shared/presentation/widgets/placeholder_page.dart';
import '../../../../shared/presentation/widgets/responsive_navigation_shell.dart';

class AuthPages {
  AuthPages._();

  static final List<NavItem> _publicNav = <NavItem>[
    const NavItem(label: 'Home', route: AppRoutes.home),
    const NavItem(label: 'Client Login', route: AppRoutes.clientLogin),
    const NavItem(label: 'Client Register', route: AppRoutes.clientRegister),
    const NavItem(label: 'Admin Login', route: AppRoutes.adminLogin),
  ];

  static Widget clientLogin() => _ClientLoginPage(navItems: _publicNav);

  static Widget clientRegister() =>
      PlaceholderPage(title: 'Client Register', navItems: _publicNav);

  static Widget adminLogin() => PlaceholderPage(
    title: 'Admin Login',
    navItems: _publicNav,
    actions: [
      Builder(
        builder: (context) => FilledButton(
          onPressed: () {
            AuthState.instance.signInAdmin();
            Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
          },
          child: const Text('Sign In as Admin + Go'),
        ),
      ),
    ],
  );
}

class _ClientLoginPage extends StatefulWidget {
  const _ClientLoginPage({required this.navItems});
  final List<NavItem> navItems;

  @override
  State<_ClientLoginPage> createState() => _ClientLoginPageState();
}

class _ClientLoginPageState extends State<_ClientLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveNavigationShell(
      title: 'Client Login',
      navItems: widget.navItems,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign in to your client portal',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Minimum 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Demo only: credentials are not validated against a backend yet.',
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          AuthState.instance.signInClient();
                          Navigator.pushNamed(
                            context,
                            AppRoutes.clientDashboard,
                          );
                        },
                        child: const Text('Sign in'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
