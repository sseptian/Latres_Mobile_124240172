import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tv_show_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.tvmaze.com';

  /// Mengambil daftar seluruh TV Shows dari API
  /// Endpoint: https://api.tvmaze.com/shows
  Future<List<TvShowModel>> fetchShows() async {
    final uri = Uri.parse('$baseUrl/shows');
    try {
      final response = await http.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Koneksi timeout saat memuat daftar shows.');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((jsonItem) => TvShowModel.fromJson(jsonItem)).toList();
      } else {
        throw Exception(
            'Gagal memuat data dari server (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data: $e');
    }
  }

  /// Mengambil detail TV Show berdasarkan ID
  /// Endpoint: https://api.tvmaze.com/shows/{id}
  Future<TvShowModel> fetchShowDetail(int id) async {
    final uri = Uri.parse('$baseUrl/shows/$id');
    try {
      final response = await http.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Koneksi timeout saat memuat detail show.');
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return TvShowModel.fromJson(data);
      } else {
        throw Exception(
            'Gagal memuat detail show (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil detail: $e');
    }
  }
}
