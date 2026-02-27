import 'package:flutter/material.dart';

class PromoStrip extends StatelessWidget {
  const PromoStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final promos = [
      {'icon': Icons.bolt, 'label': 'Flash Sale'},
      {'icon': Icons.card_giftcard, 'label': 'Daily Gifts'},
      {'icon': Icons.local_shipping_outlined, 'label': 'Free Delivery'},
      {'icon': Icons.stars_rounded, 'label': 'Top Brands'},
    ];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      height: 35,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: promos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              children: [
                Icon(
                  promos[index]['icon'] as IconData,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  promos[index]['label'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
