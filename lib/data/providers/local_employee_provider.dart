import 'package:get/get.dart';

import '../../core/models/employee.dart';
import '../repositories/employee_repository.dart';

/// In-memory implementation. Replace with Firebase/Supabase provider later.
class LocalEmployeeProvider extends GetxService implements EmployeeRepository {
  final _employees = <String, Employee>{};

  @override
  List<Employee> getAll() => _employees.values.toList();

  @override
  Employee? getById(String id) => _employees[id];

  @override
  void save(Employee employee) {
    _employees[employee.id] = employee;
  }

  @override
  void delete(String id) {
    _employees.remove(id);
  }
}
