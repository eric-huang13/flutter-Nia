import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/group.dart';
import 'package:nia_app/src/repo/groups_repo.dart';
import 'package:nia_app/src/ui/spacers.dart';

class GroupWidget extends StatelessWidget {
  final Group group;
  final Function onTap;

  const GroupWidget({Key key, @required this.group, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GroupsRepo.instance.selectedGroup = group;
        return onTap();
      },
      child: Container(
        margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
        decoration: BoxDecoration(
            border: Border.all(
          color: AppColors.lightGrey,
        )),
        child: Column(
          children: <Widget>[
            _buildCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                right: BorderSide(
                  color: AppColors.lightGrey,
                ),
              )),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: group.cover,
                      placeholder: (_, __) =>
                          Center(child: CircularProgressIndicator()),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    group.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                  AppSpacers.extraLargeVerticalSpacer,
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(group.avatar),
                      ),
                      AppSpacers.extraSmallHorizontalSpacer,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppStrings.createdBy,
                              style: TextStyle(fontSize: 12.0),
                            ),
                            AppSpacers.extraSmallVerticalSpacer,
                            Text(
                              group.ownername,
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpacers.extraSmallVerticalSpacer,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
