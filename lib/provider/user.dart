import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../database/db_helper.dart';

class UserModel {
  final String id;
  String userName;
  String userDesignation;
  String userImage;

  UserModel({
    required this.id,
    required this.userName,
    required this.userDesignation,
    required this.userImage,
  });
}

class UserProvider extends ChangeNotifier {
  List<UserModel> _item = [];

  List<UserModel> get item => _item;

  Uint8List? bytes;

  String? fileType;
  ImagePicker? picker;
  String? fileSize;
  XFile? image;
  File? showImage;
  int? size;

  Future pickImage() async {
    picker = ImagePicker();
    image = await picker!.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
      // maxHeight: ,
      // maxWidth: ,
    );
    showImage = File(image!.path);
    bytes = showImage?.readAsBytesSync();
    size = showImage?.readAsBytesSync().lengthInBytes;
    final kb = size! / 1024;
    final mb = kb / 1024;
    fileSize = mb.toString().substring(0, 4);
    fileType = image?.name.toString().split('.').last;
    print('image!.path=${image?.path}');
    print('fileName=$fileType');
    print('image!.mb=$mb');
    print('image!.kb=$kb');
    notifyListeners();
  }

  Future deleteImage() async {
    image = null;
    showImage = null;
    notifyListeners();
  }

  //database
  Future insertDatabase(
    String userName,
    String userDesignation,
    String userImage,
  ) async {
    final newUser = UserModel(
      id: const Uuid().v1(),
      userName: userName,
      userDesignation: userDesignation,
      userImage: userImage,
    );
    _item.add(newUser);

  await  DBHelper.insert(DBHelper.user, {
      'id': newUser.id,
      'userName': newUser.userName,
      'userDesignation': newUser.userDesignation,
      'userImage': newUser.userImage,
    });

  deleteImage();
    notifyListeners();
  }

// show items
  Future<void> selectUsers() async {
    final dataList = await DBHelper.selectUser();
    _item = dataList
        .map((item) => UserModel(
              id: item['id'],
              userName: item['userName'],
              userDesignation: item['userDesignation'],
              userImage: item['userImage'],
            ))
        .toList();
    notifyListeners();
  }

  Future<void> deleteUserById(pickId) async {
    await DBHelper.deleteById(DBHelper.user, 'id', pickId);
    print('delete_user');
    notifyListeners();
  }

  Future deleteTable() async {
    await DBHelper.deleteTable(DBHelper.user);
    print('table delete');
    notifyListeners();
  }

  Future<void> updateUserNameById(id, String userName) async {
    final db = await DBHelper.database();
    await db.update(
      DBHelper.user,
      {'userName': userName},
      where: "id = ?",
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<void> updateDesignationById(id, String userDesignation) async {
    final db = await DBHelper.database();
    await db.update(
      DBHelper.user,
      {'userDesignation': userDesignation},
      where: "id = ?",
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<void> updateUserImageById(id, userImage) async {
    final db = await DBHelper.database();
    await db.update(
      DBHelper.user,
      {'userImage': userImage},
      where: "id = ?",
      whereArgs: [id],
    );
    notifyListeners();
  }

}
