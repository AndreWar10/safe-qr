import 'package:equatable/equatable.dart';

enum NavigationTab {
  scan(0),
  create(1),
  history(2),
  settings(3);

  const NavigationTab(this.tabIndex);
  final int tabIndex;

  static NavigationTab fromIndex(int index) {
    return NavigationTab.values.firstWhere(
      (tab) => tab.tabIndex == index,
      orElse: () => NavigationTab.scan,
    );
  }
}

class NavigationState extends Equatable {
  final NavigationTab currentTab;
  final int currentIndex;

  const NavigationState({
    required this.currentTab,
    required this.currentIndex,
  });

  factory NavigationState.initial() {
    return const NavigationState(
      currentTab: NavigationTab.scan,
      currentIndex: 0,
    );
  }

  NavigationState copyWith({
    NavigationTab? currentTab,
    int? currentIndex,
  }) {
    return NavigationState(
      currentTab: currentTab ?? this.currentTab,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object> get props => [currentTab, currentIndex];
}
