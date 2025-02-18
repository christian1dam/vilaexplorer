import 'package:flutter/material.dart';

class CustomDraggableScrollableSheet extends StatefulWidget {
  final BuildContext context;
  final Widget Function(ScrollController, BoxConstraints) builder;

  const CustomDraggableScrollableSheet({super.key, required this.builder, required this.context});

  @override
  _CustomDraggableScrollableSheetState createState() =>
      _CustomDraggableScrollableSheetState();
}

class _CustomDraggableScrollableSheetState
    extends State<CustomDraggableScrollableSheet> {
  final DraggableScrollableController controller =
      DraggableScrollableController();
  final GlobalKey sheetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller.addListener(_onSizeChanged);
  }

  void _onSizeChanged() {
    if (controller.size < 0.3) {
      if (Navigator.of(widget.context).canPop()) {
        Navigator.of(widget.context).pop();
      }
    }
  }

  void collapse() => animateSheet(getSheet.snapSizes!.first);
  void anchor() => animateSheet(getSheet.snapSizes!.last);
  void expand() => animateSheet(getSheet.maxChildSize);
  void hide() => animateSheet(getSheet.minChildSize);

  void animateSheet(double size) {
    controller.animateTo(
      size,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  DraggableScrollableSheet get getSheet => (sheetKey.currentWidget as DraggableScrollableSheet);

  @override
  void dispose() {
    controller.removeListener(_onSizeChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DraggableScrollableSheet(
          key: sheetKey,
          initialChildSize: 0.65,
          maxChildSize: 1,
          minChildSize: 0,
          expand: false,
          snap: true,
          snapSizes: [
            0, 0.65
          ],
          controller: controller,
          builder: (BuildContext context, ScrollController scrollController) {
            return widget.builder(scrollController, constraints);
          },
        );
      },
    );
  }
}
