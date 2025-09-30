import 'package:flutter/material.dart';
import 'package:gaming_hub/services/sdui_service.dart';
import 'package:gaming_hub/widgets/header_section.dart';
import 'package:gaming_hub/widgets/game_card.dart';
import 'package:gaming_hub/widgets/category_card.dart';
import 'package:gaming_hub/widgets/top_rated_item.dart';

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
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF1a1a2e),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading gaming experience...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadScreenConfig,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
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
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: RefreshIndicator(
        onRefresh: _loadScreenConfig,
        color: const Color(0xFF1a1a2e),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildSections(),
          ),
        ),
      ),
    );
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
        case 'trending':
          widgets.add(_buildTrendingSection(section));
          break;
        case 'categories':
          widgets.add(_buildCategoriesSection(section));
          break;
        case 'topRated':
          widgets.add(_buildTopRatedSection(section));
          break;
      }
    }

    return widgets;
  }

  Widget _buildHeader(Map<String, dynamic> config) {
    final title = config['title'] as String? ?? 'Welcome';
    final subtitle = config['subtitle'] as String? ?? '';
    final gradientHex = config['gradient'] as List<dynamic>? ?? ['#1a1a2e', '#16213e'];
    
    final gradientColors = gradientHex
        .map((hex) => _hexToColor(hex as String))
        .toList();

    return HeaderSection(
      title: title,
      subtitle: subtitle,
      gradientColors: gradientColors,
    );
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
