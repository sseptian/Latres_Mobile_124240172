import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/tv_show_model.dart';
import '../../services/api_service.dart';

class ShowDetailPage extends StatefulWidget {
  final int showId;
  final TvShowModel? initialShow;

  const ShowDetailPage({
    super.key,
    required this.showId,
    this.initialShow,
  });

  @override
  State<ShowDetailPage> createState() => _ShowDetailPageState();
}

class _ShowDetailPageState extends State<ShowDetailPage> {
  final ApiService _apiService = ApiService();
  final FavoriteController _favoriteController = Get.find<FavoriteController>();

  TvShowModel? _show;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _show = widget.initialShow;
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final detail = await _apiService.fetchShowDetail(widget.showId);
      if (mounted) {
        setState(() {
          _show = detail;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_show != null)
            Obx(() {
              final isFav = _favoriteController.isFavorite(_show!.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? const Color(0xFFE50914) : Colors.white,
                ),
                tooltip: isFav ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                onPressed: () => _favoriteController.toggleFavorite(_show!),
              );
            }),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _show == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFE50914),
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Memuat detail TV Show...',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null && _show == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Color(0xFFE50914), size: 48),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _fetchDetail();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final show = _show!;
    final imageUrl = show.originalImageUrl ?? show.imageUrl;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Besar / Poster
          Stack(
            children: [
              Container(
                height: 380,
                width: double.infinity,
                color: const Color(0xFF1E1E22),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.movie, size: 64, color: Colors.grey),
                      ),
              ),
              // Gradient Overlay at bottom of image
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xE6121212),
                        const Color(0xFF121212),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                Text(
                  show.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Rating
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFBBF24),
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      show.rating != null
                          ? '${show.rating!.toStringAsFixed(1)} / 10'
                          : 'Rating: N/A',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (show.premiered != null && show.premiered!.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      Text(
                        '•  ${show.premiered!.split('-').first}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),

                // Genre
                if (show.genres.isNotEmpty)
                  Text(
                    show.genres.join(', '),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 20),

                // Action Buttons (Nonton & Tombol Favorit)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.snackbar(
                            'Informasi',
                            'Fitur streaming segera hadir!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFF26262C),
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE50914),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 24),
                        label: const Text(
                          'Nonton',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Obx(() {
                      final isFav = _favoriteController.isFavorite(show.id);
                      return InkWell(
                        onTap: () => _favoriteController.toggleFavorite(show),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E22),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isFav
                                  ? const Color(0xFFE50914)
                                  : const Color(0xFF2E2E34),
                            ),
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? const Color(0xFFE50914) : Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 28),

                // Overview Section
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // Summary Text
                Text(
                  show.cleanSummary,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.grey.shade300,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
