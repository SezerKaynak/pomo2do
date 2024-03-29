import 'package:flutter/material.dart';
import 'package:pomotodo/core/models/sum_of_task_time_model.dart';
import 'package:pomotodo/core/models/task_by_task_model.dart';
import 'package:pomotodo/core/providers/locale_provider.dart';
import 'package:pomotodo/core/providers/task_stats_provider.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/utils/constants/constants.dart';
import 'package:pomotodo/utils/languages/language_preference.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:ui' as ui;

class TaskStatistics extends StatefulWidget {
  const TaskStatistics({super.key});

  @override
  State<TaskStatistics> createState() => _TaskStatisticsState();
}

class _TaskStatisticsState extends State<TaskStatistics> {
  late TaskStatsProvider taskStatsProvider;
  @override
  void initState() {
    super.initState();
    taskStatsProvider = Provider.of<TaskStatsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var l10n = L10n.of(context)!;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: taskStatsProvider.getTasks(),
          builder: (context, snapshot) {
            return Column(
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                          width: 1.0, color: Colors.grey.withOpacity(0.5))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: kToolbarHeight / 1.5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(l10n.workTime,
                                style: const TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: SfCartesianChart(
                          selectionType: SelectionType.point,
                          tooltipBehavior: TooltipBehavior(
                              header: l10n.workTime, enable: true),
                          plotAreaBorderWidth: 0,
                          primaryXAxis: CategoryAxis(
                              majorGridLines: const MajorGridLines(width: 0)),
                          primaryYAxis: NumericAxis(
                              labelFormat: '{value}',
                              interval: 20,
                              majorTickLines: const MajorTickLines(size: 0),
                              axisLine: const AxisLine(width: 0)),
                          series: <ColumnSeries<SumOfTaskTimeModel, String>>[
                            ColumnSeries(
                                onPointTap: (pointInteractionDetails) {
                                  taskStatsProvider.count.value =
                                      pointInteractionDetails.pointIndex!;
                                },
                                dataSource: taskStatsProvider.table1,
                                xValueMapper: (SumOfTaskTimeModel x, int xx) =>
                                    x.date,
                                yValueMapper: (SumOfTaskTimeModel sum, _) =>
                                    sum.sum)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 1.0, color: Colors.grey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 5,
                  child: ValueListenableBuilder(
                    valueListenable: taskStatsProvider.count,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          SizedBox(
                            height: kToolbarHeight / 1.5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: context.read<LocaleModel>().locale ==
                                        const Locale("tr", "TR")
                                    ? Row(
                                        children: [
                                          Text(
                                            taskStatsProvider.getWeekDays()[0][
                                                -taskStatsProvider.count.value +
                                                    6],
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            L10n.of(context)!.tasksWorkedOn,
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Text(
                                            L10n.of(context)!.tasksWorkedOn,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            taskStatsProvider.getWeekDays()[0][
                                                -taskStatsProvider.count.value +
                                                    6],
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: FutureBuilder(
                              future: taskStatsProvider.taskByTaskStat(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return SfCartesianChart(
                                    plotAreaBorderWidth: 0,
                                    primaryXAxis: CategoryAxis(
                                      axisLine: const AxisLine(width: 0),
                                      majorTickLines:
                                          const MajorTickLines(width: 0),
                                      maximumLabelWidth: 100,
                                      majorGridLines:
                                          const MajorGridLines(width: 0),
                                    ),
                                    primaryYAxis: NumericAxis(),
                                    series: <
                                        BarSeries<TaskByTaskModel, String>>[
                                      BarSeries(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8)),
                                          width: 0.4,
                                          dataSource: taskStatsProvider.table2,
                                          xValueMapper:
                                              (TaskByTaskModel task, _) =>
                                                  task.taskName,
                                          yValueMapper:
                                              (TaskByTaskModel stat, _) =>
                                                  stat.passingTime,
                                          dataLabelSettings:
                                              const DataLabelSettings(),
                                          onCreateShader:
                                              ((ShaderDetails details) {
                                            return ui.Gradient.linear(
                                                details.rect.centerRight,
                                                details.rect.centerLeft,
                                                const <Color>[
                                                  Colors.red,
                                                  Colors.orange,
                                                  Colors.yellow
                                                ],
                                                <double>[
                                                  0.3,
                                                  0.6,
                                                  0.9
                                                ]);
                                          }))
                                    ],
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 1.0, color: Colors.grey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 5,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: SfCalendar(
                            todayHighlightColor: Colors.black,
                            view: CalendarView.month,
                            showDatePickerButton: true,
                            monthCellBuilder:
                                taskStatsProvider.monthCellBuilder,
                            monthViewSettings: const MonthViewSettings(
                              showTrailingAndLeadingDates: false,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * .5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [Text(l10n.few), Text(l10n.much)],
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .5,
                                  height:
                                      MediaQuery.of(context).size.height * .015,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: const LinearGradient(
                                      colors: [
                                        kLightGrey,
                                        kLightGreen,
                                        kMidGreen,
                                        kDarkGreen,
                                        kDarkerGreen,
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
