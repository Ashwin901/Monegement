import 'package:flutter/material.dart';
import 'package:monegement/widgets/daily_stats.dart';
import 'package:monegement/widgets/periodic_stats.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, bool isScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              pinned: true,
              title: Text(
                "Stats",
                style: Theme.of(context).textTheme.headline1,
              ),
              centerTitle: true,
              bottom: TabBar(
                indicatorColor: Colors.amber,
                tabs: [
                  Tab(
                    text: "Periodic",
                    icon: Icon(Icons.timeline_outlined),
                  ),
                  Tab(
                    text: "Daily",
                    icon: Icon(Icons.date_range_outlined),
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: Container(
          child: TabBarView(
            controller: _tabController,
            children: [
              PeriodicStats(),
              DailyStats(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
