import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_connect/data/models/notification_model.dart';
import 'package:job_connect/data/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

final notificationViewModelProvider =
    AsyncNotifierProvider<NotificationViewModel, List<NotificationModel>>(
      NotificationViewModel.new,
    );

final unreadCountProvider = Provider<int>((ref) {
  final state = ref.watch(notificationViewModelProvider);
  return state.maybeWhen(
    data: (notifications) => notifications.where((n) => !n.isRead).length,
    orElse: () => 0,
  );
});

class NotificationViewModel extends AsyncNotifier<List<NotificationModel>> {
  late final NotificationRepository _repository;
  StreamSubscription? _subscription;

  @override
  Future<List<NotificationModel>> build() async {
    _repository = ref.read(notificationRepositoryProvider);

    // Subscribe to realtime updates
    _subscription?.cancel();
    _subscription = _repository.subscribeToNotifications().listen((
      newNotifications,
    ) {
      // The stream returns the full list or updates.
      // Since our repository stream returns the full list for the user query,
      // we can just update the state.
      state = AsyncValue.data(newNotifications);
    });

    // Initial fetch
    return _fetchNotifications();
  }

  Future<List<NotificationModel>> _fetchNotifications() async {
    final result = await _repository.getNotifications();
    return result.fold(
      (error) => throw Exception(error),
      (notifications) => notifications,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchNotifications());
  }

  Future<void> markAsRead(String notificationId) async {
    // Optimistic update
    final previousState = state.value;
    if (previousState != null) {
      state = AsyncValue.data(
        previousState.map((n) {
          if (n.id == notificationId) {
            return n.copyWith(isRead: true);
          }
          return n;
        }).toList(),
      );
    }

    final result = await _repository.markAsRead(notificationId);

    // Revert if failed (optional, for now we just log error in repo)
    if (result.isLeft()) {
      // Could revert here if needed
    }
  }

  Future<void> markAllAsRead() async {
    final previousState = state.value;
    if (previousState != null) {
      state = AsyncValue.data(
        previousState.map((n) => n.copyWith(isRead: true)).toList(),
      );
    }

    await _repository.markAllAsRead();
  }
}
