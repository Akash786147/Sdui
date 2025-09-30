# Server-Driven UI Mock Server

This folder contains mock server responses for the Gaming App's SDUI implementation.

## Overview

The SDUI Gaming App uses JSON configurations from the server to dynamically render the UI. This approach allows for instant updates without app releases.

## File Structure

- `api/home_screen.json` - Home screen UI configuration
- `api/game_list.json` - Game list configuration  
- `api/game_details.json` - Individual game details
- `server.dart` - Mock HTTP server (optional, for local testing)

## How It Works

1. The Flutter app makes HTTP requests to fetch UI configurations
2. Server responds with JSON containing widget definitions
3. SDUI package parses JSON and renders the UI dynamically
4. Update JSON files to change the app UI instantly

## Local Testing

You can use the mock JSON files directly in the app or run a local server:

```bash
dart server/server.dart
```

## Production Setup

In production, host these JSON files on your backend server (e.g., Node.js, Django, Firebase, etc.) and update the API URLs in the Flutter app.
