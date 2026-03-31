class Song {
  final int songID;
  final String songName;
  final String songArtist;
  final String songPath;

  final int? albumId;
  Song({
    required this.songID,
    required this.songArtist,
    required this.songName,
    required this.songPath,
    this.albumId,
  });
}
