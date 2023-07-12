import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_download_files/view/file_download_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () => Get.to(FileDownloadPage()),
            child: const Text("Go with download")),
      ),
    );
  }
}
