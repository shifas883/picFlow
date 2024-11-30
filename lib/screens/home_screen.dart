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
  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions(skipIfExists: false);
    Provider.of<ImageListProvider>(context, listen: false).fetchImages();
  }
  final List<double> heights = [
    150, 200, 250, 300, 180, 240, 170, 220, 150,200,
    150, 200, 250, 300, 180, 240, 170, 220, 150,200,
    150, 200, 250, 300, 180, 240, 170, 220, 150,200];

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
            child: Text('Follow',
            style: GoogleFonts.roboto(
              color: Colors.white
            ),),
          ),
        ],
      ),
      body: imageProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with buttons
          Container(
            color: Colors.black,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTabButton('Activity', isSelected: false),
                  _buildTabButton('Community', isSelected: false),
                  _buildTabButton('Shop', isSelected: true),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'All Images(${imageProvider.images.length})',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double itemWidth =
                      (constraints.maxWidth - 16) / 2; // 2 columns
                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: _buildStaggeredGrid(itemWidth, imageProvider.images),
                  );
                },
              ),
            ),
          ),
        ],
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

  List<Widget> _buildStaggeredGrid(double itemWidth, List<ImageModel>? images) {
    List<Widget> column1 = [];
    List<Widget> column2 = [];
    bool addToLeft = true;

    for (int i = 0; i < images!.length; i++) {
      final imageUrl = images[i].downloadUrl ??
          'https://images.pexels.com/photos/60597/dahlia-red-blossom-bloom-60597.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

      final item = GestureDetector(
        onTap: () => _saveImageToGallery(imageUrl),
        child: Container(
          width: itemWidth,
          height: heights[i],
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            // color: Colors.primaries[i % Colors.primaries.length],
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

      if (addToLeft) {
        column1.add(item);
      } else {
        column2.add(item);
      }
      addToLeft = !addToLeft;
    }

    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(children: column1)),
          const SizedBox(width: 8),
          Expanded(child: Column(children: column2)),
        ],
      ),
    ];
  }

  Future<void> _saveImageToGallery(String imageUrl) async {
    // Check and request permissions
    bool permissionGranted = await _checkAndRequestPermissions(skipIfExists: false);

    if (!permissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permissions not granted!")),
      );
      return;
    }

    try {
      // Download the image
      var response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Save the image
      final imageName = imageUrl.split('/').last;
      final result = await SaverGallery.saveImage(
        Uint8List.fromList(response.data),
        quality: 80,
        fileName: imageName,
        androidRelativePath: "Pictures/MyApp/images",
        skipIfExists: false,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image saved to gallery")),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving image: $e")),
      );
    }
  }

  Future<bool> _checkAndRequestPermissions({required bool skipIfExists}) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return false; // Only Android and iOS platforms are supported
    }

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (skipIfExists) {
        // Read permission is required to check if the file already exists
        return sdkInt >= 33
            ? await Permission.photos.request().isGranted
            : await Permission.storage.request().isGranted;
      } else {
        // No read permission required for Android SDK 29 and above
        return sdkInt >= 29 ? true : await Permission.storage.request().isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS permission for saving images to the gallery
      return skipIfExists
          ? await Permission.photos.request().isGranted
          : await Permission.photosAddOnly.request().isGranted;
    }

    return false; // Unsupported platforms
  }
}
