import 'dart:io';
import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:local_db_sample/widget/navigator/navigator.dart';
import 'package:provider/provider.dart';
import '../../provider/user.dart';
import '../../widget/alert_dialog/awesome_alert.dart';
import '../../widget/buttons/red_elevation_button.dart';
import '../../widget/responsive/responsive.dart';
import '../../widget/snack_bar/snack_bar_widget.dart';
import '../../widget/style_color.dart';
import '../../widget/text_form_fileds/text_form_field_name.dart';
import 'widget/container_widget.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({
    Key? key,
    required this.id,
    required this.userName,
    required this.userDesignation,
    required this.userImage,
    required this.index,
  }) : super(key: key);
  final String id;
  final String userName;
  final String userDesignation;
  final String userImage;
  final int index;

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.userName;
    _designationController.text = widget.userDesignation;

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _designationController.dispose();
    super.dispose();
  }
  Future<bool> _onWillPop() async {
    final userProvider =
    Provider.of<UserProvider>(context, listen: false);

    userProvider.deleteImage();
    return navigatorPopWidget(context);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final userProvider =
        Provider.of<UserProvider>(context, listen: false);
    //
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Edit User',
          style: Responsive.isMobile(context)
              ? titleWhiteMobileStyle
              : titleWhiteMobileStyle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {


            navigatorPopWidget(context);
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(height: height * 0.02),

                FadeInLeft(
                  child: Consumer<UserProvider>(
                    builder: (context, user, child) => ContainerWidget(
                      widget: widget.userImage == '0' &&
                              user.image == null
                          ? FadeInImage(
                              placeholder: const AssetImage('assets/loading.gif'),
                              image: const AssetImage('assets/no_image.png'),
                              height: width * 0.27,
                              width: width * 0.25,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              placeholderFit: BoxFit.contain,
                            ):

                           user.image != null &&
                                  widget.userImage == '0'
                              ? Stack(
                                  children: [
                                    FadeInImage(
                                      placeholder:
                                          const AssetImage('assets/loading.gif'),
                                      image: FileImage(user.showImage!),
                                      width: width,
                                      height: height,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                      placeholderFit: BoxFit.contain,
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        user.deleteImage();
                                      },
                                    ),
                                  ],
                                )
                              : user.image == null
                                  ? FadeInImage(
                                    placeholder:
                                        const AssetImage('assets/loading.gif'),
                                    image: FileImage(File(widget.userImage)),
                                    height: width,
                                    width: width,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    placeholderFit: BoxFit.contain,
                                  )
                                  : Stack(
                                      children: [
                                        FadeInImage(
                                          placeholder:
                                              const AssetImage('assets/loading.gif'),
                                          image: FileImage(user.showImage!),
                                          width: width,
                                          height: height,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                          placeholderFit: BoxFit.contain,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_forever,
                                            color: primaryColor,
                                          ),
                                          onPressed: () {
                                            user.deleteImage();
                                          },
                                        ),
                                      ],
                                    ),
                      callback: () {
                        user.pickImage();
                      },
                    ),
                  ),
                ),

                //name
                FadeInLeft(
                  child: TextFormFieldNameWidget(
                    textEditingController: _nameController,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.name,
                    maxLength: 500,
                    minLine: 1,
                    maxLine: 1,
                    labelText: 'Full Name',
                    iconData: Icons.edit_outlined,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'User name is empty';
                      }
                      return null;
                    },
                  ),
                ),
                //user designation
                FadeInLeft(
                  child: TextFormFieldNameWidget(
                    textEditingController: _designationController,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    maxLength: 50,
                    minLine: 1,
                    maxLine: 1,
                    labelText: 'Designation',
                    iconData: Icons.money_rounded,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'User designation is empty';
                      }
                      return null;
                    },
                  ),
                ),

                ElevationButtonWidget(
                  text: 'Edit User',
                  onPress: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    var helperVar = userProvider.item[widget.index];
                    var item = userProvider.item
                        .firstWhere((element) => element.id == helperVar.id);

                    if (!_key.currentState!.validate()) {
                      alertDialogWarning(
                          context, 'Error', 'Input values are invalid');
                    } else {
                      _key.currentState!.save();
                      if (userProvider.image != null) {
                        if (userProvider.fileType != 'png' &&
                            userProvider.fileType != 'jpg' &&
                            userProvider.fileType != 'jpeg') {
                          alertDialogError(context, 'Error',
                              'The selected file format is incorrect');
                        } else {
                          if (double.parse(userProvider.fileSize.toString()) >=
                              double.parse('10.00')) {
                            alertDialogError(context, 'Error',
                                'The selected image size is large');
                          } else {
                            userProvider.updateUserNameById(
                              helperVar.id,
                              _nameController.text,
                            );
                            item.userName = _nameController.text;

                            userProvider.updateDesignationById(
                              helperVar.id,
                              _designationController.text.replaceAll(',', ''),
                            );
                            item.userDesignation =
                                _designationController.text.replaceAll(',', '');

                            //
                            if (userProvider.showImage == null &&
                                widget.userImage == '0') {
                              userProvider.updateUserImageById(
                                helperVar.id,
                                '0',
                              );
                              item.userImage = '0';
                            } else {
                              userProvider.updateUserImageById(
                                helperVar.id,
                                userProvider.showImage!.path,
                              );
                              print('object');
                              print(userProvider.showImage!.path);
                              item.userImage = userProvider.showImage!.path;
                            }

                            snackBarSuccessWidget(context, 'Editing done');
                            _designationController.clear();
                            _nameController.clear();
                            //
                            userProvider.deleteImage();
                            navigatorPopWidget(context);
                          }
                        }
                      }
                      //With out Image
                      //
                      //
                      //
                      //
                      //
                      else {
                        userProvider.updateUserNameById(
                          helperVar.id,
                          _nameController.text,
                        );
                        item.userName = _nameController.text;

                        userProvider.updateDesignationById(
                          helperVar.id,
                          _designationController.text.replaceAll(',', ''),
                        );
                        item.userDesignation =
                            _designationController.text.replaceAll(',', '');
                        //

                        snackBarSuccessWidget(context, 'Editing done');
                        _designationController.clear();
                        _nameController.clear();
                        //
                        userProvider.deleteImage();
                        navigatorPopWidget(context);
                      }
                    }
                  },
                  minSizeW: width * 0.5,
                ),
                SizedBox(height: height * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
