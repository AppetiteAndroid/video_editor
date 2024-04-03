// ignore_for_file: public_member_api_docs, sort_constructors_first
class AdjustData {
  final double brightness;
  final double contrast;
  final double saturation;
  AdjustData({
    required this.brightness,
    required this.contrast,
    required this.saturation,
  });

  factory AdjustData.defaultValues() {
    return AdjustData(brightness: 0, contrast: 1, saturation: 1);
  }

  bool get isDefault => brightness == 0 && contrast == 1 && saturation == 1;
}
