abstract class NavEvent {}

class TabChangedEvent extends NavEvent {
  final int tabIndex;
  TabChangedEvent(this.tabIndex);
}
