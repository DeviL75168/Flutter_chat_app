import 'package:octapreview/team_folder.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      ),
      home: const TeamFolderPage(),
      // home: const LoginPage(),
      // home: const SixthPage()

      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: const Center(
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'auth/auth_service.dart';
// import 'auth/login_page.dart';
// import 'models/user.dart';
// import 'services/chat_service.dart';
// import 'services/storage_service.dart';
// import 'services/user_service.dart';
// import 'views/home_page.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<AuthService>(create: (_) => AuthService()),
//         Provider<UserService>(create: (_) => UserService()),
//         Provider<ChatService>(create: (_) => ChatService()),
//         Provider<StorageService>(create: (_) => StorageService()),
//         StreamProvider<AppUser?>(
//           create: (context) => context.read<AuthService>().user,
//           initialData: null,
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Realtime Chat',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//           useMaterial3: true,
//         ),
//         home: const AuthWrapper(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }
//
// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final authUser = context.watch<AppUser?>();
//
//     if (authUser == null) {
//       return const LoginPage();
//     }
//
//     return const HomePage();
//   }
// }