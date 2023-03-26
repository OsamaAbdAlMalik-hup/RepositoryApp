import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/controller/screens/registration_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';

class DrawerContentHome extends GetView<MainController> {
  const DrawerContentHome({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RegistrationController());
    return Drawer(
      child: GetBuilder<MainController>(
        builder: (controller) => ListView(
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              child: Material(
                color: AppColors.primary60,
                child: Padding(
                  padding: const EdgeInsets.all(15).copyWith(bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(AppAssets.screen13),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 10, top: 10),
                                        child: Text(
                                          controller.registrationController.currentUser.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: SingleChildScrollView(
                                      reverse: true,
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: const [
                                          CircleAvatar(
                                            radius: 15,
                                            backgroundColor: AppColors.primary70,
                                            child: Icon(
                                              Icons.edit,
                                              color: AppColors.primary0,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CircleAvatar(
                                            radius: 15,
                                            backgroundColor: AppColors.primary70,
                                            child: Icon(
                                              Icons.notifications_active,
                                              color: AppColors.primary0,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CircleAvatar(
                                            radius: 15,
                                            backgroundColor: AppColors.primary70,
                                            child: Icon(
                                              Icons.settings,
                                              color: AppColors.primary0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(height: controller.isEmailsExpansion?15:0,),
                            ExpansionTile(
                              tilePadding: const EdgeInsets.only(left: 10),
                              onExpansionChanged: (value) {
                                controller.isEmailsExpansion=value;
                                controller.update();
                              },
                              title: Text(
                                controller.registrationController.currentUser.email,
                                style:
                                Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              children: List.generate(
                                controller.registrationController.myAccounts.length,
                                    (index) => ListTile(
                                  focusColor: AppColors.primary30,
                                  tileColor: AppColors.primary50,
                                  onTap: () {},
                                  title: Text(
                                    controller.registrationController.myAccounts[index].email,
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: AppColors.primary0
                                    ),
                                  ),
                                  leading: const CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(AppAssets.screen7),
                                  ),
                                ),
                              )
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text("Management",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: AppColors.primary70)),
            ),
            ExpansionTile(
              leading: const Icon(Icons.account_balance),
              tilePadding: const EdgeInsets.symmetric(horizontal: 10),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
              onExpansionChanged: (value) {},
              title: const Text(
                "My Repositories",
              ),
              children: [
                ...List.generate(controller.registrationController.myRepositories.length,
                      (index) => ListTile(
                  onTap: () {},
                  title: Text(
                    controller.registrationController.myRepositories[index].name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle:  Text(
                    controller.registrationController.myRepositories[index].address,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  leading: const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(AppAssets.screen7),
                  ),
                ),),
                ListTile(
                  focusColor: AppColors.primary30,
                  onTap: () {},
                  title: Text(
                    "Add Repository",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary60,
                      child: Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 2,
              height: 0,
            ),
            ExpansionTile(
              leading: const Icon(Icons.people_rounded),
              tilePadding: const EdgeInsets.symmetric(horizontal: 10),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
              onExpansionChanged: (value) {},
              title: const Text(
                "Current Team",
              ),
              children: [
                ...List.generate(controller.registrationController.myCurrentTeam.length,
                      (index) => ListTile(
                    onTap: () {},
                    title: Text(
                      controller.registrationController.myCurrentTeam[index].name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle:  Text(
                      controller.registrationController.myCurrentTeam[index].email,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    leading: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: controller.registrationController.myCurrentTeam[index].photo,
                      placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.primary0,
                        child: Text(
                            controller.registrationController.myCurrentTeam[index].name[0],
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black)),
                      ),
                    ),
                  ),),
              ],
            ),
            const Divider(
              thickness: 2,
              height: 0,
            ),
            ExpansionTile(
              leading: const Icon(Icons.archive),
              tilePadding: const EdgeInsets.symmetric(horizontal: 10),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
              onExpansionChanged: (value) {},
              title: const Text(
                "Archive",
              ),
              children: [
                ListTile(
                  title: Text(
                    'Invoices',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SvgPicture.asset(
                      AppAssets.invoiceIconSvg,
                      height: 25,
                      color: AppColors.primaryAccent,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppPagesRoutes.invoicesScreen, arguments: {
                      AppSharedKeys.passViewMode: ViewModeType.archiveMode
                    });
                  },
                ),
                ListTile(
                  title: Text(
                    'Clients',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  leading: SvgPicture.asset(
                    AppAssets.clientsIconSvg,
                    height: 25,
                    color: AppColors.primaryAccent,
                  ),
                  onTap: () {
                    Get.toNamed(AppPagesRoutes.clientsScreen, arguments: {
                      AppSharedKeys.passViewMode: ViewModeType.archiveMode
                    });
                  },
                ),
                ListTile(
                  title: Text(
                    'Suppliers',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  leading: SvgPicture.asset(
                    AppAssets.suppliersIconSvg,
                    height: 25,
                    color: AppColors.primaryAccent,
                  ),
                  onTap: () {
                    Get.toNamed(AppPagesRoutes.suppliersScreen, arguments: {
                      AppSharedKeys.passViewMode: ViewModeType.archiveMode
                    });
                  },
                ),
              ],
            ),
            const Divider(
              thickness: 2,
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text("Setting",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: AppColors.primary70)),
            ),
            ListTile(
              title: Text('Help', style: Theme.of(context).textTheme.bodyLarge),
              leading: const Icon(Icons.help),
              onTap: () {},
            ),
            const Divider(
              thickness: 2,
              height: 0,
            ),
            ListTile(
              title: Text('About', style: Theme.of(context).textTheme.bodyLarge),
              leading: const Icon(Icons.help_center),
              onTap: () {},
            ),
            const Divider(
              thickness: 2,
              height: 0,
            ),
            ListTile(
              title: Text('Logout', style: Theme.of(context).textTheme.bodyLarge),
              leading: const Icon(Icons.exit_to_app),
              onTap: () async {
                await controller.registrationController.logout();
              },
            ),
            const Divider(
              thickness: 2,
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}


