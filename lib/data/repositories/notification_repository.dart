import 'package:fpdart/fpdart.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/data/data_sources/supabase_service.dart';
import 'package:job_connect/data/models/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRepository {
  final SupabaseClient _client = SupabaseService.client;

  /// Get notifications for user
  Future<Either<String, List<NotificationModel>>> getNotifications(
    String userId,
  ) async {
    try {
      final data = await _client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final notifications =
          (data as List)
              .map((json) => NotificationModel.fromJson(json))
              .toList();

      AppLogger.info(
        'Fetched ${notifications.length} notifications for user: $userId',
      );
      return right(notifications);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching notifications', e, stackTrace);
      return left('Không thể tải thông báo');
    }
  }

  /// Mark notification as read
  Future<Either<String, void>> markAsRead(String notificationId) async {
    try {
      await _client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);

      AppLogger.info('Marked notification $notificationId as read');
      return right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Error marking notification as read', e, stackTrace);
      return left('Lỗi cập nhật trạng thái thông báo');
    }
  }

  /// Mark all as read
  Future<Either<String, void>> markAllAsRead(String userId) async {
    try {
      await _client
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId);

      AppLogger.info('Marked all notifications as read for user $userId');
      return right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Error marking all notifications as read', e, stackTrace);
      return left('Lỗi cập nhật trạng thái thông báo');
    }
  }
}
