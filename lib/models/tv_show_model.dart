class TvShowModel {
  final int id;
  final String name;
  final String? imageUrl;
  final String? originalImageUrl;
  final double? rating;
  final List<String> genres;
  final String? summary;
  final String? status;
  final String? premiered;
  final String? language;

  TvShowModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.originalImageUrl,
    this.rating,
    this.genres = const [],
    this.summary,
    this.status,
    this.premiered,
    this.language,
  });

  String get cleanSummary {
    if (summary == null || summary!.isEmpty) {
      return 'Tidak ada ringkasan yang tersedia.';
    }
    // Remove HTML tags
    final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    String cleaned = summary!.replaceAll(exp, '');

    // Replace common HTML entities
    cleaned = cleaned
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ')
        .trim();

    return cleaned.isNotEmpty ? cleaned : 'Tidak ada ringkasan yang tersedia.';
  }

  factory TvShowModel.fromJson(Map<String, dynamic> json) {
    // Rating handling (can be int, double, or null inside { "average": ... })
    double? parsedRating;
    if (json['rating'] != null && json['rating'] is Map) {
      final avg = json['rating']['average'];
      if (avg != null) {
        parsedRating = (avg is num) ? avg.toDouble() : double.tryParse(avg.toString());
      }
    } else if (json['rating'] != null && json['rating'] is num) {
      parsedRating = (json['rating'] as num).toDouble();
    }

    // Image handling
    String? mediumImg;
    String? origImg;
    if (json['image'] != null && json['image'] is Map) {
      mediumImg = json['image']['medium']?.toString();
      origImg = json['image']['original']?.toString();
    } else if (json['imageUrl'] != null) {
      mediumImg = json['imageUrl']?.toString();
      origImg = json['originalImageUrl']?.toString() ?? mediumImg;
    }

    // Genres handling
    List<String> parsedGenres = [];
    if (json['genres'] != null && json['genres'] is List) {
      parsedGenres = (json['genres'] as List).map((e) => e.toString()).toList();
    }

    return TvShowModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? 'Tanpa Judul',
      imageUrl: mediumImg,
      originalImageUrl: origImg ?? mediumImg,
      rating: parsedRating,
      genres: parsedGenres,
      summary: json['summary']?.toString(),
      status: json['status']?.toString(),
      premiered: json['premiered']?.toString(),
      language: json['language']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'originalImageUrl': originalImageUrl,
      'rating': rating,
      'genres': genres,
      'summary': summary,
      'status': status,
      'premiered': premiered,
      'language': language,
    };
  }
}
