import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/domain/models/product.dart';
import 'package:flutter_ecommerce/domain/models/string_extension.dart';
import 'package:flutter_ecommerce/ui/features/products/components/promo_strip.dart';
import 'package:flutter_ecommerce/ui/features/products/components/search_bar_placeholder.dart';
import 'package:flutter_ecommerce/ui/features/products/widgets/product_card.dart';
import 'package:provider/provider.dart';

import '../view_models/product_list_view_model.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<String> _currentCategories = [];

  @override
  void initState() {
    super.initState();
    final vm = context.read<ProductListViewModel>();
    vm.addListener(_handleViewModelChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      vm.init();
    });
  }

  void _handleViewModelChange() {
    if (!mounted) return;
    final newCategories = context.read<ProductListViewModel>().categories;
    if (newCategories.isNotEmpty &&
        newCategories.length != _currentCategories.length) {
      setState(() {
        _currentCategories = List.from(newCategories);
        _tabController?.dispose();
        _tabController = TabController(
          length: _currentCategories.length,
          vsync: this,
        );

        _tabController!.addListener(() {
          if (!_tabController!.indexIsChanging) _fetchCurrentCategory();
        });
      });
    }
  }

  void _fetchCurrentCategory() {
    if (!mounted) return;
    final category = _currentCategories[_tabController!.index];
    context.read<ProductListViewModel>().fetchByCategory(category);
  }

  @override
  void dispose() {
    context.read<ProductListViewModel>().removeListener(_handleViewModelChange);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Selector<ProductListViewModel, List<String>>(
        selector: (_, vm) => vm.categories,
        builder: (context, categories, child) {
          if (_tabController == null || categories.isEmpty) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            body: NestedScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.orange,
                      child: Column(
                        children: const [
                          SearchBarPlaceholder(),
                          SizedBox(height: 10),
                          PromoStrip(),
                        ],
                      ),
                    ),
                  ),
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                    sliver: SliverAppBar(
                      pinned: true,
                      floating: false,
                      snap: false,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.orange,
                      forceElevated: innerBoxIsScrolled,
                      toolbarHeight: 0,
                      bottom: TabBar(
                        splashFactory: NoSplash.splashFactory,
                        controller: _tabController!,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        physics: const BouncingScrollPhysics(),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                        labelColor: Colors.orange.shade800,
                        unselectedLabelColor: Colors.black.withOpacity(0.7),
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        dividerColor: Colors.transparent,
                        tabs: categories
                            .map(
                              (name) => Tab(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(name.toTitleCase()),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController!,
                children: categories.map((categoryName) {
                  return _ProductGridCategory(category: categoryName);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductGridCategory extends StatefulWidget {
  final String category;

  const _ProductGridCategory({required this.category});

  @override
  State<_ProductGridCategory> createState() => _ProductGridCategoryState();
}

class _ProductGridCategoryState extends State<_ProductGridCategory>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _refreshCurrentCategory() async {
    if (!mounted) return;
    final viewModel = context.read<ProductListViewModel>();
    await viewModel.refresh(widget.category);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProductListViewModel>().fetchByCategory(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Builder(
      builder: (context) {
        return RefreshIndicator(
          onRefresh: _refreshCurrentCategory,
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            key: PageStorageKey(widget.category),
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
              ),
              _buildGrid(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGrid() {
    return Selector<
      ProductListViewModel,
      ({bool loading, List<Product> items})
    >(
      selector: (_, vm) => (
        loading: vm.isLoading(widget.category),
        items: vm.getProducts(widget.category),
      ),
      builder: (context, data, child) {
        if (data.loading && data.items.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (data.items.isEmpty && !data.loading) {
          return const SliverFillRemaining(
            child: Center(child: Text('No products found')),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => RepaintBoundary(
                child: ProductCard(product: data.items[index]),
              ),
              childCount: data.items.length,
            ),
          ),
        );
      },
    );
  }
}
