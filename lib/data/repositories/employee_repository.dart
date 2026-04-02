import '../../core/models/employee.dart';

/// Abstract contract — swap implementation for Firebase/Supabase later.
abstract class EmployeeRepository {
  List<Employee> getAll();
  Employee? getById(String id);
  void save(Employee employee);
  void delete(String id);
}
