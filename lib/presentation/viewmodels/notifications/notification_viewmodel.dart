import 'package:job_connect/data/models/notification_model.dart';
import 'package:job_connect/data/repositories/notification_repository.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'notification_viewmodel.g.dart';

@riverpod
class NotificationViewModel extends _$NotificationViewModel {
  late final NotificationRepository _repository;

  @override
  Future<List<NotificationModel>> build() async {
    _repository = NotificationRepository();
    return _fetchNotifications();
  }

  Future<List<NotificationModel>> _fetchNotifications() async {
    final user = ref
        .read(authViewModelProvider)
        .mapOrNull(authenticated: (state) => state.user);
    if (user == null) return [];

    final result = await _repository.getNotifications(user.userId);
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
    final currentNotifications = state.value ?? [];

    // Optimistic update
    final updatedNotifications =
        currentNotifications.map((n) {
          if (n.id == notificationId) {
            return n.copyWith(isRead: true);
          }
          return n;
        }).toList();

    state = AsyncValue.data(updatedNotifications);

    final result = await _repository.markAsRead(notificationId);
    result.fold((error) {
      // Revert if failed (simple refresh)
      refresh();
    }, (_) {});
  }

  Future<void> markAllAsRead() async {
    final user = ref
        .read(authViewModelProvider)
        .mapOrNull(authenticated: (state) => state.user);
    if (user == null) return;

    final currentNotifications = state.value ?? [];

    // Optimistic update
    final updatedNotifications =
        currentNotifications.map((n) {
          return n.copyWith(isRead: true);
        }).toList();

    state = AsyncValue.data(updatedNotifications);

    final result = await _repository.markAllAsRead(user.userId);
    result.fold((error) {
      refresh();
    }, (_) {});
  }

  int get unreadCount {
    return state.value?.where((n) => !n.isRead).length ?? 0;
  }
}
