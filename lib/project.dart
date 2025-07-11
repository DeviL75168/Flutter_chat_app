import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> with TickerProviderStateMixin {
  int selectedIndex = 0;
  bool isSearchFieldVisible = false;
  List<String> friends = ["anya", "eri", "elis", "rena", "sofia", "alie"];
  List<String> friendImages = ["mia", "mia2", "mia3", "mia4", "mia5", "mia6"];
  List<String?> uploadedIcons = List.filled(6, null);
  List<String?> friendNames = List.filled(6, null);
  List<String> friendUsernames = ["anya123", "eri456", "elis789", "rena333", "sofia888", "alie999"];
  String? userAvatar;
  String? userName;
  String? userBio;
  final TextEditingController searchController = TextEditingController();
  List<String> searchedFriends = [];

  // Animation controllers
  late AnimationController _searchAnimationController;
  late AnimationController _scrollAnimationController;
  late Animation<double> _searchAnimation;

  // Scroll controllers
  final ScrollController _avatarScrollController = ScrollController();
  final ScrollController _listScrollController = ScrollController();

  // For refresh effect
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  // For staggered list effect
  bool _isListVisible = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _searchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );

    _scrollAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Initialize friend names if null
    for (int i = 0; i < friends.length; i++) {
      friendNames[i] ??= friends[i];
    }

    // Simulate loading time for staggered animations
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isListVisible = true;
        });
      }
    });

    // Apply system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _scrollAnimationController.dispose();
    _avatarScrollController.dispose();
    _listScrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshData,
            color: Colors.blue,
            strokeWidth: 3,
            child: CustomScrollView(
              controller: _listScrollController,
              slivers: [
                // App Bar Section
                SliverAppBar(
                  expandedHeight: screenHeight * 0.15,
                  collapsedHeight: kToolbarHeight + (isSearchFieldVisible ? 60 : 0),
                  floating: false,
                  pinned: true,
                  stretch: true, // Add this
                  snap: false, // Add this
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin, // This prevents title from overlapping
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 10), // Adjust padding
                    title: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isSearchFieldVisible
                          ? Container()
                          : Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: const Text(
                                "Friends",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    _buildAnimatedIconButton(Icons.search, () {
                      setState(() {
                        isSearchFieldVisible = !isSearchFieldVisible;
                        if (isSearchFieldVisible) {
                          _searchAnimationController.forward();
                        } else {
                          _searchAnimationController.reverse();
                          searchController.clear();
                          searchedFriends.clear();
                        }
                      });
                    }),
                    const SizedBox(width: 10),
                    _buildAnimatedIconButton(Icons.person_add, _addFriend),
                    const SizedBox(width: 10),
                    _buildAnimatedIconButton(Icons.settings, _goToSettings),
                    const SizedBox(width: 15),
                  ],
                  bottom: isSearchFieldVisible
                      ? PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search friends...',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search, color: Colors.blue),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                searchedFriends.clear();
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchedFriends = friends
                                .where((friend) => friend.toLowerCase().contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    ),
                  )
                      : null,
                ),

                // Avatar List Section
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: screenHeight * 0.18,
                    child: AnimationLimiter(
                      child: ListView.builder(
                        controller: _avatarScrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: _buildAvatar(friends[index], index),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Divider
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.blue.withOpacity(0.5),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                // Friend List Section
                _isListVisible
                    ? SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: AnimationLimiter(
                    child: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final displayIndex = isSearchFieldVisible
                              ? friends.indexOf(searchedFriends[index])
                              : index;
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: _buildFriendRow(displayIndex),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: isSearchFieldVisible
                            ? searchedFriends.length
                            : friends.length,
                      ),
                    ),
                  ),
                )
                    : SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue[400],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: FloatingActionButton(
              onPressed: () {
                _refreshIndicatorKey.currentState?.show();
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.refresh, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedIconButton(IconData icon, VoidCallback onPressed) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(.05),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onPressed,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(String friendName, int index) {
    return GestureDetector(
      onTap: () {
        _showProfile(index);
        HapticFeedback.lightImpact();
      },
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _scrollAnimationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    math.sin(_scrollAnimationController.value * math.pi * 2 + index) * 2,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.8),
                          Colors.grey.withOpacity(0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        splashColor: Colors.blue.withOpacity(0.1),
                        highlightColor: Colors.transparent,
                        onTap: () => _showProfile(index),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Hero(
                            tag: 'friend_avatar_$index',
                            child: CircleAvatar(
                              radius: 34,
                              backgroundColor: Colors.white,
                              backgroundImage: uploadedIcons[index] != null
                                  ? FileImage(File(uploadedIcons[index]!))
                                  : AssetImage('assets/images/${friendImages[index]}.jpg') as ImageProvider,
                              child: uploadedIcons[index] == null && friendImages[index] == null
                                  ? Text(
                                friendName[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    friendName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendRow(int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _showChat(index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.blue.withOpacity(0.1),
            highlightColor: Colors.grey.withOpacity(0.05),
            onTap: () => _showChat(index),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Hero(
                    tag: 'friend_list_$index',
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      backgroundImage: uploadedIcons[index] != null
                          ? FileImage(File(uploadedIcons[index]!))
                          : AssetImage('assets/images/${friendImages[index]}.jpg') as ImageProvider,
                      child: uploadedIcons[index] == null && friendImages[index] == null
                          ? Text(
                        friends[index][0].toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friendNames[index] ?? friends[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          friendUsernames[index],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: index % 2 == 0 ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showProfile(int index) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              contentPadding: EdgeInsets.zero,
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with gradient
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade300, Colors.blue.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Center(
                        child: Hero(
                          tag: 'friend_avatar_$index',
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: uploadedIcons[index] != null
                                ? FileImage(File(uploadedIcons[index]!))
                                : AssetImage('assets/images/${friendImages[index]}.jpg') as ImageProvider,
                            child: uploadedIcons[index] == null && friendImages[index] == null
                                ? Text(
                              friends[index][0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                : null,
                          ),
                        ),
                      ),
                    ),

                    // Profile info
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 500),
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: Text(
                                      friendNames[index] ?? friends[index],
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 5),
                            TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 500),
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Text(
                                    friendUsernames[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 500),
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildProfileStat('Posts', '245'),
                                      _buildProfileStat('Followers', '12.5K'),
                                      _buildProfileStat('Following', '267'),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "About Me",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "I love coding, designing, and creating beautiful user interfaces. "
                                  "Flutter is my passion and I enjoy building amazing apps with it.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _showChat(index);
                              },
                              icon: const Icon(Icons.chat),
                              label: const Text('Message'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(120, 50), // Set minimum size
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.person_outline),
                              label: const Text('View Profile'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(120, 50), // Set minimum size
                                foregroundColor: Colors.blue,
                                side: const BorderSide(color: Colors.blue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
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
      },
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showChat(int index) {
    final TextEditingController messageController = TextEditingController();

    // Sample messages for demo
    List<Map<String, dynamic>> messages = [
      {'text': 'Hey there!', 'isSent': false, 'time': '10:00 AM'},
      {'text': 'Hi! How are you?', 'isSent': true, 'time': '10:02 AM'},
      {'text': 'I\'m good, thanks! What about you?', 'isSent': false, 'time': '10:05 AM'},
      {'text': 'Doing great! Just checking out this awesome app.', 'isSent': true, 'time': '10:07 AM'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              children: [
                // Chat header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Hero(
                            tag: 'friend_list_$index',
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: uploadedIcons[index] != null
                                  ? FileImage(File(uploadedIcons[index]!))
                                  : AssetImage('assets/images/${friendImages[index]}.jpg') as ImageProvider,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friendNames[index] ?? friends[index],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Online now',
                                style: TextStyle(
                                  color: Colors.green[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.video_call, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.call, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Message list
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      image: const DecorationImage(
                        image: AssetImage('assets/images/chat_bg.jpg'),
                        opacity: 0.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(15),
                        reverse: false,
                        itemCount: messages.length,
                        itemBuilder: (context, i) {
                          final message = messages[i];
                          return AnimationConfiguration.staggeredList(
                            position: i,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              horizontalOffset: message['isSent'] ? 50 : -50,
                              child: FadeInAnimation(
                                child: _buildMessageBubble(
                                  message['text'],
                                  message['isSent'],
                                  message['time'],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Message input
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.blue),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () {
                              if (messageController.text.isNotEmpty) {
                                setState(() {
                                  messages.add({
                                    'text': messageController.text,
                                    'isSent': true,
                                    'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}'
                                  });
                                  messageController.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isSent, String time) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isSent ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSent ? 20 : 0),
            topRight: Radius.circular(isSent ? 0 : 20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isSent ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              time,
              style: TextStyle(
                color: isSent ? Colors.white.withOpacity(0.7) : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToSettings() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text('Settings'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.blue,
          ),
          body: AnimationLimiter(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 500),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  _buildSettingsCard(
                    title: 'Account Settings',
                    icon: Icons.account_circle,
                    children: [
                      _buildSettingsItem('Edit Profile', Icons.edit, () {}),
                      _buildSettingsItem('Change Password', Icons.lock, () {}),
                      _buildSettingsItem('Privacy Settings', Icons.privacy_tip, () {}),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSettingsCard(
                    title: 'App Settings',
                    icon: Icons.settings,
                    children: [
                      _buildSettingsItem('Notifications', Icons.notifications, () {}),
                      _buildSettingsItem('Theme', Icons.color_lens, () {}),
                      _buildSettingsItem('Language', Icons.language, () {}),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSettingsCard(
                    title: 'Support',
                    icon: Icons.help_outline,
                    children: [
                      _buildSettingsItem('Help Center', Icons.help, () {}),
                      _buildSettingsItem('Contact Us', Icons.email, () {}),
                      _buildSettingsItem('About App', Icons.info, () {}),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: const Text('Close Settings'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOutQuart;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 24),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _addFriend() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController bioController = TextEditingController();

    String? imagePath;
    final picker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: const Text('Add New Friend'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          imagePath = pickedFile.path;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      backgroundImage: imagePath != null
                          ? FileImage(File(imagePath!))
                          : null,
                      child: imagePath == null
                          ? const Icon(Icons.add_a_photo, size: 30)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Friend Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: bioController,
                    decoration: InputDecoration(
                      labelText: 'Bio (Optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      usernameController.text.isNotEmpty) {
                    setState(() {
                      friends.add(nameController.text);
                      friendUsernames.add(usernameController.text);
                      if (imagePath != null) {
                        uploadedIcons.add(imagePath);
                      } else {
                        uploadedIcons.add(null);
                      }
                      friendNames.add(nameController.text);
                      friendImages.add('default');
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Add Friend'),
              ),
            ],
          );
        },
      ),
    );
  }
}