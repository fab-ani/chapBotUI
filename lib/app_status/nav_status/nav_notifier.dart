import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_tips/app_status/nav_status/nav_status.dart';

class NavNotifier extends StateNotifier<NavStatus> {
  NavNotifier() : super(const NavStatus());

  void onIndexChanged(int index) {
    state = state.copyWith(index: index);
  }
}

final navProvider =
    StateNotifierProvider<NavNotifier, NavStatus>((ref) => NavNotifier());
