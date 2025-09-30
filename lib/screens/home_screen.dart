import 'package:flutter/material.dart';
import 'package:gaming_hub/services/sdui_service.dart';
import 'package:gaming_hub/widgets/header_section.dart';
import 'package:gaming_hub/widgets/game_card.dart';
import 'package:gaming_hub/widgets/category_card.dart';
import 'package:gaming_hub/widgets/top_rated_item.dart';
import 'package:gaming_hub/widgets/quick_actions_section.dart';
import 'package:gaming_hub/widgets/live_events_section.dart';
import 'package:gaming_hub/widgets/friends_activity_section.dart';
import 'package:gaming_hub/widgets/deals_section.dart';
import 'package:gaming_hub/widgets/news_section.dart';

/// Home screen that renders UI based on server-driven configuration
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SDUIService _sduiService = SDUIService();
  Map<String, dynamic>? _screenConfig;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadScreenConfig();
  }

  @override
  void dispose() {
    _sduiService.dispose();
    super.dispose();
  }

  Future<void> _loadScreenConfig() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final config = await _sduiService.fetchHomeScreen();

      setState(() {
        _screenConfig = config;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isLoading) {
      return _buildLoadingState();
    }

    // Show error state
    if (_error != null) {
      return _buildErrorState();
    }

    // Main content
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFF1a1a2e),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildSections(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleRefresh,
        backgroundColor: const Color(0xFF1a1a2e),
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  /// Builds the loading state widget
  Widget _buildLoadingState() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF1a1a2e)),
            const SizedBox(height: 16),
            Text(
              'Loading gaming experience...',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the error state widget
  Widget _buildErrorState() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Failed to load content',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1a1a2e),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _error ?? 'An unknown error occurred',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadScreenConfig,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1a1a2e),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handles the pull-to-refresh action
  Future<void> _handleRefresh() async {
    try {
      await _loadScreenConfig();

      if (mounted) {
        // Only show success message if there's no error
        if (_error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Content refreshed!'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error during refresh: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  List<Widget> _buildSections() {
    if (_screenConfig == null) return [];

    final sections = _screenConfig!['sections'] as List<dynamic>? ?? [];
    final widgets = <Widget>[];

    for (var section in sections) {
      final type = section['type'] as String;

      switch (type) {
        case 'header':
          widgets.add(_buildHeader(section));
          break;
        case 'quickActions':
          widgets.add(_buildQuickActions(section));
          break;
        case 'trending':
          widgets.add(_buildTrendingSection(section));
          break;
        case 'categories':
          widgets.add(_buildCategoriesSection(section));
          break;
        case 'topRated':
          widgets.add(_buildTopRatedSection(section));
          break;
        case 'liveEvents':
          widgets.add(_buildLiveEventsSection(section));
          break;
        case 'friendsActivity':
          widgets.add(_buildFriendsActivity(section));
          break;
        case 'deals':
          widgets.add(_buildDealsSection(section));
          break;
        case 'news':
          widgets.add(_buildNewsSection(section));
          break;
      }
    }

    return widgets;
  }

  Widget _buildHeader(Map<String, dynamic> config) {
    final title = config['title'] as String? ?? 'Welcome';
    final subtitle = config['subtitle'] as String? ?? '';
    final gradientHex =
        config['gradient'] as List<dynamic>? ?? ['#1a1a2e', '#16213e'];
    final userPoints = config['userPoints'] as int? ?? 0;
    final level = config['level'] as int? ?? 1;
    final avatar = config['avatar'] as String?;

    final gradientColors = gradientHex
        .map((hex) => _hexToColor(hex as String))
        .toList();

    return HeaderSection(
      title: title,
      subtitle: subtitle,
      gradientColors: gradientColors,
      userPoints: userPoints,
      level: level,
      avatar: avatar,
      onProfileTap: () {
        // Handle profile tap
        _handleAction('profile');
      },
    );
  }

  Widget _buildQuickActions(Map<String, dynamic> config) {
    final actions = config['actions'] as List<dynamic>? ?? [];
    return QuickActionsSection(
      actions: actions,
      onActionPressed: (actionId) {
        _handleAction(actionId);
      },
    );
  }

  Widget _buildLiveEventsSection(Map<String, dynamic> config) {
    final title = config['title'] as String? ?? '🎯 Live Events';
    final events = config['events'] as List<dynamic>? ?? [];

    return LiveEventsSection(
      title: title,
      events: events,
      onEventTap: (eventId) {
        _handleAction('view_event', data: {'eventId': eventId});
      },
    );
  }

  Widget _buildFriendsActivity(Map<String, dynamic> config) {
    final title = config['title'] as String? ?? '👥 Friends Activity';
    final activities = config['activities'] as List<dynamic>? ?? [];

    return FriendsActivitySection(
      title: title,
      activities: activities,
      onActivityTap: (userId) {
        _handleAction('view_friend_profile', data: {'userId': userId});
      },
    );
  }

  Widget _buildDealsSection(Map<String, dynamic> config) {
    final title = config['title'] as String? ?? '🔥 Hot Deals';
    final deals = config['deals'] as List<dynamic>? ?? [];

    return DealsSection(
      title: title,
      deals: deals,
      onDealTap: (dealId) {
        _handleAction('view_deal', data: {'dealId': dealId});
      },
    );
  }

  Widget _buildNewsSection(Map<String, dynamic> config) {
    final title = config['title'] as String? ?? '📰 Latest News';
    final newsItems = config['items'] as List<dynamic>? ?? [];

    return NewsSection(
      title: title,
      items: newsItems,
      onNewsTap: (newsId) {
        _handleAction('view_news', data: {'newsId': newsId});
      },
    );
  }

  Future<void> _handleAction(
    String actionId, {
    Map<String, dynamic>? data,
  }) async {
    // Show loading indicator
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      switch (actionId) {
        case 'play_now':
          // Handle play now action
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Launching game...')),
          );
          break;

        case 'store':
          // Navigate to store
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Opening store...')),
          );
          break;

        case 'friends':
          // Show friends list
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Showing friends list...')),
          );
          break;

        case 'profile':
          // Show profile
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Opening profile...')),
          );
          break;

        case 'view_event':
          final eventId = data?['eventId'];
          if (eventId != null) {
            // Navigate to event details
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text('Viewing event: $eventId')),
            );
          }
          break;

        case 'view_friend_profile':
          final userId = data?['userId'];
          if (userId != null) {
            // Navigate to friend's profile
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text('Viewing friend profile: $userId')),
            );
          }
          break;

        case 'view_deal':
          final dealId = data?['dealId'];
          if (dealId != null) {
            // Navigate to deal details
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text('Viewing deal: $dealId')),
            );
          }
          break;

        case 'view_news':
          final newsId = data?['newsId'];
          if (newsId != null) {
            // Navigate to news details
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text('Viewing news: $newsId')),
            );
          }
          break;

        case 'view_all_news':
          // Navigate to all news screen
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Viewing all news')),
          );
          break;

        default:
          // Handle other actions
          debugPrint('Unhandled action: $actionId');
          break;
      }

      // Log the action to the server
      await _sduiService.handleAction(actionId: actionId, data: data);
    } catch (e) {
      debugPrint('Error handling action $actionId: $e');
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildTrendingSection(Map<String, dynamic> config) {
    final title = config['title'] as String? ?? 'Trending';
    final games = config['games'] as List<dynamic>? ?? [];

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
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return GameCard(
                id: game['id'] as String,
                title: game['title'] as String,
                genre: game['genre'] as String,
                rating: (game['rating'] as num).toDouble(),
                players: game['players'] as String,
                color: _hexToColor(game['color'] as String),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(Map<String, dynamic> config) {
    final title = config['title'] as String? ?? 'Categories';
    final items = config['items'] as List<dynamic>? ?? [];

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final category = items[index];
              return CategoryCard(
                name: category['name'] as String,
                icon: _getIconData(category['icon'] as String),
                color: _hexToColor(category['color'] as String),
                count: category['count'] as String,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopRatedSection(Map<String, dynamic> config) {
    final title = config['title'] as String? ?? 'Top Rated';
    final games = config['games'] as List<dynamic>? ?? [];

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
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: games.map((game) {
              return TopRatedItem(
                id: game['id'] as String,
                title: game['title'] as String,
                genre: game['genre'] as String,
                rating: (game['rating'] as num).toDouble(),
                downloads: game['downloads'] as String,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'sports_esports':
        return Icons.sports_esports;
      case 'explore':
        return Icons.explore;
      case 'psychology':
        return Icons.psychology;
      case 'extension':
        return Icons.extension;
      default:
        return Icons.games;
    }
  }
}
