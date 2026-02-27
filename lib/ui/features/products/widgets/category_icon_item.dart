import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/domain/models/string_extension.dart';

class CategoryIconItem extends StatelessWidget {
  final String name;
  const CategoryIconItem({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 65, // "Little bit smaller" squared layout
          height: 65,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              // Using a placeholder service based on the category name
              'https://picsum.photos/seed/${name.length}/200',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name.toTitleCase(),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
