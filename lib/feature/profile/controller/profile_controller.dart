import 'dart:io';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/model/request_model.dart';
import 'package:diyar_app/feature/profile/controller/profile_state.dart';
import 'package:diyar_app/feature/profile/model/profile_response_model.dart';
import 'package:diyar_app/feature/profile/model/user_units_response_model.dart';
import 'package:diyar_app/feature/profile/service/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';

class ProfileController extends Cubit<ProfileState> {
  ProfileController() : super(ProfileInitialState());

  static ProfileController get(BuildContext context) =>
      BlocProvider.of(context);

  ProfileResponseModel profileResponseModel = ProfileResponseModel();
  late TextEditingController emailProfileController;
  late TextEditingController nameProfileController;

  void initProfileInfoControllers() {
    emailProfileController = TextEditingController();
    nameProfileController = TextEditingController();
    phoneProfileController = PhoneController(
      initialValue: const PhoneNumber(isoCode: IsoCode.EG, nsn: ''),
    );
  }

  void disposeProfileInfoControllers() {
    emailProfileController.dispose();
    nameProfileController.dispose();
  }

  late PhoneController phoneProfileController;

  UserUnitsResponseModel userLinkedUnitsResponseModel =
      UserUnitsResponseModel();

  File? image;
  Future<void> getMyProfile() async {
    if (isClosed) return;
    emit(GetMyProfileLoadingState());
    try {
      final value = await ProfileService.getProfile();
      if (isClosed) return;
      image = null;
      profileResponseModel = value;

      if (value.data != null) {
        nameProfileController.text = value.data!.name ?? '';
        emailProfileController.text = value.data!.email ?? '';
        phoneProfileController.value = PhoneNumber(
          isoCode: IsoCode.EG,
          nsn: value.data!.phoneNumber ?? '',
        );
      }

      emit(GetMyProfileSuccessState());
    } catch (error) {
      AppLogger.warning('Error Happen While Get My Profile is $error');
      if (!isClosed) emit(GetMyProfileFailureState());
    }
  }

  Future<void> pickImage({required bool fromCamera}) async {
    emit(PickingImageProfileLoadingState());

    try {
      final ImagePicker picker = ImagePicker();

      // GALLERY → uses Android Photo Picker on Android 13+ automatically
      // CAMERA → requires only CAMERA permission (allowed by Google Play)
      final XFile? xfile = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 70, // built-in compression
        maxHeight: 1400,
        maxWidth: 1400,
      );

      if (xfile == null) {
        if (!isClosed) emit(EmptyImageProfileState());
        return;
      }

      File file = File(xfile.path);

      // Extra compression for large images
      final sizeMB = file.lengthSync() / (1024 * 1024);
      if (sizeMB > 1) {
        final compressed = await FlutterImageCompress.compressAndGetFile(
          file.path,
          '${file.path}_compressed.jpg',
          quality: 50,
          minWidth: 800,
          minHeight: 800,
        );

        if (compressed != null) {
          file = File(compressed.path);
        }
      }

      image = file;

      if (!isClosed) emit(PickingImageProfileSuccessfully());
    } catch (e, stack) {
      AppLogger.error("Error picking image: $e\n$stack");
      if (!isClosed) {
        emit(PickingImageProfileFailureState(error: e.toString()));
      }
    }
  }

  Future<void> editProfile() async {
    emit(EditingProfileLoadingState());
    try {
      final value = await ProfileService.editProfile(
        authRequestModel: RequestModel(
          email: emailProfileController.text,
          name: nameProfileController.text,
          phoneNumber: phoneProfileController.value.international,
        ),
        image: image,
      );

      if (value.success == true) {
        await getMyProfile();
        await savedCredentials(
          email: emailProfileController.text,
          password: savedPasswordForLoginWithBioMetric,
        );

        image = null;
        emit(EditingProfileSuccessfullyState());
        emit(GetMyProfileSuccessState());
      } else {
        emit(EditingProfileFailureState());
      }
    } catch (error) {
      emit(EditingProfileFailureState());
    }
  }

  Future<void> getUserLinkedUnits() async {
    if (isClosed) return;
    emit(GetUserLinkedUnitsLoadingState());
    try {
      final value = await ProfileService.getLinkedUnitsForUser();
      if (isClosed) return;

      userLinkedUnitsResponseModel = value;
      AppLogger.info('getUserLinkedUnits==> ${value.data}');

      if (value.success == true) {
        emit(GetUserLinkedUnitsSuccessfullyState());
      } else {
        emit(GetUserLinkedUnitsFailureState());
      }
    } catch (error) {
      AppLogger.error('Error Happen While Get User Linked Units is $error');
      if (!isClosed) emit(GetUserLinkedUnitsFailureState());
    }
  }
}
