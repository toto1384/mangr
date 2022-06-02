import 'package:flutter/material.dart';
import 'package:mangr/data/data.dart';
import 'package:mangr/icon_pack_icons.dart';
import 'package:mangr/utils.dart';
import 'package:mangr/widgets/widget_parts/animated_money_text.dart';
import 'package:mangr/widgets/widget_parts/tab_layout.dart';


class BudgetPage extends StatefulWidget {

  final DataHelper dataHelper;

  BudgetPage({Key key,@required this.dataHelper}) : super(key: key);

  @override
  BudgetPageState createState() => BudgetPageState();
}

class BudgetPageState extends State<BudgetPage> {


  int totalRevenue ;
  int revenuePerMonth;
  int expensesPerMonth;


  @override
  void initState() { 

    if(totalRevenue==null){
      totalRevenue=widget.dataHelper.getTotalRevenue();
    }

    if(revenuePerMonth==null){
      revenuePerMonth = widget.dataHelper.getRevenuePerMonth();
    }

    if(expensesPerMonth == null){
      expensesPerMonth = widget.dataHelper.getExpensesPerMonth();
    }


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Budgeting',backEnabled: true,context: context),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15,bottom: 10),
            child: getText('Total revenue',textType: TextType.textTypeSubtitle),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: AnimatedMoneyText(textType: TextType.textTypeSubtitle,value: totalRevenue),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20,left: 10),
                child: IconButton(
                  icon: Icon(IconPack.edit,size: 15,color: getIconColor(),),
                  onPressed: (){
                    showEditTotalRevenueBottomSheet(
                      context: context,
                      dataHelper: widget.dataHelper,
                      updateJson: (value){
                        setState(() {
                          revenuePerMonth =value;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: 15,bottom: 10),
            child: getText('Revenue per month',textType: TextType.textTypeSubtitle),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: AnimatedMoneyText(textType: TextType.textTypeSubtitle,value: revenuePerMonth),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20,left: 10),
                child: IconButton(
                  icon: Icon(IconPack.edit,size: 15,color: getIconColor(),),
                  onPressed: (){
                    BudgetPageState.showEditExpensesRevenuePerMonthBottomSheet(
                                                expensesNotRevenue: false,
                                                context: context,
                                                updateJson: (value){
                                                  setState(() {
                                                    revenuePerMonth = value;
                                                  });
                                                },
                                                dataHelper: widget.dataHelper);
                  },
                ),
              ),
            ],
          ),


          Padding(
            padding: EdgeInsets.only(top: 15,bottom: 10),
            child: getText('Expeneses per month',textType: TextType.textTypeSubtitle),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: AnimatedMoneyText(textType: TextType.textTypeSubtitle,value: expensesPerMonth),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20,left: 10),
                child: IconButton(
                  icon: Icon(IconPack.edit,size: 15,color: getIconColor(),),
                  onPressed: (){
                    BudgetPageState.showEditExpensesRevenuePerMonthBottomSheet(
                                                expensesNotRevenue: true,
                                                context: context,
                                                updateJson: (value){
                                                  setState(() {
                                                    expensesPerMonth=value;
                                                  });
                                                },
                                                dataHelper: widget.dataHelper);
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }


  static showEditTotalRevenueBottomSheet({@required DataHelper dataHelper,@required BuildContext context,@required Function(int value) updateJson}){

    int tabLayoutPosition = 0;  
    TextEditingController valueController = TextEditingController();

    showDistivityModalBottomSheet(context, Column(

      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: TabLayout(
            entries: ['Set','Add','Remove'],
            onSelectedPos: (pos){
              tabLayoutPosition=pos;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              getTextField(hint: "Enter value here",textEditingController: valueController,
                focus: true,width: 300,textInputType: TextInputType.number),
              IconButton(
                icon: Icon(IconPack.send,color: getIconColor(),),
                onPressed: () async {
                  int newValue = 0;
                  if(tabLayoutPosition==1){
                    newValue = int.parse(valueController.text) + dataHelper.getTotalRevenue();
                  }else if(tabLayoutPosition==2){
                    newValue = dataHelper.getTotalRevenue() - int.parse(valueController.text);
                  }else if(tabLayoutPosition==0){
                    newValue = int.parse(valueController.text);
                  }

                  await dataHelper.setTotalRevenue(newValue);
                  Navigator.pop(context);
                  updateJson(newValue);
                },
              ),
            ],
          ),
        ),


      ],


    ));

  }





  static showEditExpensesRevenuePerMonthBottomSheet({@required bool expensesNotRevenue,@required DataHelper dataHelper,@required BuildContext context,@required Function(int value) updateJson}){

    TextEditingController textEditingController = TextEditingController();

    showDistivityModalBottomSheet(context, Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: getTextField(
            focus: true,
            textEditingController: textEditingController,
            hint: expensesNotRevenue?"Expenses Per Month:" : "Revenue Per Month",
            textInputType: TextInputType.number,
            width: 300
          ),
        ),
        IconButton(
          icon: Icon(IconPack.send,color: getIconColor(),),
          onPressed: () async {
            if(expensesNotRevenue){
              await dataHelper.setExpensesPerMonth(int.parse(textEditingController.text));
            }else{
             await  dataHelper.setRevenuePerMonth(int.parse(textEditingController.text));
            }
            Navigator.pop(context);
            updateJson(int.parse(textEditingController.text));
          },
        ),
      ],
    ));

  }
}