import 'package:flutter/material.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:intl/intl.dart';
import '../services/navigation_service.dart';

class DateTimePickerDialog extends StatefulWidget {
  const DateTimePickerDialog({super.key, required this.initialDateTime});

  final DateTime initialDateTime;

  @override
  State<DateTimePickerDialog> createState() => _DateTimePickerDialogState();
}

class _DateTimePickerDialogState extends State<DateTimePickerDialog> {
  DateTime? _selected; // null until both date & time chosen
  bool _isPicking = false; // prevents double‑taps on button
  NavigationService get _navigationService => locator<NavigationService>();
  Future<void> _runPickers() async {
    if (_isPicking) return;
    _isPicking = true;

    // 1. Calendar
    final date = await showDatePicker(
      context: context,
      initialDate: widget.initialDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) {
      _isPicking = false;
      return; // user hit back/cancel
    }

    // 2. Clock
    TimeOfDay? time;
    final DateTime tomorrow = DateTime.now().add(Duration(days: 1));
    final TimeOfDay initialTime = TimeOfDay.fromDateTime(tomorrow);
    if (mounted) {
      time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(widget.initialDateTime),
      );

      time ??= initialTime;
    }
    setState(() {
      _selected = DateTime(
        date.year,
        date.month,
        date.day,
        time!.hour,
        time.minute,
      );
    });
    _isPicking = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatted = _selected != null
        ? DateFormat('yyyy-MM-dd HH:mm:ss').format(_selected!)
        : 'Pick date & time';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: const Color(0xFFFAF3E0),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Date & Time',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              formatted,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _runPickers,
              child: const Text('Open Calendar ▸ Clock'),
            ),
            const SizedBox(height: 24),

            // ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () =>
                      _navigationService.popDialog(result: null), // cancel
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _selected == null
                      ? null
                      : () => _navigationService.popDialog(result: _selected),
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
