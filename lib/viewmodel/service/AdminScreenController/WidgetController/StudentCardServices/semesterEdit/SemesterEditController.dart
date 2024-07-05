// semester_controller.dart
import 'dart:async';

import 'package:attendanceadmin/constant/AppUrl/StudentCard/StudentCardApi.dart';
import 'package:attendanceadmin/viewmodel/service/LoginService/AuthServices.dart';
import 'package:attendanceadmin/viewmodel/service/LoginService/AutharizationHeader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../../../constant/AppUrl/TeacherCard/TeacherCardAPi.dart';
import '../../../../../../model/LoginModel.dart';

class SemesterController extends GetxController {
  final AuthService authService = AuthService();

  final semesterNameController = TextEditingController();

  final Rx<int?> selectedDepartmentId = Rx<int?>(null);

  final RxList<int> departmentIdList = <int>[].obs;

  FutureOr<void> getDepartmentId() async {
    //
    final UserModel? userModel = authService.getUserModel();
    if (userModel != null) {
      //
      final response = await ApiHelper.get(
        "${Teachercardapi.teacherEndPoint}/${userModel.id}",
        headers: await ApiHelper().getHeaders(),
      );

      if (response.statusCode != 200) {
        return;
      } else {
        // Add this line to debug
        final List<dynamic> bodyDecode = jsonDecode(response.body);

        // Assuming you want to process each department
        for (var department in bodyDecode) {
          departmentIdList.add(department['id']);
        }
      }
    } else {
      return;
    }
    return null;
  }

  Future<void> addSemester() async {
    final name = semesterNameController.text.trim();
    if (name.isNotEmpty && selectedDepartmentId.value != null) {
      await ApiHelper.update(
        "${StudentCardApi.addSemesterEndPoint}?sem=$name&deptId=$selectedDepartmentId",
        headers: await ApiHelper().getHeaders(),
      );
    } else {
      Get.snackbar('Error', 'Please enter a semester name');
    }
  }

  @override
  void onClose() {
    semesterNameController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    getDepartmentId();
    super.onInit();
  }
}