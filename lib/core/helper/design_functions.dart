
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

  static void showInfoSnackBar(
      {String title = 'Info',
        String message = 'operation is done',
        int duration = 5}
      ){
    Get.snackbar(title, message,
        icon: const Icon(
          Icons.done,
          color: AppColors.primary90,
        ),
        barBlur: 5,
        isDismissible: true,
        colorText: AppColors.primary90,
        backgroundColor: AppColors.primary35,
        duration: Duration(seconds: duration),
        animationDuration: const Duration(seconds: 1));
  }
  static void showSuccessSnackBar(
      {String title = 'Success',
        String message = 'operation is done',
        int duration = 5}
      ){
    Get.snackbar(title, message,
        icon: const Icon(
          Icons.done,
          color: AppColors.primary90,
        ),
        barBlur: 5,
        isDismissible: true,
        colorText: AppColors.primary90,
        backgroundColor: AppColors.success60,
        duration: Duration(seconds: duration),
        animationDuration: const Duration(seconds: 1));
  }
  static void showErrorSnackBar(
      {String title = 'Error',
        String message = 'operation is not done!',
        int duration = 5}
      ){
    Get.snackbar(title, message,
        icon: const Icon(
          Icons.error,
          color: AppColors.danger60,
        ),
        barBlur: 5,
        isDismissible: true,
        colorText: AppColors.primary90,
        backgroundColor: AppColors.danger60,
        duration: Duration(seconds: duration),
        animationDuration: const Duration(milliseconds: 600));
  }
  static void showWarringSnackBar(
      {String title = 'Warring',
        String message = 'operation may be not done!',
        int duration = 5}
      ){
    Get.snackbar(title, message,
        icon: const Icon(
          Icons.error,
          color: AppColors.danger60,
        ),
        barBlur: 5,
        isDismissible: true,
        colorText: AppColors.primary90,
        backgroundColor: AppColors.warning60,
        duration: Duration(seconds: duration),
        animationDuration: const Duration(milliseconds: 600));
  }

  static void showFormDialog(BuildContext context,
      {required String title,
      GlobalKey<FormState>? formKey,
      List<Widget> children = const [],
      String okText = 'Save',
      String cancelText = 'Cancel',
      double insetPaddingHorizontal = 30,
      Function()? btnOkOnPress,
      Function()? btnCancelOnPress,
      bool hasButtonsAction = true,
      bool barrierDismissible = true}
      ){
    Get.dialog(
      barrierDismissible: barrierDismissible,
      Dialog(
        clipBehavior: Clip.hardEdge,
        insetPadding: EdgeInsets.symmetric(horizontal: insetPaddingHorizontal),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
            shrinkWrap: true,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.oswald(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: AppColors.primary90,
                ),
              ),
              const Divider(
                thickness: 2,
                height: 20,
              ),
              ...children,
              if(hasButtonsAction) Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: MaterialButton(
                        onPressed: () {
                          if(btnCancelOnPress!=null){
                            btnCancelOnPress.call();
                          }
                          Get.back();
                        },
                        color: AppColors.gray,
                        disabledColor: AppColors.gray,
                        disabledTextColor: Colors.white54,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(30))),
                        child: Text(
                          cancelText,
                          style: const TextStyle(
                              fontSize: 20, color: AppColors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      flex: 3,
                      child: MaterialButton(
                        onPressed: btnOkOnPress,
                        color: AppColors.primary50,
                        disabledColor: AppColors.danger50,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(30))),
                        child: Text(
                          okText,
                          style: const TextStyle(
                              fontSize: 20, color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  static void showAlertDialog(BuildContext context,
      {required String title,
      List<Widget> children = const [],
      String? subTitle,
      String okText = 'Ok',
      String cancelText = 'Cancel',
      String dialogType = 'default',
      Function()? btnOkOnPress,
      Function()? btnCancelOnPress,
      bool hasButtonsAction = true,
      bool barrierDismissible = true}
      ){
    Get.dialog(
      barrierDismissible: barrierDismissible,
      SimpleDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(
              thickness: 2,
              height: 10,
            ),
          ],
        ),
        children: [
          if(subTitle!=null) Center(child: Text(subTitle,textAlign: TextAlign.center,style: const TextStyle(fontSize: 18),)),
          ...children,
          if(hasButtonsAction) Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: MaterialButton(
                    onPressed: () {
                      if(btnCancelOnPress!=null) {
                        btnCancelOnPress.call();
                      }
                      Get.back();
                    },
                    color: AppColors.gray,
                    disabledColor: AppColors.gray,
                    disabledTextColor: Colors.white54,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(30))),
                    child: Text(
                      cancelText,
                      style: const TextStyle(
                          fontSize: 20, color: AppColors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  flex: 3,
                  child: MaterialButton(
                    onPressed: (){
                      if(btnOkOnPress!=null) {
                        btnOkOnPress.call();
                      }
                      Get.back();
                    },
                    color: dialogType=='delete' ? AppColors.danger50 : AppColors.primary50,
                    disabledColor: AppColors.danger50,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(30))),
                    child: Text(
                      okText,
                      style: const TextStyle(
                          fontSize: 20, color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
