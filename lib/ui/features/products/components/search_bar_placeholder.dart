import 'package:flutter/material.dart';

class SearchBarPlaceholder extends StatelessWidget {
  const SearchBarPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, topPadding + 10, 16, 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.search, size: 20, color: Colors.orange),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Search for products, brands...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              height: 25,
              width: 1,
              color: Colors.grey.withOpacity(0.3),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.camera_alt_outlined, size: 20, color: Colors.grey),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
