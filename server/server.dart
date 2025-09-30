import 'dart:io';
import 'dart:convert';

/// Mock HTTP server for SDUI Gaming App
/// This simulates a backend server that serves UI configurations
/// 
/// Run with: dart server/fixed_server.dart
void main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('🚀 SDUI Mock Server running on http://localhost:8080');
  print('📱 Available endpoints:');
  print('   - GET /api/home_screen.json');
  print('   - GET /api/game_list.json');
  print('   - GET /api/game_details/:id');
  print('\n💡 Press Ctrl+C to stop the server\n');

  await for (HttpRequest request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) async {
  try {
    // Set CORS headers
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers', 'Content-Type');
    
    // Handle preflight OPTIONS request
    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
      return;
    }

    print('📨 ${request.method} ${request.uri.path}');

    // Set content type
    request.response.headers.contentType = ContentType.json;

    // Route handling
    if (request.uri.path == '/api/home_screen.json' || 
        request.uri.path == '/api/home_screen') {
      await serveFile(request, 'server/api/home_screen.json');
    } else if (request.uri.path == '/api/game_list.json') {
      await serveFile(request, 'server/api/game_list.json');
    } else if (request.uri.path.startsWith('/api/game_details/')) {
      final gameId = request.uri.pathSegments.last;
      await serveGameDetails(request, gameId);
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write(jsonEncode({
        'error': 'Endpoint not found',
        'path': request.uri.path
      }));
      await request.response.close();
    }
  } catch (e) {
    print('❌ Error handling request: $e');
    if (request.response.persistentConnection) {
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write(jsonEncode({
        'error': 'Internal server error',
        'details': e.toString()
      }));
      await request.response.close();
    }
  }
}

Future<void> serveFile(HttpRequest request, String filePath) async {
  try {
    final file = File(filePath);
    if (!await file.exists()) {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write(jsonEncode({
        'error': 'File not found',
        'path': filePath
      }));
    } else {
      final content = await file.readAsString();
      request.response.statusCode = HttpStatus.ok;
      request.response.write(content);
      print('✅ Served: $filePath');
    }
  } catch (e) {
    print('❌ Error serving file $filePath: $e');
    request.response.statusCode = HttpStatus.internalServerError;
    request.response.write(jsonEncode({
      'error': 'Error reading file',
      'path': filePath,
      'details': e.toString()
    }));
  } finally {
    if (request.response.persistentConnection) {
      await request.response.close();
    }
  }
}

Future<void> serveGameDetails(HttpRequest request, String gameId) async {
  try {
    final gameDetails = {
      'id': gameId,
      'title': 'Game $gameId',
      'description': 'An amazing gaming experience awaits you!',
      'rating': 4.8,
      'players': '1M+',
      'genre': 'Adventure',
      'imageUrl': 'https://picsum.photos/400/300?random=$gameId',
      'screenshots': [
        'https://picsum.photos/400/300?random=${gameId}1',
        'https://picsum.photos/400/300?random=${gameId}2',
        'https://picsum.photos/400/300?random=${gameId}3',
      ]
    };

    request.response.statusCode = HttpStatus.ok;
    request.response.write(jsonEncode(gameDetails));
  } catch (e) {
    print('❌ Error serving game details: $e');
    request.response.statusCode = HttpStatus.internalServerError;
    request.response.write(jsonEncode({
      'error': 'Error getting game details',
      'gameId': gameId,
      'details': e.toString()
    }));
  } finally {
    if (request.response.persistentConnection) {
      await request.response.close();
    }
  }
}
