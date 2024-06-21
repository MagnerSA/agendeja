import 'dart:async';

import 'package:flutter/material.dart';

import '../services/tasks.service.dart';
import '../style/sizes.dart';
import '../util/formatting.dart';
import 'panel.dart';
import 'taskCard.dart';

class Checklist extends StatefulWidget {
  final DateTime date;
  final DateTime selectedDate;
  final Map<String, dynamic> tasks;
  final bool isOneDayView;
  final void Function(DateTime date) selectDay;

  const Checklist({
    super.key,
    required this.date,
    required this.selectedDate,
    required this.selectDay,
    required this.isOneDayView,
    required this.tasks,
  });

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  TaskService taskService = TaskService();

  Map<String, Map<String, dynamic>> tasks = {};

  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  bool isLoading = false;

  @override
  initState() {
    super.initState();
    _initPage();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _initPage() {
    _loadTasks();
  }

  _reloadContent() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () async {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _loadTasks() async {
    tasks.clear();
    Map<String, Map<String, dynamic>> newData = {};

    var collection = await taskService.bd
        .collection("users")
        .doc(taskService.getUID())
        .collection("tasks")
        .where("date", isEqualTo: widget.date.toString())
        .get();

    for (var doc in collection.docs) {
      newData[doc.data()["id"]] = doc.data();
    }

    List<Map<String, dynamic>> tasksWithStartTime = [];
    List<Map<String, dynamic>> tasksWithoutStartTime = [];

    newData.forEach((key, value) {
      if (value['startTime'] != null) {
        tasksWithStartTime.add(value);
      } else {
        tasksWithoutStartTime.add(value);
      }
    });

    tasksWithStartTime.sort((a, b) {
      return a['startTime'].compareTo(b['startTime']);
    });

    List<Map<String, dynamic>> orderedTasks = [
      ...tasksWithStartTime,
      ...tasksWithoutStartTime
    ];

    setState(() {
      tasks = {for (var task in orderedTasks) task['id']: task};
    });

    _reloadContent();
  }

  Widget timeLine() {
    List<Map<String, dynamic>> tasksWithStartTime = [];

    tasks.forEach((key, value) {
      if (value['startTime'] != null) {
        tasksWithStartTime.add(value);
      }
    });

    double screenWidth = MediaQuery.of(context).size.width;
    double currentHourPercentage =
        (_currentTime.hour * 60 + _currentTime.minute) / (24 * 60);
    double currentTimePosition = currentHourPercentage * screenWidth;

    return Container(
      width: screenWidth,
      height: 100,
      color: Colors.white,
      child: Stack(
        children: [
          for (int hour = 0; hour < 24; hour++)
            Positioned(
              left: (hour / 24) * screenWidth,
              top: 5,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$hour:00',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: 1,
                    height: 58,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          for (int i = 0; i < tasksWithStartTime.length; i++)
            Positioned(
              left: calculatePosition(tasksWithStartTime[i], screenWidth),
              top: 5,
              bottom: 0,
              child: buildTaskPanel(tasksWithStartTime[i], screenWidth, i),
            ),
          Positioned(
            left: currentTimePosition,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 2,
                  height: 82,
                  color: Colors.blue,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double calculatePosition(Map<String, dynamic> task, double screenWidth) {
    String startTimeString = task['startTime'];
    String? endTimeString = task['endTime'];

    List<String> startTimeParts = startTimeString.split(':');
    int startHour = int.parse(startTimeParts[0]);
    int startMinute = int.parse(startTimeParts[1]);
    double startHourPercentage = (startHour + startMinute / 60) / 24;
    double startX = startHourPercentage * screenWidth;

    if (endTimeString != null) {
      List<String> endTimeParts = endTimeString.split(':');
      int endHour = int.parse(endTimeParts[0]);
      int endMinute = int.parse(endTimeParts[1]);
      double endHourPercentage = (endHour + endMinute / 60) / 24;
      double endX = endHourPercentage * screenWidth;
      return startX;
    } else {
      double halfHourWidth = screenWidth / 48;
      return startX;
    }
  }

  Widget buildTaskPanel(
      Map<String, dynamic> task, double screenWidth, int index) {
    String startTimeString = task['startTime'];
    String? endTimeString = task['endTime'];

    List<String> startTimeParts = startTimeString.split(':');
    int startHour = int.parse(startTimeParts[0]);
    int startMinute = int.parse(startTimeParts[1]);
    double startHourPercentage = (startHour + startMinute / 60) / 24;
    double startX = startHourPercentage * screenWidth;

    double panelWidth;
    if (endTimeString != null) {
      List<String> endTimeParts = endTimeString.split(':');
      int endHour = int.parse(endTimeParts[0]);
      int endMinute = int.parse(endTimeParts[1]);
      double endHourPercentage = (endHour + endMinute / 60) / 24;
      double endX = endHourPercentage * screenWidth;
      panelWidth = endX - startX;
    } else {
      panelWidth = screenWidth / 48;
    }

    List<Color> colors = [
      Colors.red,
      Colors.amber,
      Colors.green,
      Colors.blue,
    ];
    Color panelColor = colors[index % colors.length];

    return Tooltip(
      message: task["name"],
      child: Center(
        child: Panel(
          hasShadow: false,
          width: panelWidth,
          height: 65,
          color: panelColor,
        ),
      ),
    );
  }

  _widgetChecklist(DateTime date) {
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    Color color = Colors.white;
    Color textColor = Colors.black;

    if (date.isAtSameMomentAs(today)) {
      color = Colors.green.shade300;
      textColor = Colors.white;
    }
    if (date.isAtSameMomentAs(widget.selectedDate)) {
      color = Colors.blue.shade400;
      textColor = Colors.white;
    }

    Color cardColor = Colors.white;

    return Expanded(
      child: Column(
        children: [
          Panel(
            onTap: () {
              widget.selectDay(date);
            },
            height: getSizeHeight(context),
            width: w(context, 100),
            color: color,
            bottomLeft: widget.isOneDayView ? 0 : null,
            bottomRight: widget.isOneDayView ? 0 : null,
            child: Center(
              child: Text(
                formatDate(date, !widget.isOneDayView),
                style: TextStyle(color: textColor),
              ),
            ),
          ),
          Visibility(
            visible: widget.isOneDayView,
            child: timeLine(),
          ),
          sizedBox(context),
          Visibility(
            visible: widget.isOneDayView,
            child: TaskCard(
              date: widget.date,
              reloadTasks: _loadTasks,
              isOneDayView: widget.isOneDayView,
              selectDay: widget.selectDay,
            ),
          ),
          sizedBox(context),
          Visibility(
            visible: widget.isOneDayView || tasks.isEmpty,
            child: Padding(
              padding: EdgeInsets.only(bottom: getSizeSpace(context)),
              child: Text(
                "${tasks.isEmpty ? "Sem t" : 'T'}arefas",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isLoading,
            child: Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  String taskId = tasks.keys.elementAt(index);
                  Map<String, dynamic> task = tasks[taskId]!;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: getSizeSmallSpace(context),
                    ),
                    child: TaskCard(
                      index: index,
                      date: date,
                      reloadTasks: _loadTasks,
                      task: task,
                      isOneDayView: widget.isOneDayView,
                      selectDay: widget.selectDay,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _widgetChecklist(
      widget.date,
    );
  }
}
