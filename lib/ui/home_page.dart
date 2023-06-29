import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:date_picker_timeline/extra/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_to_do_app/ui/widgets/button.dart';
import 'package:flutter_to_do_app/ui/themes.dart';
import 'package:flutter_to_do_app/ui/widgets/task_title.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'add_task_bard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _addTaskBar() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style: subHeadingStyle,
                    ),
                    Text(
                      "Today",
                      style: headingStyle,
                    ),
                  ],
                ),
              ),
              MyButton(
                  label: "Add Task",
                  onTap: () async {
                    await Get.to(() => AddTaskPage());
                    _taskController.getTasks();
                  }),
            ],
          ),
        )
      ],
    );
  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
        left: 20,
      ),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.blue,
        selectedTextColor: Colors.white,
        dateTextStyle: TextStyle(
            fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });

          debugPrint(_selectedDate.toString());
        },
      ),
    );
  }

  _showTasks() {
    _taskController.getTasks();
    return Expanded(child: Obx(() {
      return ListView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: (_, index) {
          print(index);
          debugPrint(
              "The length is" + _taskController.taskList.length.toString());
          Task task = _taskController.taskList[index];
          print(task.toJson());
          if (task.repeat == "Daily") {
            print("Find one daily task");
            print(task.title);
          }

          return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                child: FadeInAnimation(
                    child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          debugPrint("Taped");
                          _showBottomSheet(context, task);
                        },
                        child: TaskTitle(task)),
                  ],
                )),
              ));
        },
      );
    }));
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: EdgeInsets.only(top: 20),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.34
          : MediaQuery.of(context).size.height * 0.42,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)),
          ),
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottonSheetButton(
                  label: "Task Completed",
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!);
                    debugPrint("Taped Completed");
                    Get.back();
                  },
                  color: Colors.blue,
                  context: context),
          _bottonSheetButton(
              label: "Task Update",
              onTap: () async {
                await Get.to(() => AddTaskPage(task: task));
                // _taskController.delete(task);
                debugPrint("Taped Updated");
                Get.back();
              },
              color: Colors.red,
              context: context),
          _bottonSheetButton(
              label: "Task Deleted",
              onTap: () {
                _taskController.delete(task);
                debugPrint("Taped Deleted");
                Get.back();
              },
              color: Colors.red,
              context: context),
          _bottonSheetButton(
              label: "Cancel",
              onTap: () {
                debugPrint("Taped cancel");
                Get.back();
              },
              color: Colors.grey,
              context: context)
        ],
      ),
    ));
  }

  _bottonSheetButton(
      {required String label,
      required Function()? onTap,
      required Color color,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        height: 60,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          debugPrint('notification payload: ');
        },
        child: Icon(
          color: Colors.black,
          Icons.nightlight_round,
          size: 20,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage('images/profile.png'),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}
