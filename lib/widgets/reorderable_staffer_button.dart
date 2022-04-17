import 'package:flutter/material.dart';
import 'package:reorderableitemsview/reorderableitemsview.dart';

class ReorderStaggerButtonView extends StatefulWidget {
  List<Map<String, dynamic>> buttons;
  ReorderStaggerButtonView({Key? key, required this.buttons}) : super(key: key);

  @override
  State<ReorderStaggerButtonView> createState() =>
      _ReorderStaggerButtonViewState();
}

class _ReorderStaggerButtonViewState extends State<ReorderStaggerButtonView> {
  List<StaggeredTileExtended> _listStaggeredTileExtended =
      <StaggeredTileExtended>[
    //StaggeredTileExtended.count(2, 2),
    //StaggeredTileExtended.count(2, 1),
    //StaggeredTileExtended.count(1, 2),
    //StaggeredTileExtended.count(1, 1),
    //StaggeredTileExtended.count(2, 2),
    //StaggeredTileExtended.count(1, 2),
    //StaggeredTileExtended.count(1, 1),
    //StaggeredTileExtended.count(3, 1),
    //StaggeredTileExtended.count(1, 1),
    //StaggeredTileExtended.count(4, 1),
    StaggeredTileExtended.count(2, 2),
    StaggeredTileExtended.count(2, 2),
    StaggeredTileExtended.count(2, 2),
    StaggeredTileExtended.count(2, 2),
    StaggeredTileExtended.count(2, 2),
    StaggeredTileExtended.count(2, 2),
    StaggeredTileExtended.count(2, 2),
    StaggeredTileExtended.count(2, 2),
    StaggeredTileExtended.count(2, 2),
    StaggeredTileExtended.count(2, 2),
  ];

  List<Widget> _tiles = <Widget>[];
  //List<Widget> _tiles = <Widget>[
  //  _Example01Tile(Key("a"), Colors.green, Icons.widgets),
  //  _Example01Tile(Key("b"), Colors.lightBlue, Icons.wifi),
  //  _Example01Tile(Key("c"), Colors.amber, Icons.panorama_wide_angle),
  //  _Example01Tile(Key("d"), Colors.brown, Icons.map),
  //  _Example01Tile(Key("e"), Colors.deepOrange, Icons.send),
  //  _Example01Tile(Key("f"), Colors.indigo, Icons.airline_seat_flat),
  //  _Example01Tile(Key("g"), Colors.red, Icons.bluetooth),
  //  _Example01Tile(Key("h"), Colors.pink, Icons.battery_alert),
  //  _Example01Tile(Key("i"), Colors.purple, Icons.desktop_windows),
  //  _Example01Tile(Key("j"), Colors.blue, Icons.radio),
  //];

  bool bGrid = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bGrid = true;
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Center(
          child: Text(
            "List Demo",
            //"List Demo fdas f fdsa fdsa fdsa fdsa1 fdsa2 fdsa3 fdsa4 fdsa5 fdsa6 fdsa7 fdsa8 fdsafdsafdsafsd fdsa9 fdsa10 fdsa11 fdsa12å fdsa fdsa fdas fdsa fdsa fdsa fds",
            textScaleFactor: 1.0,
            maxLines: 2,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        actions: [
          IconButton(
              onPressed: () => {
                    setState(() => {bGrid = !bGrid})
                  },
              icon: Icon(Icons.more_vert)),
        ],
      ),
      body: ReorderableItemsView(
        padding: EdgeInsets.all(0.1 * w),
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            _tiles.insert(newIndex, _tiles.removeAt(oldIndex));
          });
        },
        children: _tiles,
        crossAxisCount: 4,
        isGrid: bGrid,
        staggeredTiles: _listStaggeredTileExtended,
        longPressToDrag: true,
        mainAxisSpacing: 0.1 * w,
        crossAxisSpacing: 0.1 * w,
      ),
    );
  }
}

class _Example01Tile extends StatelessWidget {
  _Example01Tile(Key key, this.backgroundColor, this.iconData)
      : super(key: key);

  final Color backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: () {
          print('tab');
        },
        child: new Center(
          child: new Padding(
            padding: EdgeInsets.all(4.0),
            child: new Icon(
              iconData,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
