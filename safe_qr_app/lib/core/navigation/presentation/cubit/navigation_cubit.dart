import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState.initial());

  void navigateToTab(int index) {
    final tab = NavigationTab.fromIndex(index);
    emit(state.copyWith(
      currentTab: tab,
      currentIndex: index,
    ));
  }

  void navigateToScan() {
    navigateToTab(NavigationTab.scan.tabIndex);
  }

  void navigateToCreate() {
    navigateToTab(NavigationTab.create.tabIndex);
  }

  void navigateToHistory() {
    navigateToTab(NavigationTab.history.tabIndex);
  }

  void navigateToSettings() {
    navigateToTab(NavigationTab.settings.tabIndex);
  }
}
