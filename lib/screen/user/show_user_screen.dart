import 'dart:io';

import 'package:flutter/material.dart';
import '../../widget/navigator/navigator.dart';
import 'package:provider/provider.dart';
import '../../../widget/border.dart';
import '../../../widget/buttons/small_white_elevation_button.dart';
import '../../provider/user.dart';
import '../../widget/buttons/small_red_elevation_button.dart';
import '../../widget/dismiss_back_ground/delete_dismiss_container.dart';
import '../../widget/dismiss_back_ground/update_dismiss_container.dart';
import '../../widget/responsive/responsive.dart';
import '../../widget/snack_bar/snack_bar_widget.dart';
import '../../widget/style_color.dart';
import '../../widget/text_widget.dart';
import 'add_user_screen.dart';
import 'edit_user_screen.dart';
import 'image_screen.dart';

class ShowUserScreen extends StatelessWidget {
  const ShowUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //add user
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          navigatorPushWidget(context, const AddUserScreen());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text(
          'Users',
          style: Responsive.isMobile(context)
              ? titleWhiteMobileStyle
              : titleWhiteTabletStyle,
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false)
            .selectUsers(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : Consumer<UserProvider>(
                child: Center(
                  child: Text(
                    'No user added',
                    textAlign: TextAlign.center,
                    style: Responsive.isMobile(context)
                        ? titleBigBlackMobileStyle
                        : titleBigBlackTabletStyle,
                  ),
                ),
                builder: (context, userProvider, child) => userProvider
                        .item.isEmpty
                    ? child!
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: userProvider.item.length,
                        itemBuilder: (context, index) => Dismissible(
                          key: ValueKey(userProvider.item[index].id),
                          background: const DeleteDismiss(verticalMargin: 0.03),
                          secondaryBackground:
                              const EditDismiss(verticalMargin: 0.03),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              //delete
                              return showModalBottomSheet(
                                shape: bottomSheetborderWidget(context),
                                backgroundColor: backGroundColor,
                                context: context,
                                builder: (context) => DeleteUserBottomSheet(
                                  index: index,
                                  userProvider: userProvider,
                                ),
                              );
                            } else {
                              //edit user
                              var helperVar = userProvider.item[index];
                              navigatorPushWidget(
                                context,
                                EditUserScreen(
                                  id: helperVar.id,
                                  userName: helperVar.userName,
                                  userDesignation: helperVar.userDesignation,
                                  userImage:helperVar.userImage,
                                  index: index,
                                ),
                              );
                            }
                            return null;
                          },
                          child: MainBody(
                            userProvider: userProvider,
                            index: index,
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}

class DeleteUserBottomSheet extends StatelessWidget {
  const DeleteUserBottomSheet({
    Key? key,
    required this.userProvider,
    required this.index,
  }) : super(key: key);
  final UserProvider userProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var helper = userProvider.item[index];
    return Container(
      width: width,
      height: height * 0.23,
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Do you want to delete the ${helper.userName}?',
            maxLines: 2,
            style: Responsive.isMobile(context)
                ? bodyBoldBlackMobileStyle
                : bodyBoldBlackTabletStyle,
          ),
          Row(
            children: [
              Expanded(
                child: SmallRedElevationButton(
                  text: 'Delete it',
                  onPress: () async {
                    userProvider.deleteUserById(helper.id);
                    userProvider.item.removeAt(index);
                    snackBarSuccessWidget(context, 'user removed');
                    navigatorPopWidget(context);
                  },
                ),
              ),
              Expanded(
                child: SmallWhiteElevationButton(
                  text: 'Return',
                  onPress: () {
                    navigatorPopWidget(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MainBody extends StatelessWidget {
  const MainBody({
    Key? key,
    required this.userProvider,
    required this.index,
  }) : super(key: key);
  final UserProvider userProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var helper = userProvider.item[index];
    return Card(
      elevation: 3,
      shape: shapeWidget(context),
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.01),
      shadowColor: shadowColor,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.01),
        child: Row(
         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                helper.userImage.toString() != '0'
                    ? ClipRRect(
                  borderRadius: borderWidget(context),
                  child: GestureDetector(
                    onTap: () {
                      navigatorPushWidget(
                        context,
                        ImageScreen(
                          image: File(helper.userImage),
                          heroTag: 'flutterLogo$index',
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'flutterLogo$index',
                      child: FadeInImage(
                        placeholder: const AssetImage('assets/loading.gif'),
                        image: FileImage(File(helper.userImage)),
                        width: width * 0.25,
                        height: height * 0.17,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        placeholderFit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
                    : Image.asset(
                  'assets/no_image.png',
                  height: width * 0.27,
                  width: width * 0.2,
                ),
              ],
            ),
            const SizedBox(width: 12.0),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  getBodyBoldText(context, 'Name: ', helper.userName,),
                  SizedBox(height: height * 0.02),
                  getDesignationText(context, 'Designation: ', helper.userDesignation),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
