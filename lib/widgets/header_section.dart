import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Header section widget with gradient background
class HeaderSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final int userPoints;
  final int level;
  final String? avatar;
  final VoidCallback? onProfileTap;

  const HeaderSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    this.userPoints = 0,
    this.level = 1,
    this.avatar,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User profile section
              // GestureDetector(
              //   onTap: onProfileTap,
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //     decoration: BoxDecoration(
              //       color: Colors.white.withOpacity(0.1),
              //       borderRadius: BorderRadius.circular(20),
              //       border: Border.all(color: Colors.white.withOpacity(0.2)),
              //     ),
              //     // child: Row(
              //     //   children: [
              //     //     // Avatar
              //     //     // Container(
              //     //     //   width: 40,
              //     //     //   height: 40,
              //     //     //   decoration: BoxDecoration(
              //     //     //     shape: BoxShape.circle,
              //     //     //     image: avatar != null
              //     //     //         ? DecorationImage(
              //     //     //             image: NetworkImage(avatar!), 
              //     //     //             fit: BoxFit.cover,
              //     //     //           )
              //     //     //         : const DecorationImage(
              //     //     //             image: AssetImage('assets/default_avatar.png'),
              //     //     //             fit: BoxFit.cover,
              //     //     //           ),
              //     //     //   ),
              //     //     // ),
                      
              //     //     const SizedBox(width: 10),
              //     //     // User info
              //     //     // Column(
              //     //     //   crossAxisAlignment: CrossAxisAlignment.start,
              //     //     //   children: [
              //     //     //     // Level badge
              //     //     //     Container(
              //     //     //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              //     //     //       decoration: BoxDecoration(
              //     //     //         color: Colors.amber[700],
              //     //     //         borderRadius: BorderRadius.circular(10),
              //     //     //       ),
              //     //     //       child: Text(
              //     //     //         'Lv. $level',
              //     //     //         style: const TextStyle(
              //     //     //           color: Colors.white,
              //     //     //           fontSize: 10,
              //     //     //           fontWeight: FontWeight.bold,
              //     //     //         ),
              //     //     //       ),
              //     //     //     ),
              //     //     //     const SizedBox(height: 2),
              //     //     //     // Points
              //     //     //     Text(
              //     //     //       '$userPoints XP',
              //     //     //       style: const TextStyle(
              //     //     //         color: Colors.white,
              //     //     //         fontSize: 12,
              //     //     //         fontWeight: FontWeight.w500,
              //     //     //       ),
              //     //     //     ),
              //     //     //   ],
              //     //     // ),
                    
              //     //   ],
              //     // ),
                
              //   ),
              // ),
              
              // // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ).animate(delay: 400.ms).scale(duration: 400.ms),
            ],
          ),
          const SizedBox(height: 20),
          
          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                Icon(
                  Icons.search,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Search for games...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1a2e),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ).animate(delay: 600.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}
