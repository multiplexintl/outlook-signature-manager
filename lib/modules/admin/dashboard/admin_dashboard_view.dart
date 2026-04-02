import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_pages.dart';
import '../../../core/models/employee.dart';
import 'admin_dashboard_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Multiplex Signature Manager'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.icon(
              onPressed: () => Get.toNamed(Routes.templatesList),
              icon: const Icon(Icons.style_outlined, size: 18),
              label: const Text('Templates'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFC8102E),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: controller.goToAddEmployee,
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text('Add Employee'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFC8102E),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final employees = controller.employees;
        if (employees.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.black26),
                SizedBox(height: 16),
                Text('No employees yet.',
                    style: TextStyle(color: Colors.black45, fontSize: 16)),
                SizedBox(height: 8),
                Text('Click "Add Employee" to get started.',
                    style: TextStyle(color: Colors.black38)),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: employees.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) => _EmployeeTile(
            employee: employees[i],
            onView: () => controller.viewSignature(employees[i]),
            onEdit: () => controller.goToEditEmployee(employees[i]),
            onDelete: () => _confirmDelete(context, employees[i]),
          ),
        );
      }),
    );
  }

  void _confirmDelete(BuildContext context, Employee emp) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text('Remove ${emp.name}? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.deleteEmployee(emp);
            },
            style:
                FilledButton.styleFrom(backgroundColor: const Color(0xFFC8102E)),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  final Employee employee;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EmployeeTile({
    required this.employee,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFC8102E),
          child: Text(
            employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(employee.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${employee.title}  •  ${employee.email}',
            style: const TextStyle(fontSize: 13, color: Colors.black54)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'View Signature',
              icon: const Icon(Icons.visibility_outlined, color: Color(0xFFC8102E)),
              onPressed: onView,
            ),
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined, color: Colors.black54),
              onPressed: onEdit,
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline, color: Colors.black38),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
