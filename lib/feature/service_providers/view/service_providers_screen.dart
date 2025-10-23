import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ServiceProvidersScreen extends StatefulWidget {
  const ServiceProvidersScreen({super.key});

  @override
  State<ServiceProvidersScreen> createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen> {

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.serviceProviders.tr()),
    );
}}
