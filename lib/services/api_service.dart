import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';

class ImageListProvider with ChangeNotifier {
  List<ImageModel> _images = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  List<ImageModel> get images => _images;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchImages({int page = 1}) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://picsum.photos/v2/list?page=$page');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          _hasMore = false;
        } else {
          if (page == 1) {
            _images = data.map((json) => ImageModel.fromJson(json)).toList();
          } else {
            _images.addAll(data.map((json) => ImageModel.fromJson(json)).toList());
          }
        }
      } else {
        throw Exception('Failed to load images');
      }
    } catch (error) {
      throw Exception('Error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextPage() async {
    if (_hasMore && !_isLoading) {
      _currentPage++;
      await fetchImages(page: _currentPage);
    }
  }
}
