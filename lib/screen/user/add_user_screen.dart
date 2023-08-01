import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:local_db_sample/widget/border.dart';
import 'package:local_db_sample/widget/text_form_fileds/text_form_field_name.dart';
import 'package:provider/provider.dart';
import '../../../widget/navigator/navigator.dart';
import '../../provider/user.dart';
import '../../widget/alert_dialog/awesome_alert.dart';
import '../../widget/buttons/red_elevation_button.dart';
import '../../widget/responsive/responsive.dart';
import '../../widget/snack_bar/snack_bar_widget.dart';
import '../../widget/style_color.dart';
import 'widget/container_widget.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();

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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            'Add user',
            style: Responsive.isMobile(context)
                ? titleWhiteMobileStyle
                : titleWhiteTabletStyle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              userProvider.deleteImage();
              navigatorPopWidget(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(height: height * 0.02),
                FadeInLeft(
                  child: Consumer<UserProvider>(
                    builder: (context, value, child) {
                      return value.showImage == null
                          ? ContainerWidget(
                              widget: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Pick Image',
                                    style: Responsive.isMobile(context)
                                        ? bodyBlackMobileStyle
                                        : bodyBlackTabletStyle,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.02),
                                    child: Icon(
                                      Icons.image,
                                      size: width * 0.07,
                                    ),
                                  ),
                                ],
                              ),
                              callback: () {
                                userProvider.pickImage();
                              },
                            )
                          : ContainerWidget(
                              widget: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: borderWidget(context),
                                    child: FadeInImage(
                                      placeholder:
                                          const AssetImage('assets/loading.gif'),
                                      image: FileImage(value.showImage!),
                                      width: width,
                                      height: height,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                      placeholderFit: BoxFit.contain,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      color: primaryColor,
                                    ),
                                    onPressed: () {
                                      value.deleteImage();
                                    },
                                  ),
                                ],
                              ),
                              callback: () {
                                value.pickImage();
                              },
                            );
                    },
                  ),
                ),

                //user name
                FadeInLeft(
                  child: TextFormFieldNameWidget(
                    textEditingController: _nameController,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    textInputAction: TextInputAction.next,
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
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    maxLength: 500,
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
                  text: 'Add User',
                  onPress: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (!_key.currentState!.validate()) {
                      alertDialogWarning(
                          context, 'Error', 'Problem with entered values');
                    } else {
                      if (userProvider.fileSize != null &&
                          double.parse(userProvider.fileSize.toString()) >=
                              double.parse('10.00')) {
                        alertDialogError(context, 'Error',
                            'The selected image size is large');
                      } else {
                        if (userProvider.image != null &&
                            userProvider.fileType != 'png' &&
                            userProvider.fileType != 'jpg' &&
                            userProvider.fileType != 'jpeg') {
                          alertDialogError(context, 'Error',
                              'The selected file format is incorrect');
                        } else {
                          await userProvider.insertDatabase(
                            _nameController.text,
                            _designationController.text.replaceAll(',', ''),
                            userProvider.showImage == null
                                ? '0'
                                : userProvider.showImage!.path,
                          );
                          _designationController.clear();
                          _nameController.clear();
                          userProvider.deleteImage();
                          snackBarSuccessWidget(context, 'User added');
                          navigatorPopWidget(context);
                        }
                      }
                    }
                  },
                  minSizeW: width * 0.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
