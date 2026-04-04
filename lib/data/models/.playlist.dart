class Playlist {
  final String id;
  String name;
  List<int> songIds;

  Playlist({
    required this.id,
    required this.name,
    required this.songIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'songIds': songIds,
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] as String,
      name: map['name'] as String,
      songIds: List<int>.from(map['songIds'] as List),
    );
  }

  Playlist copyWith({
    String? name,
    List<int>? songIds,
  }) {
    return Playlist(
      id: id,
      name: name ?? this.name,
      songIds: songIds ?? this.songIds,
    );
  }
}