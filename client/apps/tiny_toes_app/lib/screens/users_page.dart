// users_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/users_provider.dart';
import '../widgets/nav_bar.dart';
import 'album_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UsersProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);

    return Scaffold(
      appBar: const CustomNavBar(title: 'Users', showBack: false),
      body: Builder(
        builder: (context) {
          if (usersProvider.state == UsersState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (usersProvider.state == UsersState.failure || usersProvider.users.isEmpty) {
            return const Center(child: Text('Failed to load users'));
          }

          return ListView.builder(
            itemCount: usersProvider.users.length,
            itemBuilder: (context, index) {
              final user = usersProvider.users[index];
              return ListTile(
                title: Text(user.name),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AlbumPage(userId: user.id, userName: user.name),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
