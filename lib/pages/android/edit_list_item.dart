import 'package:flutter/material.dart';
import 'package:totp/totp.dart';

class EditListItem extends StatefulWidget {
  const EditListItem(this.item, this.addRemovalItem, this.removeRemovalItem,
      {super.key});

  final TOTPItem item;
  final Function addRemovalItem;
  final Function removeRemovalItem;

  @override
  State<StatefulWidget> createState() {
    return _EditListItem();
  }
}

class _EditListItem extends State<EditListItem> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Hero(
      key: widget.key,
      tag: widget.item.id,
      child: Card(
        child: CheckboxListTile(
          secondary: const Icon(Icons.drag_handle),
          onChanged: (e) {
            if (e == true) {
              widget.addRemovalItem(widget.item.id);
            } else {
              widget.removeRemovalItem(widget.item.id);
            }

            setState(() {
              _value = e!;
            });
          },
          value: _value,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item.issuer,
                    style: Theme.of(context).textTheme.titleMedium),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(widget.item.placeHolder,
                      style: Theme.of(context).textTheme.displaySmall),
                ),
                Text(widget.item.accountName,
                    style: Theme.of(context).textTheme.bodyMedium)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
