class PlayerArguments {
  const PlayerArguments({
    required this.video,
    this.subtitles,
  });

  final Uri video;
  final Uri? subtitles;
}
