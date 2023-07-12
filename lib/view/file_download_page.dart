import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_download_files/controller/download_controller.dart';
import 'file_preview_page.dart';

class FileDownloadPage extends StatelessWidget {
  FileDownloadPage({Key? key}) : super(key: key);
  final DownloadCtr downloadCtr = Get.put(DownloadCtr());

  @override
  Widget build(BuildContext context) {
    print("******************** FileDownloadPage *************************");
    return SafeArea(
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: downloadDataList,
          builder: (context, value, child) {
            return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {

                  Get.to(FilePreviewPage(filePath: downloadCtr.localPath ?? ""),
                      arguments: index);
                },
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10)),
                      child: LinearProgressIndicator(
                        backgroundColor: const Color(0xffd1d1d4),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xff0bae56)),
                        value:
                            double.parse(value[index].downloadPer.toString()) /
                                100,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    value[index].downloadPer.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
