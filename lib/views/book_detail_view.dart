import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_media_station_base/apis/stream_api.dart';
import 'package:open_media_station_base/models/internal/grid_item_model.dart';
import 'package:open_media_station_base/widgets/favorite_button.dart';
import 'package:open_media_station_book/services/inventory_service.dart';
import 'package:open_media_station_book/views/book_detail_content.dart';

class BookDetailView extends StatelessWidget {
  const BookDetailView({super.key, required this.gridItem});

  final GridItemModel gridItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        actions: [
          FavoriteButton(
            inventoryItem: gridItem.inventoryItem,
            isFavorite: gridItem.isFavorite,
          ),
        ],
      ),
      body: FutureBuilder<(GridItemModel, Uint8List?)>(
        // Tuple type
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Grid item could not be loaded'));
          }

          // Destructure the tuple
          final (book, extraData) = snapshot.data!;

          return BookDetailContent(itemModel: book, epubBytes: extraData);
        },
      ),
    );
  }

  Future<(GridItemModel, Uint8List?)> _fetchData() async {
    final book = await InventoryService.getBook(gridItem.inventoryItem!);
    if (book.inventoryItem?.id == null) {
      return (book, null);
    }

    final epubBytes =
        await StreamApi.downloadBytes("Book", book.inventoryItem!.id);

    return (book, epubBytes);
  }
}
