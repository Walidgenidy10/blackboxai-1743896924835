import 'package:flutter/material.dart';
import 'package:hr_app/models/leave_model.dart';
import 'package:intl/intl.dart';

class LeaveApprovalCard extends StatelessWidget {
  final LeaveRequest leave;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const LeaveApprovalCard({
    super.key,
    required this.leave,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leave.employeeName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Chip(
                  label: Text(leave.leaveType),
                  backgroundColor: _getLeaveTypeColor(leave.leaveType),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${DateFormat('MMM d').format(leave.startDate)} - ${DateFormat('MMM d, y').format(leave.endDate)} (${leave.duration})',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Reason: ${leave.reason}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (leave.status == 'Pending')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                      onPressed: onReject,
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onApprove,
                      child: const Text('Approve'),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Icon(
                    leave.status == 'Approved'
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: leave.status == 'Approved'
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    leave.status,
                    style: TextStyle(
                      color: leave.status == 'Approved'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _getLeaveTypeColor(String type) {
    switch (type) {
      case 'Annual':
        return Colors.blue.shade100;
      case 'Sick':
        return Colors.green.shade100;
      case 'Emergency':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}