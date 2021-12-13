import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/model/Cart.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

import 'list_item_card_shoppingcart.dart';
import 'list_item_card_wishlist.dart';

class ListDismissible extends StatefulWidget {
  /// *
  ///   dynamic list = list with certain content which must be visible
  ///   Function funcOnDismissible = function which must be invoked after item has been dismissed
  /// *
  final String emptyListText;
  final dynamic list;
  final Function funcOnDismissible;
  final GlobalKey<ScaffoldState> scaffoldState;

  const ListDismissible({
    Key key,
    this.emptyListText = "Empty list",
    @required this.list,
    @required this.funcOnDismissible,
    this.scaffoldState,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListItemDismissible();
}

class _ListItemDismissible extends State<ListDismissible> {
  @override
  Widget build(BuildContext context) {
    return widget.list.isEmpty
        ? Center(
            child: Text(widget.emptyListText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kWhiteColor,
                )),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
                itemCount: widget.list.length,
                itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      child: Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: kBackgroundLikeButton,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Spacer(),
                              Icon(CupertinoIcons.trash),
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            /// -->  make sure that every method only takes product as parameter
                            widget
                                .funcOnDismissible(widget.list[index].product);
                            widget.list.removeAt(index);
                          });
                          // Show a snackbar --> This snackbar could also contain "Undo" actions.
                          /*Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(content: Text("Dismiss?")));*/
                        },
                        child: Row(
                            children:
                                /* Check which list-item-card must be created:
                      items for shopping cart or items for wishlist */
                                widget.list is List<Cart>
                                    ? buildShoppingCartCard(
                                        cartItem: widget.list[index],
                                        scaffoldKey: widget.scaffoldState)
                                    : buildWishListCard(
                                        wishListItem: widget.list[index])),
                      ),
                    )),
          );
  }
}
