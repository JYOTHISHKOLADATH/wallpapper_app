
import 'package:dio/dio.dart';
import '../models/photo.dart';

class ApiService {
  static const String _baseUrl = 'https://api.unsplash.com/photos/';
  static const String _clientId = '-zRQighyvdzPs-kRKzh8TLcDYFSrDH7r_eth0j_N_Js';

  static final Dio _dio = Dio();
  static Future<List<Photo>> fetchPhotos({required int page, int perPage = 10}) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'client_id': _clientId,
          'page': page,
          'per_page': perPage,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        // print("Fetched ${jsonData.length} photos from API");
        return jsonData.map((photo) => Photo.fromJson(photo)).toList();
      } else {
        throw Exception('Failed to fetch photos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching photos: $e');
    }
  }
}
