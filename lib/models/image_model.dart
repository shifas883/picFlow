class ImageModel {
  final String id;
  final String author;
  final String url;
  final String downloadUrl;

  ImageModel({
    required this.id,
    required this.author,
    required this.url,
    required this.downloadUrl,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      author: json['author'],
      url: json['url'],
      downloadUrl: json['download_url'],
    );
  }
}
