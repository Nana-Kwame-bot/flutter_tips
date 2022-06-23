// Want to support my work 🤝? https://buymeacoffee.com/vandad

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

const rawBlobRoot =
    'https://raw.githubusercontent.com/vandadnp/flutter-tips-and-tricks/main/';

void getTips() async {
  final url = Uri.https('bit.ly', '/2V1GKsC');
  try {
    // final client = HttpClient();
    // final request = await client.getUrl(url);
    // log("Request: $request");
    var dio = Dio();
    final response =
        await dio.getUri<String>(url, onReceiveProgress: ((count, total) {
      debugPrint("Count: $count Total: $total");
    }));
    // dio.close();
    final data = response.data as String;
    final split = data.split('\n').map((e) => e.trim()).toList();

    split.retainWhere((element) => element.endsWith('.dart)'));
    final replaced = split.map((e) => e.replaceAll('[Source Code](', ''));
    final replacement = replaced.map((e) => e.replaceAll(')', ''));
    debugPrint("${replacement.toList()}");

    // split.retainWhere((s) => s.endsWith('.jpg)'));
    // final replaced = split.map((e) => e.replaceAll('![](', ''));
    // final replacement = replaced.map((e) => e.replaceAll(')', ''));
    // debugPrint("IMAGES: ${replacement.toList()}");
    final images = replacement.toList();
    // final images = await client
    //     .getUrl(url)
    //     .then((req) => req.close())
    //     .then((resp) => resp.transform(utf8.decoder).join())
    //     .then((body) => body.split('\n').map((e) => e.trim()))
    //     .then((iter) => iter.toList())
    //     .then((list) => list..retainWhere((s) => s.endsWith('.jpg)')))
    //     .then((imageList) => imageList.map((e) => e.replaceAll('![](', '')))
    //     .then((imageList) => imageList.map((e) => e.replaceAll(')', '')))
    //     .then((iter) => iter.toList());

    final found = images[Random().nextInt(images.length)];
    final result = '$rawBlobRoot$found';
    debugPrint("Result: $result");
    final path = await _getPath(found);
    debugPrint("Path: $path");
    dio.download(result, path);
    // await _launchURL(result);
    // await Process.run('open', [result]);

    // exit(0);
  } catch (e) {
    debugPrint("Error: $e");
    // stderr.writeln('Could not proceed due to $e');
    // exit(1);
  }
}

Future<String> _getPath(String fileName) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  return "$appDocPath/$fileName";
}

_launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}
