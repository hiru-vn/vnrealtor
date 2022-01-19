import 'package:collection/collection.dart' show IterableExtension;
import 'package:html/dom.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:html/parser.dart';

class UrlPreviewData {
  String? title;
  String? description;
  String? siteName;
  String? image;
  String? url;

  UrlPreviewData(
      {this.title, this.description, this.siteName, this.image, this.url});
}

Future<UrlPreviewData?> getUrlData(String url) async {
  try {
    final store = DefaultCacheManager();
    var response = await store.getSingleFile(url).catchError((error) {
      return null;
    });

    var document = parse(await response.readAsString());

    final data = UrlPreviewData(
        title: _extractOGData(document, 'og:title'),
        description: _extractOGData(document, 'og:description'),
        siteName: _extractOGData(document, 'og:site_name'),
        image: _extractOGData(document, 'og:image'),
        url: url);
    return data;
  } catch (e) {
    return null;
  }
}

String? _extractOGData(Document document, String parameter) {
  var titleMetaTag = document
      .getElementsByTagName("meta")
      .firstWhereOrNull((meta) => meta.attributes['property'] == parameter);
  if (titleMetaTag != null) {
    return titleMetaTag.attributes['content'];
  }
  return null;
}
