// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:video_editor/video_editor.dart';

class TrimPage extends StatefulWidget {
  final VideoEditorController controller;
  const TrimPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<TrimPage> createState() => _TrimPageState();
}

class _TrimPageState extends State<TrimPage> {
  final double height = 60;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
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
            child: CropGridViewer.preview(controller: widget.controller),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _trimSlider(),
          ),
        ],
      ),
    );
  }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
        duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0')
      ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: Listenable.merge([
          widget.controller,
          widget.controller.video,
        ]),
        builder: (_, __) {
          final int duration = widget.controller.videoDuration.inMilliseconds;
          final double pos = widget.controller.trimPosition * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(formatter(Duration(milliseconds: pos.toInt()))),
              const Expanded(child: SizedBox()),
              AnimatedOpacity(
                opacity: widget.controller.isTrimming ? 1 : 0,
                duration: kThemeAnimationDuration,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(formatter(widget.controller.startTrim)),
                  const SizedBox(width: 10),
                  Text(formatter(widget.controller.endTrim)),
                ]),
              ),
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
          controller: widget.controller,
          height: height,
          horizontalMargin: height / 4,
        ),
      )
    ];
  }
}
