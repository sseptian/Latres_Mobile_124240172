import 'package:get/get.dart';
import '../models/tv_show_model.dart';
import '../services/api_service.dart';

class ShowController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<TvShowModel> shows = <TvShowModel>[].obs;
  final RxList<TvShowModel> filteredShows = <TvShowModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShows();
  }

  Future<void> fetchShows() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _apiService.fetchShows();
      shows.assignAll(result);
      applyFilter(searchQuery.value);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter(String query) {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      filteredShows.assignAll(shows);
    } else {
      final q = query.toLowerCase();
      filteredShows.assignAll(
        shows.where((item) =>
            item.name.toLowerCase().contains(q) ||
            item.genres.any((g) => g.toLowerCase().contains(q))),
      );
    }
  }

  void clearFilter() {
    searchQuery.value = '';
    filteredShows.assignAll(shows);
  }
}
