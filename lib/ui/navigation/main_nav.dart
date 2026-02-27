import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/ui/features/auth/view_models/auth_view_model.dart';
import 'package:flutter_ecommerce/ui/features/auth/views/login_screen.dart';
import 'package:flutter_ecommerce/ui/features/products/views/product_list_screen.dart';
import 'package:flutter_ecommerce/ui/features/profile/views/profile_screen.dart';
import 'package:provider/provider.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    final List<Widget> screens = [
      const ProductListScreen(),
      const Center(child: Text('Search')),
      const Center(child: Text('Cart')),
      authViewModel.isLoggedIn
          ? const ProfileScreen()
          : const LoginScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
