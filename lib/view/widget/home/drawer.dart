
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/controller/screens/registration_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/helper/validator_functions.dart';

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
                                      RegistrationController.currentUser.photo==''?
                                        CircleAvatar(
                                            radius: 60,
                                            backgroundColor: AppColors.primary70,
                                            child: Text(RegistrationController.currentUser.name[0],style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                              color: AppColors.primary0
                                            ),)
                                        )
                                        :CircleAvatar(
                                            radius: 60,
                                            backgroundImage: FileImage(File(RegistrationController.currentUser.photo)),
                                            child: controller.profileStatusView==StatusView.loading
                                                ? const SpinKitSpinningLines(color: AppColors.primary90)
                                                : null,
                                        ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 10, top: 10),
                                        child: Text(
                                          RegistrationController.currentUser.name,
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
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showDialogUpdateProfile(context);
                                            },
                                            child: const CircleAvatar(
                                              radius: 15,
                                              backgroundColor: AppColors.primary70,
                                              child: Icon(
                                                Icons.edit,
                                                color: AppColors.primary0,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const CircleAvatar(
                                            radius: 15,
                                            backgroundColor: AppColors.primary70,
                                            child: Icon(
                                              Icons.notifications_active,
                                              color: AppColors.primary0,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const CircleAvatar(
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
                                RegistrationController.currentUser.email,
                                style:
                                Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              children:[
                                ...List.generate(
                                  controller.registrationController.myAccounts.length,
                                      (index) => ListTile(
                                    focusColor: AppColors.primary30,
                                    tileColor: AppColors.primary50,
                                    onTap: () {
                                      HelperDesignFunctions.showAlertDialog(context,
                                          btnOkOnPress: () async {
                                            await controller.registrationController.loginWithToken(newAccount: controller.registrationController.myAccounts[index]);
                                            controller.update();
                                          },
                                          title: "Switch Account",
                                          subTitle: "Are you login by: ${controller.registrationController.myAccounts[index].name}",
                                      );
                                    },
                                    title: Text(
                                      controller.registrationController.myAccounts[index].email,
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: AppColors.primary0
                                      ),
                                    ),
                                    leading: controller.registrationController.myAccounts[index].photo==''?
                                    CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppColors.primary70,
                                        child: Text(controller.registrationController.myAccounts[index].name[0],style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                            color: AppColors.primary0
                                        ),)
                                    )
                                        :CircleAvatar(
                                      radius: 20,
                                      backgroundImage: FileImage(File(controller.registrationController.myAccounts[index].photo)),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  focusColor: AppColors.primary30,
                                  tileColor: AppColors.primary50,
                                  onTap: () {
                                    controller.registrationController.statusView=StatusView.none;
                                    controller.registrationController.update();
                                    Get.toNamed(AppPagesRoutes.registration);
                                  },
                                  title: Text(
                                    "Add Account",
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: AppColors.primary0
                                    ),
                                  ),
                                  leading: const Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppColors.primary30,
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                ),
                              ]
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
                  onTap: () {
                    HelperDesignFunctions.showAlertDialog(context,
                        btnOkOnPress: () async {
                          await controller.registrationController.switchRepo(newRepository: controller.registrationController.myRepositories[index]);
                          controller.update();
                        },
                        title: "Switch Repository",
                        subTitle: "Are you switch to: ${controller.registrationController.myRepositories[index].name}",
                    );
                  },
                  title: Text(
                    controller.registrationController.myRepositories[index].name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle:  Text(
                    controller.registrationController.myRepositories[index].address,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  leading: RegistrationController.currentRepository.id==controller.registrationController.myRepositories[index].id
                    ? const CircleAvatar(
                        radius: 23,
                        backgroundColor: AppColors.success50,
                        child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(AppAssets.screen7),
                      ),
                    ) :const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(AppAssets.screen7),
                  ),
                ),),
                ListTile(
                  focusColor: AppColors.primary30,
                  onTap: () {
                    controller.registrationController.currentStep=1;
                    controller.registrationController.statusView=StatusView.none;
                    controller.registrationController.update();
                    Get.toNamed(AppPagesRoutes.registration);
                  },
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
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        controller.registrationController.myCurrentTeam[index].photo,
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
                      color: AppColors.primary40,
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
                    color: AppColors.primary40,
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
                    color: AppColors.primary40,
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
                HelperDesignFunctions.showAlertDialog(context,
                    btnOkOnPress: () async {
                      await controller.registrationController.logout();
                    },
                    dialogType: 'delete',
                    title: "Logout",
                    subTitle: "Are you sure remove the account : ${RegistrationController.currentUser.name}",
                );
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

  void showDialogUpdateProfile(BuildContext context) {
    controller.clearFields();
    controller.nameFieldController.text=RegistrationController.currentUser.name;
    HelperDesignFunctions.showAlertDialog(context,
        btnOkOnPress: () async {
          if(controller.formKeyUpdateProfileDebt.currentState!.validate()){
            controller.profileStatusView=StatusView.loading;
            controller.update();
            bool result = await controller.registrationController.updateProfile(
              name: controller.nameFieldController.text,
              image: controller.image,
            );
            if (result) {
              controller.profileStatusView=StatusView.none;
              controller.update();
            }
          } else{
            HelperDesignFunctions.showErrorSnackBar(message: "the name can't be empty ");
          }
        },
      title: "Update Your Profile",
      children: [
        Form(
          key: controller.formKeyUpdateProfileDebt,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GetBuilder<MainController>(
                    builder: (controller) => CircleAvatar(
                      radius: 52,
                      backgroundColor: AppColors.primary60,
                      child: CircleAvatar(
                        backgroundImage: controller.image != null
                            ? FileImage(controller.image!)
                            : RegistrationController.currentUser.photo!=''
                            ? FileImage(File(RegistrationController.currentUser.photo))
                            : null,
                        radius: 50,
                        backgroundColor: AppColors.primary5,
                        child: controller.image == null && RegistrationController.currentUser.photo==''
                            ? Image.asset(
                          AppAssets.person,
                        )
                            : null,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    right: -10,
                    child: InkWell(
                      onTap: () async {
                        controller.image = await HelperLogicFunctions.pickImage(
                            ImageSource.gallery);
                        controller.update();
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary10,
                        child: Icon(
                          Icons.camera,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Name"),
                  hintText: 'Enter your name',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.nameFieldController,
                validator: (text) {
                  return Validate.valid(text!);
                },
              )
            ],
          ),
        )
      ]
    );
  }

}


