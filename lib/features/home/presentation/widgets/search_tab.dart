import 'package:flutter/material.dart';
import 'package:tilet/core/theme/app_colors.dart';
import 'package:tilet/features/home/data/models/product_model.dart';
import 'package:tilet/features/home/presentation/widgets/product_card.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onFavoriteTap,
  });

  final List<ProductModel> products;
  final ValueChanged<ProductModel> onProductTap;
  final ValueChanged<ProductModel> onFavoriteTap;

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _controller = TextEditingController();
  static const _filters = ['All', 'Green', 'Red', 'Gold', 'Heritage'];

  String _query = '';
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<ProductModel> get _filteredProducts {
    return widget.products.where((product) {
      final title = product.title.toLowerCase();
      final matchesQuery = _query.isEmpty || title.contains(_query.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' ||
          title.contains(_selectedFilter.toLowerCase());
      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredProducts;

    return Container(
      color: AppColors.forest,
      child: Column(
        children: [
          // Deep Forest Green Header + Search Input
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search Kemis',
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.paper,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: AppColors.forest,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onChanged: (val) => setState(() => _query = val),
                            style: const TextStyle(
                              fontFamily: 'Arial',
                              color: AppColors.ink,
                              fontSize: 14,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Search by color, style, or name...',
                              hintStyle: TextStyle(
                                color: AppColors.muted,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (_query.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _controller.clear();
                              setState(() => _query = '');
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppColors.muted,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rising Warm Cream Sheet
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  // Filter Chips
                  SizedBox(
                    height: 58,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final active = filter == _selectedFilter;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = filter),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: active ? AppColors.forest : AppColors.paper,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: active
                                    ? AppColors.goldBorder
                                    : AppColors.line,
                              ),
                            ),
                            child: Text(
                              filter,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: active ? AppColors.cream : AppColors.ink,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Results Grid
                  Expanded(
                    child: results.isEmpty
                        ? const Center(
                            child: Text(
                              'No Kemis found matching your search',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                color: AppColors.muted,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.64,
                            ),
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final product = results[index];
                              return ProductCard(
                                product: product,
                                onTap: () => widget.onProductTap(product),
                                onFavoriteTap: () =>
                                    widget.onFavoriteTap(product),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}