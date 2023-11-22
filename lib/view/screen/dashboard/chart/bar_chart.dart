import 'package:d_chart/d_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/response/dailywise_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/dashboard_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:provider/provider.dart';

class BarChartSample2 extends StatefulWidget {
  String startDMY,endDMY;
  BarChartSample2(this.startDMY,this.endDMY,{super.key});
  final Color leftBarColor = Colors.yellow;
  final Color rightBarColor = Colors.red;
  final Color avgColor = Colors.orange;
  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 7;
  bool isLoading = true;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  var maxy;
  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context,bool read) async {
    Future.delayed(Duration.zero,() {
      Provider.of<DashboardProvider>(context, listen: false).getSalesPaymentChart(context,PreferenceUtils.getString("${AppConstants.companyId}"),widget.startDMY,widget.endDMY).then((value) {
        setState(() {
          isLoading = false;
          for(int i=0;i<Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList.length;i++) {
            final barGroup1 = makeGroupData(
                Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList.length,
                Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalSale!,
                Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalPayment!);
            final items = [
              barGroup1,
            ];
            rawBarGroups = items;
            showingBarGroups = rawBarGroups;
          }
        });
      });
    },);
  }

  SalesPaymentChartData salesPaymentChartData = SalesPaymentChartData();

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, dashboard, child) {
      for(int i=0;i<dashboard.salesPaymentChartList.length;i++){
        // var maxValue = dashboard.salesPaymentChartList.sort((a, b) => a.intTotalSale!.compareTo(b.intTotalSale!),);
         var max = dashboard.salesPaymentChartList[0];
        for (var element in dashboard.salesPaymentChartList) {
          if (element.intTotalSale! > max.intTotalSale!) max = element;
        }
        maxy = max.intTotalSale;
        print("max ::${max.intTotalSale} :: $maxy");
      }
      return AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Sales Vs Payment',
                    style: montserratRegular.copyWith(color: Colors.black, fontSize: Dimensions.FONT_SIZE_22),
                  ),
                ],
              ),
              SizedBox(height: AppConstants.itemHeight*0.038),
              Expanded(
                child: DChartBarCustom(
                  loadingDuration: const Duration(milliseconds: 150),
                  showLoading: true,
                  valueAlign: Alignment.topCenter,
                  showDomainLine: true,
                  showDomainLabel: true,
                  showMeasureLine: true,
                  showMeasureLabel: true,
                  spaceDomainLabeltoChart: 5,
                  spaceMeasureLabeltoChart: 0,
                  spaceDomainLinetoChart: 0,
                  spaceMeasureLinetoChart: 2,
                  spaceBetweenItem: 2,
                  radiusBar: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  measureLabelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.purple,
                  ),
                  // domainLabelStyle: const TextStyle(
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 10,
                  //   color: Colors.purple,
                  // ),
                  // measureLineStyle: const BorderSide(color: Colors.amber, width: 2),
                  // domainLineStyle: const BorderSide(color: Colors.red, width: 2),
                  // max: maxy,
                  listData: List.generate(dashboard.salesPaymentChartList.length, (index) {
                    return DChartBarDataCustom(
                      onTap: () {},
                      elevation: 2,
                      showValue: false,
                      value: dashboard.salesPaymentChartList[index].intTotalSale!,
                      valueStyle: montserratRegular.copyWith(color: ColorResources.WHITE,fontSize: 10),
                      label: dashboard.salesPaymentChartList[index].dtDate.toString(),
                      color: Colors.blue,
                      splashColor: Colors.blue,
                      labelCustom: Transform.rotate(
                        angle: -1,
                        child: Text(AppConstants.changeDateD(dashboard.salesPaymentChartList[index].dtDate.toString()),style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 08,
                          color: Colors.purple,
                        ),),
                      ),
                      valueTooltip: '${dashboard.salesPaymentChartList[index].intTotalSale}',
                    );
                  }),
                ),
                /*BarChart(
                BarChartData(
                  maxY: 20,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }
                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod
                          in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum /
                              showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .length;

                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                                barRods: showingBarGroups[touchedGroupIndex]
                                    .barRods
                                    .map((rod) {
                                  return rod.copyWith(
                                      toY: avg, color: widget.avgColor);
                                }).toList(),
                              );
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: FlGridData(show: false),
                ),
              ),*/
              ),
              SizedBox(height: AppConstants.itemHeight*0.012),
            ],
          ),
        ),
      );
    },);
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '5K';
    } else if (value == 19) {
      text = '10K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}