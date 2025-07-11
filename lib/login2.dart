import 'package:flutter/material.dart';



class SixthPage extends StatefulWidget {
  const SixthPage({super.key});

  @override
  State<SixthPage> createState() => _SixthPageState();
}


class _SixthPageState extends State<SixthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background shapes
          Positioned(
            top: -50,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.pinkAccent.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.orangeAccent, Colors.pinkAccent],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'LOGO',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: <Widget>[
                              isLogin ? _buildLoginForm() : _buildSignupForm(),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isLogin = !isLogin;
                                  });
                                },
                                child: Text(
                                  isLogin ? "Don't have an account? Sign Up" : "Already have an account? Log In",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Social Media Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          // Handle button tap for Google
                        },
                        child: Image.asset(
                          'assets/images/google.png',
                          height: 40.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle button tap for Facebook
                        },
                        child: Image.asset(
                          'assets/images/facebook.png',
                          height: 40.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle button tap for Twitter
                        },
                        child: Image.asset(
                          'assets/images/twitter.png',
                          height: 40.0,
                        ),
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
        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Colors.pink, Colors.orangeAccent],
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
              colors: [Colors.pink, Colors.orangeAccent],
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

  Widget _buildTextField(IconData icon, String hint, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white24,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
