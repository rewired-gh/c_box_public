import 'package:flutter/material.dart';

class CustomCardItem extends StatelessWidget {
  const CustomCardItem({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: child,
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem(
      {super.key,
      required this.title,
      this.leading,
      this.subtitle,
      this.showTailing = false,
      this.onTap,
      this.onLongPress});

  final String title;
  final bool showTailing;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Widget? leading;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final listTile = ListTile(
      title: Text(title),
      subtitle: subtitle,
      leading: leading,
      trailing: showTailing ? Icon(Icons.keyboard_arrow_right_rounded) : null,
      contentPadding: EdgeInsets.fromLTRB(16.0, 3.0, 12.0, 3.0),
      onTap: onTap,
      onLongPress: onLongPress,
    );
    return CustomCardItem(
      child: subtitle == null
          ? listTile
          : Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: listTile,
            ),
    );
  }
}
