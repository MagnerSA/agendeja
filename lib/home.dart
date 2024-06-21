import 'package:agendeja/services/tasks.service.dart';
import 'package:agendeja/widgets/checklist.dart';
import 'package:flutter/material.dart';

import 'routes/routes.dart';
import 'services/user.service.dart';
import 'style/colors.dart';
import 'style/sizes.dart';
import 'widgets/panel.dart';
import 'widgets/squaredIconPanel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserService userService = UserService();
  TaskService taskService = TaskService();

  Map<String, dynamic> tasks = {};

  Map<String, dynamic> userInfo = {};

  bool isLoading = false;

  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  List<DateTime> nextTwo = [];
  List<DateTime> week = [];

  String viewType = "oneDay";

  @override
  initState() {
    initPage();
    super.initState();
  }

  initPage() async {
    await _auth();

    userInfo = await userService.getCurrentUser();

    _initDates();
    _updateLateTasks();
    // _loadTasks();

    setState(() {});
  }

  _updateLateTasks() async {
    setState(() {
      isLoading = true;
    });

    await taskService.updateLateTasks();

    setState(() {
      isLoading = false;
    });
  }

  _loadTasks() async {
    var newTasks = await taskService.getTasks();

    setState(() {
      tasks = newTasks;
    });
  }

  _auth() async {
    bool isUserLogged = await userService.isUserLogged();

    if (!isUserLogged) {
      navigateToLogin(context);
    }
  }

  _initDates() {
    nextTwo.clear();
    week.clear();

    nextTwo = [
      selectedDate.add(Duration(days: 1)),
      selectedDate.add(Duration(days: 2)),
    ];

    DateTime initialDay = selectedDate;
    if (selectedDate.weekday != 7) {
      initialDay = selectedDate.subtract(Duration(days: selectedDate.weekday));
    }

    for (int i = 0; i < 7; i++) {
      week.add(initialDay.add(Duration(days: i)));
    }

    setState(() {});
  }

  _changeView() {
    setState(() {
      viewType = agendaTypeMap[viewType]["next"];
    });
    _reloadContent();
  }

  _widgetTopBar() {
    return SizedBox(
      height: getSizeHeight(context),
      child: Row(
        children: [
          SquaredIconPanel(
            onTap: () {
              userService.logout();
              navigateToLogin(context);
            },
            iconData: Icons.power_settings_new,
          ),
          sizedBox(context),
          Panel(
            height: getSizeHeight(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                sizedBox(context),
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  // width: 300, // Largura desejada da imagem
                  height: 30, // Altura desejada da imagem
                  fit:
                      BoxFit.contain, // Ajuste da imagem dentro do widget Image
                ),
                smallSizedBox(context),
                Visibility(
                  visible: userInfo["name"] != null,
                  child: const Text(
                    "Agenda de ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  userInfo["name"] ?? "Carregando...",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                sizedBox(context),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Panel(
            height: getSizeHeight(context),
            onTap: _changeView,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                sizedBox(context),
                Icon(
                  agendaTypeMap[viewType]["icon"],
                  size: 20,
                ),
                smallSizedBox(context),
                Text(
                  "Visualização de ${agendaTypeMap[viewType]["visualization"]}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                sizedBox(context),
              ],
            ),
          ),

          // sizedBox(context),
          // Panel(
          //   height: getSizeHeight(context),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       sizedBox(context),
          //       const Icon(
          //         Icons.calendar_month,
          //         size: 20,
          //       ),
          //       smallSizedBox(context),
          //       Visibility(
          //         visible: userInfo["name"] != null,
          //         child: const Text(
          //           "Calendário",
          //           style: TextStyle(
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //       ),
          //       sizedBox(context),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  _nextDay() {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: 1));
      _initDates();
    });
    _reloadContent();
  }

  _nextWeek() {
    int add = 7 - selectedDate.weekday;
    if (add == 0) {
      add = 7;
    }
    selectedDate = selectedDate.add(Duration(days: add));
    setState(() {
      _initDates();
    });
    _reloadContent();
  }

  _lastDay() {
    setState(() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
      _initDates();
    });
    _reloadContent();
  }

  _lastWeek() {
    selectedDate = selectedDate.subtract(Duration(days: 7));
    setState(() {
      _initDates();
    });
    _reloadContent();
  }

  _widgetArrowsBar() {
    return Padding(
      padding: EdgeInsets.only(top: getSizeSpace(context)),
      child: SizedBox(
        height: getSizeHeight(context),
        child: Row(
          children: [
            Panel(
              onTap: viewType == "oneWeek" ? _lastWeek : _lastDay,
              height: getSizeHeight(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  sizedBox(context),
                  const Icon(
                    Icons.arrow_back,
                    size: 20,
                  ),
                  smallSizedBox(context),
                  Text(
                    viewType == "oneWeek" ? "Semana Anterior" : "Dia Anterior",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  sizedBox(context),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            Panel(
              height: getSizeHeight(context),
              onTap: viewType == "oneWeek" ? _nextWeek : _nextDay,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  sizedBox(context),
                  Text(
                    viewType == "oneWeek" ? "Semana Seguinte" : "Próximo Dia",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  smallSizedBox(context),
                  const Icon(
                    Icons.arrow_forward,
                    size: 20,
                  ),
                  sizedBox(context),
                ],
              ),
            ),
          ],
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

    Color color = Colors.green;

    if (date.isAtSameMomentAs(today)) {
      color = Colors.yellow;
    }
    if (date.isAtSameMomentAs(selectedDate)) {
      color = Colors.blue;
    }
    return Expanded(
      child: Column(
        children: [
          Panel(
            onTap: () {
              setState(() {
                selectedDate = date;
                nextTwo = [
                  selectedDate.add(Duration(days: 1)),
                  selectedDate.add(Duration(days: 2)),
                ];
                if (!week.contains(selectedDate)) {
                  _initDates();
                }
              });
            },
            height: getSizeHeight(context),
            width: w(context, 100),
            color: color,
            child: Center(child: Text(date.toString())),
          ),
        ],
      ),
    );
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

  _selectDay(DateTime date) {
    setState(() {
      if (selectedDate.isAtSameMomentAs(date) && viewType == "oneWeek") {
        viewType = "oneDay";
        _reloadContent();
      }
      selectedDate = date;
      nextTwo = [
        selectedDate.add(Duration(days: 1)),
        selectedDate.add(Duration(days: 2)),
      ];
      if (!week.contains(selectedDate)) {
        _initDates();
      }
    });
  }

  _widgetWeek() {
    List<Widget> days = [];

    if (viewType == "oneDay") {
      days.add(
        Checklist(
          date: selectedDate,
          selectedDate: selectedDate,
          selectDay: _selectDay,
          isOneDayView: true,
          tasks: tasks,
        ),
      );
    } else if (viewType == "threeDays") {
      days.add(
        Checklist(
          date: selectedDate,
          selectedDate: selectedDate,
          selectDay: _selectDay,
          isOneDayView: false,
          tasks: tasks,
        ),
      );
      days.add(sizedBox(context));
      days.add(
        Checklist(
          date: nextTwo[0],
          selectedDate: selectedDate,
          selectDay: _selectDay,
          isOneDayView: false,
          tasks: tasks,
        ),
      );
      days.add(sizedBox(context));
      days.add(
        Checklist(
          date: nextTwo[1],
          selectedDate: selectedDate,
          selectDay: _selectDay,
          isOneDayView: false,
          tasks: tasks,
        ),
      );
    } else if (viewType == "oneWeek") {
      for (int i = 0; i < 7; i++) {
        days.add(
          Checklist(
            date: week[i],
            selectedDate: selectedDate,
            selectDay: _selectDay,
            isOneDayView: false,
            tasks: tasks,
          ),
        );
        days.add(Visibility(
          visible: i < 6,
          child: smallSizedBox(context),
        ));
      }
    }

    return Visibility(
      visible: !isLoading,
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: getSizeSpace(context)),
          child: Container(
            child: Row(
              children: days,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      body: Padding(
        padding: EdgeInsets.all(getSizeSpace(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _widgetTopBar(),
            _widgetArrowsBar(),
            _widgetWeek(),
          ],
        ),
      ),
    );
  }
}

const Map<String, dynamic> agendaTypeMap = {
  "oneDay": {
    "visualization": "Hoje",
    "icon": Icons.today,
    "next": "oneWeek",
  },
  "threeDays": {
    "visualization": "Três Dias",
    "icon": Icons.calendar_view_month,
    "next": "oneWeek",
  },
  "oneWeek": {
    "visualization": "Uma Semana",
    "icon": Icons.calendar_view_week,
    "next": "oneDay",
  },
};
