
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/api/registration_api_controller.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/core/service/storage_services.dart';
import 'package:repository/data/models/repository.dart';
import 'package:repository/data/models/user.dart';

class RegistrationController extends GetxController {

  RegistrationApiController registrationApiController = RegistrationApiController(Get.find());

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
  static User currentUser=User();
  static Repository currentRepository=Repository();
  int currentStep = 0;

  @override
  onInit() async {
    bool isAuthenticated = StorageServices.sharedPreferences.getBool(AppSharedKeys.isAuthenticated) ?? false;
    if (isAuthenticated) {
      var user = StorageServices.getStorage.read(AppSharedKeys.currentUser);
      if(user is User) {
        currentUser = user;
      } else {
        currentUser = User.fromJson(user ?? {}) ;
      }
      var repository = StorageServices.getStorage.read(AppSharedKeys.currentRepository);
      if(repository is Repository) {
        currentRepository = repository;
      } else {
        currentRepository = Repository.fromJson(repository ?? {}) ;
      }
      var users = StorageServices.getStorage.read(AppSharedKeys.accounts);
      if(users is List<User>) {
        myAccounts = users;
      } else {
        myAccounts = User.fromJsonToList(users ?? []);
      }
      var repositories = StorageServices.getStorage.read(AppSharedKeys.repositories);
      if(repositories is List<Repository>) {
        myRepositories = repositories;
      } else {
        myRepositories = Repository.fromJsonToList(repositories ?? []) ;
      }
      var teamUsers = StorageServices.getStorage.read(AppSharedKeys.currentTeamUsers);
      if(teamUsers is List<User>) {
        myCurrentTeam = teamUsers;
      } else {
        myCurrentTeam = User.fromJsonToList(teamUsers ?? []) ;
      }
    }
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
            StorageServices.sharedPreferences.setBool(AppSharedKeys.isAuthenticated, true);
            user.name=nameTextController.text;
            user.email=emailTextController.text;
            currentUser=user;
            StorageServices.getStorage.write(AppSharedKeys.currentUser, currentUser);
            StorageServices.getStorage.save();
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
  Future<bool> registerAddAccount() async {
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
            user.name=nameTextController.text;
            user.email=emailTextController.text;
            var users = StorageServices.getStorage.read(AppSharedKeys.accounts);
            if(users is List<User>) {
              myAccounts = users;
            } else {
              myAccounts = User.fromJsonToList(users ?? []) ;
            }
            myAccounts.add(currentUser);
            StorageServices.getStorage.write(AppSharedKeys.accounts, myAccounts);
            currentUser=user;
            StorageServices.getStorage.write(AppSharedKeys.currentUser, currentUser);
            StorageServices.getStorage.save();
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
            StorageServices.sharedPreferences.setBool(AppSharedKeys.isAuthenticated, true);
            user.photo = await HelperLogicFunctions.saveFileToStorageFromURL(user.photo);
            var users = StorageServices.getStorage.read(AppSharedKeys.accounts);
            if(users is List<User>) {
              myAccounts = users;
            } else {
              myAccounts = User.fromJsonToList(users ?? []) ;
            }
            myAccounts.add(user);
            StorageServices.getStorage.write(AppSharedKeys.accounts, myAccounts);
            StorageServices.getStorage.write(AppSharedKeys.currentUser, user);
            StorageServices.getStorage.save();
            currentUser=user;
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
  Future<bool> loginAddAccount() async {
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
            user.photo = await HelperLogicFunctions.saveFileToStorageFromURL(user.photo);
            var users = StorageServices.getStorage.read(AppSharedKeys.accounts);
            if(users is List<User>) {
              myAccounts = users;
            } else {
              myAccounts = User.fromJsonToList(users ?? []) ;
            }
            myAccounts.add(currentUser);
            StorageServices.getStorage.write(AppSharedKeys.accounts, myAccounts);
            currentUser=user;
            StorageServices.getStorage.write(AppSharedKeys.currentUser, user);
            StorageServices.getStorage.save();
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
  Future<bool> loginWithToken({required User newAccount}) async {
    return await ApiService.sendRequest(
      request: () async {
        return await registrationApiController.loginWithToken(
          token: newAccount.rememberToken,
        );
      },
      onSuccess: (user) async {
        if (user is User) {
          myAccounts.add(currentUser);
          myAccounts.removeWhere((element) => element.id==newAccount.id);
          StorageServices.getStorage.write(AppSharedKeys.accounts, myAccounts);
          currentUser=user;
          currentUser.photo=newAccount.photo;
          StorageServices.getStorage.write(AppSharedKeys.currentUser, currentUser);
          StorageServices.getStorage.save();
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
  Future<bool> logout() async {
    Get.back();
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await registrationApiController.logout();
      },
      onSuccess: (response) async {
        StorageServices.sharedPreferences.setBool(AppSharedKeys.isAuthenticated, false);
        StorageServices.sharedPreferences.setBool(AppSharedKeys.isHasRepo, false);
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
  Future<bool> updateProfile({required String name,required File? image}) async {

    return await ApiService.sendRequest(
      request: () async {
        return await registrationApiController.updateProfile(
          name: name,
          photo: image
        );
      },
      onSuccess: (response) async {
        if(image!=null){
          if(currentUser.photo!='') {
            HelperLogicFunctions.deleteFileFromStorage(File(currentUser.photo));
          }
          String photoPath = await HelperLogicFunctions.saveFileToStorage(image,"profile image ${DateTime.now()}");
          currentUser.photo=photoPath;
        }
        currentUser.name=name;
        StorageServices.getStorage.write(AppSharedKeys.currentUser, currentUser);
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
            StorageServices.sharedPreferences.setBool(AppSharedKeys.isHasRepo, true);
            var repositories = StorageServices.getStorage.read(AppSharedKeys.repositories);
            if(repositories is List<Repository>) {
              myRepositories = repositories;
            } else {
              myRepositories = Repository.fromJsonToList(repositories ?? []) ;
            }
            myRepositories.add(response);
            StorageServices.getStorage.write(AppSharedKeys.repositories, myRepositories);
            StorageServices.getStorage.write(AppSharedKeys.currentRepository, response);
            StorageServices.getStorage.save();
            currentRepository=response;
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
            StorageServices.sharedPreferences.setBool(AppSharedKeys.isHasRepo, true);
            var repositories = StorageServices.getStorage.read(AppSharedKeys.repositories);
            if(repositories is List<Repository>) {
              myRepositories = repositories;
            } else {
              myRepositories = Repository.fromJsonToList(repositories ?? []) ;
            }
            myRepositories.add(response);
            StorageServices.getStorage.write(AppSharedKeys.repositories, myRepositories);
            StorageServices.getStorage.write(AppSharedKeys.currentRepository, response);
            StorageServices.getStorage.save();
            currentRepository=response;
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
  Future<void> switchRepo({required Repository newRepository}) async {
    RegistrationController.currentRepository=newRepository;
    StorageServices.getStorage.write(AppSharedKeys.currentRepository, newRepository);
    StorageServices.getStorage.save();
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
  Future<bool> getUsersForRepositories() async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await registrationApiController.getUsersForRepositories(
            repositoryId: currentRepository.id);
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
