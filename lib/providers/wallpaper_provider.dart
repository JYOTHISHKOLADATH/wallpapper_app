import 'package:flutter/foundation.dart';
import '../models/photo.dart';
import '../utils/api_service.dart';

class WallpaperProvider extends ChangeNotifier {
  final List<Photo> _photos = [];
  Photo? _bannerPhoto;
  bool _isLoading = false;
  bool _hasMorePhotos = true;
  int _currentPage = 1;

  List<Photo> get photos => _photos;
  Photo? get bannerPhoto => _bannerPhoto;
  bool get isLoading => _isLoading;
  bool get hasMorePhotos => _hasMorePhotos;

  Future<void> loadPhotos({bool isInitialLoad = false}) async {
    if (_isLoading || (!_hasMorePhotos && !isInitialLoad)) return;

    _isLoading = true;
    notifyListeners();

    try {
      final fetchedPhotos = await ApiService.fetchPhotos(page: _currentPage);

      if (isInitialLoad) {
        _photos.clear();
        _bannerPhoto = null;
        _currentPage = 1;
      }

      if (fetchedPhotos.isNotEmpty) {
        if (_bannerPhoto == null) {
          _bannerPhoto = fetchedPhotos.first;
          fetchedPhotos.removeAt(0);
        }
        _photos.addAll(fetchedPhotos);
        _currentPage++;
      } else {
        _hasMorePhotos = false;
      }
    } catch (error) {
      debugPrint('Error loading photos: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshPhotos() async {
    await loadPhotos(isInitialLoad: true);
  }
}
