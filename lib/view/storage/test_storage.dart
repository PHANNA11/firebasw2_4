import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageImage extends StatefulWidget {
  const StorageImage({super.key});

  @override
  State<StorageImage> createState() => _StorageImageState();
}

class _StorageImageState extends State<StorageImage> {
  String? image;
  final storageRef = FirebaseStorage.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Image'),
      ),
      body: Center(
        child: image == null
            ? SizedBox()
            : Image(image: NetworkImage(image.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final refImage = await storageRef
              .child(
                  "image/358364702_621026430006236_7936655231217583563_n.jpg")
              .getDownloadURL();
          setState(() {
            image = refImage;
          });
        },
        child: Icon(Icons.download),
      ),
    );
  }
}
