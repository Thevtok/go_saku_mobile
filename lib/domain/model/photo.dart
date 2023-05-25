class Photo {
  final int photoId;
  final String userId;
  final String url;

  Photo({required this.photoId, required this.userId, required this.url});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      photoId: json['photo_id'],
      userId: json['user_id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo_id': photoId,
      'user_id': userId,
      'url': url,
    };
  }
}
