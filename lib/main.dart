import 'package:flutter/material.dart';
import 'package:open_media_station_base/helpers/app_helper.dart';
import 'package:open_media_station_book/globals.dart';

Future main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  AppHelper.start(args, Globals.gallery, "Open Media Station");
}
