import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/album_provider.dart';
import '../widgets/nav_bar.dart';
import 'gallery_page.dart';

class AlbumPage extends StatefulWidget {
  final int userId;
  final String userName;

  const AlbumPage({super.key, required this.userId, required this.userName});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<AlbumsProvider>(context, listen: false).fetchAlbums(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final albumsProvider = Provider.of<AlbumsProvider>(context);

    return Scaffold(
      appBar: CustomNavBar(title: "${widget.userName}'s Albums"),
      body: Builder(
        builder: (context) {
          if (albumsProvider.state == AlbumsState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (albumsProvider.state == AlbumsState.failure) {
            return const Center(child: Text('Failed to load albums'));
          }

          return ListView.builder(
            itemCount: albumsProvider.albums.length,
            itemBuilder: (context, index) {
              final album = albumsProvider.albums[index];
              return ListTile(
                title: Text(album.title),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GalleryPage(
                        albumId: album.id,
                        albumTitle: album.title,
                      ),
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
