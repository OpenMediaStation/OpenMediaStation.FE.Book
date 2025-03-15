import 'package:flutter/material.dart';
import 'package:open_media_station_base/views/gallery.dart';
import 'package:open_media_station_book/services/inventory_service.dart';
import 'package:open_media_station_book/views/book_detail_view.dart';
import 'package:open_media_station_book/views/settings.dart';

class Globals {
  static String Title = "Open Media Station";
  static String PictureNotFoundUrl =
      "https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg";
  static Gallery gallery = Gallery(
    gridItemAspectRatio: 0.6,
    getInventoryItems: InventoryService.getInventoryItems,
    appTitle: Globals.Title,
    settings: const Settings(),
    additionalWidgets: const [],
    getGridItemModel: InventoryService.getBook,
    onGridItemTap: (context, inventoryItem, gridItem) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          if (inventoryItem.category == "Book") {
            return BookDetailView(
              gridItem: gridItem,
            );
          }

          throw ArgumentError("Server models not correct");
        }),
      );
    },
    pictureNotFoundUrl: Globals.PictureNotFoundUrl,
    setFilter: null,
  );
}
