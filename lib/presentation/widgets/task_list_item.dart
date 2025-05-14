import 'package:flutter/material.dart';
import '../../../data/models/task.dart';
import '../../../core/util/date_formatter.dart';
import '../../../config/theme.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(Task) onStatusChanged;
  final Function() onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onTap,
    required this.onStatusChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('task_${task.id}'),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Task'),
              content: const Text('Are you sure you want to delete this task?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('DELETE'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        onDelete();
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: _getPriorityColor(),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: AppTheme.titleStyle.copyWith(
                          decoration: task.status == TaskStatus.done
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor().withAlpha((0.2 * 255).toInt()),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        task.priority.name,
                        style: AppTheme.captionStyle.copyWith(
                          color: _getPriorityColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: AppTheme.bodyStyle.copyWith(
                    color: Colors.black54,
                    decoration: task.status == TaskStatus.done
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatter.formatRelativeDate(task.createdDate),
                      style: AppTheme.captionStyle,
                    ),
                    const Spacer(),
                    _buildStatusDropdown(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _getStatusColor().withAlpha((0.2 * 255).toInt()),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TaskStatus>(
          value: task.status,
          icon: const Icon(Icons.arrow_drop_down, size: 16),
          elevation: 4,
          isDense: true,
          style: AppTheme.captionStyle.copyWith(
            color: _getStatusColor(),
            fontWeight: FontWeight.bold,
          ),
          onChanged: (TaskStatus? newValue) {
            if (newValue != null) {
              onStatusChanged(task.copyWith(status: newValue));
            }
          },
          items: TaskStatus.values.map<DropdownMenuItem<TaskStatus>>((status) {
            return DropdownMenuItem<TaskStatus>(
              value: status,
              child: Text(status.name),
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.low:
        return AppTheme.lowPriorityColor;
      case TaskPriority.medium:
        return AppTheme.mediumPriorityColor;
      case TaskPriority.high:
        return AppTheme.highPriorityColor;
    }
  }

  Color _getStatusColor() {
    switch (task.status) {
      case TaskStatus.todo:
        return AppTheme.pendingStatusColor;
      case TaskStatus.inProgress:
        return AppTheme.inProgressStatusColor;
      case TaskStatus.done:
        return AppTheme.completedStatusColor;
    }
  }
}
