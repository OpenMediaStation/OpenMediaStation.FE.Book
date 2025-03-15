import 'package:flutter/material.dart';
import 'package:open_media_station_base/models/internal/grid_item_model.dart';
import 'package:open_media_station_base/widgets/favorite_button.dart';
import 'package:open_media_station_book/services/inventory_service.dart';
import 'package:open_media_station_book/views/book_detail_content.dart';

class BookDetailView extends StatelessWidget {
  const BookDetailView({super.key, required this.gridItem});

  final GridItemModel gridItem;

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (!gridItem.fake) {
      body = BookDetailContent(itemModel: gridItem);
    } else {
      body = FutureBuilder<GridItemModel>(
        future: InventoryService.getBook(gridItem.inventoryItem!),
        builder: (context, snapshot) {
          GridItemModel gridItem;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Grid item could not be loaded'));
          } else {
            gridItem = snapshot.data!;
          }

          return BookDetailContent(itemModel: gridItem);
        },
      );
    }

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
      body: body,
    );
  }
}
