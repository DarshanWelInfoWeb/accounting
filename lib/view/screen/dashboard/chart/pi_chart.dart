import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/dashboard_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:provider/provider.dart';

class Pie_Charts extends StatefulWidget {
  double sale,due,payment;
  Pie_Charts(this.sale,this.due,this.payment,{super.key});

  @override
  State<Pie_Charts> createState() => _Pie_ChartsState();
}

class _Pie_ChartsState extends State<Pie_Charts> {
  int touchedIndex = -1;
  bool isLoading = true;
  double sale = 0.0;
  double due = 0.0;
  double payment = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _loadData(context, true);
  }

  // Future<void> _loadData(BuildContext context, bool reload) async {
  //   Future.delayed(Duration.zero, () async {
  //     Provider.of<DashboardProvider>(context, listen: false).getSalesPaymentChart(context,PreferenceUtils.getString("${AppConstants.companyId}"),widget.start,widget.end).then((value) {
  //       setState(() {
  //         isLoading = false;
  //         for(int i=0;i<Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList.length;i++){
  //           sale += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalSale!;
  //           due += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalDue!;
  //           payment += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalPayment!;
  //           print("max ::${sale}");
  //         }
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Row(
        children: <Widget>[
          SizedBox(
            height: AppConstants.itemHeight*0.018,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Indicator(
                color: Colors.blue,
                text: 'Sale',
                isSquare: true,
              ),
              SizedBox(height: AppConstants.itemHeight*0.004),
              const Indicator(
                color: Colors.purple,
                text: 'Due',
                isSquare: true,
              ),
              SizedBox(height: AppConstants.itemHeight*0.004),
              const Indicator(
                color: Colors.yellow,
                text: 'Payment',
                isSquare: true,
              ),
              SizedBox(height: AppConstants.itemHeight*0.018),
            ],
          ),
          SizedBox(width: AppConstants.itemWidth*0.028),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 14.0;
      final radius = isTouched ? 80.0 : 70.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: widget.sale,
            title: '${widget.sale.round()} \u20b9',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.purple,
            value: widget.due,
            title: '${widget.due.round()} \u20b9',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.yellow,
            value: widget.payment,
            title: '${widget.payment.round()} \u20b9',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}


class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: montserratBold.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}