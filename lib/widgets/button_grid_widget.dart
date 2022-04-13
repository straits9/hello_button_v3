import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hello_button_v3/services/graphql.dart';
import 'package:hello_button_v3/widgets/reorder_grid/reorderable_grid.dart';
import 'package:hello_button_v3/widgets/waiting_widget.dart';

class ButtonGridView extends StatelessWidget {
  const ButtonGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphqlConfig.initClient(),
      child: Query(
          options: QueryOptions(
            document: gql(Queries.site),
            variables: const {'siteid': 35},
          ),
          builder: (result, {refetch, fetchMore}) {
            if (result.hasException) return Text(result.exception.toString());
            if (result.isLoading) return const WaitingView();

            String? storeName = result.data?['site']?['name'];
            List buttons = result.data?['site']?['buttons'];
            print('store name: $storeName');

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: storeName == null ? null : Text(storeName),
              ),
              body: ButtonGridWidget(buttons: buttons),
            );
          }),
    );
  }
}

class ButtonGridWidget extends StatefulWidget {
  final List<dynamic> buttons;
  const ButtonGridWidget({Key? key, required this.buttons}) : super(key: key);

  @override
  State<ButtonGridWidget> createState() => _ButtonGridWidgetState();
}

class _ButtonGridWidgetState extends State<ButtonGridWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildButton(Map<String, dynamic> btn) {
      return Card(
        key: ValueKey(btn['title']),
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          children: [
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                width: constraints.maxWidth,
                height: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20)
                  ),
                  // borderRadius: const BorderRadius.only(
                  //   topLeft: Radius.circular(20),
                  //   topRight: Radius.circular(20),
                  //   bottomLeft: Radius.circular(20),
                  //   bottomRight: Radius.circular(20),
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                // child: Image.asset("assets/images/splash.png"),
                child: Image.network(btn['image']),
              );
            }),
            SizedBox(height: 10),
            Text(btn['title'].replaceAll("<BR>", '\n'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ReorderableGridView.count(
      primary: false,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      crossAxisSpacing: 40,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      childAspectRatio: 5 / 6,
      children: widget.buttons.map((btn) => buildButton(btn)).toList(),
      onReorder: (oldIndex, newIndex) {
        print('reorder $oldIndex => $newIndex');
        setState(() {
          final element = widget.buttons.removeAt(oldIndex);
          widget.buttons.insert(newIndex, element);
        });
      },
    );
  }
}
