
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appViewModelProvider = StateNotifierProvider<AppViewModel, AppState>((ref) {
  return AppViewModel();
});

class AppState {
  final bool isDarkTheme;
  final List<String> lowStockProducts;

  AppState({this.isDarkTheme = false, this.lowStockProducts = const []});

  AppState copyWith({
    bool? isDarkTheme,
    List<String>? lowStockProducts,
  }) {
    return AppState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      lowStockProducts: lowStockProducts ?? this.lowStockProducts,
    );
  }
}

class AppViewModel extends StateNotifier<AppState> {
  AppViewModel() : super(AppState());

  void toggleDarkTheme() {
    state = state.copyWith(isDarkTheme: !state.isDarkTheme);
  }

  // Mock data for low stock products
  void fetchLowStockProducts() {
    state = state.copyWith(lowStockProducts: [
      'Product A',
      'Product B',
    ]);
  }

  bool get isDarkTheme => state.isDarkTheme;
  List<String> get lowStockProducts => state.lowStockProducts;
}
