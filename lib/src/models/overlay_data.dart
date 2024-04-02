import 'dart:typed_data';

class OverlayData {
  final Uint8List data;
  final Duration start;
  final Duration end;

  OverlayData({required this.data, required this.start, required this.end});
}
