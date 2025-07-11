import 'package:flutter/material.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> images = [
    'https://c.tenor.com/th0OkZ3n3c0AAAAd/tenor.gif',
    'https://i.pinimg.com/564x/97/fc/09/97fc09b184ed4a155b65c97220b5616c.jpg',
  ];
  int currentIndex = -1; // Initialize to -1 to indicate no image initially

  List<String> games = [
    'https://media.tenor.com/05gi6_LhqHsAAAAM/kiss.gif',
    'https://media.tenor.com/05gi6_LhqHsAAAAM/kiss.gif',
  ];
  int currentIndexGames = -1; // Initialize to -1 to indicate no image initially

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {}); // Update the UI when text changes
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changeImage() {
    setState(() {
      currentIndexGames = -1;
      currentIndex = (currentIndex + 1) % images.length;
    });
  }

  void _changeGame() {
    setState(() {
      currentIndex = -1; // Reset currentIndex when changing to game images
      currentIndexGames = (currentIndexGames + 1) % games.length;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset(
              'assets/images/fluttertest.jpg', 
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text(
              'Locked',
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.red,
          ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black87,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            children: [
              if (currentIndex != -1 || currentIndexGames != -1)
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                  ),
                  child: Image.network(
                    currentIndex != -1 ? images[currentIndex] : games[currentIndexGames],
                    height: 100,
                    width: 100,
                  ),
                ),
              ListTile(
                title: const Text('Item 1', style: TextStyle(color: Colors.red)),
                onTap: () {
                  // Update UI to reflect item 1 selected
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,

                      style: const TextStyle(color: Colors.transparent),
                      decoration: const InputDecoration(
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.toLowerCase() == 'images') {
                        _changeImage();
                      } else if (_controller.text.toLowerCase() == 'games') {
                        _changeGame();
                      } else {
                        // If no valid command is entered, reset indices to -1
                        currentIndex = -1;
                        currentIndexGames = -1;
                      }
                      setState(() {}); // Update UI
                    },
                    child: const Text('Execute'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
