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
// import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:file_picker/file_picker.dart';

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

  // Future<void> pickImage() async {
  //   emit(PickingImageProfileLoadingState());
  //   try {
  //     final ImagePicker picker = ImagePicker();
  //     final XFile? pickedFile = await picker.pickImage(
  //       source: ImageSource.gallery,
  //     );

  //     if (pickedFile == null) {
  //       if (!isClosed) emit(EmptyImageProfileState());
  //       return;
  //     }

  //     File file = File(pickedFile.path);
  //     XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
  //       file.path,
  //       '${file.path}_compressed.jpg',
  //       quality: 70,
  //       minWidth: 800,
  //       minHeight: 800,
  //     );

  //     File compressedImage = compressedXFile != null
  //         ? File(compressedXFile.path)
  //         : file;
  //     final sizeInMb = await compressedImage.length() / (1024 * 1024);
  //     if (sizeInMb > 1) {
  //       XFile? compressedXFile2 = await FlutterImageCompress.compressAndGetFile(
  //         compressedImage.path,
  //         '${compressedImage.path}_compressed2.jpg',
  //         quality: 50,
  //         minWidth: 800,
  //         minHeight: 800,
  //       );

  //       if (compressedXFile2 != null) {
  //         compressedImage = File(compressedXFile2.path);
  //       }
  //     }

  //     image = compressedImage;
  //     if (!isClosed) emit(PickingImageProfileSuccessfully());
  //   } catch (e, stack) {
  //     AppLogger.error('Error Happen While Picking Image $e\n$stack');
  //     if (!isClosed) {
  //       emit(PickingImageProfileFailureState(error: e.toString()));
  //     }
  //   }
  // }

  Future<void> pickImage() async {
    emit(PickingImageProfileLoadingState());

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowCompression: true, // مهم جدًا
        compressionQuality: 70,
      );

      if (result == null || result.files.isEmpty) {
        if (!isClosed) emit(EmptyImageProfileState());
        return;
      }

      PlatformFile platformFile = result.files.first;
      File file = File(platformFile.path!);
      final sizeInMb = file.lengthSync() / (1024 * 1024);

      if (sizeInMb > 1) {
        XFile? extraCompressed = await FlutterImageCompress.compressAndGetFile(
          file.path,
          '${file.path}_extra_compressed.jpg',
          quality: 50,
          minWidth: 800,
          minHeight: 800,
        );

        if (extraCompressed != null) {
          file = File(extraCompressed.path);
        }
      }

      image = file;
      if (!isClosed) emit(PickingImageProfileSuccessfully());
    } catch (e, stack) {
      AppLogger.error('Error picking image: $e\n$stack');
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
