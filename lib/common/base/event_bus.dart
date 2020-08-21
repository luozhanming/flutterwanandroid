
/**
 * Global [EventBus] which manager event to send or receive;
 **/
import 'package:event_bus/event_bus.dart';

class Bus{
  static EventBus getEventBus(){
    return _BusHolder._eventBus;
  }

}

class _BusHolder{
  static EventBus _eventBus = EventBus();
}


class HomeIndexChangedEvent{
  final int lastIndex;
  final int newIndex;

  const HomeIndexChangedEvent(this.lastIndex, this.newIndex);
}