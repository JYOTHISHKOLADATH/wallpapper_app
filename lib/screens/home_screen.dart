import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final provider = Provider.of<WallpaperProvider>(context, listen: false);
      if (!provider.isLoading) {
        provider.loadMorePhotos();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Wallpapers'),
        backgroundColor: Colors.white,
        elevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Consumer<WallpaperProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.photos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.photos.isEmpty) {
            return const Center(child: Text('No photos found'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: StaggeredGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(provider.photos.length, (index) {
                    final photo = provider.photos[index];
                    final aspectRatio = photo.height / photo.width;

                    return GestureDetector(
                      onTap: () async {

                        String url = photo.urls.small;
                        final tempDir = await getTemporaryDirectory();
                        final path = "${tempDir.path}/myfile.jpg";
                        await Dio().download(url, path);
                        await GallerySaver.saveImage(path,
                            albumName: "Wallpaper App");
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Image Downloaded to Gallery!')));

                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: photo.urls.small,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
