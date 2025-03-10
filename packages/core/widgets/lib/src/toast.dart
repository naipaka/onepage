import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// A utility function to show a toast message.
void _showToast(
  BuildContext context, {
  required ToastificationType type,
  required String title,
  String? description,
  Widget? icon,
}) {
  toastification.show(
    context: context,
    type: type,
    style: ToastificationStyle.flat,
    title: Text(title),
    description: description != null ? Text(description) : null,
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(seconds: 3),
    icon: icon,
    borderRadius: BorderRadius.circular(12),
    showProgressBar: false,
  );
}

/// Display a success toast message.
void showSuccessToast(
  BuildContext context, {
  required String title,
  String? description,

  required Widget icon,
}) {
  _showToast(
    context,
    title: title,
    description: description,
    type: ToastificationType.success,
    icon: icon,
  );
}

/// Display an error toast message.
void showErrorToast(
  BuildContext context, {
  required String title,
  String? description,
}) {
  _showToast(
    context,
    title: title,
    description: description,
    type: ToastificationType.error,
  );
}
