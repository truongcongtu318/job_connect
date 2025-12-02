import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/data/data_sources/supabase_service.dart';
import 'package:job_connect/data/models/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRepository {
  final SupabaseClient _client = SupabaseService.client;

  /// Fetch notifications for the current user
  Future<Either<String, List<NotificationModel>>> getNotifications({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return left('User not logged in');

      final data = await _client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final notifications =
          (data as List).map((e) => NotificationModel.fromJson(e)).toList();

      return right(notifications);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching notifications', e, stackTrace);
      return left('Không thể tải thông báo');
    }
  }

  /// Mark a notification as read
  Future<Either<String, Unit>> markAsRead(String notificationId) async {
    try {
      await _client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
      return right(unit);
    } catch (e, stackTrace) {
      AppLogger.error('Error marking notification as read', e, stackTrace);
      return left('Lỗi khi cập nhật trạng thái');
    }
  }

  /// Mark all notifications as read
  Future<Either<String, Unit>> markAllAsRead() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return left('User not logged in');

      await _client
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId)
          .eq('is_read', false); // Only update unread ones

      return right(unit);
    } catch (e, stackTrace) {
      AppLogger.error('Error marking all as read', e, stackTrace);
      return left('Lỗi khi cập nhật trạng thái');
    }
  }

  /// Subscribe to realtime notifications
  Stream<List<NotificationModel>> subscribeToNotifications() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return const Stream.empty();

    // Note: This is a simplified stream. In a real app, you might want to
    // merge this with the initial fetch or use a StreamController to manage state.
    // For now, we'll just listen to INSERT events and return the new notification.
    // However, the ViewModel usually handles the list state.
    // So here we return a stream of *new* notifications.

    return _client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((e) => NotificationModel.fromJson(e)).toList());
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return 0;

      final count = await _client
          .from('notifications')
          .count(CountOption.exact)
          .eq('user_id', userId)
          .eq('is_read', false);

      return count;
    } catch (e) {
      return 0;
    }
  }
}
