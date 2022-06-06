import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? icon;
  const ActionButton({Key? key, @required this.onPressed, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(),
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      color: Theme.of(context).colorScheme.secondary,
      child: IconButton(
        icon: icon!,
        onPressed: onPressed,
      ),
    );
  }
}
