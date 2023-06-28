import 'package:flutter/material.dart';

class AnimeModel {
  final int id;
  final String bannerImage;
  final AnimeTitleModel title;
  final String type;
  final List<String> genres;

  AnimeModel({
    required this.id,
    required this.bannerImage,
    required this.title,
    required this.type,
    required this.genres,
  });
}

class AnimeTitleModel {
  final String english;

  AnimeTitleModel({required this.english});
}
