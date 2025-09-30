import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

/// Service to fetch SDUI configurations from the server
class SDUIService {
  // Use local file system for mock data
  // In production, this would be your actual API URL
  static const String baseUrl = 'https://12cb4e70d381.ngrok-free.app/api';
  final Dio _dio = Dio();
  final http.Client _httpClient = http.Client();

  /// Fetches the home screen UI configuration
  Future<Map<String, dynamic>> fetchHomeScreen() async {
    try {
      // For development, we'll use local JSON
      // In production, uncomment the HTTP call

      final response = await _httpClient.get(
        Uri.parse('$baseUrl/home_screen.json'),
      );
      if (response.statusCode == 200) {
        debugPrint("${response.body}-----------------");
        return json.decode(response.body);
      }

      // For now, return mock data directly
      return _getMockHomeScreen();
    } catch (e) {
      print('Error fetching home screen: $e');
      // Return mock data as fallback
      return _getMockHomeScreen();
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

  // Add this method to properly close the http client
  void dispose() {
    _httpClient.close();
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
}
