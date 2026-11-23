import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHero(
                    cartCount: context.watch<CartBloc>().state.totalItems,
                    onMenuTap: () {},
                    onCartTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    ),
                    onShopNowTap: () {},
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CategoryItem(
                          icon: Icons.checkroom,
                          label: 'New\nArrivals',
                        ),
                        CategoryItem(icon: Icons.star, label: 'Best\nSellers'),
                        CategoryItem(icon: Icons.sell, label: 'Offers'),
                        CategoryItem(
                          icon: Icons.favorite_border,
                          label: 'Favorites',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(19, 24, 17, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Popular Kemis',
                          style: TextStyle(
                            color: AppColors.forest,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'See All  ›',
                            style: TextStyle(color: AppColors.forest),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailsPage(product: product),
                            ),
                          ),
                          onFavoriteTap: () => context.read<HomeBloc>().add(
                            HomeFavoriteToggled(product.id),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
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
                      icon: Icon(Icons.home_outlined, color: AppColors.forest),
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
