
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/api/registration_api_controller.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/core/service/get_storage_service.dart';
import 'package:repository/core/service/shared_preferences_service.dart';
import 'package:repository/data/models/repository.dart';
import 'package:repository/data/models/user.dart';

class RegistrationController extends GetxController {
  RegistrationApiController registrationApiController = RegistrationApiController(Get.find());
  SharedPreferencesService sharedService = Get.find();
  GetStorageService storageService = Get.find();

  GlobalKey<FormState> formRegisterKey = GlobalKey<FormState>();
  GlobalKey<FormState> formLoginKey = GlobalKey<FormState>();
  GlobalKey<FormState> formCreateRepo = GlobalKey<FormState>();
  GlobalKey<FormState> formJoinToRepo = GlobalKey<FormState>();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();

  StatusView statusView = StatusView.none;
  bool isHidePassword = true, isHideConfirmPassword = true, isRegister = true, isCreateRepo = true;
  List<Repository> myRepositories = [];
  List<User> myAccounts = [];
  List<User> myCurrentTeam = [];
  User currentUser=User();
  Repository currentRepository=Repository();
  int currentStep = 0;

  @override
  onInit() async {
    HelperLogicFunctions.printNote(storageService.storage.read(AppSharedKeys.accounts));
    myCurrentTeam = storageService.storage.read<List<User>>(AppSharedKeys.currentTeamUsers) ?? [];
    // myRepositories = storageService.storage.read<List<Repository>>(AppSharedKeys.repositories) ?? [];
    // currentUser = storageService.storage.read<User>(AppSharedKeys.currentUser) ?? currentUser;
    // currentRepository = storageService.storage.read<Repository>(AppSharedKeys.currentRepository) ?? currentRepository;
    super.onInit();
  }

  Future<bool> register() async {
    if (passwordTextController.text != confirmPasswordTextController.text) {
      HelperDesignFunctions.showErrorSnackBar(title: "Password and confirm dont not match", message: "Please try again");
      return false;
    }
    if (formRegisterKey.currentState!.validate()) {
      statusView = StatusView.loading;
      update();
      return await ApiService.sendRequest(
        request: () async {
          return await registrationApiController.register(
            name: nameTextController.text,
            email: emailTextController.text,
            password: passwordTextController.text,
            confirmPassword: confirmPasswordTextController.text,
          );
        },
        onSuccess: (user) async {
          if (user is User) {
            sharedService.sharedPreferences.setBool(AppSharedKeys.isAuthenticated, true);
            sharedService.sharedPreferences.setInt(AppSharedKeys.currentUserId, user.id);
            user.name=nameTextController.text;
            user.email=emailTextController.text;
            myAccounts = storageService.storage.read<List<User>>(AppSharedKeys.accounts)?? myAccounts;
            myAccounts.add(user);
            storageService.storage.write(AppSharedKeys.accounts, myAccounts);
            storageService.storage.save();
            ApiService.currentUser.rememberToken = user.rememberToken;
            currentStep++;
            clearField();
            statusView = StatusView.none;
            update();
          }
        },
        onFailure: (statusView, message) async {
          this.statusView = statusView;
          if (statusView == StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
      );
    }
    return false;
  }

  Future<bool> login() async {
    if (formLoginKey.currentState!.validate()) {
      statusView = StatusView.loading;
      update();
      return await ApiService.sendRequest(
        request: () async {
          return await registrationApiController.login(
            email: emailTextController.text,
            password: passwordTextController.text,
          );
        },
        onSuccess: (user) async {
          if (user is User) {
            sharedService.sharedPreferences.setBool(AppSharedKeys.isAuthenticated, true);
            sharedService.sharedPreferences.setInt(AppSharedKeys.currentUserId, user.id);
            myAccounts = storageService.storage.read<List<User>>(AppSharedKeys.accounts) ?? myAccounts;
            myAccounts.add(user);
            storageService.storage.write(AppSharedKeys.accounts, myAccounts);
            storageService.storage.save();
            ApiService.currentUser.rememberToken = user.rememberToken;
            currentStep++;
            clearField();
            statusView = StatusView.none;
            update();
          }
        },
        onFailure: (statusView, message) async {
          this.statusView = statusView;
          if (statusView == StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
      );
    }
    return false;
  }

  Future<bool> logout() async {
    Get.back();
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await registrationApiController.logout();
      },
      onSuccess: (response) async {
        sharedService.sharedPreferences.setBool(AppSharedKeys.isAuthenticated, false);
        sharedService.sharedPreferences.setBool(AppSharedKeys.isHasRepo, false);
        statusView = StatusView.none;
        Get.offAllNamed(AppPagesRoutes.registration);
      },
      onFailure: (statusView, message) async {
        this.statusView = statusView;
        if (statusView == StatusView.none) {
          HelperDesignFunctions.showErrorSnackBar(message: message.text);
        }
        update();
      },
    );
  }

  Future<bool> updateProfile() async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        // return await registrationApiController.updateProfile();
      },
      onSuccess: (response) async {
        statusView = StatusView.none;
        update();
      },
      onFailure: (statusView, message) async {
        this.statusView = statusView;
        if (statusView == StatusView.none) {
          HelperDesignFunctions.showErrorSnackBar(message: message.text);
        }
        update();
      },
    );
  }

  Future<bool> addRepository() async {
    if (passwordTextController.text != confirmPasswordTextController.text) {
      HelperDesignFunctions.showErrorSnackBar(
          title: "Password and confirm dont not match",
          message: "Please try again");
      return false;
    }
    if (formCreateRepo.currentState!.validate()) {
      statusView = StatusView.loading;
      update();
      return await ApiService.sendRequest(
        request: () async {
          return await registrationApiController.addRepository(
            name: nameTextController.text,
            address: addressTextController.text,
            code: passwordTextController.text,
          );
        },
        onSuccess: (response) async {
          if (response is Repository) {
            sharedService.sharedPreferences.setBool(AppSharedKeys.isHasRepo, true);
            myRepositories = storageService.storage.read<List<Repository>>(AppSharedKeys.repositories) ?? [];
            myRepositories.add(response);
            storageService.storage.write(AppSharedKeys.repositories, myRepositories);
            storageService.storage.save();
            Get.offAllNamed(AppPagesRoutes.mainScreen);
          }
        },
        onFailure: (statusView, message) async {
          this.statusView = statusView;
          if (statusView == StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
      );
    }
    return false;
  }

  Future<bool> joinToRepository() async {
    if (formJoinToRepo.currentState!.validate()) {
      statusView = StatusView.loading;
      update();
      return await ApiService.sendRequest(
        request: () async {
          return await registrationApiController.joinToRepository(
            code: passwordTextController.text,
          );
        },
        onSuccess: (response) async {
          if (response is Repository) {
            sharedService.sharedPreferences.setBool(AppSharedKeys.isHasRepo, true);
            myRepositories = storageService.storage.read<List<Repository>>(AppSharedKeys.repositories) ?? [];
            myRepositories.add(response);
            storageService.storage.write(AppSharedKeys.repositories, myRepositories);
            storageService.storage.save();
            Get.offAllNamed(AppPagesRoutes.mainScreen);
          }
        },
        onFailure: (statusView, message) async {
          this.statusView = statusView;
          if (statusView == StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
      );
    }
    return false;
  }

  Future<bool> getRepositoriesForUser() async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await registrationApiController.getRepositoriesForUser();
      },
      onSuccess: (response) async {
        if (response is List<Repository>) {
          myRepositories = response;
        }
      },
      onFailure: (statusView, message) async {
        this.statusView = statusView;
        if (statusView == StatusView.none) {
          HelperDesignFunctions.showErrorSnackBar(message: message.text);
        }
        update();
      },
    );
  }

  Future<bool> getUsersForRepositories({required int repositoryId}) async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await registrationApiController.getUsersForRepositories(
            repositoryId: repositoryId);
      },
      onSuccess: (response) async {
        if (response is List<User>) {
          myCurrentTeam = response;
        }
      },
      onFailure: (statusView, message) async {
        this.statusView = statusView;
        if (statusView == StatusView.none) {
          HelperDesignFunctions.showErrorSnackBar(message: message.text);
        }
        update();
      },
    );
  }

  void goTo(bool isAuthStep) {
    if (isAuthStep) {
      isRegister = !isRegister;
    } else {
      isCreateRepo = !isCreateRepo;
    }
    clearField();
    update();
  }

  void clearField() {
    isHidePassword = true;
    isHideConfirmPassword = true;
    nameTextController.clear();
    emailTextController.clear();
    addressTextController.clear();
    passwordTextController.clear();
    confirmPasswordTextController.clear();
  }
}
