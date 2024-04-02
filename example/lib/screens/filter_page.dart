// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:video_editor/video_editor.dart';

class FilterPage extends StatefulWidget {
  final VideoEditorController controller;
  const FilterPage({
    Key? key,
    required this.controller,
  }) : super(key: key);
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late Filter currentFilter;
  late List<Filter> filters;

  @override
  void initState() {
    filters = Filters().list();
    currentFilter = widget.controller.selectedFilter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              widget.controller.setFilter(currentFilter);
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
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 100,
        color: Colors.black,
        child: SafeArea(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            itemBuilder: (BuildContext context, int index) {
              Filter filter = filters[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: InkWell(
                          onTap: () {
                            widget.controller.setFilter(filters[index]);
                          },
                          child: ColorFiltered(
                            colorFilter: ColorFilter.matrix(filter.matrix),
                            child: const Icon(
                              Icons.abc,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      filter.filterName,
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
