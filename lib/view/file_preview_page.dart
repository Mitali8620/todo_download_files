import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:todo_download_files/controller/download_controller.dart';

class FilePreviewPage extends StatelessWidget {
  String filePath;

  FilePreviewPage({Key? key, required this.filePath}) : super(key: key);
  final DownloadCtr downloadCtr = Get.find<DownloadCtr>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("File Preview")),
      body: ValueListenableBuilder(
        valueListenable: downloadDataList,
        builder: (context, value, child) {
          return Get.arguments == null
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              value[Get.arguments].downloadPer.toString(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15),
                            ),
                          ),
                          Container(
                            height: 15,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(10)),
                            child: LinearProgressIndicator(
                              backgroundColor: const Color(0xffd1d1d4),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xff0bae56)),
                              value: double.parse(value[Get.arguments]
                                      .downloadPer
                                      .toString()) /
                                  100,
                            ),
                          ),
                        ],
                      ),
                      (downloadCtr.documentBytes == null)
                          ? const SizedBox()
                          : Expanded(
                              child: SfPdfViewer.memory(
                                downloadCtr.documentBytes!,
                                key: downloadCtr.pdfViewerKey,
                                canShowScrollHead: true,
                                canShowScrollStatus: true,
                                canShowHyperlinkDialog: true,
                                enableHyperlinkNavigation: true,
                                controller: downloadCtr.pdfViewerController,
                                enableTextSelection: true,
                                pageLayoutMode: PdfPageLayoutMode.continuous,
                                onTextSelectionChanged:
                                    (PdfTextSelectionChangedDetails details) {},
                                currentSearchTextHighlightColor:
                                    Colors.blue.shade50,
                                otherSearchTextHighlightColor:
                                    Colors.yellowAccent.shade100,
                                enableDoubleTapZooming: true,
                              ),
                            )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
