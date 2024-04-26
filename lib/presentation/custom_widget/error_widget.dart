import 'package:flutter/material.dart';

typedef RetryCallBack = void Function();

Widget buildErrorWidget(
    BuildContext context, String errorMessage, RetryCallBack stateRetry) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 64,
        ),
        const SizedBox(height: 16),
        Text(
          'Error',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          errorMessage,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: stateRetry,
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}
