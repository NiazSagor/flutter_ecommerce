import 'package:flutter/material.dart';

class SearchBarPlaceholder extends StatelessWidget {
  const SearchBarPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
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
}
