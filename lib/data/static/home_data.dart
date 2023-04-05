
import 'package:flutter/material.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/view/widget/home/home_page.dart';
import 'package:repository/view/widget/home/monitoring_page.dart';
import 'package:repository/view/widget/home/stocktaking_page.dart';

List<NavigationDestination> bottomNavigationBarItems = [
  const NavigationDestination(
    selectedIcon: Icon(Icons.monitor_heart,color: AppColors.primary10,),
    icon: Icon(Icons.monitor_heart_outlined,color: AppColors.primary90,),
    label: 'Monitoring',
  ),
  const NavigationDestination(
    selectedIcon: Icon(Icons.home,color: AppColors.primary10,),
    icon: Icon(Icons.home_outlined,color: AppColors.primary90,),
    label: 'Home',
  ),
  const NavigationDestination(
    selectedIcon: Icon(Icons.featured_play_list,color: AppColors.primary10,),
    icon: Icon(Icons.featured_play_list_outlined,color: AppColors.primary90,),
    label: 'Stocktaking',
  ),
];
List<Widget> bottomNavigationBarPages = [
  const MonitoringPage(),
  const HomePage(),
  const StocktakingPage(),
];
// TODO Change this Icon To illustration Image
List<CardDataHome> cardItems = [
  CardDataHome(AppAssets.categoriesIconSvg, "Categories",AppPagesRoutes.categoriesScreen),
  CardDataHome(AppAssets.productsIconSvg, "Products",AppPagesRoutes.productsScreen),
  CardDataHome(AppAssets.clientsIconSvg, "Clients",AppPagesRoutes.clientsScreen),
  CardDataHome(AppAssets.suppliersIconSvg, "Suppliers",AppPagesRoutes.suppliersScreen),
  CardDataHome(AppAssets.invoiceIconSvg, "Invoices",AppPagesRoutes.invoicesScreen),
  CardDataHome(AppAssets.moneyIconSvg, "Money box",AppPagesRoutes.moneyBoxScreen),
];


class CardDataHome{
  String imagePath;
  String title;
  String screen;

  CardDataHome(this.imagePath, this.title, this.screen);
}

List<String> units=['Kg','Litter','Meter','Piece'];