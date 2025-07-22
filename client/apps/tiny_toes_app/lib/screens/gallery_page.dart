import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/gallery_provider.dart';
import '../screens/photo_view_page.dart';

class GalleryPage extends StatefulWidget {
  final int albumId;
  final String albumTitle;

  const GalleryPage({super.key, required this.albumId, required this.albumTitle});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<GalleryProvider>(context, listen: false).fetchPhotos(widget.albumId);
  }

  @override
  Widget build(BuildContext context) {
    final galleryProvider = Provider.of<GalleryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.albumTitle),
      ),
      body: Builder(
        builder: (context) {
          if (galleryProvider.state == GalleryState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (galleryProvider.state == GalleryState.failure) {
            return const Center(child: Text('Failed to load photos'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            padding: const EdgeInsets.all(12),
            itemCount: galleryProvider.photos.length,
            itemBuilder: (context, index) {
              final photo = galleryProvider.photos[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PhotoDetailPage(photo: photo),
                    ),
                  );
                },
                child: GridTile(
                  footer: Container(
                    padding: const EdgeInsets.all(4),
                    color: Colors.black54,
                    child: Text(
                      photo.title,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  child: Image.network(photo.thumbnailUrl, fit: BoxFit.cover),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
