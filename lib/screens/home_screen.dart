import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinterest_clone/models/image_model.dart';
import 'package:pinterest_clone/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:saver_gallery/saver_gallery.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<ImageModel> _imageList;
  late List<double> _heights;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions(skipIfExists: false);
    final provider = Provider.of<ImageListProvider>(context, listen: false);
    provider.fetchImages().then((_) {
      setState(() {
        _imageList = provider.images;
        _heights = List.generate(
            _imageList.length, (index) => 150 + (index % 5) * 30.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageListProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Icon(Icons.arrow_back, color: Colors.white),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('asset/man.png'),
          ),
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Follow',
              style: GoogleFonts.roboto(color: Colors.white),
            ),
          ),
        ],
      ),
      body: imageProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabBar(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'All Images(${_imageList.length})',
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _buildReorderableStaggeredList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTabButton('Activity', isSelected: false),
            _buildTabButton('Community', isSelected: false),
            _buildTabButton('Shop', isSelected: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildReorderableStaggeredList() {
    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = _imageList.removeAt(oldIndex);
          final height = _heights.removeAt(oldIndex);
          _imageList.insert(newIndex, item);
          _heights.insert(newIndex, height);
        });
      },
      padding: const EdgeInsets.all(8.0),
      children: List.generate(_imageList.length, (index) {
        return _buildStaggeredItem(index);
      }),
    );
  }

  Widget _buildStaggeredItem(int index) {
    final imageUrl = _imageList[index].downloadUrl ??
        'https://images.pexels.com/photos/60597/dahlia-red-blossom-bloom-60597.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

    return GestureDetector(
      key: ValueKey(_imageList[index]),
      onTap: () => _saveImageToGallery(imageUrl),
      child: Container(
        height: _heights[index],
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Future<void> _saveImageToGallery(String imageUrl) async {
    bool permissionGranted =
    await _checkAndRequestPermissions(skipIfExists: false);

    if (!permissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permissions not granted!")),
      );
      return;
    }

    try {
      var response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final imageName = imageUrl.split('/').last;
      await SaverGallery.saveImage(
        Uint8List.fromList(response.data),
        quality: 80,
        fileName: imageName,
        androidRelativePath: "Pictures/MyApp/images",
        skipIfExists: false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image saved to gallery")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving image: $e")),
      );
    }
  }

  Future<bool> _checkAndRequestPermissions({required bool skipIfExists}) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return false;
    }

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      return sdkInt >= 29 ? true : await Permission.storage.request().isGranted;
    } else if (Platform.isIOS) {
      return await Permission.photosAddOnly.request().isGranted;
    }

    return false;
  }
}
