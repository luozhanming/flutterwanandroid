import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show  Codec;
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';


///带本地缓存功能的NetworkImage
class MyNetWorkImage extends ImageProvider<NetworkImage> implements NetworkImage {
  const MyNetWorkImage(this.url,
      {this.scale = 1.0, this.headers, this.sdCache = false})
      : assert(url != null),
        assert(scale != null);

  @override
  final String url;

  @override
  final double scale;

  @override
  final Map<String, String> headers;

  final bool sdCache;

  static final HttpClient _sharedHttpClient = HttpClient()
    ..autoUncompress = false;

  static HttpClient get _httpClient {
    HttpClient client = _sharedHttpClient;
    assert(() {
      if (debugNetworkImageHttpClientProvider != null)
        client = debugNetworkImageHttpClientProvider();
      return true;
    }());
    return client;
  }

  @override
  ImageStreamCompleter load(NetworkImage key, decode) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key as MyNetWorkImage, chunkEvents, decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<MyNetWorkImage>('Image key', key),
        ];
      },
    );
  }

  @override
  Future<NetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<NetworkImage>(this);
  }

   Future<ui.Codec> _loadAsync(MyNetWorkImage key, StreamController<ImageChunkEvent> chunkEvents,
      decode) async {
    try {
      assert(key == this);
      if (sdCache != null) {
        final Uint8List bytes = await _getFromSdcard(key.url);
        if (bytes != null &&
            bytes.lengthInBytes != null &&
            bytes.lengthInBytes != 0) {
          return await PaintingBinding.instance.instantiateImageCodec(bytes);
        }
      }
      final Uri resolved = Uri.base.resolve(key.url);
      final HttpClientRequest request = await _httpClient.getUrl(resolved);
      headers?.forEach((String name, String value) {
        request.headers.add(name, value);
      });
      final HttpClientResponse response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        // The network may be only temporarily unavailable, or the file will be
        // added on the server later. Avoid having future calls to resolve
        // fail to check the network again.
        PaintingBinding.instance.imageCache.evict(key);
        throw NetworkImageLoadException(
            statusCode: response.statusCode, uri: resolved);
      }

      final Uint8List bytes = await consolidateHttpClientResponseBytes(
        response,
        onBytesReceived: (int cumulative, int total) {
          chunkEvents.add(ImageChunkEvent(
            cumulativeBytesLoaded: cumulative,
            expectedTotalBytes: total,
          ));
        },
      );
      if (sdCache != null && bytes.lengthInBytes != 0) {
        _saveToImage(bytes, key.url);
      }
      if (bytes.lengthInBytes == 0)
        throw Exception('NetworkImage is an empty file: $resolved');

      return decode(bytes);
    } finally {
      chunkEvents.close();
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyNetWorkImage && url == other.url && scale == other.scale;

  @override
  int get hashCode => url.hashCode ^ scale.hashCode;

  _getFromSdcard(String url) async{
    url = md5.convert(utf8.encode(url)).toString();
    var directory = await getTemporaryDirectory();
    String path = directory.path + "/" + url;
    var file = File(path);
    bool exist = await file.exists();
    if (exist) {
      final Uint8List bytes = await file.readAsBytes();
      return bytes;
    } else {
      return null;
    }
  }

  _saveToImage(Uint8List bytes, String url) async {
    url = md5.convert(utf8.encode(url)).toString();
    Directory dir = await getTemporaryDirectory();
    String path = dir.path +"/"+url;
    var file = File(path);
    bool exist =  await file.exists();
    if(!exist)
      File(path).writeAsBytesSync(bytes);
  }
}
