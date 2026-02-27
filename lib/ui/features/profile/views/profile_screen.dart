import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/ui/features/auth/view_models/auth_view_model.dart';
import 'package:flutter_ecommerce/ui/features/profile/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserViewModel>().loadUser(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();

    if (userVM.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userVM.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text('Error: ${userVM.errorMessage}')),
      );
    }

    final user = userVM.user;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<UserViewModel>().clearUser();
              context.read<AuthViewModel>().logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.orange,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.orange),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name.fullName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.badge,
                    title: 'Username',
                    subtitle: user.username,
                  ),
                  _buildInfoTile(
                    icon: Icons.phone,
                    title: 'Phone Number',
                    subtitle: user.phone,
                  ),
                  _buildInfoTile(
                    icon: Icons.location_on,
                    title: 'Shipping Address',
                    subtitle: user.address.fullAddress,
                  ),
                  const SizedBox(height: 20),

                  _buildActionTile(Icons.shopping_bag, 'My Orders'),
                  _buildActionTile(Icons.favorite, 'Wishlist'),
                  _buildActionTile(Icons.payment, 'Payment Methods'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () {},
    );
  }
}
