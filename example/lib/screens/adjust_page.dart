import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';
import 'package:video_editor/video_editor.dart';

class AdjustPage extends StatefulWidget {
  final VideoEditorController controller;
  const AdjustPage({Key? key, required this.controller}) : super(key: key);
  @override
  State<AdjustPage> createState() => _AdjustPageState();
}

class _AdjustPageState extends State<AdjustPage> {
  late double brightness = widget.controller.adjustData.brightness;
  late double contrast = widget.controller.adjustData.contrast;
  late double saturation = widget.controller.adjustData.saturation;

  bool showBrightness = true;
  bool showContrast = false;
  bool showSaturation = false;

  late ColorFilterGenerator adj;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.setLatestAdjustFilter();
    super.dispose();
  }

  adjust({b, c, s}) {
    adj = ColorFilterGenerator(name: 'Adjust', filters: [
      ColorFilterAddons.brightness(b ?? brightness),
      ColorFilterAddons.contrast(c ?? contrast),
      ColorFilterAddons.saturation(s ?? saturation),
    ]);
    widget.controller.setAdjustFilter(b ?? brightness, c ?? contrast, s ?? saturation);
  }

  showSlider({b, c, s, h, se}) {
    setState(() {
      showBrightness = b != null ? true : false;
      showContrast = c != null ? true : false;
      showSaturation = s != null ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              widget.controller.saveAdjustFilter();
              Navigator.pop(context);
            },
            icon: Center(
              child: Text(
                "done",
                style: TextStyle(
                  color: const CropGridStyle().selectedBoundariesColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: CropGridViewer.preview(controller: widget.controller),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: showBrightness,
                        child: slider(
                          value: brightness,
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              brightness = value;
                              adjust(b: brightness);
                            });
                          },
                          max: 1.0,
                          min: -1.0,
                        ),
                      ),
                      Visibility(
                        visible: showContrast,
                        child: slider(
                          value: contrast,
                          onChanged: (value) {
                            setState(() {
                              contrast = value;
                              adjust(c: contrast);
                            });
                          },
                          max: 1000.0,
                          min: -1000.0,
                        ),
                      ),
                      Visibility(
                        visible: showSaturation,
                        child: slider(
                          value: saturation,
                          onChanged: (value) {
                            setState(() {
                              saturation = value;
                              adjust(s: saturation);
                            });
                          },
                          max: 3.0,
                          min: 0.0,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  child: const Text(
                    'RESET',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      brightness = 0;
                      contrast = 1;
                      saturation = 1;
                      adjust(b: brightness, c: contrast, s: saturation);
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        color: Colors.black,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _bottomBatItem(Icons.brightness_4_rounded, 'Brightness', color: showBrightness ? Colors.blue : null, onPress: () {
                  showSlider(b: true);
                }),
                _bottomBatItem(Icons.contrast, 'Contrast', color: showContrast ? Colors.blue : null, onPress: () {
                  showSlider(c: true);
                }),
                _bottomBatItem(Icons.water_drop, 'Saturation', color: showSaturation ? Colors.blue : null, onPress: () {
                  showSlider(s: true);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBatItem(IconData icon, String title, {Color? color, required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color ?? Colors.white),
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(color: color ?? Colors.white70),
            )
          ],
        ),
      ),
    );
  }

  Widget slider({value, onChanged, max = 1, min = -0.9}) {
    return Slider(label: '${value.toStringAsFixed(2)}', value: value, max: max, min: min, onChanged: onChanged);
  }
}
