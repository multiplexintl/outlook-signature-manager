import 'package:get/get.dart';

import '../../modules/admin/dashboard/admin_dashboard_binding.dart';
import '../../modules/admin/dashboard/admin_dashboard_view.dart';
import '../../modules/admin/employee_manager/employee_form_binding.dart';
import '../../modules/admin/employee_manager/employee_form_view.dart';
import '../../modules/admin/template_builder/template_builder_binding.dart';
import '../../modules/admin/template_builder/template_builder_view.dart';
import '../../modules/admin/template_builder/templates_list_view.dart';
import '../../modules/employee/signature_view/signature_binding.dart';
import '../../modules/employee/signature_view/signature_view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.adminDashboard;

  static final routes = [
    GetPage(
      name: Routes.adminDashboard,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: Routes.employeeForm,
      page: () => const EmployeeFormView(),
      binding: EmployeeFormBinding(),
    ),
    GetPage(
      name: Routes.signatureView,
      page: () => const SignatureView(),
      binding: SignatureBinding(),
    ),
    GetPage(
      name: Routes.templateBuilder,
      page: () => const TemplateBuilderView(),
      binding: TemplateBuilderBinding(),
    ),
    GetPage(
      name: Routes.templatesList,
      page: () => const TemplatesListView(),
    ),
  ];
}
