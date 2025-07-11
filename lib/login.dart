import 'package:octapreview/second.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: CustomPaint(
              painter: MyPainter(),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Image.asset(
                        'assets/images/icon1.jpg', 
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      isLogin ? _buildLoginForm() : _buildSignupForm(),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin
                              ? "Don't have an account? Sign Up"
                              : "Already have an account? Log In",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _handleGoogleSignIn(context);

                            },
                            child: Image.asset(
                              'assets/images/google.png', // Replace with your image path
                              width: 40,
                              height: 40,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                            },
                            child: Image.asset(
                              'assets/images/facebook.png', // Replace with your image path
                              width: 40,
                              height: 40,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/twitter.png', // Replace with your image path
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: <Widget>[
        _buildTextField(Icons.email, 'Email'),
        const SizedBox(height: 20),
        _buildTextField(Icons.lock, 'Password', obscureText: true),
        const SizedBox(height: 20),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF9F00),
                Color(0xFFFF5722),
              ],
            ),
          ),
          child: const Center(
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm() {
    return Column(
      children: <Widget>[
        _buildTextField(Icons.person, 'Name'),
        const SizedBox(height: 20),
        _buildTextField(Icons.email, 'Email'),
        const SizedBox(height: 20),
        _buildTextField(Icons.lock, 'Password', obscureText: true),
        const SizedBox(height: 20),
        _buildTextField(Icons.lock, 'Confirm Password', obscureText: true),
        const SizedBox(height: 30),
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF9F00),
                Color(0xFFFF5722),
              ],
            ),
          ),
          child: const Center(
            child: Text(
              'Signup',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(IconData icon, String hint,
      {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.black,
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}

void _handleGoogleSignIn(BuildContext context) async {
  // Create a GoogleSignIn instance
  GoogleSignIn googleSignIn = GoogleSignIn();

  // Attempt to sign in
  try {
    await googleSignIn.signIn();
    // If successful, navigate to SixthPage
    Navigator.pushReplacement( // Use pushReplacement to replace current route
      context,
      MaterialPageRoute(builder: (context) => const SecondPage()),
    );
  } catch (error) {
    // Handle sign-in errors
    print('Error signing in with Google: $error');
  }
}


class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFFFFC107);
    Path path = Path();
    path.moveTo(0, size.height * 0.3);
    path.lineTo(size.width * 0.3, 0);
    path.lineTo(size.width * 0.7, size.height);
    path.lineTo(size.width, size.height * 0.7);
    path.lineTo(size.width * 0.3, 0);
    path.close();
    canvas.drawPath(path, paint);
    // Add more paths to create different shapes and colors
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}