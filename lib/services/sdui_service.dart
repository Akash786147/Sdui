import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// Represents a user action response
class ActionResponse {
  final bool success;
  final String message;
  final dynamic data;

  ActionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ActionResponse.fromJson(Map<String, dynamic> json) {
    return ActionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}

/// Service to fetch SDUI configurations from the server
class SDUIService {
  // Use local file system for mock data
  // In production, this would be your actual API URL
  static const String baseUrl = 'https://12cb4e70d381.ngrok-free.app/api';
  final Dio _dio = Dio();
  
  // Cache for storing API responses
  final Map<String, dynamic> _cache = {};
  static const Duration _cacheDuration = Duration(minutes: 5);
  DateTime? _lastFetchTime;

  /// Get cached data if available and not expired
  dynamic _getCachedData(String key) {
    if (_cache.containsKey(key) && 
        _lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
      return _cache[key];
    }
    return null;
  }

  /// Fetches the home screen UI configuration
  Future<Map<String, dynamic>> fetchHomeScreen() async {
    try {
      // Check cache first
      final cachedData = _getCachedData('home_screen');
      if (cachedData != null) {
        return cachedData;
      }

      final response = await _dio.get('$baseUrl/home_screen.json');
      if (response.statusCode == 200) {
        // Update cache
        _cache['home_screen'] = response.data;
        _lastFetchTime = DateTime.now();
        return response.data;
      }
      return _getMockHomeScreen();
    } catch (e) {
      debugPrint('Error fetching home screen: $e');
      return _getMockHomeScreen();
    }
  }

  /// Fetches a specific section by type
  Future<Map<String, dynamic>> fetchSection(String sectionType) async {
    try {
      final response = await _dio.get('$baseUrl/sections/$sectionType.json');
      if (response.statusCode == 200) {
        return response.data;
      }
      return {'error': 'Failed to load section'};
    } catch (e) {
      debugPrint('Error fetching section $sectionType: $e');
      return {'error': e.toString()};
    }
  }

  /// Handles user actions like button clicks and other interactions
  /// 
  /// This method sends the action to the server and returns a response.
  /// In case of network errors, it returns a mock success response for development.
  Future<ActionResponse> handleAction({
    required String actionId,
    Map<String, dynamic>? data,
  }) async {
    try {
      // In a real app, this would make an API call to log the action
      debugPrint('Action performed: $actionId, data: $data');
      
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // For development, return a success response
      return ActionResponse(
        success: true,
        message: 'Action completed successfully',
        data: data,
      );
      
      // Uncomment this in production to make the actual API call
      /*
      final response = await _dio.post(
        '$baseUrl/actions',
        data: {
          'action': actionId,
          'data': data,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        return ActionResponse.fromJson(response.data);
      }
      return ActionResponse(
        success: false,
        message: 'Failed to process action',
      );
      */
    } catch (e) {
      debugPrint('Error handling action $actionId: $e');
      // In development, return a success response even on error
      return ActionResponse(
        success: true, // Changed to true for development
        message: 'Action completed (simulated)',
        data: data,
      );
      
      // In production, you would want to return an error response:
      /*
      return ActionResponse(
        success: false,
        message: e.toString(),
      );
      */
    }
  }

  /// Fetches game details
  Future<Map<String, dynamic>> getGameDetails(String gameId) async {
    try {
      final response = await _dio.get('$baseUrl/games/$gameId.json');
      if (response.statusCode == 200) {
        return response.data;
      }
      return _getMockGameDetails(gameId);
    } catch (e) {
      debugPrint('Error fetching game details: $e');
      return _getMockGameDetails(gameId);
    }
  }

  /// Fetches user profile
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('$baseUrl/users/$userId.json');
      if (response.statusCode == 200) {
        return response.data;
      }
      return {'error': 'Failed to load profile'};
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return {
        'id': userId,
        'username': 'Player$userId',
        'level': 1,
        'points': 0,
        'avatar': 'https://i.pravatar.cc/150?img=$userId',
      };
    }
  }

  /// Fetches game details for a specific game ID
  Future<Map<String, dynamic>> fetchGameDetails(String gameId) async {
    try {
      // In production, fetch from actual API using dio
      // final response = await _dio.get('$baseUrl/game_details/$gameId');
      // return response.data;

      return _getMockGameDetails(gameId);
    } catch (e) {
      print('Error fetching game details: $e');
      return _getMockGameDetails(gameId);
    }
  }

  /// Refreshes the cache
  Future<void> refreshCache() async {
    _cache.clear();
    _lastFetchTime = null;
    await fetchHomeScreen();
  }

  /// Closes all active connections
  void dispose() {
    _dio.close();
    _cache.clear();
  }

  /// Mock home screen data
  Map<String, dynamic> _getMockHomeScreen() {
    return {
      'screenType': 'home',
      'title': 'Gaming Hub',
      'sections': [
        {
          'type': 'header',
          'title': 'Welcome Back, Gamer!',
          'subtitle': 'Ready for your next adventure?',
          'gradient': ['#1a1a2e', '#16213e'],
        },
        {
          'type': 'trending',
          'title': '🔥 Trending Games',
          'games': [
            {
              'id': '1',
              'title': 'Cyber Legends',
              'genre': 'Action RPG',
              'rating': 4.8,
              'players': '2.5M+',
              'color': '#FF6B6B',
            },
            {
              'id': '2',
              'title': 'Space Warriors',
              'genre': 'Strategy',
              'rating': 4.6,
              'players': '1.8M+',
              'color': '#4ECDC4',
            },
            {
              'id': '3',
              'title': 'Mystic Quest',
              'genre': 'Adventure',
              'rating': 4.9,
              'players': '3.2M+',
              'color': '#FFE66D',
            },
          ],
        },
        {
          'type': 'categories',
          'title': '🎮 Categories',
          'items': [
            {
              'name': 'Action',
              'icon': 'sports_esports',
              'color': '#FF6B6B',
              'count': '150+',
            },
            {
              'name': 'Adventure',
              'icon': 'explore',
              'color': '#4ECDC4',
              'count': '120+',
            },
            {
              'name': 'Strategy',
              'icon': 'psychology',
              'color': '#FFE66D',
              'count': '90+',
            },
            {
              'name': 'Puzzle',
              'icon': 'extension',
              'color': '#A8DADC',
              'count': '200+',
            },
          ],
        },
        {
          'type': 'topRated',
          'title': '⭐ Top Rated',
          'games': [
            {
              'id': '4',
              'title': "Dragon's Fury",
              'genre': 'RPG',
              'rating': 4.9,
              'downloads': '5M+',
            },
            {
              'id': '5',
              'title': 'Neon Racer',
              'genre': 'Racing',
              'rating': 4.7,
              'downloads': '3M+',
            },
            {
              'id': '6',
              'title': 'Battle Arena',
              'genre': 'MOBA',
              'rating': 4.8,
              'downloads': '8M+',
            },
          ],
        },
      ],
    };
  }

  /// Mock game details
  Map<String, dynamic> _getMockGameDetails(String gameId) {
    return {
      'id': gameId,
      'title': 'Game $gameId',
      'description':
          'An epic gaming experience that will keep you engaged for hours! '
          'Battle enemies, explore vast worlds, and become a legend.',
      'rating': 4.8,
      'players': '2.5M+',
      'genre': 'Action',
      'size': '1.2 GB',
      'version': '2.5.0',
      'features': [
        'Stunning graphics',
        'Multiplayer mode',
        'Regular updates',
        'In-game chat',
      ],
    };
  }

  /// Fetches the latest events
  Future<Map<String, dynamic>> fetchEvents() async {
    try {
      final response = await _dio.get('$baseUrl/events.json');
      return response.data;
    } catch (e) {
      debugPrint('Error fetching events: $e');
      // Return mock data in case of error
      return {
        'events': [
          {
            'id': 'event1',
            'title': 'Weekly Tournament',
            'description': 'Join now for a chance to win 1000 coins!',
            'timeLeft': '2h 30m',
            'participants': 245,
            'image': 'https://picsum.photos/300/200?random=1',
          },
          {
            'id': 'event2',
            'title': 'New Game Launch',
            'description': 'Be among the first to play Cyber Legends 2.0',
            'timeLeft': '1d 4h',
            'participants': 1200,
            'image': 'https://picsum.photos/300/200?random=2',
          },
        ],
      };
    }
  }

  /// Fetches friends' activities
  Future<Map<String, dynamic>> fetchFriendsActivity() async {
    try {
      final response = await _dio.get('$baseUrl/friends_activity.json');
      return response.data;
    } catch (e) {
      debugPrint('Error fetching friends activity: $e');
      // Return mock data in case of error
      return {
        'activities': [
          {
            'userId': 'user1',
            'username': 'GamerPro99',
            'action': "just earned the 'Legendary' achievement in Cyber Legends",
            'timeAgo': '5m ago',
            'avatar': 'https://i.pravatar.cc/150?img=1',
          },
          {
            'userId': 'user2',
            'username': 'SpaceExplorer',
            'action': 'is now playing Space Warriors',
            'timeAgo': '12m ago',
            'avatar': 'https://i.pravatar.cc/150?img=2',
            'game': {
              'id': '2',
              'title': 'Space Warriors',
              'genre': 'Strategy',
            },
          },
        ],
      };
    }
  }

  /// Fetches current deals
  Future<Map<String, dynamic>> fetchDeals() async {
    try {
      final response = await _dio.get('$baseUrl/deals.json');
      return response.data;
    } catch (e) {
      debugPrint('Error fetching deals: $e');
      // Return mock data in case of error
      return {
        'deals': [
          {
            'id': 'deal1',
            'title': '50% Off All Games',
            'description': 'Limited time offer. Use code: GAMING50',
            'validUntil': '2023-12-31T23:59:59Z',
            'banner': 'https://picsum.photos/600/200?random=4',
          },
          {
            'id': 'deal2',
            'title': 'Starter Pack',
            'description': 'Get 1000 coins + exclusive items for \$4.99',
            'validUntil': '2023-11-30T23:59:59Z',
            'banner': 'https://picsum.photos/600/200?random=5',
          },
        ],
      };
    }
  }

  /// Fetches latest news
  Future<Map<String, dynamic>> fetchNews() async {
    try {
      final response = await _dio.get('$baseUrl/news.json');
      return response.data;
    } catch (e) {
      debugPrint('Error fetching news: $e');
      // Return mock data in case of error
      return {
        'news': [
          {
            'id': 'news1',
            'title': 'New Update: Winter Wonderland',
            'summary': 'Explore the new winter map and collect limited-time rewards!',
            'date': '2023-12-01',
            'image': 'https://picsum.photos/300/200?random=6',
          },
          {
            'id': 'news2',
            'title': 'Community Contest Winners',
            'summary': 'Check out the amazing fan art from our community contest.',
            'date': '2023-11-28',
            'image': 'https://picsum.photos/300/200?random=7',
          },
        ],
      };
    }
  }
}
