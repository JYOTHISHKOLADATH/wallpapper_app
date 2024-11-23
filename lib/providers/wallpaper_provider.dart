import 'package:flutter/foundation.dart';
import '../models/photo.dart';
import '../utils/api_service.dart';

class WallpaperProvider extends ChangeNotifier {
  final List<Photo> _photos = [];
  bool _isLoading = false;
  bool _hasMorePhotos = true;
  int _currentPage = 1;

  List<Photo> get photos => _photos;
  bool get isLoading => _isLoading;
  bool get hasMorePhotos => _hasMorePhotos;

  Future<void> loadPhotos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedPhotos = await ApiService.fetchPhotos(page: _currentPage);

      if (fetchedPhotos.isEmpty) {
        _hasMorePhotos = false;
      } else {
        _photos.addAll(fetchedPhotos);
        _currentPage++;
      }
    } catch (error) {
      // print('Error loading photos: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePhotos() async {
    if (_isLoading || !_hasMorePhotos) return;
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedPhotos = await ApiService.fetchPhotos(page: _currentPage);

      if (fetchedPhotos.isEmpty) {
        _hasMorePhotos = false;
      } else {
        _photos.addAll(fetchedPhotos);
        _currentPage++;
      }
    } catch (error) {
      // print('Error loading more photos: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
