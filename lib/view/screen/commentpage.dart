import 'package:comment_box/comment/comment.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/data/datasource/remote/comments/addingComments.dart';
import 'package:ecommercebig/data/datasource/remote/comments/getImgName.dart';
import 'package:ecommercebig/data/datasource/remote/comments/viewComments.dart';
import 'package:ecommercebig/view/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ecommercebig/linkapi.dart';

class commentpage extends StatefulWidget {
  @override
  _TestMeState createState() => _TestMeState();
}

class _TestMeState extends State<commentpage> {
  late final _ratingController;
  late double _rating;
  statusrequest statusreq = statusrequest.none;
  addingComments commentData = addingComments(Get.find());
  viewComments viewcommentData = viewComments(Get.find());
  userImgName imgNameData = userImgName(Get.find());
  double _userRating = 3.0;
  int _ratingBarMode = 1;
  double _initialRating = 2.0;
  bool _isRTLMode = false;
  bool _isVertical = false;

  IconData? _selectedIcon;
  @override
  void initState() {
    getAllComments();
    _rating = _initialRating;
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [];

  getAllComments() async {
    var response = await viewcommentData.postdata(selectedDriver);
    print(response);
    print("=====================================");
    print(UserPhoto);
    if (response['status'] != "failure") {
      for (int i = 0; i < response['data'].length; i++) {
        var imgName = await imgNameData
            .postdata(response['data'][i]['comment_user_id'].toString());
        var value = {
          'name': imgName['data'][0]['users_name'],
          'pic': imgName['data'][0]['users_photo'] == ""
              ? AssetImage('assets/images/profile.png') as ImageProvider<Object>
              : NetworkImage(applink.linkImageRoot +
                  '/' +
                  imgName['data'][0]['users_photo']),
          'message': response['data'][i]['comment_info'],
          'date': response['data'][i]['comment_date'],
          'rating': response['data'][i]['comment_rating'],
        };
        print(value);
        filedata.insert(0, value);
      }
    }
    setState(() {
    });
  }

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath: data[i]['pic'])),
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data[i]['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RatingBarIndicator(
                    rating: data[i]['rating'].toDouble(),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
              subtitle: Text(data[i]['message']),
              trailing: Text(data[i]['date'], style: TextStyle(fontSize: 14)),
            ),
          )
      ],
    );
  }

  Widget _heading(String text) => Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      );
  Widget _ratingBar(int mode) {
    switch (mode) {
      case 1:
        return RatingBar.builder(
          initialRating: _initialRating,
          minRating: 1,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Colors.blue.withAlpha(50),
          itemCount: 5,
          itemSize: 50.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            _selectedIcon ?? Icons.star,
            color: Colors.blue,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        );
      case 2:
        return RatingBar.builder(
          initialRating: _initialRating,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return Icon(
                  Icons.sentiment_neutral,
                  color: Colors.blue,
                );
              case 3:
                return Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              //showdialograting = false;
              Get.back(result: showdialograting);
            },
            child: Icon(Icons.arrow_back)),
        title: Text("Comment Page"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Column(
          children: [
            _heading('Rate the driver'),
            _ratingBar(_ratingBarMode),
            SizedBox(height: 20.0),
            Text(
              'Rating: $_rating',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: CommentBox(
                userImage: CommentBox.commentImageParser(
                  imageURLorPath:
                      UserPhoto == "" ? AssetImage('assets/images/profile.png') as ImageProvider<Object>:
                      NetworkImage(applink.linkImageRoot + '/$UserPhoto'),
                ),
                child: commentChild(filedata),
                labelText: 'Write a comment...',
                errorText: 'Comment cannot be blank',
                withBorder: false,
                sendButtonMethod: () async {
                  if (formKey.currentState!.validate()) {
                    //print(commentController.text);
                    setState(() {
                      var value = {
                        'name': Username,
                        'pic': UserPhoto == ""?
                        AssetImage('assets/images/profile.png') as ImageProvider<Object>:
                            NetworkImage(applink.linkImageRoot + '/$UserPhoto'),
                        'message': commentController.text,
                        'date': DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(DateTime.now()),
                        'rating': _rating,
                      };
                      filedata.insert(0, value);
                    });
                    var response = await commentData.postdata(
                        Userid!,
                        commentController.text,
                        _rating,
                        DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(DateTime.now())
                            .toString(),
                        selectedDriver);
                    statusreq = handlingdata(response);
                    print(response);
                    commentController.clear();
                    FocusScope.of(context).unfocus();
                  } else {
                    print("Not validated");
                  }
                },
                formKey: formKey,
                commentController: commentController,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                sendWidget:
                    Icon(Icons.send_sharp, size: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
