


import 'package:flutter/widgets.dart';

import '../../app.dart';


/**
 * 路由生命周期可知的State,无ViewModel
 * */
abstract class RouteAwareWidgetState<T extends StatefulWidget> extends State<T> with RouteAware{
     @override
     void dispose() {
          routeObserver.unsubscribe(this);
          super.dispose();
     }

     @override
     void didChangeDependencies() {
          super.didChangeDependencies();
          routeObserver.subscribe(this, ModalRoute.of(context));
     }
}
