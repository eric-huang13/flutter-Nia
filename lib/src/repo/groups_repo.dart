import 'package:nia_app/src/model/group.dart';

class GroupsRepo {
  List<Group> groupList = [];

  Group _selectedGroup;
  Group get selectedGroup => _selectedGroup == null
      ? ((groupList.isNotEmpty) ? groupList.first : null)
      : _selectedGroup;
  set selectedGroup(Group group) => _selectedGroup = group;

  GroupsRepo._private();
  static final GroupsRepo instance = GroupsRepo._private();
}
