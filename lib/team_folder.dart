import 'package:octapreview/project.dart';
import 'package:octapreview/second.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamFolderPage extends StatefulWidget {
  const TeamFolderPage({super.key});

  @override
  State<TeamFolderPage> createState() => _TeamFolderPageState();
}

Future<void> _navigateToSecondPage(BuildContext context) async {
  String? username = '';
  String? password = '';

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _AuthenticationDialog(
        onUsernameChanged: (value) => username = value,
        onPasswordChanged: (value) => password = value,
        onLoginPressed: () {
          if (username == 'devil' && password == 'devil') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid credentials. Please try again.'),
              ),
            );
          }
        },
      );
    },
  );
}

class _TeamFolderPageState extends State<TeamFolderPage> {
  double availableScreenWidth = 0;
  int selectedIndex = 0;
  bool isSearchFieldVisible = false;

  @override
  Widget build(BuildContext context) {
    availableScreenWidth = MediaQuery.of(context).size.width - 50;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
            ),
            child: Stack(
              children: [
                const Positioned(
                  left: 30,
                  bottom: 30,
                  child: Text(
                    "Test App",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Positioned(
                  left: 35,
                  bottom: 15, // Position at the bottom
                  child: Text(
                    "testing..",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearchFieldVisible = false;
                    });
                  },
                ),
                Stack(
                  children: [
                    Positioned(
                      bottom: 25,
                      right: 30,
                      child: Visibility(
                        visible: !isSearchFieldVisible,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(.1),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isSearchFieldVisible = true;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Adding some space between the buttons
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(.1),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.notifications,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isSearchFieldVisible) // Conditionally render the search field
                      Positioned(
                        top: 50, // Adjust as needed
                        right: 30,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          width: 250, // Adjust the width as needed
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: TextField(
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: 'Search...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    isSearchFieldVisible = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Storage ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "1.9GB/2TB",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Get More",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                buildFileSizeChart("Sources", Colors.pink, .3),
                const SizedBox(
                  width: 2,
                ),
                buildFileSizeChart("Docs", Colors.lightBlueAccent, .25),
                const SizedBox(
                  width: 2,
                ),
                buildFileSizeChart("Images", Colors.yellow, .20),
                const SizedBox(
                  width: 2,
                ),
                buildFileSizeChart("Others", Colors.grey, .23),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Divider(
            height: 20,
          ),
          // SizedBox(height: 1, ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearchFieldVisible = false;
                      });
                    },
                    child: Container(

                      child: const Text(
                        "Cloud",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SecondPage()),
                            );
                          },
                          child: buildFileColumn('icon1', 'Grow'),
                        ),
                        SizedBox(width: availableScreenWidth * 0.03),
                        InkWell(
                          onTap: () async {
                            const url = 'https://play.google.com/store/games?hl=en&pli=1';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: buildFileColumn('icon5', 'Store'),
                        ),
                        SizedBox(width: availableScreenWidth * 0.03),

                        InkWell(
                          onTap: () async {
                            const url2 = 'https://photos.google.com/?pli=1';
                            if (await canLaunch(url2)) {
                              await launch(url2);
                            } else {
                              throw 'Could not launch $url2';
                            }
                          },
                          child: buildFileColumn('icon3', 'Photos'),
                        ),
                        SizedBox(width: availableScreenWidth * 0.03),
                        buildFileColumn('icon6', 'Pie'),
                        SizedBox(width: availableScreenWidth * 0.03),
                        buildFileColumn('icon4', 'Kitty'),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 60,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Projects",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Create new",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  buildProjectRow("ChatBox", true, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProjectPage()));
                  }),
                  buildProjectRow("TimeNote", false, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProjectPage()));
                  }),
                  buildProjectRow("Saves", true, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProjectPage()));
                  }),
                  buildProjectRow("Other", false, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProjectPage()));
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
          BoxShadow(blurRadius: 1, spreadRadius: 7, color: Colors.white)
        ]),
        child: FloatingActionButton(
          onPressed: () {
            _navigateToSecondPage(context);
          },

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const SecondPage()),
          // );

          backgroundColor: Colors.blue,
          // You can set your desired background color
          shape: const CircleBorder(),
          // Ensure the shape is circular
          elevation: 5.0,
          // Adjust elevation as needed
          highlightElevation: 10.0,
          // Adjust highlight elevation as needed
          splashColor: Colors.white,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ), // Optional: Set a splash color
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          currentIndex: selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.blue,
          // Color for selected item
          unselectedItemColor: Colors.grey,
          // Color for unselected items
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              label: 'Time',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: 'Folder',
            ),
          ]),
    );
  }

  // Widget buildProjectRow(String folderName) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.of(context).push(
  //         MaterialPageRoute<void>(
  //           builder: (BuildContext context) => ProjectPage(folderName: folderName),
  //         ),
  //       );
  //     },
  Container buildProjectRow(
      String folderName, bool showAlert, Function() onTap) {
    Color containerColor =
        showAlert ? Colors.blueAccent : Colors.pink; // Default container color
    Color textColor =
        showAlert ? Colors.red : Colors.yellow; // Default text color

    return Container(
      child: GestureDetector(
        onTap: () {
          onTap(); // Call the onTap function
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: containerColor, // Use containerColor here
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.folder,
                      color: Colors.blue[200],
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      folderName,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor, // Use textColor here
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //String extension
  buildFileColumn(String image, String filename) {
    return Column(
      children: [
        Container(
          width: availableScreenWidth * .31,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          // Reduce padding for better space utilization
          height: 110,
          // Increased height for the image container

          child: Image.asset(
            'assets/images/$image.jpg',
            fit: BoxFit.cover, // Adjusts the image to cover the container
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              text: filename,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              children: const [
                TextSpan(
                  // text: extension,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column buildFileSizeChart(
      String title, Color? color, double widthPercentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: availableScreenWidth * widthPercentage,
          height: 4,
          color: color,
        ),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ],
    );
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
      title:
          const Text('Authentication Required', style: TextStyle(color: Colors.red)),
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
