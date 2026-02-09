import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';

void main() {
  EasyRefresh.debugLogEnabled = true;
  EasyRefresh.debugLogger = (msg) => debugPrint(msg);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'EasyRefresh',
      home: NestPage(),
    );
  }
}
class NestPage extends StatefulWidget {
  const NestPage({super.key});

  @override
  State<StatefulWidget> createState() => NestPageState();
}

class NestPageState extends State<NestPage> with TickerProviderStateMixin {
  late final TabController tabCon;

  final tabData = <String>["TABONE", "TABTWO"];

  @override
  void initState() {
    super.initState();

    tabCon = TabController(length: tabData.length, vsync: this);
  }

  @override
  void dispose() {
    tabCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (c, f) {
          return [
            const SliverAppBar(
              pinned: true,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(collapseMode: CollapseMode.pin),
            ),
            SliverToBoxAdapter(child: Container(height: 150, color: Colors.blue)),
          ];
        },
        body: Column(
          children: [
            TabBar(
              controller: tabCon,
              labelPadding: const EdgeInsets.only(top: 20, bottom: 20),
              tabs: tabData.map((e) => Text(e)).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: tabCon,
                children: tabData.map((e) => const TabView()).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabView extends StatefulWidget {
  const TabView({super.key});

  @override
  State<StatefulWidget> createState() => TabViewState();
}

class TabViewState extends State<TabView> with AutomaticKeepAliveClientMixin {
  final refreshCon = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  int _itemCount = 20;

  @override
  void dispose() {
    refreshCon.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    _itemCount = 20;

    refreshCon.finishRefresh();

    setState(() {});
  }

  Future<void> _loadMore() async {
    await Future.delayed(const Duration(seconds: 2));
    _itemCount += 20;

    refreshCon.finishLoad();

    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Container(height: 150, color: Colors.yellow),
        Expanded(
          child: EasyRefresh(
            controller: refreshCon,
            header: const ClassicHeader(safeArea: false),
            onRefresh: () {
              _refresh();
            },
            onLoad: () {
              _loadMore();
            },
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 15, right: 15),
              itemCount: _itemCount,
              separatorBuilder: (con, index) => const SizedBox(height: 10),
              itemBuilder: (con, index) => ListTile(title: Text("Item $index")),
            ),
          ),
        ),
      ],
    );
  }
}