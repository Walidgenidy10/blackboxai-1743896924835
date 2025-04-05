import 'package:flutter/material.dart';
import 'package:hr_app/models/leave_model.dart';
import 'package:hr_app/widgets/leave_approval_card.dart';

class ManagerHomeScreen extends StatefulWidget {
  const ManagerHomeScreen({super.key});

  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  final List<LeaveRequest> _pendingLeaves = [
    // Mock data - will be replaced with API calls
    LeaveRequest(
      id: '1',
      employeeName: 'John Doe',
      leaveType: 'Annual',
      startDate: DateTime.now().add(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 3)),
      status: 'Pending',
      reason: 'Family vacation',
    ),
    LeaveRequest(
      id: '2',
      employeeName: 'Jane Smith',
      leaveType: 'Sick',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      status: 'Pending',
      reason: 'Doctor appointment',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implement logout
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Pending Approvals'),
                Tab(text: 'Attendance'),
                Tab(text: 'Team'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Pending Approvals Tab
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _pendingLeaves.length,
                    itemBuilder: (context, index) {
                      return LeaveApprovalCard(
                        leave: _pendingLeaves[index],
                        onApprove: () => _handleApproval(index, true),
                        onReject: () => _handleApproval(index, false),
                      );
                    },
                  ),
                  // Attendance Tab
                  const Center(child: Text('Attendance Reports')),
                  // Team Tab
                  const Center(child: Text('Team Management')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleApproval(int index, bool isApproved) {
    setState(() {
      _pendingLeaves[index].status = isApproved ? 'Approved' : 'Rejected';
    });
    // TODO: Send approval to API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Leave ${isApproved ? 'approved' : 'rejected'} successfully'),
      ),
    );
  }
}