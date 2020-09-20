import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';

class ProjectSegment extends StatefulWidget {
  @override
  _ProjectSegmentState createState() => _ProjectSegmentState();
}

class _ProjectSegmentState extends BaseState<ProjectSegment, ProjectViewModel> {
  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(

        )
      ],
    );
  }

  @override
  ProjectViewModel buildViewModel(BuildContext context) {
    return ProjectViewModel(context);
  }
}

class ProjectViewModel extends BaseViewModel {
  ProjectViewModel(BuildContext context) : super(context);

  @override
  void initState() {}

  @override
  void dispose() {
    super.dispose();
  }
}
