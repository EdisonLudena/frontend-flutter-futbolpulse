import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repository_providers.dart';
import 'auth_provider.dart';

enum SubscriptionPlan { basic, premium }

class SubscriptionState {
  final SubscriptionPlan plan;
  final bool isActive;
  final bool isLoading;

  SubscriptionState({
    this.plan = SubscriptionPlan.basic,
    this.isActive = false,
    this.isLoading = false,
  });

  bool get isPremium => plan == SubscriptionPlan.premium && isActive;

  SubscriptionState copyWith({
    SubscriptionPlan? plan,
    bool? isActive,
    bool? isLoading,
  }) {
    return SubscriptionState(
      plan: plan ?? this.plan,
      isActive: isActive ?? this.isActive,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SubscriptionNotifier extends Notifier<SubscriptionState> {
  @override
  SubscriptionState build() {
    // Escuchamos authProvider para reaccionar a cambios de usuario
    final authState = ref.watch(authProvider);
    
    if (authState.status == AuthStatus.authenticated && authState.user != null) {
      Future.microtask(() => checkRealSubscription(authState.user!.id));
    } else if (authState.status == AuthStatus.unauthenticated) {
      // Si no hay usuario, reset inmediato a básico
      return SubscriptionState();
    }
    
    return SubscriptionState();
  }

  Future<void> checkRealSubscription(String loggedUserId) async {
    state = state.copyWith(isLoading: true);
    try {
      final sub = await ref.read(subscriptionRepositoryProvider).getActiveSubscription();
      
      // CANDADO DE SEGURIDAD: 
      // 1. Debe existir suscripción.
      // 2. El usuario de la suscripción DEBE coincidir con el usuario logueado.
      // 3. El plan debe ser Premium y el estado Activo.
      
      if (sub != null && 
          sub.usuarioId == loggedUserId && 
          sub.plan.toLowerCase().trim() == 'premium' && 
          sub.estado.toLowerCase().trim() == 'activo') {
        
        state = SubscriptionState(
          plan: SubscriptionPlan.premium,
          isActive: true,
          isLoading: false,
        );
      } else {
        state = SubscriptionState(plan: SubscriptionPlan.basic, isActive: false, isLoading: false);
      }
    } catch (e) {
      state = SubscriptionState(plan: SubscriptionPlan.basic, isActive: false, isLoading: false);
    }
  }

  void clearSubscription() {
    state = SubscriptionState();
  }

  void upgradeToPremiumLocally() {
    state = SubscriptionState(plan: SubscriptionPlan.premium, isActive: true);
  }
}

final subscriptionProvider = NotifierProvider<SubscriptionNotifier, SubscriptionState>(() {
  return SubscriptionNotifier();
});
