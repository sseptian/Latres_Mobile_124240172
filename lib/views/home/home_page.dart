import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/show_controller.dart';
import '../../models/tv_show_model.dart';
import '../detail/show_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final showController = Get.find<ShowController>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          'Skuy Nonton!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Segarkan Data',
            onPressed: () => showController.fetchShows(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: (val) => showController.applyFilter(val),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E1E22),
                hintText: 'Cari serial TV atau genre...',
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: Obx(
                  () => showController.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () => showController.clearFilter(),
                        )
                      : const SizedBox.shrink(),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2A2A30)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE50914)),
                ),
              ),
            ),
          ),

          // Main Shows Content
          Expanded(
            child: Obx(() {
              if (showController.isLoading.value) {
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
                        'Memuat data TV Shows...',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              if (showController.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Color(0xFFE50914),
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          showController.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => showController.fetchShows(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE50914),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final displayList = showController.filteredShows;

              if (displayList.isEmpty) {
                return const Center(
                  child: Text(
                    'Tidak ada serial TV ditemukan.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                );
              }

              return RefreshIndicator(
                color: const Color(0xFFE50914),
                backgroundColor: const Color(0xFF1E1E22),
                onRefresh: () => showController.fetchShows(),
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final show = displayList[index];
                    return _buildShowCard(context, show);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildShowCard(BuildContext context, TvShowModel show) {
    return InkWell(
      onTap: () {
        Get.to(() => ShowDetailPage(showId: show.id, initialShow: show));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF26262C)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  show.imageUrl != null
                      ? Image.network(
                          show.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFF26262C),
                            child: const Center(
                              child: Icon(Icons.broken_image, color: Colors.grey, size: 36),
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: const Color(0xFF1E1E22),
                              child: const Center(
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFE50914),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: const Color(0xFF26262C),
                          child: const Center(
                            child: Icon(Icons.movie, color: Colors.grey, size: 36),
                          ),
                        ),
                ],
              ),
            ),

            // Info (Judul & Rating)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFBBF24),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        show.rating != null ? show.rating!.toStringAsFixed(1) : 'N/A',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
