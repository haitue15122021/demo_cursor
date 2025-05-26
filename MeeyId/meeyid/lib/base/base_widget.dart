import 'package:flutter/material.dart';

abstract class BaseWidget extends StatelessWidget {
  const BaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildAppBar(context),
      body: SafeArea(child: buildBody(context)),
      bottomNavigationBar: buildBottomNavigationBar(context),
      floatingActionButton: buildFloatingActionButton(context),
      drawer: buildDrawer(context),
    );
  }

  // Abstract method that must be implemented by subclasses
  Widget buildBody(BuildContext context);

  // Optional methods that can be overridden
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;
  Widget? buildBottomNavigationBar(BuildContext context) => null;
  Widget? buildFloatingActionButton(BuildContext context) => null;
  Widget? buildDrawer(BuildContext context) => null;
  Color? get backgroundColor => null;
}

abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});
}

abstract class BaseState<T extends BaseStatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildAppBar(context),
      body: SafeArea(child: buildBody(context)),
      bottomNavigationBar: buildBottomNavigationBar(context),
      floatingActionButton: buildFloatingActionButton(context),
      drawer: buildDrawer(context),
    );
  }

  // Abstract method that must be implemented by subclasses
  Widget buildBody(BuildContext context);

  // Optional methods that can be overridden
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;
  Widget? buildBottomNavigationBar(BuildContext context) => null;
  Widget? buildFloatingActionButton(BuildContext context) => null;
  Widget? buildDrawer(BuildContext context) => null;
  Color? get backgroundColor => null;
}
