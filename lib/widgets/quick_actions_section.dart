import 'package:flutter/material.dart';
import 'package:gaming_hub/services/sdui_service.dart';

class QuickActionsSection extends StatelessWidget {
  final List<dynamic> actions;
  final Function(String)? onActionPressed;

  const QuickActionsSection({
    Key? key,
    required this.actions,
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a1a2e),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                return _buildActionItem(context, action);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, dynamic action) {
    final color = _parseColor(action['color'] ?? '#1a1a2e');
    
    return GestureDetector(
      onTap: () {
        if (onActionPressed != null) {
          onActionPressed!(action['id']);
        }
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _getIconData(action['icon'] ?? 'extension'),
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              action['title'] ?? 'Action',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return const Color(0xFF1a1a2e);
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'play_arrow':
        return Icons.play_arrow_rounded;
      case 'shopping_cart':
        return Icons.shopping_cart_rounded;
      case 'people':
        return Icons.people_rounded;
      case 'person':
        return Icons.person_rounded;
      case 'settings':
        return Icons.settings_rounded;
      case 'leaderboard':
        return Icons.leaderboard_rounded;
      case 'notifications':
        return Icons.notifications_rounded;
      case 'gift':
        return Icons.card_giftcard_rounded;
      default:
        return Icons.extension_rounded;
    }
  }
}
