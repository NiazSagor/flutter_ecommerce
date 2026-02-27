import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/data/repositories/auth/auth_repository_remote.dart';
import 'package:flutter_ecommerce/data/repositories/product/product_repository_remote.dart';
import 'package:flutter_ecommerce/data/repositories/user/user_repository_remote.dart';
import 'package:flutter_ecommerce/data/services/api/auth_api_client.dart';
import 'package:flutter_ecommerce/data/services/api/product_api_service.dart';
import 'package:flutter_ecommerce/ui/navigation/main_nav.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'ui/features/auth/view_models/auth_view_model.dart';
import 'ui/features/products/view_models/product_list_view_model.dart';
import 'ui/features/profile/view_models/user_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();

    final authApiService = AuthApiService(httpClient);
    final productApiService = ProductApiService(httpClient);
    return MultiProvider(
      providers: [
        Provider<AuthRepositoryRemote>(
          create: (_) => AuthRepositoryRemote(
            authApiService: authApiService,
            productApiService: productApiService,
          ),
        ),
        Provider<ProductRepositoryRemote>(
          create: (_) => ProductRepositoryRemote(apiService: productApiService),
        ),
        Provider<UserRepositoryRemote>(
          create: (_) => UserRepositoryRemote(apiService: authApiService),
        ),

        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
            authRepository: context.read<AuthRepositoryRemote>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductListViewModel(
            productRepository: context.read<ProductRepositoryRemote>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(
            userRepository: context.read<UserRepositoryRemote>(),
          ),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Ecommerce',
        home: Scaffold(body: MainNavigationScreen()),
      ),
    );
  }
}
