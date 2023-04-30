import 'package:flutter/material.dart';

import 'package:omegle_clone/constants/numerics.dart';

class ActionButton extends StatefulWidget {
  final PageController controller;
  final bool isBusy;
  final VoidCallback onPressed;

  const ActionButton({
    Key? key,
    required this.controller,
    required this.isBusy,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  double _xOffset = -.5;

  final double _minimumIconSize = .8;
  final double _minimumIconOpacity = .6;

  double _activePage = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controller.addListener(() {
        if (!widget.controller.hasClients) return;

        if (widget.controller.page != null) {
          _activePage = widget.controller.page!;
        }
        // interpolates from .5 to 5
        _xOffset = _activePage - .5;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: double.infinity,
          height: floatingButtonSize,
          color: Colors.transparent,
          margin: EdgeInsets.only(bottom: 15),
          child: Stack(
            children: [
              Center(
                child: Container(
                  decoration: widget.isBusy
                      ? null
                      : BoxDecoration(
                          border: Border.all(
                            color: Colors.black26,
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                        ),
                  child: widget.isBusy
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
                            opacity: 1 - _activePage < _minimumIconOpacity
                                ? _minimumIconOpacity
                                : 1 - _activePage,
                            child: Transform.scale(
                              scale: 1 - _activePage < _minimumIconSize
                                  ? _minimumIconSize
                                  : 1 - _activePage,
                              child: Image.asset(
                                "images/video_call.png",
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(width: 20),
                        Expanded(
                          child: Opacity(
                            opacity: _activePage < _minimumIconOpacity
                                ? _minimumIconOpacity
                                : _activePage,
                            child: Transform.scale(
                              scale: _activePage < _minimumIconSize
                                  ? _minimumIconSize
                                  : _activePage,
                              child: Image.asset(
                                "images/chat.png",
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
