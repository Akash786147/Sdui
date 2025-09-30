import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DealsSection extends StatelessWidget {
  final String title;
  final List<dynamic> deals;
  final Function(String) onDealTap;

  const DealsSection({
    super.key,
    required this.title,
    required this.deals,
    required this.onDealTap,
  });

  @override
  Widget build(BuildContext context) {
    if (deals.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a1a2e),
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: deals.length,
            controller: PageController(
              viewportFraction: 0.9,
              initialPage: 0,
            ),
            padEnds: false,
            itemBuilder: (context, index) {
              final deal = deals[index];
              final validUntil = DateTime.tryParse(deal['validUntil'] as String? ?? '');
              
              return GestureDetector(
                onTap: () => onDealTap(deal['id'] as String),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Background image with gradient overlay
                        Stack(
                          children: [
                            // Image
                            Positioned.fill(
                              child: Image.network(
                                deal['banner'] as String? ?? 
                                'https://picsum.photos/600/200?random=deal$index',
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Gradient overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Content
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  deal['title'] as String? ?? 'Special Deal',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Description
                                Text(
                                  deal['description'] as String? ?? '',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // Valid until
                                if (validUntil != null)
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        color: Colors.white70,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Ends ${DateFormat('MMM d, y').format(validUntil)}',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // Ribbon for special offers
                        if (deal['title']?.toString().toLowerCase().contains('off') ?? false)
                          Positioned(
                            top: 16,
                            right: -24,
                            child: Transform.rotate(
                              angle: 0.79,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 6,
                                ),
                                color: Colors.red,
                                child: const Text(
                                  'HOT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
