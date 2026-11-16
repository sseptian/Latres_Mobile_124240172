import 'package:flutter_test/flutter_test.dart';
import 'package:latres_mobile_124240172/models/tv_show_model.dart';

void main() {
  group('TvShowModel Test', () {
    test('TvShowModel parses JSON correctly', () {
      final json = {
        'id': 1,
        'name': 'Under the Dome',
        'rating': {'average': 6.6},
        'genres': ['Drama', 'Science-Fiction'],
        'image': {
          'medium': 'https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg',
          'original': 'https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg'
        },
        'summary': '<p><b>Under the Dome</b> is a great show.</p>'
      };

      final show = TvShowModel.fromJson(json);

      expect(show.id, 1);
      expect(show.name, 'Under the Dome');
      expect(show.rating, 6.6);
      expect(show.genres, ['Drama', 'Science-Fiction']);
      expect(show.cleanSummary, 'Under the Dome is a great show.');
    });

    test('TvShowModel handles null fields gracefully', () {
      final json = {
        'id': 2,
        'name': 'No Image Show',
      };

      final show = TvShowModel.fromJson(json);

      expect(show.id, 2);
      expect(show.name, 'No Image Show');
      expect(show.rating, isNull);
      expect(show.imageUrl, isNull);
      expect(show.cleanSummary, 'Tidak ada ringkasan yang tersedia.');
    });
  });
}
