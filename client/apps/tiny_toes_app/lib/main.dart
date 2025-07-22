import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/auth_provider.dart';
import 'providers/users_provider.dart';
import 'providers/album_provider.dart';
import 'providers/gallery_provider.dart';
import 'services/storage_service.dart';
import 'screens/login_page.dart';
import 'screens/users_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => StorageService(prefs)),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => AlbumsProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, this.initialRoute = '/'});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 100)),
      builder: (context, snapshot) {
        final storage = Provider.of<StorageService>(context, listen: false);
        final username = storage.username;

        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp(
          title: 'Tiny Toes',
          theme: ThemeData(primarySwatch: Colors.blue),
          initialRoute: initialRoute,
          routes: {
            '/login': (_) => const LoginPage(),
            '/users': (_) => const UsersPage(),
          },
          home: username == null ? const LoginPage() : const UsersPage(),
        );
      },
    );
  }
}
