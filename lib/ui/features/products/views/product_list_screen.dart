import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/ui/features/products/widgets/product_card.dart';
import 'package:provider/provider.dart';

import '../view_models/product_list_view_model.dart';

class _TabDef {
  final String label;
  final String category;

  const _TabDef({required this.label, required this.category});
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  static const List<_TabDef> _tabs = [
    _TabDef(label: 'All', category: 'all'),
    _TabDef(label: 'Electronics', category: 'electronics'),
    _TabDef(label: 'Jewelery', category: 'jewelery'),
    _TabDef(label: "Men's", category: "men's clothing"),
    _TabDef(label: "Women's", category: "women's clothing"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProductListViewModel>().init();
    });

    // Fetch data when tab changes
    _tabController.addListener(() {
      if (!mounted) return;
      if (!_tabController.indexIsChanging) {
        _fetchCurrentTab();
      }
    });
  }

  void _fetchCurrentTab() {
    if (!mounted) return;
    final category = _tabs[_tabController.index].category;
    context.read<ProductListViewModel>().fetchByCategory(category);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.select<ProductListViewModel, List<String>>(
      (vm) => vm.categories,
    );

    if (categories.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  expandedHeight: 200.0,
                  pinned: true,
                  floating: true,
                  snap: true,
                  automaticallyImplyLeading: false,
                  forceElevated: innerBoxIsScrolled,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Colors.orange,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildSearchBar(context),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    tabAlignment: TabAlignment.start,
                    tabs: categories
                        .map((name) => Tab(text: name.toUpperCase()))
                        .toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: categories.map((categoryName) {
              return _ProductGridCategory(category: categoryName);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

Widget _buildSearchBar(BuildContext context) {
  final double topPadding = MediaQuery.of(context).padding.top;

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: topPadding),
    child: Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          SizedBox(width: 12),
          Icon(Icons.search, size: 18, color: Colors.white70),
          SizedBox(width: 8),
          Text(
            'Search products...',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    ),
  );
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
          edgeOffset: 60,
          displacement: 20,
          onRefresh: _refreshCurrentCategory,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            key: PageStorageKey(widget.category),
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
              ),
              _buildGrid(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGrid(BuildContext context) {
    final viewModel = context.watch<ProductListViewModel>();
    final isLoading = viewModel.isLoading(widget.category);
    final products = viewModel.getProducts(widget.category);

    if (isLoading && products.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (products.isEmpty && !isLoading) {
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
          (context, index) => ProductCard(product: products[index]),
          childCount: products.length,
        ),
      ),
    );
  }
}
