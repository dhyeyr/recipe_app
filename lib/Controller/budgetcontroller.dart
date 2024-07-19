
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/budgetmodel.dart';
import '../Model/db_helper.dart';
import '../Model/util.dart';

class BudgetController extends GetxController {
  TextEditingController number = TextEditingController();
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController note = TextEditingController();

  RxList<BudgetModel> inList = <BudgetModel>[].obs;
  RxList<BudgetModel> exList = <BudgetModel>[].obs;

  RxString? type = "Income".obs;
  RxString category = "".obs;

  @override
  void onInit() {
    inTVal();
    super.onInit();
  }

  void inTVal() {
    if (type?.value == "Income") {
      category.value = inCategory.first;
    } else {
      category.value = exCategory.first;
    }
  }

  void fillData() async {
    DbHelper helper = DbHelper();
    if (globalKey.currentState?.validate() ?? false) {
      await helper.insertBudget(
        BudgetModel(
          date: DateTime.now().toString(),
          amount: int.tryParse(amount.text),
          category: category.value,
          name: name.text,
          note: note.text,
          type: type?.value,
        ),
      );
      // Get.off(() => AddExpense());
      amount.clear();
      print("success");
    } else {
      print(" else success");

    }
  }

  Future<void> feaTchData(bool isIncome) async {
    DbHelper helper = DbHelper();
    var data = await helper.getBalance(income: isIncome);
    print(" hiii data $data");

    if (isIncome) {
      inList.value = data?.map(
            (e) {
              return BudgetModel.fromJson(e);
            },
          ).toList() ??
          [];
      print("LENGTH ==>> ${inList.length}");
    } else {
      exList.value = data?.map((e) {
            return BudgetModel.fromJson(e);
          }).toList() ??
          [];
      print("LENGTH ==>> ${exList.length}");
    }
  }
}
