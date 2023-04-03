
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repository/core/bindings/intial_bindings.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/service/storage_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => StorageServices().init());
  InitialBindings().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Repository',
      color: AppColors.primary0,
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primary0,
        splashColor: AppColors.primary20,
        canvasColor: AppColors.primary0,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: AppColors.materialPrimary,
          backgroundColor: AppColors.primary5,
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.oswald(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: AppColors.primary90,
          ),
          headlineMedium: GoogleFonts.oswald(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: AppColors.primary90,
          ),
          headlineSmall: GoogleFonts.oswald(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: AppColors.primary90,
          ),
          titleLarge: GoogleFonts.oswald(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: AppColors.primary90,
          ),
          titleMedium: GoogleFonts.arimo(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: AppColors.black,
          ),
          titleSmall: GoogleFonts.oswald(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: AppColors.primary90,
          ),
          bodyLarge: GoogleFonts.oxygen(
            fontSize: 18,
            color: AppColors.black,
            fontWeight: FontWeight.w800,
          ),
          bodyMedium: GoogleFonts.oxygen(
            fontSize: 16,
            color: AppColors.black,
            fontWeight: FontWeight.w800,
          ),
          bodySmall: GoogleFonts.oxygen(
            fontSize: 14,
            color: AppColors.gray,
            fontWeight: FontWeight.w800,
          ),
          labelLarge: GoogleFonts.arimo(
            fontSize: 20,
            color: AppColors.primary70,
            fontWeight: FontWeight.bold,
          ),
          labelMedium: GoogleFonts.arimo(
            fontSize: 16,
            color: AppColors.primary70,
            fontWeight: FontWeight.w900 ,
          ),
          labelSmall: GoogleFonts.arimo(
            fontSize: 14,
            color: AppColors.primary70,
            fontWeight: FontWeight.w800,
          ),
        ),
        appBarTheme: AppBarTheme(
          color: AppColors.primary0,
          titleTextStyle: GoogleFonts.oswald(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: AppColors.primary70,
          ),
          iconTheme: const IconThemeData(
            color: AppColors.primary90,
            size: 25,
          ),
          elevation: 1,
          scrolledUnderElevation: 0,
          titleSpacing: 1,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColors.primary70,
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(color: AppColors.primary70),
          unselectedLabelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(color: AppColors.primary60),

        ),
        indicatorColor: AppColors.primary60,
        popupMenuTheme: PopupMenuThemeData(
          color: AppColors.primary0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          textStyle: GoogleFonts.oxygen(
            fontSize: 18,
            color: AppColors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          elevation: 200,
          height: 60,
          indicatorColor: AppColors.primary60,
          backgroundColor: AppColors.primary10,
          labelTextStyle: MaterialStatePropertyAll(
            GoogleFonts.arimo(
                fontSize: 14,
                color: AppColors.primary90,
                fontWeight: FontWeight.w800
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary60,
          splashColor: AppColors.primary50,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.primary5,
          errorMaxLines: 1,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.all(10),
          errorStyle: GoogleFonts.arimo(
            fontSize: 16,
            color: AppColors.danger50,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: GoogleFonts.arimo(
            fontSize: 16,
            color: AppColors.gray,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.black,width: 1)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary70,width: 1)
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.danger50,width: 1)
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.danger50,width: 1)
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.gray,width: 1)
          )
        ),
        timePickerTheme: const TimePickerThemeData(

        ),
        cardTheme: CardTheme(
          color: AppColors.primary5,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        chipTheme: ChipThemeData(
          padding: const EdgeInsets.all(8),
          side: const BorderSide(
            color: AppColors.primary60,
            width: 2,
          ),
          labelStyle: GoogleFonts.arimo(
            fontSize: 14,
            color: AppColors.black,
            fontWeight: FontWeight.w700 ,
          ),
          selectedColor: AppColors.primary20,
          backgroundColor: AppColors.primary0,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.primary70,
        )
      ),
      getPages: AppPagesRoutes.appPages,
      initialRoute: "/",
    );
  }
}
