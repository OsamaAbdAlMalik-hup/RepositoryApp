
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/registration_controller.dart';
import 'package:repository/core/helper/validator_functions.dart';
import 'package:repository/view/widget/auth/button_auth.dart';
import 'package:repository/view/widget/auth/text_auth.dart';
import 'package:repository/view/widget/auth/text_large_body.dart';
import 'package:repository/view/widget/auth/text_large_title.dart';
import 'package:repository/view/widget/shared/handle_request.dart';

class RegistrationScreen extends GetView<RegistrationController> {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RegistrationController>(
        builder: (controller) => SafeArea(
          child: HandleRequest(
            statusView: controller.statusView,
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: controller.currentStep,
              onStepTapped: (value) {
                controller.currentStep = value;
                controller.update();
              },
              controlsBuilder: (context, details) {
                return Row();
              },
              elevation: 0,
              steps: [
                Step(
                    isActive: controller.currentStep >= 0,
                    state: controller.currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    title: const Text("Authentication"),
                    content: AnimatedCrossFade(
                        firstChild: registerForm(),
                        secondChild: loginForm(),
                        crossFadeState: controller.isRegister
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(microseconds: 800))),
                Step(
                    isActive: controller.currentStep >= 1,
                    state: controller.currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                    title: const Text("Repository"),
                    content: AnimatedCrossFade(
                        firstChild: addRepoForm(),
                        secondChild: joinToRepoForm(),
                        crossFadeState: controller.isCreateRepo
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(microseconds: 800))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registerForm(){
    return Form(
      key: controller.formRegisterKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextLargeTitle(text: "Register"),
            const SizedBox(height: 10),
            const TextLargeBody(text: "By email or phone"),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: controller.nameTextController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Enter user name",
                    label: const Text("Name"),
                    suffixIcon: InkWell(
                      onTap: () {},
                      child: const Icon(Icons.person_outline)
                    ),
                ),
                validator: (value) {
                  return Validate.valid(value!, maxLength: 30);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: controller.emailTextController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter user email",
                  label: const Text("Email"),
                  suffixIcon: InkWell(
                      onTap: () {},
                      child: const Icon(Icons.mail_outline)
                  ),
                ),
                validator: (value) {
                  return Validate.valid(value!,type: Validate.email, maxLength: 30);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: controller.passwordTextController,
                keyboardType: TextInputType.text,
                obscureText: controller.isHidePassword,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  label: const Text("Password"),
                  suffixIcon: InkWell(
                      onTap: () {
                        controller.isHidePassword = !controller.isHidePassword;
                        controller.update();
                      },
                  child: Icon(controller.isHidePassword
                      ? Icons.lock_outline
                      : Icons.lock_open_outlined)),
                ),
                validator: (val) {
                  return Validate.valid(val!, minLength: 8, maxLength: 30);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: controller.confirmPasswordTextController,
                keyboardType: TextInputType.text,
                obscureText: controller.isHideConfirmPassword,
                decoration: InputDecoration(
                  hintText: "Enter confirm password",
                  label: const Text("Confirm Password"),
                  suffixIcon: InkWell(
                      onTap: () {
                        controller.isHideConfirmPassword = !controller.isHideConfirmPassword;
                        controller.update();
                      },
                      child: Icon(controller.isHideConfirmPassword
                          ? Icons.lock_outline
                          : Icons.lock_open_outlined)),
                ),
                validator: (val) {
                  return Validate.valid(val!, minLength: 8, maxLength: 30);
                },
              ),
            ),
            ButtonAuth(
                text: "Register",
                onPressed: () {
                  controller.register();
                }),
            const SizedBox(height: 40),
            TextAuth(
              textone: "Are have account? ",
              texttwo: "Login",
              onTap: () {
                controller.goTo(true);
              },
            ),
          ]),
    );
  }
  Widget loginForm(){
    return Form(
      key: controller.formLoginKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextLargeTitle(text: "Login"),
            const SizedBox(height: 10),
            const TextLargeBody(text: "By email or phone"),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: controller.emailTextController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter user email",
                  label: const Text("Email"),
                  suffixIcon: InkWell(
                      onTap: () {},
                      child: const Icon(Icons.mail_outline)
                  ),
                ),
                validator: (value) {
                  return Validate.valid(value!,type: Validate.email, maxLength: 30);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: controller.passwordTextController,
                keyboardType: TextInputType.text,
                obscureText: controller.isHidePassword,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  label: const Text("Password"),
                  suffixIcon: InkWell(
                      onTap: () {
                        controller.isHidePassword = !controller.isHidePassword;
                        controller.update();
                      },
                      child: Icon(controller.isHidePassword
                          ? Icons.lock_outline
                          : Icons.lock_open_outlined)),
                ),
                validator: (val) {
                  return Validate.valid(val!, minLength: 8, maxLength: 30);
                },
              ),
            ),
            ButtonAuth(
                text: "Login",
                onPressed: () {
                  controller.login();
                }),
            const SizedBox(height: 40),
            TextAuth(
              textone: "Do you not have account? ",
              texttwo: "Register",
              onTap: () {
                controller.goTo(true);
              },
            )
          ]),
    );
  }
  Widget addRepoForm(){
    return Form(
      key: controller.formCreateRepo,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextLargeTitle(text: "Create Repository"),
            const SizedBox(height: 10),
            const TextLargeBody(
                text: "By name and unique number"),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: controller.nameTextController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Enter repo name",
                  label: const Text("Repo Name"),
                  suffixIcon: InkWell(
                      onTap: () {},
                      child: const Icon(Icons.person_outline)
                  ),
                ),
                validator: (value) {
                  return Validate.valid(value!, maxLength: 30);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: controller.addressTextController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Enter repo address",
                  label: const Text("Repo address"),
                  suffixIcon: InkWell(
                      onTap: () {},
                      child: const Icon(Icons.add_location_outlined)
                  ),
                ),
                validator: (value) {
                  return Validate.valid(value!, maxLength: 30);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: controller.passwordTextController,
                keyboardType: TextInputType.text,
                obscureText: controller.isHidePassword,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  label: const Text("Password"),
                  suffixIcon: InkWell(
                      onTap: () {
                        controller.isHidePassword = !controller.isHidePassword;
                        controller.update();
                      },
                      child: Icon(controller.isHidePassword
                          ? Icons.lock_outline
                          : Icons.lock_open_outlined)),
                ),
                validator: (val) {
                  return Validate.valid(val!, minLength: 8, maxLength: 30);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: controller.confirmPasswordTextController,
                keyboardType: TextInputType.text,
                obscureText: controller.isHideConfirmPassword,
                decoration: InputDecoration(
                  hintText: "Enter confirm password",
                  label: const Text("Confirm Password"),
                  suffixIcon: InkWell(
                      onTap: () {
                        controller.isHideConfirmPassword = !controller.isHideConfirmPassword;
                        controller.update();
                      },
                      child: Icon(controller.isHideConfirmPassword
                          ? Icons.lock_outline
                          : Icons.lock_open_outlined)),
                ),
                validator: (val) {
                  return Validate.valid(val!, minLength: 8, maxLength: 30);
                },
              ),
            ),
            ButtonAuth(
                text: "Create",
                onPressed: () {
                  controller.addRepository();
                }),
            const SizedBox(height: 40),
            TextAuth(
              textone: "Are have Know repo? ",
              texttwo: "Join",
              onTap: () {
                controller.goTo(false);
              },
            ),
          ]),
    );
  }
  Widget joinToRepoForm(){
    return Form(
      key: controller.formJoinToRepo,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextLargeTitle(text: "Join To Repository"),
            const SizedBox(height: 10),
            const TextLargeBody(text: "By name and unique number"),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: controller.nameTextController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Enter repo name",
                  label: const Text("Repo Name"),
                  suffixIcon: InkWell(
                      onTap: () {},
                      child: const Icon(Icons.person_outline)
                  ),
                ),
                validator: (value) {
                  return Validate.valid(value!, maxLength: 30);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: controller.passwordTextController,
                keyboardType: TextInputType.text,
                obscureText: controller.isHidePassword,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  label: const Text("Password"),
                  suffixIcon: InkWell(
                      onTap: () {
                        controller.isHidePassword = !controller.isHidePassword;
                        controller.update();
                      },
                      child: Icon(controller.isHidePassword
                          ? Icons.lock_outline
                          : Icons.lock_open_outlined)),
                ),
                validator: (val) {
                  return Validate.valid(val!, minLength: 8, maxLength: 30);
                },
              ),
            ),
            ButtonAuth(
                text: "Join",
                onPressed: () {
                  controller.joinToRepository();
                }),
            const SizedBox(height: 40),
            TextAuth(
              textone: "Are not have Know repo? ",
              texttwo: "Create",
              onTap: () {
                controller.goTo(false);
              },
            )
          ]),
    );
  }

}


/*
onStepContinue: () {
                if(controller.currentStep<2){
                  controller.currentStep++;
                  controller.update();
                }
              },
              onStepCancel: () {
                if(controller.currentStep>0){
                  controller.currentStep--;
                  controller.update();
                }
              },
              controlsBuilder: (context, details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    TextButton(
                      onPressed: details.onStepCancel,
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          backgroundColor: AppColors.primaryAccent201,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )
                      ),
                      child: const Text('Back'),
                    ),
                    TextButton(
                      onPressed: details.onStepContinue,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        )
                      ),
                      child: const Text('Continue',style: TextStyle(color: AppColors.white),),
                    ),
                  ],
                );
              },
 */
