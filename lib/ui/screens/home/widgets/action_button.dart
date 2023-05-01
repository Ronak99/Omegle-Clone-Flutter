import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:omegle_clone/constants/numerics.dart';

class ActionButton extends ConsumerWidget {
  final double viewPage;
  final bool isBusy;
  final VoidCallback onPressed;

  const ActionButton({
    Key? key,
    required this.viewPage,
    required this.isBusy,
    required this.onPressed,
  }) : super(key: key);

  final double _minimumIconSize = .8;
  final double _minimumIconOpacity = .6;

  // double _activePage = 0;

  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     widget.controller.addListener(() {
  //       if (!widget.controller.hasClients) return;

  //       if (widget.controller.page != null) {
  //         _activePage = widget.controller.page!;
  //       }
  //       // interpolates from .5 to 5
  //       setState(() {});
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double _xOffset = viewPage - .5;

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          height: floatingButtonSize,
          color: Colors.transparent,
          margin: EdgeInsets.only(bottom: 15),
          child: Stack(
            children: [
              Center(
                child: Container(
                  decoration: isBusy
                      ? null
                      : BoxDecoration(
                          border: Border.all(
                            color: Colors.black26,
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                        ),
                  child: isBusy
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black26),
                          strokeWidth: 3,
                        )
                      : SizedBox.shrink(),
                  height: floatingButtonSize,
                  width: floatingButtonSize,
                ),
              ),
              Center(
                child: Transform.translate(
                  offset: Offset(-(floatingButtonSize * _xOffset), 0),
                  child: Container(
                    width: floatingButtonSize * 2,
                    height: floatingButtonSize,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Opacity(
                            opacity: 1 - viewPage < _minimumIconOpacity
                                ? _minimumIconOpacity
                                : 1 - viewPage,
                            child: Transform.scale(
                              scale: 1 - viewPage < _minimumIconSize
                                  ? _minimumIconSize
                                  : 1 - viewPage,
                              child: Image.asset(
                                "images/call_icon.png",
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(width: 20),
                        Expanded(
                          child: Opacity(
                            opacity: viewPage < _minimumIconOpacity
                                ? _minimumIconOpacity
                                : viewPage,
                            child: Transform.scale(
                              scale: viewPage < _minimumIconSize
                                  ? _minimumIconSize
                                  : viewPage,
                              child: Image.asset(
                                "images/chat_icon.png",
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
