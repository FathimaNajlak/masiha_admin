// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:masiha_admin/utils/consts/colors.dart';
// import '../../../business_logic/registration/auth_bloc.dart';
// import '../../../business_logic/registration/auth_event.dart';
// import '../../../business_logic/registration/auth_states.dart';

// class RegisterationScreen extends StatefulWidget {
//   const RegisterationScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _RegisterationScreenState createState() => _RegisterationScreenState();
// }

// class _RegisterationScreenState extends State<RegisterationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isLogin = true;
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _usernameController =
//       TextEditingController(); // New username controller

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _usernameController.dispose(); // Dispose username controller
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Center(
//         child: ScrollConfiguration(
//           behavior: NoGlowScrollBehavior(), // Custom ScrollBehavior
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(vertical: 20.0), // Add padding
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Logo Space
//                 Image.asset(
//                   'assets/images/logoo.png',
//                   height: 250,
//                   width: 250,
//                 ),

//                 // Login/Signup Container
//                 Container(
//                   width: 500,
//                   padding: const EdgeInsets.all(30),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.4),
//                         spreadRadius: 2,
//                         blurRadius: 8,
//                       )
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Top Header with Switch
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             _isLogin ? 'Login' : 'Sign Up',
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.darkcolor,
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 _isLogin = !_isLogin;
//                               });
//                             },
//                             child: Text(
//                               _isLogin ? 'Sign Up' : 'Login',
//                               style: const TextStyle(color: Colors.blue),
//                             ),
//                           ),
//                         ],
//                       ),

//                       // Welcome Text
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10.0),
//                         child: Text(
//                           _isLogin
//                               ? 'Welcome Back! Please login to continue.'
//                               : 'Create a new account',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ),

//                       // Form
//                       Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             // Username field for signup
//                             if (!_isLogin) ...[
//                               TextFormField(
//                                 controller: _usernameController,
//                                 decoration: InputDecoration(
//                                   labelText: 'Username',
//                                   prefixIcon: const Icon(Icons.person_outline),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter a username';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               const SizedBox(height: 10),
//                             ],

//                             // Email field
//                             TextFormField(
//                               controller: _emailController,
//                               decoration: InputDecoration(
//                                 labelText: 'Email Address',
//                                 prefixIcon: const Icon(Icons.email_outlined),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your email';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 10),

//                             // Password field
//                             TextFormField(
//                               controller: _passwordController,
//                               obscureText: true,
//                               decoration: InputDecoration(
//                                 labelText: 'Password',
//                                 prefixIcon: const Icon(Icons.lock_outline),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your password';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 15),

//                             // Login/Signup Button
//                             BlocBuilder<AuthBloc, AuthState>(
//                               builder: (context, state) {
//                                 if (state is AuthLoadingState) {
//                                   return const CircularProgressIndicator();
//                                 }
//                                 return Column(
//                                   children: [
//                                     ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                         minimumSize:
//                                             const Size(double.infinity, 50),
//                                         backgroundColor: AppColors.darkcolor,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                       ),
//                                       onPressed: () {
//                                         if (_formKey.currentState!.validate()) {
//                                           final authBloc =
//                                               context.read<AuthBloc>();
//                                           _isLogin
//                                               ? authBloc.add(LoginEvent(
//                                                   email: _emailController.text,
//                                                   password:
//                                                       _passwordController.text,
//                                                 ))
//                                               : authBloc.add(SignupEvent(
//                                                   email: _emailController.text,
//                                                   password:
//                                                       _passwordController.text,
//                                                   username:
//                                                       _usernameController.text,
//                                                 ));
//                                         }
//                                       },
//                                       child: Text(
//                                         _isLogin ? 'Login' : 'Sign Up',
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 20),

//                                     // Google Sign-In Button
//                                     if (_isLogin)
//                                       ElevatedButton.icon(
//                                         icon: Image.asset(
//                                           'assets/images/google.png',
//                                           height: 24,
//                                           width: 24,
//                                         ),
//                                         label:
//                                             const Text('Sign in with Google'),
//                                         style: ElevatedButton.styleFrom(
//                                           minimumSize:
//                                               const Size(double.infinity, 50),
//                                           backgroundColor: Colors.white,
//                                           foregroundColor: Colors.black,
//                                           side: BorderSide(
//                                               color: Colors.grey[300]!),
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                         ),
//                                         onPressed: () {
//                                           final authBloc =
//                                               context.read<AuthBloc>();
//                                           authBloc.add(GoogleSignInEvent());
//                                         },
//                                       ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class NoGlowScrollBehavior extends ScrollBehavior {
//   @override
//   Widget buildOverscrollIndicator(
//       BuildContext context, Widget child, ScrollableDetails details) {
//     return child; // Simply return the child to disable the glow.
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masiha_admin/utils/consts/colors.dart';
import '../../../business_logic/registration/auth_bloc.dart';
import '../../../business_logic/registration/auth_event.dart';
import '../../../business_logic/registration/auth_states.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(), // Custom ScrollBehavior
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Space
                Image.asset(
                  'assets/images/logoo.png',
                  height: 250,
                  width: 250,
                ),

                // Login Container
                Container(
                  width: 500,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Text
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkcolor,
                        ),
                      ),

                      // Welcome Text
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Welcome Back! Please login to continue.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),

                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Email field
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),

                            // Password field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),

                            // Login Button
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is AuthLoadingState) {
                                  return const CircularProgressIndicator();
                                }
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    backgroundColor: AppColors.darkcolor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final authBloc = context.read<AuthBloc>();
                                      authBloc.add(LoginEvent(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ));
                                    }
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Google Sign-In Button
                            ElevatedButton.icon(
                              icon: Image.asset(
                                'assets/images/google.png',
                                height: 24,
                                width: 24,
                              ),
                              label: const Text('Sign in with Google'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                final authBloc = context.read<AuthBloc>();
                                authBloc.add(GoogleSignInEvent());
                              },
                            ),
                          ],
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
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Simply return the child to disable the glow.
  }
}
