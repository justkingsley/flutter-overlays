
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

mixin OverlayStateMixin<T extends StatefulWidget> on State<T>{

  OverlayEntry? _overlayEntry;

  void removeOverlay(){
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _dismissibleOverlay(Widget child) => Stack(
    children: [
      Positioned.fill(child: ColoredBox(
        color: AppColors.barrierColor,
        child: GestureDetector(
          onTap: removeOverlay,
          ),
        ),
      ),
      child,
    ],
  );

}