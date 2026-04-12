import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ApiService {
  static final YoutubeExplode _yt = YoutubeExplode();

  /// Search YouTube and return a list of results
  /// Each result is a Map with: id, title, artist, thumbnail
  static Future<List<Map<String, String>>> searchSongs(String query) async {
    try {
      debugPrint('🔍 Searching YouTube for: "$query"');

      final results = await _yt.search.search('$query official audio');

      final tracks = results.map((video) {
        return {
          'id': video.id.value,
          'title': video.title,
          'artist': video.author,
          'thumbnail': video.thumbnails.standardResUrl,
          'duration': video.duration?.inSeconds.toString() ?? '0',
        };
      }).toList();

      debugPrint('✅ Found ${tracks.length} results for "$query"');
      return tracks;
    } catch (e) {
      debugPrint('❌ YouTube search error: $e');
      return [];
    }
  }

  /// Get a streamable audio URL from a YouTube video ID
  /// Returns null if extraction fails
  static Future<String?> getStreamUrl(String videoId) async {
    try {
      debugPrint('🎵 Getting stream URL for: $videoId');

      final manifest =
          await _yt.videos.streamsClient.getManifest(videoId);

      // Get the best audio-only stream
      final audioStream = manifest.audioOnly.withHighestBitrate();

      debugPrint('✅ Got stream URL');
      return audioStream.url.toString();
    } catch (e) {
      debugPrint('❌ Stream URL error: $e');
      return null;
    }
  }

  static void dispose() {
    _yt.close();
  }
}