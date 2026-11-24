import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilet/features/account/presentation/pages/account_tab.dart';
import 'package:tilet/features/auth/presentation/pages/login_page.dart';
import 'package:tilet/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:tilet/features/cart/presentation/pages/cart_page.dart';
import 'package:tilet/features/home/presentation/pages/product_details_page.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/textile_footer.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/category_item.dart';
import '../widgets/home_hero.dart';
import '../widgets/product_card.dart';
import '../widgets/search_tab.dart';
import '../widgets/wishlist_tab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(const HomeStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  void _openProductDetails(BuildContext context, dynamic product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailsPage(product: product)),
    );
  }

  Widget _buildHomeFeed(BuildContext context, HomeState state) {
    return RefreshIndicator(
      color: AppColors.forest,
      onRefresh: () async => context.read<HomeBloc>().add(const HomeStarted()),
      child: CustomScrollView(
        slivers: [
          // 1. Hero Banner
          SliverToBoxAdapter(
            child: HomeHero(
              cartCount: context.watch<CartBloc>().state.totalItems,
              onMenuTap: () {},
              onCartTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              ),
              onShopNowTap: () =>
                  context.read<HomeBloc>().add(const HomeTabChanged(1)),
            ),
          ),

          // 2. Dynamic Category Pills
          SliverToBoxAdapter(
            child: SizedBox(
              height: 62,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
                itemCount: state.categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final isAll = index == 0;
                  final category = isAll ? null : state.categories[index - 1];
                  final active = isAll
                      ? state.selectedCategoryId == null
                      : state.selectedCategoryId == category!.id;

                  return GestureDetector(
                    onTap: () => context.read<HomeBloc>().add(
                      HomeCategorySelected(isAll ? null : category!.id),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: active ? AppColors.forest : AppColors.paper,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: active ? AppColors.goldBorder : AppColors.line,
                          width: active ? 1.3 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          isAll ? 'All' : category!.name,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: active ? AppColors.goldLight : AppColors.ink,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 3. Dynamic Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 14, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.selectedCategoryTitle,
                    style: const TextStyle(
                      color: AppColors.forest,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.read<HomeBloc>().add(const HomeTabChanged(1)),
                    child: const Text(
                      'See All  ›',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Loading / Error / 2-Column Product Grid
          if (state.isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.forest),
              ),
            )
          else if (state.errorMessage != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage!,
                      style: const TextStyle(
                        fontFamily: 'Arial',
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () =>
                          context.read<HomeBloc>().add(const HomeStarted()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (state.products.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'No items in this category yet.',
                  style: TextStyle(fontFamily: 'Arial', color: AppColors.muted),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.66,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = state.products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => _openProductDetails(context, product),
                    onFavoriteTap: () => context.read<HomeBloc>().add(
                      HomeFavoriteToggled(product.id),
                    ),
                  );
                }, childCount: state.products.length),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: state.selectedTab,
              children: [
                // Tab 0: Home Feed
                _buildHomeFeed(context, state),

                // Tab 1: Search
                SearchTab(
                  products: state.products,
                  onProductTap: (product) =>
                      _openProductDetails(context, product),
                  onFavoriteTap: (product) => context.read<HomeBloc>().add(
                    HomeFavoriteToggled(product.id),
                  ),
                ),

                // Tab 2: Wishlist
                WishlistTab(
                  favorites: state.products.where((p) => p.isFavorite).toList(),
                  onProductTap: (product) =>
                      _openProductDetails(context, product),
                  onFavoriteTap: (product) => context.read<HomeBloc>().add(
                    HomeFavoriteToggled(product.id),
                  ),
                  onExploreTap: () =>
                      context.read<HomeBloc>().add(const HomeTabChanged(0)),
                ),

                // const AccountTab(),
              ],
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NavigationBar(
                  height: 70,
                  selectedIndex: state.selectedTab,
                  onDestinationSelected: (index) {
                    if (index == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                      return;
                    }
                    context.read<HomeBloc>().add(HomeTabChanged(index));
                  },
                  backgroundColor: AppColors.cream,
                  indicatorColor: AppColors.navIndicator,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined, color: AppColors.muted),
                      selectedIcon: Icon(Icons.home, color: AppColors.forest),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.search, color: AppColors.muted),
                      selectedIcon: Icon(Icons.search, color: AppColors.forest),
                      label: 'Search',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.favorite_border, color: AppColors.muted),
                      selectedIcon: Icon(
                        Icons.favorite,
                        color: AppColors.forest,
                      ),
                      label: 'Wishlist',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline, color: AppColors.muted),
                      selectedIcon: Icon(Icons.person, color: AppColors.forest),
                      label: 'Account',
                    ),
                  ],
                ),
                const TextileFooter(height: 48),
              ],
            ),
          );
        },
      ),
    );
  }
}
