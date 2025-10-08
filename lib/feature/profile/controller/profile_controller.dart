import 'dart:developer';
import 'dart:io';
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
  TextEditingController emailProfileController = TextEditingController();
  TextEditingController nameProfileController = TextEditingController();
  final phoneProfileController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.EG, nsn: ''),
  );
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
      log("FROM gET pROFILE cONTROLLER(profileResponseModel): ${profileResponseModel.toJson()}");
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
      log('Error Happen While Get My Profile is $error');
      if (!isClosed) emit(GetMyProfileFailureState());
    }
  }

  Future<void> pickImage() async {
    emit(PickingImageProfileLoadingState());
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) {
        if (!isClosed) emit(EmptyImageProfileState());
        return;
      }

      File file = File(pickedFile.path);
      XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
        file.path,
        '${file.path}_compressed.jpg',
        quality: 70,
        minWidth: 800,
        minHeight: 800,
      );

      File compressedImage = compressedXFile != null
          ? File(compressedXFile.path)
          : file;
      final sizeInMb = await compressedImage.length() / (1024 * 1024);
      if (sizeInMb > 1) {
        XFile? compressedXFile2 = await FlutterImageCompress.compressAndGetFile(
          compressedImage.path,
          '${compressedImage.path}_compressed2.jpg',
          quality: 50,
          minWidth: 800,
          minHeight: 800,
        );

        if (compressedXFile2 != null) {
          compressedImage = File(compressedXFile2.path);
        }
      }

      image = compressedImage;
      if (!isClosed) emit(PickingImageProfileSuccessfully());
    } catch (e, stack) {
      log('Error Happen While Picking Image $e\n$stack');
      if (!isClosed) {
        emit(PickingImageProfileFailureState(error: e.toString()));
      }
    }
  }
  Future<void> editProfile() async {
    emit(EditingProfileLoadingState());
    await ProfileService.editProfile(
          authRequestModel: RequestModel(
            email: emailProfileController.text,
            name: nameProfileController.text,
            phoneNumber: phoneProfileController.value.international,
          ),
          image: image,
        )
        .then((value) async {
          if (value.success == true) {
            image = null; 
            emit(EditingProfileSuccessfullyState());
          } else {
            emit(EditingProfileFailureState());
          }
        })
        .catchError((error) {
          log('Error Happen While Editing My Profile is $error');
          emit(EditingProfileFailureState());
        });
  }

  Future<void> getUserLinkedUnits() async {
    if (isClosed) return;
    emit(GetUserLinkedUnitsLoadingState());
    try {
      final value = await ProfileService.getLinkedUnitsForUser();
      if (isClosed) return;

      userLinkedUnitsResponseModel = value;
      log('getUserLinkedUnits==> ${value.data}');

      if (value.success == true) {
        emit(GetUserLinkedUnitsSuccessfullyState());
      } else {
        emit(GetUserLinkedUnitsFailureState());
      }
    } catch (error) {
      log('Error Happen While Get User Linked Units is $error');
      if (!isClosed) emit(GetUserLinkedUnitsFailureState());
    }
  }
}
