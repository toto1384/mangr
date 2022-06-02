
import 'package:flutter/material.dart';
import 'package:mangr/data/data.dart';
import 'package:mangr/utils.dart';


class StatsPage extends StatefulWidget {

  final DataHelper dataHelper;

  StatsPage({Key key,@required this.dataHelper}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Stats',
        backEnabled: true,
        context: context),
      body:ListView(
            //data
            children: <Widget>[

              Padding(
                padding: EdgeInsets.all(10),
                child: getText('Total revenue history',textType: TextType.textTypeSubtitle),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                  height: 300,
                  child: getChart(widget.dataHelper.getRevenueHistory())
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: getText('Revenue per month history',textType: TextType.textTypeSubtitle),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                  height: 300,
                  child: getChart(widget.dataHelper.getRevenuePerMonthHistory()),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: getText('Expenses per month history',textType: TextType.textTypeSubtitle),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                  height: 300,
                  child: getChart(widget.dataHelper.getExpensesPerMonthHistory()),
                ),
              ),
            ],
          ),
        );
  }
}