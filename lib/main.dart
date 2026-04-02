import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'data/providers/local_employee_provider.dart';
import 'data/providers/local_template_provider.dart';

void main() {
  // Register the in-memory repos as permanent GetX services before the app starts.
  Get.put(LocalEmployeeProvider(), permanent: true);
  Get.put(LocalTemplateProvider(), permanent: true);

  runApp(const SignatureManagerApp());
}

class SignatureManagerApp extends StatelessWidget {
  const SignatureManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Multiplex Signature Manager',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC8102E)),
        useMaterial3: true,
      ),
    );
  }
}
