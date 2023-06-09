// ignore_for_file: unnecessary_null_comparison

import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:totp/totp.dart' show TOTPItem;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './edit_list_item.dart' show EditListItem;

/// Android edit page.
class AndroidEditPage extends StatefulWidget {
  const AndroidEditPage(this.items, this._itemsChanged, this.replaceItems,
      {super.key});

  final Function replaceItems;
  final Function _itemsChanged;
  final List<TOTPItem> items;

  // Remove items with given ids
  void removeItems(List<String> itemIDs) {
    items.removeWhere((item) => itemIDs.contains(item.id));
  }

  // Whether items have changed
  bool get itemsChanged {
    return _itemsChanged(items);
  }

  @override
  State<StatefulWidget> createState() {
    return _EditPageState();
  }
}

class _EditPageState extends State<AndroidEditPage> {
  // Handles reorder of elements
  void _handleReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      widget.items.insert(newIndex, widget.items.removeAt(oldIndex));
      _refreshHide();
    });
  }

  // Hide bottom bar
  final ValueNotifier<bool> _hideTrash = ValueNotifier(true);
  // Whether to hide save icon
  final ValueNotifier<bool> _hideSave = ValueNotifier(true);

  // List of selected items (to be removed)
  final List<String> _pendingRemovalList = [];

  // Handles item check
  void addRemovalItem(String id) {
    _pendingRemovalList.add(id);
    _refreshHide();
  }

  // Handles item uncheck
  void removeRemovalItem(String id) {
    _pendingRemovalList.remove(id);
    _refreshHide();
  }

  // Refreshes value of _hide
  void _refreshHide() {
    _hideTrash.value = _pendingRemovalList.isEmpty;
    _hideSave.value = !widget.itemsChanged;
  }

  // Remove dialog
  void showRemoveDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(AppLocalizations.of(context)!.removeAccounts),
              content: Text(AppLocalizations.of(context)!.removeConfirmation),
              actions: [
                TextButton(
                    child: Text(AppLocalizations.of(context)!.no),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.yes,
                      style: const TextStyle(color: Colors.red)),
                  onPressed: () {
                    setState(() {
                      widget.removeItems(_pendingRemovalList);
                      _pendingRemovalList.clear();
                      _refreshHide();
                    });
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  // Handle history pop
  Future<bool> _popCallback() async {
    if (!widget.itemsChanged) {
      return true;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.exitEditTitle),
            content: Text(AppLocalizations.of(context)!.exitEditInfo),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(context)!.no),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(AppLocalizations.of(context)!.yes,
                    style: const TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                },
              )
            ],
          );
        });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // Handle back button
        onWillPop: _popCallback,
        child: Scaffold(
            appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.editTitle),
                actions: <Widget>[
                  // Save
                  ValueListenableBuilder<bool>(
                      valueListenable: _hideSave,
                      builder: (context, value, child) {
                        if (value) {
                          return Container();
                        } else {
                          return IconButton(
                              icon: const Icon(Icons.check),
                              tooltip: AppLocalizations.of(context)!.save,
                              onPressed: () {
                                widget.replaceItems(widget.items);
                                Navigator.pop(context);
                              });
                        }
                      })
                ]),
            body: widget.items == null
                ? Center(child: Text(AppLocalizations.of(context)!.loading))
                : Container(
                    margin: const EdgeInsets.all(10),
                    child: ReorderableListView(
                        padding: const EdgeInsets.all(0),
                        scrollDirection: Axis.vertical,
                        onReorder: _handleReorder,
                        children: widget.items
                            .map((item) => EditListItem(
                                item, addRemovalItem, removeRemovalItem,
                                key: Key(item.id)))
                            .toList())),
            // Delete button
            bottomSheet: ValueListenableBuilder<bool>(
              valueListenable: _hideTrash,
              builder: (context, value, child) {
                if (value == true) {
                  return const SizedBox(width: 0, height: 0);
                }
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          showRemoveDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                              AppLocalizations.of(context)!.removeAccounts,
                              style: const TextStyle(color: Colors.redAccent)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )));
  }
}
