import 'package:agendeja/services/tasks.service.dart';
import 'package:agendeja/style/sizes.dart';
import 'package:agendeja/widgets/panel.dart';
import 'package:flutter/material.dart';

import '../util/formatting.dart';
import 'input.dart';

class TaskCard extends StatefulWidget {
  final DateTime date;
  final Map<String, dynamic>? task;
  final void Function() reloadTasks;
  final bool isOneDayView;
  final void Function(DateTime date) selectDay;
  final int? index;

  const TaskCard({
    super.key,
    required this.date,
    required this.reloadTasks,
    this.task,
    required this.isOneDayView,
    required this.selectDay,
    this.index,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final TaskService _taskService = TaskService();
  late DateTime _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  bool enableHourSelection = false;
  final TextEditingController _nameController = TextEditingController();

  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
    if (widget.task != null) {
      setState(() {
        _nameController.text = widget.task?["name"];
        _selectedStartTime = widget.task?["startTime"] == null
            ? null
            : parseTimeOfDay(widget.task?["startTime"]);
        _selectedEndTime = widget.task?["endTime"] == null
            ? null
            : parseTimeOfDay(widget.task?["endTime"]);
        _selectedDate = DateTime.parse(widget.task?["date"]);
        isSelected = widget.task?["checked"] ?? false;
      });
    }
  }

  String _getSelectedDateString() {
    String string =
        "${_selectedDate.day} de ${monthNames[_selectedDate.month]} de ${_selectedDate.year}";

    if (_selectedDate.isAtSameMomentAs(DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ))) {
      string = "Hoje";
    }

    return string;
  }

  TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  void saveTask() async {
    final task = {
      'id': _isCreation() ? DateTime.now().toString() : widget.task?["id"],
      'date': _selectedDate.toString(),
      'startTime': _selectedStartTime != null
          ? '${_selectedStartTime!.hour.toString().padLeft(2, '0')}:${_selectedStartTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'endTime': _selectedEndTime != null
          ? '${_selectedEndTime!.hour.toString().padLeft(2, '0')}:${_selectedEndTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'name': _nameController.text,
      'createdAt': DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).toString(),
      "checked": isSelected,
    };

    await _taskService.createTask(task);

    widget.reloadTasks();

    if (_isCreation()) {
      setState(() {
        _nameController.clear();
        _selectedStartTime = null;
        _selectedEndTime = null;
      });
    }
  }

  void deleteTask() async {
    await _taskService.deleteTask(widget.task?["id"]);

    widget.reloadTasks();
  }

  String _getSelectedTimeString(TimeOfDay? time) {
    if (time == null) {
      return "Selecionar";
    } else {
      final String formattedHour = time.hour.toString().padLeft(2, '0');
      final String formattedMinute = time.minute.toString().padLeft(2, '0');
      return "$formattedHour:$formattedMinute";
    }
  }

  bool isModified() {
    if (widget.task == null) return false;

    final bool nameModified = _nameController.text != widget.task?['name'];
    final bool startTimeModified = _selectedStartTime !=
        (widget.task?['startTime'] == null
            ? null
            : parseTimeOfDay(widget.task?['startTime']));
    final bool endTimeModified = _selectedEndTime !=
        (widget.task?['endTime'] == null
            ? null
            : parseTimeOfDay(widget.task?['endTime']));
    final bool dateModified =
        _selectedDate != DateTime.parse(widget.task?['date']);
    final bool checkedModified =
        isSelected != (widget.task?['checked'] ?? false);

    return nameModified ||
        startTimeModified ||
        endTimeModified ||
        dateModified ||
        checkedModified;
  }

  Future<void> _datePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<void> _timePicker(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _selectedStartTime = picked;
        } else {
          if (picked.hour > 23 || (picked.hour == 23 && picked.minute > 59)) {
            _selectedEndTime = TimeOfDay(hour: 23, minute: 59);
          } else {
            _selectedEndTime = picked;
          }
        }
      });
    }
  }

  Widget _widgetDateButton() {
    return Panel(
      onTap: () {
        _datePicker(context);
      },
      hasShadow: false,
      color: Colors.grey.shade100,
      height: getSizeHeight(context) * 0.7,
      child: Padding(
        padding: EdgeInsets.only(
          left: getSizeSmallSpace(context),
          right: getSizeSmallSpace(context),
        ),
        child: Center(
          child: Row(
            children: [
              const Icon(
                Icons.today,
                size: 18,
              ),
              Visibility(
                visible: _isCreation(),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: getSizeSmallSpace(context) * 0.5),
                  child: Text(
                    _getSelectedDateString(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTimeString() {
    if (_selectedStartTime == null && _selectedEndTime == null) {
      return "Sem Horário Definido";
    } else if (_selectedStartTime != null && _selectedEndTime == null) {
      final String formattedStartHour =
          _selectedStartTime!.hour.toString().padLeft(2, '0');
      final String formattedStartMinute =
          _selectedStartTime!.minute.toString().padLeft(2, '0');
      return "$formattedStartHour:$formattedStartMinute";
    } else if (_selectedStartTime != null && _selectedEndTime != null) {
      final String formattedStartHour =
          _selectedStartTime!.hour.toString().padLeft(2, '0');
      final String formattedStartMinute =
          _selectedStartTime!.minute.toString().padLeft(2, '0');
      final String formattedEndHour =
          _selectedEndTime!.hour.toString().padLeft(2, '0');
      final String formattedEndMinute =
          _selectedEndTime!.minute.toString().padLeft(2, '0');
      return "$formattedStartHour:$formattedStartMinute às $formattedEndHour:$formattedEndMinute";
    }
  }

  Widget _widgetHourButton() {
    return Panel(
      onTap: () {
        setState(() {
          enableHourSelection = !enableHourSelection;
        });
      },
      hasShadow: false,
      color: Colors.grey.shade100,
      height: getSizeHeight(context) * 0.7,
      child: Padding(
        padding: EdgeInsets.only(
          left: getSizeSmallSpace(context),
          right: getSizeSmallSpace(context),
        ),
        child: Center(
          child: Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 18,
              ),
              Visibility(
                visible: _isCreation() || _selectedStartTime != null,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: getSizeSmallSpace(context) * 0.5),
                  child: Text(
                    getTimeString(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _widgetStartTimeButton() {
    return Panel(
      onTap: () {
        _timePicker(context, true);
      },
      hasShadow: false,
      color: Colors.grey.shade100,
      height: getSizeHeight(context) * 0.7,
      child: Padding(
        padding: EdgeInsets.only(
          left: getSizeSmallSpace(context),
          right: getSizeSmallSpace(context),
        ),
        child: Center(
          child: Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 18,
              ),
              SizedBox(
                width: getSizeSmallSpace(context) * 0.5,
              ),
              Text(_getSelectedTimeString(_selectedStartTime)),
            ],
          ),
        ),
      ),
    );
  }

  _widgetEndTimeButton() {
    return Panel(
      onTap: () {
        _timePicker(context, false);
      },
      hasShadow: false,
      color: Colors.grey.shade100,
      height: getSizeHeight(context) * 0.7,
      child: Padding(
        padding: EdgeInsets.only(
          left: getSizeSmallSpace(context),
          right: getSizeSmallSpace(context),
        ),
        child: Center(
          child: Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 18,
              ),
              SizedBox(
                width: getSizeSmallSpace(context) * 0.5,
              ),
              Text(
                _getSelectedTimeString(_selectedEndTime),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _isCreation() {
    return widget.task == null;
  }

  getPanelColor() {
    return isSelected ? Colors.green : Colors.white;
  }

  getTextColor() {
    return isSelected ? Colors.white : Colors.black;
  }

  _widgetSimpleCard() {
    return Panel(
      color: getPanelColor(),
      onTap: () {
        widget.selectDay(widget.date);
      },
      child: Padding(
        padding: EdgeInsets.all(getSizeSmallSpace(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: _selectedStartTime != null,
              child: Padding(
                padding: EdgeInsets.only(bottom: getSizeSmallSpace(context)),
                child: Text(getTimeString(),
                    style: TextStyle(color: getTextColor())),
              ),
            ),
            Text(_nameController.text,
                textAlign: TextAlign.center,
                style: TextStyle(color: getTextColor())),
          ],
        ),
      ),
    );
  }

  _getColor() {
    List<Color> colors = [
      Colors.red,
      Colors.amber,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.pink.shade400,
    ];
    return colors[(widget.index ?? 0) % colors.length];
  }

  _widgetCheck() {
    return Visibility(
      visible: !_isCreation(),
      child: Padding(
        padding: EdgeInsets.only(left: getSizeSpace(context)),
        child: Panel(
          color: Colors.transparent,
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          hasShadow: false,
          width: getSizeSpace(context),
          height: getSizeSpace(context),
          child: Center(
            child: Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              size: 15,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isOneDayView
        ? Panel(
            color: getPanelColor(),
            child: Column(
              children: [
                SizedBox(
                  height: getSizeHeight(context),
                  child: Row(
                    children: [
                      _widgetCheck(),
                      Visibility(
                        visible: _selectedStartTime != null,
                        child: Padding(
                          padding: EdgeInsets.only(left: getSizeSpace(context)),
                          child: Container(
                            width: getSizeSpace(
                              context,
                            ),
                            height: getSizeSpace(
                              context,
                            ),
                            decoration: BoxDecoration(
                              color: _getColor(),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white, // Cor da borda
                                width: 1.0, // Largura da borda
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _isCreation(),
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: getSizeSmallSpace(context)),
                          child: Icon(Icons.add_circle),
                        ),
                      ),
                      Visibility(
                        visible: !_isCreation(),
                        child: Padding(
                          padding: EdgeInsets.only(left: getSizeSpace(context)),
                          child: _widgetHourButton(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: getSizeSpace(context)),
                        child: Input(
                          onChanged: (_) {
                            setState(() {});
                          },
                          width: getSizeHeight(context) * 10,
                          height: getSizeSubHeight(context),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          hintText: "Criar nova tarefa",
                          controller: _nameController,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: getSizeSpace(context)),
                        child: _widgetDateButton(),
                      ),
                      Visibility(
                        visible: _isCreation(),
                        child: Padding(
                          padding: EdgeInsets.only(left: getSizeSpace(context)),
                          child: _widgetHourButton(),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Visibility(
                        visible: _isCreation() || isModified(),
                        child: IconButton(
                          icon: Icon(Icons.save),
                          onPressed: saveTask,
                        ),
                      ),
                      Visibility(
                        visible: !_isCreation(),
                        child: IconButton(
                          icon: Icon(Icons.delete_forever_outlined,
                              color: Colors.red),
                          onPressed: deleteTask,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: enableHourSelection,
                  child: SizedBox(
                    height: getSizeHeight(context) * 2.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _widgetStartTimeButton(),
                            smallSizedBox(context),
                            Text("Início"),
                            Visibility(
                              visible: _selectedStartTime != null,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: getSizeSmallSpace(context),
                                ),
                                child: Panel(
                                  hasShadow: false,
                                  onTap: () {
                                    setState(() {
                                      _selectedStartTime = null;
                                      _selectedEndTime = null;
                                    });
                                  },
                                  child: Text(
                                    "Cancelar",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: getSizeHeight(context),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _widgetEndTimeButton(),
                            smallSizedBox(context),
                            Text("Término"),
                            Visibility(
                              visible: _selectedEndTime != null,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: getSizeSmallSpace(context),
                                ),
                                child: Panel(
                                  hasShadow: false,
                                  onTap: () {
                                    setState(() {
                                      _selectedEndTime = null;
                                    });
                                  },
                                  child: Text(
                                    "Cancelar",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : _widgetSimpleCard();
  }
}
