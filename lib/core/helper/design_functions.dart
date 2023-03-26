
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/core/constant/app_colors.dart';

class HelperDesignFunctions{

  static Future<String?> choseDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      return formatDate(date);
    }
    return null;
  }
  static Future<DateTimeRange?> choseDateRange(BuildContext context) async {
    return await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 30)),
          end: DateTime.now()
      ),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary90,
              onPrimary: AppColors.primary10,
            ),
          ),
          child: child!),
    );
  }
  static String formatDate(DateTime date){
    if(date.month<10){
      if(date.day<10){
        return '${date.year}-0${date.month}-0${date.day}';
      }
      return '${date.year}-0${date.month}-${date.day}';
    }
    if(date.day<10){
      if(date.month<10){
        return '${date.year}-0${date.month}-0${date.day}';
      }
      return '${date.year}-${date.month}-0${date.day}';
    }
    return '${date.year}-${date.month}-${date.day}';
  }


  static void showAwesomeDialog(BuildContext context, {Function()? btnOkOnPress,
    Function()? btnCancelOnPress,required Widget body,
    DialogType dialogType = DialogType.noHeader ,bool dismissOnTouchOutside=true}
    ){
    AwesomeDialog(
      context: context,
      dialogBackgroundColor: AppColors.primary0,
      dismissOnTouchOutside: dismissOnTouchOutside,
      dialogType: dialogType,
      btnCancelOnPress: btnCancelOnPress,
      btnOkOnPress: btnOkOnPress,
      btnCancelColor: AppColors.gray,
      btnOkColor: AppColors.primary70,
      buttonsTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: AppColors.primary0
      ),
      body: body,
    ).show();
  }
  static void showMainBottomSheet(BuildContext context, {Function()? btnOkOnPress,
    Function()? btnCancelOnPress, required Widget content,required double height,
    String title = "Create Product",double titleSize=30,
    Color headerColor = AppColors.primary60, bool isHaveButtons=true}
    ){
    bool isFullScreen=height==Get.height;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(
        top: isFullScreen ? const Radius.circular(0) : const Radius.circular(25),
      )),
      builder: (context) => SafeArea(
        child: Container(
          height: height,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: headerColor,
                    borderRadius: BorderRadius.only(
                        topRight: isFullScreen
                            ? const Radius.circular(0)
                            : const Radius.circular(25),
                        topLeft: isFullScreen
                            ? const Radius.circular(0)
                            : const Radius.circular(25))),
                width: double.infinity,
                height: 0.13 * Get.height,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: isFullScreen ? 40 : 10),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: AppColors.white
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ListView(
                    children: [
                      content,
                      isHaveButtons
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: MaterialButton(
                                    onPressed: btnCancelOnPress,
                                    color: AppColors.gray,
                                    disabledColor: AppColors.gray,
                                    disabledTextColor: Colors.white54,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: const Text(
                                      "cancel",
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.white),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    width: 5,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: MaterialButton(
                                    onPressed: btnOkOnPress,
                                    color: AppColors.primary,
                                    disabledColor: AppColors.red,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: const Text(
                                      "save",
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showSuccessSnackBar({String title='Success', String message='operation is done',int duration=3}){
    Get.snackbar(title, message,
        icon: const Icon(
          Icons.done,
          color: AppColors.white,
        ),
        backgroundColor: AppColors.green,
        duration: Duration(seconds: duration),
        animationDuration: const Duration(seconds: 1));
  }
  static void showErrorSnackBar({String title='Error',String message='operation is not done!',int duration=3}){
    Get.snackbar(title, message,
        icon: const Icon(
          Icons.error,
          color: AppColors.white,
        ),
        colorText: AppColors.white,
        backgroundColor: AppColors.red,
        duration: Duration(seconds: duration),
        animationDuration: const Duration(seconds: 1));
  }
  static void showWarringSnackBar({String title='Warring',String message='operation may be not done!',int duration=3}){
    Get.snackbar(title, message,
        icon: const Icon(
          Icons.error,
          color: AppColors.white,
        ),
        colorText: AppColors.black,
        backgroundColor: AppColors.warning50,
        duration: Duration(seconds: duration),
        animationDuration: const Duration(seconds: 1));
  }
  static Future<bool> alertExitApp() {
    Get.defaultDialog(
        title: "Waning",
        titleStyle: const TextStyle(color: AppColors.primary , fontWeight: FontWeight.bold),
        middleText: "Are you sure from ignore the invoice!",
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(AppColors.primary)),
              onPressed: () {
                Get.back();
                Get.back();
              },
              child:const Text("Ok",style: TextStyle( fontWeight: FontWeight.bold),)),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(AppColors.gray)),
              onPressed: () {
                Get.back();
              },
              child:const Text("Cancel",style: TextStyle( fontWeight: FontWeight.bold),))
        ]);
    return Future.value(true);
  }

}
