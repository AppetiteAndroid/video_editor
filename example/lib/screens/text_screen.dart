// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:text_editor/text_editor.dart';

import 'package:video_editor/video_editor.dart';
import 'package:video_editor_example/fonts.dart';
import 'package:video_editor_example/screens/test.dart';

class TextScreen extends StatefulWidget {
  final VideoEditorController controller;
  final LindiController lindiController;
  const TextScreen({
    Key? key,
    required this.controller,
    required this.lindiController,
  }) : super(key: key);

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  late final LindiController controller = widget.lindiController;

  bool showEditor = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: const Text('Text'),
            actions: [
              IconButton(
                  onPressed: () async {
                    Uint8List? image = await controller.saveAsUint8List();
                    widget.controller.addOverlay(OverlayData(data: image!, start: Duration.zero, end: widget.controller.maxDuration));
                    Navigator.of(context).pop();
                    if (!mounted) return;
                  },
                  icon: const Icon(Icons.done))
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: Center(
                        child: CropGridViewer.preview(controller: widget.controller),
                      ),
                    ),
                    Positioned.fill(
                      child: LindiStickerWidget(
                        controller: controller,
                        child: SizedBox(
                          height: widget.controller.videoHeight,
                          width: widget.controller.videoWidth,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width - 32,
                child: ThumbnailSlider(
                  controller: widget.controller,
                  height: 60,
                  onlyTrimmed: true,
                ),
              )
            ],
          ),
          bottomNavigationBar: Container(
            width: double.infinity,
            height: 50,
            color: Colors.black,
            child: Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    showEditor = true;
                  });
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    Text(
                      "Add Text",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (showEditor)
          Scaffold(
            backgroundColor: Colors.black.withOpacity(0.85),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextEditor(
                  fonts: Fonts().list(),
                  textStyle: const TextStyle(color: Colors.white),
                  minFontSize: 10,
                  maxFontSize: 70,
                  onEditCompleted: (style, align, text) {
                    setState(() {
                      showEditor = false;
                      if (text.isNotEmpty) {
                        controller.addWidget(
                          Text(
                            text,
                            textAlign: align,
                            style: style,
                          ),
                        );
                      }
                    });
                  },
                ),
              ),
            ),
          )
      ],
    );
  }
}
