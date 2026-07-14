import '../model/suscripcion.dart';

abstract class SubscriptionRepository {
  Future<Suscripcion?> getActiveSubscription();
  Future<void> createSubscription(Map<String, dynamic> data);
}
