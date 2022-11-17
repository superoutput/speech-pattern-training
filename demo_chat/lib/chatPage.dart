import 'dart:io';
import 'package:http/http.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final docs;
  ChatPage(this.docs);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class Message {
  final String filePath;
  final String content;

  Message(this.filePath, this.content);
}

class _ChatPageState extends State<ChatPage> {
  ScrollController scrollController = ScrollController();
  String chatRoomID = '', userID = '', recordFilePath = '';
  List<Message> messages = [];
  int count = 0;
  bool isPlayingMsg = false,
      isRecording = false,
      isSending = false,
      isListening = false;
  static final _audioRecorder = Record();

  @override
  void initState() {
    // GET CHAT ROOM ID FOR CURRENT FROM CLOUD FIRESTORE
    getRoomId();
    super.initState();
  }

  getRoomId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    userID = _prefs.getString('id').toString();
    // String anotherUserID = widget.docs['id'];

    // // LOGIC TO SELECT DESIRED CHAT ROOM FROM COUD FIRESTORE
    // if (userID.compareTo(anotherUserID) > 0) {
    //   chatRoomID = '$userID - $anotherUserID';
    // } else {
    //   chatRoomID = '$anotherUserID - $userID';
    // }
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple.shade500,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 18),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.docs.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      // SizedBox(height: 6,),
                      // Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(8.0),
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(
                  top: 8,
                  // left: ((doc['senderId'] == userID) ? 64 : 10),
                  // right: ((doc['senderId'] == userID) ? 10 : 64)
                  left: 180,
                  right: 10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GestureDetector(
                    onTap: () {
                      play(messages[index].filePath);
                    },
                    onSecondaryTap: () {
                      stopRecord();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                                isPlayingMsg ? Icons.cancel : Icons.play_arrow),
                            Text(
                              'Audio-${messages[index].content}',
                              // maxLines: 10,
                            ),
                          ],
                        ),
                        // CircleAvatar(
                        //   backgroundImage: NetworkImage(
                        //       "<https://randomuser.me/api/portraits/men/5.jpg>"),
                        //   maxRadius: 20,
                        // ),
                      ],
                    )),
              ),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
          child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 50),
          onLongPress: () {
            startRecord();
            setState(() {
              isRecording = true;
            });
          },
          onLongPressEnd: (details) {
            stopRecord();
            setState(() {
              isRecording = false;
            });
          }));

  sendMsg() {
    print("Hello sendMsg");
    //   setState(() {
    //     isSending = true;
    //   });
    //   String msg = _tec.text.trim();
    //   print('here');
    //   if (msg.isNotEmpty) {
    //     var ref = FirebaseFirestore.instance
    //         .collection('messages')
    //         .doc(chatRoomID)
    //         .collection(chatRoomID)
    //         .doc(DateTime.now().millisecondsSinceEpoch.toString());
    //     FirebaseFirestore.instance.runTransaction((transaction) async {
    //       await transaction.set(ref, {
    //         "senderId": userID,
    //         "anotherUserId": widget.docs['id'],
    //         "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
    //         "content": msg,
    //         "type": 'text'
    //       });
    //     });
    //     scrollController.animateTo(0.0,
    //         duration: Duration(milliseconds: 500), curve: Curves.bounceInOut);
    //     setState(() {
    //       isSending = false;
    //     });
    //   } else {
    //     print("Hello");
    //   }
  }

  sendAudioMsg(String audioMsg) async {
    print("Hello sendAudioMsg");
    //   if (audioMsg.isNotEmpty) {
    //     var ref = FirebaseFirestore.instance
    //         .collection('messages')
    //         .doc(chatRoomID)
    //         .collection(chatRoomID)
    //         .doc(DateTime.now().millisecondsSinceEpoch.toString());
    //     await FirebaseFirestore.instance.runTransaction((transaction) async {
    //       await transaction.set(ref, {
    //         "senderId": userID,
    //         "anotherUserId": widget.docs['id'],
    //         "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
    //         "content": audioMsg,
    //         "type": 'audio'
    //       });
    //     }).then((value) {
    //       setState(() {
    //         isSending = false;
    //       });
    //     });
    //     scrollController.animateTo(0.0,
    //         duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    //   } else {
    //     print("Hello");
    //   }
  }

  // Future _loadFile(String url) async {
  //   final bytes = await readBytes(url);
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/audio.mp3');
  //   await file.writeAsBytes(bytes);
  //   if (await file.exists()) {
  //     setState(() {
  //       recordFilePath = file.path;
  //       isPlayingMsg = true;
  //       print(isPlayingMsg);
  //     });
  //     await play();
  //     setState(() {
  //       isPlayingMsg = false;
  //       print(isPlayingMsg);
  //     });
  //   }
  // }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    print(hasPermission);
    if (hasPermission) {
      recordFilePath = await getFilePath();

      await _audioRecorder.start(path: recordFilePath);
    } else {}
    setState(() {});
  }

  void stopRecord() async {
    var stop = await _audioRecorder.stop();
    if (stop != null) {
      count = count + 1;
      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
      messages.add(Message(recordFilePath, "test-send-$count"));

      setState(() {
        isSending = true;
        isPlayingMsg = false;
      });
      // await uploadAudio();
    }
  }

  Future<void> play(filePath) async {
    if (filePath != null && File(filePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(UrlSource(filePath));
    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  // uploadAudio() {
  //   final StorageReference firebaseStorageRef = FirebaseStorage.instance
  //       .ref()
  //       .child(
  //           'profilepics/audio${DateTime.now().millisecondsSinceEpoch.toString()}}.jpg');

  //   StorageUploadTask task = firebaseStorageRef.putFile(File(recordFilePath));
  //   task.onComplete.then((value) async {
  //     print('##############done#########');
  //     var audioURL = await value.ref.getDownloadURL();
  //     String strVal = audioURL.toString();
  //     await sendAudioMsg(strVal);
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

}
