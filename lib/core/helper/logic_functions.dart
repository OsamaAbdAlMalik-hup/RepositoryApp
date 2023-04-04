
// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_lib;

class HelperLogicFunctions{

  static void printNote(Object? note) {
    print("=== $note ===");
  }

  static Future<File?> pickImage(ImageSource imageSource) async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedImage = await picker.getImage(source: imageSource);
    if(pickedImage!=null){
      return File(pickedImage.path);
    }
    return null;
  }

  static String upperFirstChar(String string){
    if(string.isNotEmpty) {
      return string.replaceFirst(string[0], string[0].toUpperCase());
    }
    return string;
  }

  static getVale({required Map map, required String key, required dynamic defaultVal}){
    if(map.containsKey(key) && map[key]!=null){
      if(defaultVal is double) {
        return double.parse(map[key].toString());
      }
      return map[key];
    }
    return defaultVal;
  }
  static getNestedVale({required Map map, required String firstKey, required String secondKey, required dynamic defaultVal}){
    if(map.containsKey(firstKey) && map[firstKey]!=null){
      if(map[firstKey].containsKey(secondKey)) {
        return map[firstKey][secondKey];
      }
    }
    return defaultVal;
  }

  static Future<String> saveFileToStorage(File file,String name, {bool visible = false}) async {
    Directory? directory = visible
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String extension=file.path.split('.').last;
    File savedFile = File(path_lib.join(directory!.path,"$name.$extension"));
    await savedFile.writeAsBytes(await file.readAsBytes());

    return savedFile.path;
  }
  static Future<void> deleteFileFromStorage(File file) async {
    await file.delete();
  }
  static Future<String> getFileFromAssets(String path, {bool visible = false}) async {
    final byteData = await rootBundle.load(path);
    Directory? directory = visible
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    final file = await File(path_lib.join(directory!.path,path)).create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file.path;
  }

  static Future<String> saveFileToStorageFromURL(String url, {bool visible = false}) async {
    Directory? directory = visible
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String filename = path.basename(url);
    String extension = path.extension(filename);
    final response = await http.get(Uri.parse(url));
    final file = File('${directory!.path}/${DateTime.now().millisecondsSinceEpoch}.$extension');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }
  static String listToColumns(List<String> columnsList) {
    String columns = "";
    if (columnsList.isEmpty) {
      return '*';
    }
    for (int i = 0; i < columnsList.length; i++) {
      if (i == columnsList.length - 1) {
        columns = "$columns ${columnsList[i]}";
        break;
      }
      columns = "$columns ${columnsList[i]},";
    }
    return columns;
  }
  static String listToValues(List valuesList) {
    String values = "";
    for (int i = 0; i < valuesList.length; i++) {
      if (i == valuesList.length - 1) {
        if (valuesList[i] is String) {
          values = "$values '${valuesList[i]}'";
        } else {
          values = '$values ${valuesList[i]}';
        }
        break;
      }
      if (valuesList[i] is String) {
        values = "$values '${valuesList[i]}',";
      } else {
        values = '$values ${valuesList[i]},';
      }
    }
    return values;
  }
  static String listsToColumnAndValue(List<String> columnsList, List valuesList) {
    String values = "";
    for (int i = 0; i < valuesList.length; i++) {
      if (i == valuesList.length - 1) {
        if (valuesList[i] is String) {
          values = "$values '${columnsList[i]}'='${valuesList[i]}'";
        } else {
          values = "$values '${columnsList[i]}'=${valuesList[i]}";
        }
        break;
      }
      if (valuesList[i] is String) {
        values = "$values '${columnsList[i]}'='${valuesList[i]}',";
      } else {
        values = "$values '${columnsList[i]}'=${valuesList[i]},";
      }
    }
    return values;
  }
}

