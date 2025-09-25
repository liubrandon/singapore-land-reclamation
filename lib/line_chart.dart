import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class BarChartSG extends StatefulWidget {
  @override
  _BarChartSGState createState() => _BarChartSGState();
}

class _BarChartSGState extends State<BarChartSG> {
  var data;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;
  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>> getGovData() async {
    var dio = Dio();
    var res = await dio.get('https://data.gov.sg/api/action/datastore_search?resource_id=f4bbfac9-c3ed-4f71-9b9a-238517b214ef');
    return res.data['result']['records'];
    //   // print(data[0]['total_land_area']);
    // });
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            // decoration: const BoxDecoration(
            //     borderRadius: BorderRadius.all(
            //       Radius.circular(18),
            //     ),
            //     color: Color(0xff232d37)),
            child: Padding(
              padding: const EdgeInsets.only(right: 28.0, left: 12.0, top: 24, bottom: 12),
              child: FutureBuilder(
                future: getGovData(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if( snapshot.connectionState == ConnectionState.waiting){
                      return  Center(child: CircularProgressIndicator());
                  }else{
                      if (snapshot.hasError)
                        return Center(child: Text('Error: ${snapshot.error}'));
                      else
                        return BarChart(
                          mainData(snapshot.data),
                        );
                  }
                },
              )
            ),
          ),
      ],
    );
  }

  BarChartData mainData(List<dynamic> data) {
    List<BarChartGroupData> barGroups = [];
    double sum = 0.0;
    for(int i = 1; i < data.length; i++) {
      int year = int.parse(data[i]['year']);
      double lastYearLandArea = double.parse(data[i-1]['total_land_area']);
      double landArea = double.parse(data[i]['total_land_area']);
      barGroups.add(
        BarChartGroupData(
          x: year,
          barRods: [
            BarChartRodData(y: landArea-lastYearLandArea, colors: [Colors.lightBlueAccent, Colors.greenAccent])
          ],
        )
      );
      sum = sum + (landArea-lastYearLandArea);
    }
    // print(sum);
    return BarChartData(
      maxY: 25,
      barTouchData: BarTouchData(
      touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              rod.y.toStringAsFixed(1) + '\n',
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (group.x).toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          })),
      barGroups: barGroups,
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) =>
              const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 12),
          // interval: 5,
          getTitles: (year) => year.toString(),
          margin: 16,
          rotateAngle: -40,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          // interval: 20,
          // reservedSize: 28,
          // margin: 12,
        ),
      ),
      axisTitleData: FlAxisTitleData(
        show: true,
        topTitle: AxisTitle(
          showTitle: true,
          titleText: "Singapore land reclamation by year, 1960-2024",
          textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          margin: 10,
        ),
        leftTitle: AxisTitle(
          showTitle: true,
          titleText: "Square kilometers",
          textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 10,
        ),
        bottomTitle: AxisTitle(
          showTitle: true,
          titleText: "Year",
          textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 10,
        ),
      ),
          borderData:
              FlBorderData(show: false, border: Border.all(color: const Color(0xff37434d), width: 1)),
    );
    
  //   LineChartData(
  //     gridData: FlGridData(
  //       show: true,
  //       drawVerticalLine: true,
  //       getDrawingHorizontalLine: (value) {
  //         return FlLine(
  //           color: const Color(0xff37434d),
  //           strokeWidth: 1,
  //         );
  //       },
  //       getDrawingVerticalLine: (value) {
  //         return FlLine(
  //           color: const Color(0xff37434d),
  //           strokeWidth: 1,
  //         );
  //       },
  //     ),
  //     axisTitleData: FlAxisTitleData(
  //       show: true,
  //       topTitle: AxisTitle(
  //         showTitle: true,
  //         titleText: "Singapore total",
  //         textStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
  //         margin: 20,
  //       ),
  //       leftTitle: AxisTitle(
  //         showTitle: true,
  //         titleText: "Square KM",
  //         textStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
  //         margin: 20,
  //       ),
  //       bottomTitle: AxisTitle(
  //         showTitle: true,
  //         titleText: "Year",
  //         textStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
  //         margin: 20,
  //       ),
  //     ),
  //     titlesData: FlTitlesData(
  //       show: true,
  //       bottomTitles: SideTitles(
  //         showTitles: true,
  //         // reservedSize: 22,
  //         getTextStyles: (value) =>
  //             const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 14),
  //         interval: 5,
  //         getTitles: (year) {
  //           return year.toString();
  //         },
  //         // margin: 8,
  //       ),
  //       leftTitles: SideTitles(
  //         showTitles: true,
  //         getTextStyles: (value) => const TextStyle(
  //           color: Color(0xff67727d),
  //           fontWeight: FontWeight.bold,
  //           fontSize: 15,
  //         ),
  //         interval: 20,
  //         // getTitles: (value) {
  //         //   switch (value.toInt()) {
  //         //     case 1:
  //         //       return '10k';
  //         //     case 3:
  //         //       return '30k';
  //         //     case 5:
  //         //       return '50k';
  //         //   }
  //         //   return '';
  //         // },
  //         reservedSize: 28,
  //         // margin: 12,
  //       ),
  //     ),
  //     borderData:
  //         FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
  //     // minX: 0,
  //     // maxX: 11,
  //     // minY: 0,
  //     // maxY: 6,
  //     lineBarsData: [
  //       LineChartBarData(
  //         spots: spotList,
  //         // isCurved: true,
  //         colors: gradientColors,
  //         barWidth: 5,
  //         isStrokeCapRound: true,
  //         dotData: FlDotData(
  //           show: false,
  //         ),
  //         belowBarData: BarAreaData(
  //           show: true,
  //           colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  }
}
