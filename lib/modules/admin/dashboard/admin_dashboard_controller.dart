import 'package:get/get.dart';

import '../../../core/models/employee.dart';
import '../../../data/providers/local_employee_provider.dart';
import '../../../app/routes/app_pages.dart';

class AdminDashboardController extends GetxController {
  final LocalEmployeeProvider _repo = Get.find();

  final employees = <Employee>[].obs;

  @override
  void onInit() {
    super.onInit();
    _refresh();
  }

  void _refresh() => employees.assignAll(_repo.getAll());

  void goToAddEmployee() {
    Get.toNamed(Routes.employeeForm)?.then((_) => _refresh());
  }

  void goToEditEmployee(Employee emp) {
    Get.toNamed(Routes.employeeForm, arguments: emp)?.then((_) => _refresh());
  }

  void viewSignature(Employee emp) {
    final route = '/signature/${emp.id}';
    Get.toNamed(route, arguments: emp);
  }

  void deleteEmployee(Employee emp) {
    _repo.delete(emp.id);
    _refresh();
  }
}
