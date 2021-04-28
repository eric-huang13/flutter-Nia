import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/model/group.dart';
import 'package:nia_app/src/repo/groups_repo.dart';

class GroupsSelectBottomSheet extends StatelessWidget {
  final Function(Group) onItemTap;
  const GroupsSelectBottomSheet({
    Key key,
    this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Container(
            margin: EdgeInsets.all(4.0),
            height: 10.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: AppColors.darkGrey,
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ),
        Expanded(
            child: SingleChildScrollView(
                child: Column(
          children: GroupsRepo.instance.groupList
              .map((group) => new GroupSelectBottomSheetItem(
                  group: group, onTap: onItemTap))
              .toList(),
        )))
      ],
    );
  }
}

class GroupSelectBottomSheetItem extends StatelessWidget {
  final Group group;
  final Function(Group) onTap;

  const GroupSelectBottomSheetItem({Key key, @required this.group, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap(group);
        Navigator.pop(context);
      },
      title: Text(group.name),
      trailing: Icon(group == GroupsRepo.instance.selectedGroup
          ? Icons.check
          : MaterialCommunityIcons.circle_outline),
    );
  }
}
