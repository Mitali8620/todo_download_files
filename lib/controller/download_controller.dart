import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../model/download_model.dart';

ValueNotifier<List<DownloadModel>> downloadDataList = ValueNotifier([]);

class DownloadCtr extends GetxController {
  @override
  void onInit() {
    downloadDataList.value = [
      DownloadModel(
          downloadPer: '0',
          fileUrl: 'https://research.nhm.org/pdfs/10592/10592-001.pdf'),
      DownloadModel(
          downloadPer: '0',
          fileUrl: 'https://research.nhm.org/pdfs/10592/10592-001.pdf'),
      DownloadModel(
          downloadPer: '0',
          fileUrl: 'https://research.nhm.org/pdfs/10592/10592-001.pdf'),
      DownloadModel(
          downloadPer: '0',
          fileUrl: 'https://research.nhm.org/pdfs/10592/10592-001.pdf')
    ];
    if (downloadDataList.value.first.downloadPer == '0') {
      onDownloadFile();
    }
    update();
    super.onInit();
  }

  Uint8List? documentBytes;
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
  final PdfViewerController pdfViewerController = PdfViewerController();
  File file = File('');
  String? localPath;
  TargetPlatform? platform;

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/storage/emulated/0/Download";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  Future<void> _prepareSaveDir() async {
    localPath = (await _findLocalPath())!;

    print(":localPath :: $localPath");
    final savedDir = Directory(localPath!);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<bool> saveFile(String url, String fileName, int i) async {
    try {
      localPath = (await _findLocalPath())!;

      final savedDir = Directory(localPath!);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }
      Dio().download(
        url,
        "$localPath/abc$i.pdf",
        onReceiveProgress: (count, total) {
          int percentage = ((count / total) * 100).floor();
          downloadDataList.value[i].downloadPer = percentage.toString();
          update();
          downloadDataList.notifyListeners();
          print('----------------------------------');
          print(i);
          print(file.path);
          print("file.path :: $localPath/abc$i.pdf");
          print(downloadDataList.value[i].downloadPer);
          print('---------------------------------');
        },
      ).whenComplete(() {
        documentBytes = Uint8List.fromList(
            File("$localPath/abc$i.pdf")
                .readAsBytesSync());
        print("documentBytes :: $documentBytes");
      });
      return true;
    } catch (e) {
      print("Exceptiion :: $e");
      return false;
    }
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }



  Future<void> onDownloadFile() async {
    bool check = await _checkPermission();
    if (check) {
      await _prepareSaveDir();
      for (int i = 0; i < downloadDataList.value.length; i++) {
        saveFile(downloadDataList.value[i].fileUrl ?? '',
            downloadDataList.value[i].fileUrl.toString().split('/').last, i);
      }



    } else {
      Get.snackbar('Error', 'Permission denied ',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
