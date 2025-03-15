import 'package:open_media_station_base/apis/favorites_api.dart';
import 'package:open_media_station_base/apis/inventory_api.dart';
import 'package:open_media_station_base/apis/metadata_api.dart';
import 'package:open_media_station_base/apis/progress_api.dart';
import 'package:open_media_station_base/models/internal/grid_item_model.dart';
import 'package:open_media_station_base/models/inventory/inventory_item.dart';
import 'package:open_media_station_base/models/metadata/metadata_model.dart';
import 'package:open_media_station_base/models/progress/progress.dart';
import 'package:open_media_station_book/globals.dart';

class InventoryService {
  static Future<List<InventoryItem>> getInventoryItems() async {
    InventoryApi inventoryApi = InventoryApi();

    var items = await inventoryApi.listItems("Book");

    items.sort((a, b) => a.title?.compareTo(b.title ?? '') ?? 0);
    return items;
  }

  static Future<GridItemModel> getBook(InventoryItem element) async {
    InventoryApi inventoryApi = InventoryApi();
    MetadataApi metadataApi = MetadataApi();
    FavoritesApi favoritesApi = FavoritesApi();
    ProgressApi progressApi = ProgressApi();

    var book = await inventoryApi.getBook(element.id);

    Future<MetadataModel?> metadataFuture = book.metadataId != null
        ? metadataApi.getMetadata(book.metadataId!, "Book")
        : Future.value(null);

    Future<bool?> favFuture = favoritesApi.isFavorited("Book", book.id);
    Future<Progress?> progressFuture =
        progressApi.getProgress("Book", book.id);

    var results = await Future.wait([metadataFuture, favFuture, progressFuture]);

    var metadata = results[0] as MetadataModel?;
    var fav = results[1] as bool?;
    var progress = results[2] as Progress?;

    var gridItem = GridItemModel(
      inventoryItem: book,
      metadataModel: metadata,
      isFavorite: fav,
      progress: progress,
    );

    gridItem.image = metadata?.book?.thumbnail ?? Globals.PictureNotFoundUrl;

    return gridItem;
  }

}
