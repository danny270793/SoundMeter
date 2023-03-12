import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:soundmeter/pages/settings.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SoundMeterPage extends StatefulWidget {
  static String get path => '/soundmeter';

  const SoundMeterPage({super.key});

  @override
  State<StatefulWidget> createState() => _SoundMeterPageState();
}

class _SoundMeterPageState extends State<SoundMeterPage> {
  final NoiseMeter noiseMeter = NoiseMeter();
  late StreamSubscription<NoiseReading> noiseSubscription;
  final List<LineMeasurement> measurements = [];
  final List<LineMeasurement> maxMeasurements = [];
  final List<LineMeasurement> minMeasurements = [];
  bool isRecording = true;
  final int maxXs = 400;
  double max = double.maxFinite;
  double min = double.minPositive;
  double avg = 0;
  double current = 0;

  MaterialColor dbToColor(final double db) {
    if(db < 60) {
      return Colors.blue;
    } else if(db >= 60 && db < 80) {
      return Colors.purple;
    } else {
      return Colors.red;
    }
  }

  String dbToString(final double db) {
    if(db < 20) {
      return 'Near-total silence\nThreshold of human hearing';
    } else if(db >= 20 && db < 60) {
      return 'Whisper';
    } else if(db >= 60 && db < 80) {
      return 'Normal conversation at 1pm';
    } else if(db >= 80 && db < 90) {
      return 'Heavy traffic at 10am';
    } else if(db >= 90 && db < 110) {
      return 'A Lawnmower';
    } else if(db >= 110 && db < 120) {
      return 'Night club peak levels';
    } else if(db >= 120 && db < 140) {
      return 'Jet engine at 100m';
    } else if(db >= 140 && db < 180) {
      return 'Gunshot at gunner\'s ear';
    } else if(db >= 180) {
      return 'Rocket launch (one mile from the launch site)';
    } else {
      return 'Impossible';
    }
  }

  void onData(final NoiseReading noiseReading) {
      if(!isRecording) {
        return;
      }

      if(noiseReading.maxDecibel > max || max == double.maxFinite) {
        max = noiseReading.maxDecibel;
      }
      if(noiseReading.maxDecibel < min || min == double.minPositive) {
        min = noiseReading.maxDecibel;
      }

      avg = noiseReading.meanDecibel;
      current = noiseReading.maxDecibel;

      if(measurements.length > maxXs) {
        measurements.removeAt(0);
      }

      measurements.add(LineMeasurement(x: DateTime.now().millisecondsSinceEpoch, y: noiseReading.maxDecibel));
      maxMeasurements.clear();
      minMeasurements.clear();
      for (var lineMeasurement in measurements) {
        maxMeasurements.add(LineMeasurement(x: lineMeasurement.x, y: max));
        minMeasurements.add(LineMeasurement(x: lineMeasurement.x, y: min));
      }

      setState(() {});
    }

  @override
  void initState() {
    noiseSubscription = noiseMeter.noiseStream.listen(onData);
    super.initState();
  }

  @override
  void dispose() {
    noiseSubscription.cancel();
    super.dispose();
  }

  Widget getCurrentGraph() => Stack(
    alignment: Alignment.center,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${current.toStringAsFixed(2)} dB'),
          Text(dbToString(current)),
        ],
      ),
      SfCircularChart(
        series: [
          RadialBarSeries<CircularChartMeasurement, String>(
              dataSource: [
                CircularChartMeasurement(x: 'Current', y: current)
              ],
              maximumValue: 120,
              xValueMapper: (CircularChartMeasurement data, _) => data.x,
              yValueMapper: (CircularChartMeasurement data, _) => data.y,
              pointColorMapper: (CircularChartMeasurement data, _) => dbToColor(data.y),
              cornerStyle: CornerStyle.bothCurve,
              innerRadius: '90%'
          )
        ],
      )
    ],
  );

  Widget getHistoricalGraph() => measurements.isEmpty ? const Center(child: CircularProgressIndicator()) : SfCartesianChart(
    primaryXAxis: NumericAxis(
        isVisible: false,
        /*
        plotBands: [
          PlotBand(
            associatedAxisStart: 0,
            associatedAxisEnd: 30,
            color: Colors.blue
          ),
          PlotBand(
            associatedAxisStart: 30,
            associatedAxisEnd: 60,
            color: Colors.green
          ),
          PlotBand(
              associatedAxisStart: 60,
              associatedAxisEnd: 100,
              color: Colors.yellow
          ),
          PlotBand(
              associatedAxisStart: 100,
              associatedAxisEnd: 120,
              color: Colors.red
          )
        ]
        */
    ),
    series: [
      FastLineSeries(
          dataSource: maxMeasurements,
          dashArray: <double>[5, 5],
          xValueMapper: (LineMeasurement measurement, _) => measurement.x,
          yValueMapper: (LineMeasurement measurement, _) => measurement.y,
          color: Colors.red,
          animationDuration: 0
      ),
      FastLineSeries(
          dataSource: minMeasurements,
          dashArray: <double>[5, 5],
          xValueMapper: (LineMeasurement measurement, _) => measurement.x,
          yValueMapper: (LineMeasurement measurement, _) => measurement.y,
          color: Colors.green,
          animationDuration: 0
      ),
      FastLineSeries(
          dataSource: measurements,
          xValueMapper: (LineMeasurement measurement, _) => measurement.x,
          yValueMapper: (LineMeasurement measurement, _) => measurement.y,
          color: Colors.blue,
          animationDuration: 0
      ),

      /*
      FastLineSeries(
          dataSource: measurements,
          dashArray: <double>[5, 5],
          xValueMapper: (LineMeasurement measurement, _) => measurement.x,
          yValueMapper: (LineMeasurement measurement, _) => 20,
          color: Colors.grey,
          animationDuration: 0
      ),
      FastLineSeries(
          dataSource: measurements,
          dashArray: <double>[5, 5],
          xValueMapper: (LineMeasurement measurement, _) => measurement.x,
          yValueMapper: (LineMeasurement measurement, _) => 60,
          color: Colors.grey,
          animationDuration: 0
      ),
      FastLineSeries(
          dataSource: measurements,
          dashArray: <double>[5, 5],
          xValueMapper: (LineMeasurement measurement, _) => measurement.x,
          yValueMapper: (LineMeasurement measurement, _) => 80,
          color: Colors.grey,
          animationDuration: 0
      ),
      FastLineSeries(
          dataSource: measurements,
          dashArray: <double>[5, 5],
          xValueMapper: (LineMeasurement measurement, _) => measurement.x,
          yValueMapper: (LineMeasurement measurement, _) => 90,
          color: Colors.grey,
          animationDuration: 0
      ),
      FastLineSeries(
          dataSource: measurements,
          dashArray: <double>[5, 5],
          xValueMapper: (LineMeasurement measurement, _) => measurement.x,
          yValueMapper: (LineMeasurement measurement, _) => 110,
          color: Colors.grey,
          animationDuration: 0
      ),
      FastLineSeries(
          dataSource: measurements,
          dashArray: <double>[5, 5],
          xValueMapper: (LineMeasurement measurement, _) => measurement.x,
          yValueMapper: (LineMeasurement measurement, _) => 120,
          color: Colors.grey,
          animationDuration: 0
      ),
      FastLineSeries(
          dataSource: measurements,
          dashArray: <double>[5, 5],
          xValueMapper: (LineMeasurement measurement, _) => measurement.x,
          yValueMapper: (LineMeasurement measurement, _) => 140,
          color: Colors.grey,
          animationDuration: 0
      ),
      FastLineSeries(
          dataSource: measurements,
          dashArray: <double>[5, 5],
          xValueMapper: (LineMeasurement measurement, _) => measurement.x,
          yValueMapper: (LineMeasurement measurement, _) => 180,
          color: Colors.grey,
          animationDuration: 0
      )
      */
    ],
  );

  Widget getBar() => Row(
    children: [
      Expanded(child: Align(alignment: Alignment.center, child: Text('MAX: ${(max == double.maxFinite ? 0 : max).toStringAsFixed(2)}'))),
      Expanded(child: Align(alignment: Alignment.center, child: Text('MIN: ${min.toStringAsFixed(2)}'))),
      Expanded(child: Align(alignment: Alignment.center, child: Text('AVG: ${avg.toStringAsFixed(2)}'))),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound meter')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (final int index) async {
          if(index == 0) {
            maxMeasurements.clear();
            minMeasurements.clear();
            measurements.clear();
            max = double.maxFinite;
            min = double.minPositive;
            avg = 0;
            current = 0;
          } else if (index == 1) {
            isRecording = !isRecording;
          } else if (index == 2) {
            noiseSubscription.cancel();
            await Navigator.pushNamed(context, SettingsPage.path);
            noiseSubscription = noiseMeter.noiseStream.listen(onData);
          }
          setState(() {});
        },
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.restart_alt),
              label: 'Restart',
          ),
          isRecording ? const BottomNavigationBarItem(
              icon: Icon(Icons.stop),
              label: 'Stop'
          ) : const BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow),
              label: 'Play'
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings'
          )
        ],
      ),
      body: MediaQuery.of(context).orientation == Orientation.portrait ? Column(
        children: [
          getCurrentGraph(),
          getBar(),
          Expanded(child: getHistoricalGraph())
        ],
      ) : Row(
        children: [
          Expanded(
              child: Column(
                children: [
                  Expanded(child: getCurrentGraph()),
                  getBar()
                ],
          )),
          Expanded(child: getHistoricalGraph())
        ],
      ),
    );
  }
}

class CircularChartMeasurement {
  final String x;
  final double y;

  CircularChartMeasurement({
    required this.x,
    required this.y
  });
}


class LineMeasurement {
  final int x;
  final double y;

  LineMeasurement({
    required this.x,
    required this.y
  });
}
