import 'package:flutter/material.dart';
import 'third.dart'; // Import the ThirdPage class
import 'fourth.dart'; // Import the ThirdPage class

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool isScreenTouched = false;
  final TextEditingController _messageControllerTab1 = TextEditingController();
  final TextEditingController _messageControllerTab2 = TextEditingController();

  final List<String> savedLinks = []; // List to save provided links
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;
  int genshinIndex = 0;

  List<String> imageUrls = [
    'https://i.pinimg.com/originals/24/5d/e0/245de0f6762408d17b51f333f9a74c57.gif',
    'https://c4.wallpaperflare.com/wallpaper/888/685/94/devil-may-cry-5-games-art-video-game-art-video-games-devil-may-cry-hd-wallpaper-preview.jpg',
    'https://64.media.tumblr.com/437a2529fb5712592e69e4a66d09421f/dae7e5f9d0663bfc-d7/s640x960/fa00da8f109a41c454db264cc32281fe7b054321.gif',
  ];
  List<String> genshinUrls = [
    "https://static1.srcdn.com/wordpress/wp-content/uploads/2023/09/genshin-impact-42-playable-characters-banners-furina-focalors-charlotte.jpg",
    "https://cdn.donmai.us/original/05/f8/05f8177a5ae2f8595b268f8ec6d80839.png",
    "https://cdn.donmai.us/original/05/f8/05f8177a5ae2f8595b268f8ec6d80839.png",
  ];

  Widget _botResponseTab1 = Container();
  Widget _botResponseTab2 = Container();

  Widget _buildImageFromUrl(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
                : null,
          );
        },
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      );
    } else {
      return Image.asset('assets/images/$imageUrl');
    }
  }

  Widget _buildImageFromAssets(String imageName) {
    return Image.asset('assets/customimages/$imageName');
  }

  Widget _simulateBotResponse(String message) {
    if (message == 'devil') {
      String currentUrl = imageUrls[currentIndex];
      currentIndex = (currentIndex + 1) % imageUrls.length;
      return _buildImageFromUrl(currentUrl);
    } else if (message.startsWith('add ')) {
      String imageUrl =
      message.substring(4).trim(); // Get the image URL or name after 'add '
      setState(() {
        savedLinks.add(imageUrl); // Save the provided link
      });
      if (imageUrl.startsWith('http') || imageUrl.endsWith('.gif')) {
        return _buildImageFromUrl(imageUrl); // It's a URL
      } else {
        return _buildImageFromAssets(imageUrl); // It's a local asset
      }
    } else if (message == 'show') {
      return Column(
        children: savedLinks.map((link) {
          if (link.startsWith('http') || link.endsWith('.gif')) {
            return _buildImageFromUrl(link);
          } else {
            return _buildImageFromAssets(link);
          }
        }).toList(),
      );
    } else if (message == 'third') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ThirdPage()),
        );
      });
      return Container(); // Return an empty container as we are navigating to another page
    } else if (message == 'fourth') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FourthPage()),
        );
      });
      return Container(); // Return an empty container as we are navigating to another page
    } else if (message == 'genshin') {
      String genshinUrl = genshinUrls[genshinIndex];
      genshinIndex = (genshinIndex + 1) % genshinUrls.length;
      return _buildImageFromUrl(genshinUrl);
    } else {
      return const Text('');
    }
  }

  void _sendMessageTab1() {
    String message = _messageControllerTab1.text;
    setState(() {
      _botResponseTab1 = _simulateBotResponse(message);
    });
  }

  void _sendMessageTab2() {
    String message = _messageControllerTab2.text;
    setState(() {
      _botResponseTab2 = _simulateBotResponse(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
        backgroundColor: Colors.black87,
        body: TabBarView(
          children: [
            // First Tab (Originally Tab 1)
            GestureDetector(
              onTap: () {
                setState(() {
                  isScreenTouched = false;
                });
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 40,
                        ),
                        child: TextField(
                          onTap: (){
                            isScreenTouched = true;

                          },
                          controller: _messageControllerTab1,
                          cursorColor: Colors.blue,
                          style: const TextStyle(
                            color: Colors.transparent,
                          ),
                          enabled: !isScreenTouched,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 28,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.lightBlueAccent,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _sendMessageTab1,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.yellowAccent,
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 40,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          '',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _botResponseTab1,
                              const SizedBox(height: 20.0),
                              if (savedLinks.isNotEmpty) ...[
                                for (var link in savedLinks)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    // Add widget for saved links here
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Second Tab (Originally Tab 2)
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 4.0,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  _botResponseTab2, // Assuming _botResponse is already a widget containing images or other content
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 40,
                    ),
                    child: TextField(
                      controller: _messageControllerTab2,
                      cursorColor: Colors.blue,
                      style: const TextStyle(
                        color: Colors.transparent,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 28,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.lightBlueAccent,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _sendMessageTab2,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.yellowAccent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      '',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageControllerTab1.dispose();
    _messageControllerTab2.dispose();
    super.dispose();
  }
}

class _AuthenticationDialog extends StatefulWidget {
  final ValueChanged<String> onUsernameChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onLoginPressed;

  const _AuthenticationDialog({
    required this.onUsernameChanged,
    required this.onPasswordChanged,
    required this.onLoginPressed,
  });

  @override
  __AuthenticationDialogState createState() => __AuthenticationDialogState();
}

class __AuthenticationDialogState extends State<_AuthenticationDialog> {
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _usernameFocused = false;
  bool _passwordFocused = false;

  void _toggleUsernameFocus() {
    setState(() {
      _usernameFocused = !_usernameFocused;
      if (_usernameFocused) {
        _usernameFocusNode.requestFocus();
      } else {
        _usernameFocusNode.unfocus();
      }
    });
  }

  void _togglePasswordFocus() {
    setState(() {
      _passwordFocused = !_passwordFocused;
      if (_passwordFocused) {
        _passwordFocusNode.requestFocus();
      } else {
        _passwordFocusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Authentication Required', style: TextStyle(color: Colors.red)),
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
            child: GestureDetector(
              onTap: _toggleUsernameFocus,
              child: TextField(

                cursorColor: Colors.red,
                focusNode: _usernameFocusNode,
                obscureText: true,
                enableInteractiveSelection: false, // Disable text copying
                onChanged: widget.onUsernameChanged,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.blue,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.lightBlueAccent,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
            child: GestureDetector(
              onTap: _togglePasswordFocus,
              child: TextField(
                style: const TextStyle(color: Colors.transparent),

                cursorColor: Colors.red,
                focusNode: _passwordFocusNode,
                obscureText: true,
                enableInteractiveSelection: false, // Disable text copying
                onChanged: widget.onPasswordChanged,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.yellow,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.lightBlueAccent,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            const Spacer(), // Adds space between Cancel and Login buttons
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: widget.onLoginPressed,
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ],

    );
  }
}


