import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petcare_new/Admin/AdminTab.dart';


class DoctorView extends StatefulWidget {
  var name;
  var qualification;
  var email;
  var fees;
  var documents;
  String id;
  String dept;

  DoctorView({
    super.key,
    required this.name,
    required this.email,
    required this.qualification,
    required this.fees,
    
    required List<DocumentSnapshot<Object?>> documents,
    required this.id, required this.dept,
  });

  @override
  State<DoctorView> createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView> {
  String statusText = ''; // Added to hold status text

  @override
  void initState() {
    super.initState();
    // Fetch and set the status when the widget is initialized
    fetchStatus();
  }

  Future<void> fetchStatus() async {
    // Fetch the document from Firestore
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('doctorlist')
        .doc(widget.id)
        .get();

    // Get the status field from the document
    var status = documentSnapshot['status'];
    setState(() {
      statusText = status;
    });

    // Set the status text based on the retrieved status
  }

  @override
  Widget build(BuildContext context) {
    // var a = widget.documents;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Doctor Profile'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 255, 242, 237),
                  backgroundImage: AssetImage('asset/doctor.png'),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            ],
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 190,
              width: double.infinity,
              color: Color.fromARGB(255, 247, 238, 235),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Email'),
                          Text(widget.email),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Department'),
                           Text(widget.dept),
                         // RatingBar(
                              //   filledIcon: Icons.star,
                              //   size: 20,
                              //   emptyIcon: Icons.star_border,
                              //   onRatingChanged: (value) =>
                              //       debugPrint('$value'),
                              //   initialRating: 3,
                              //   maxRating: 5,
                              // )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Location'),
                          Text(widget.qualification),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Fee'),
                          Text(widget.fees),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),   ],
              ),
              if (statusText == '0')
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('doctorlist')
                                .doc(widget.id)
                                .update({'status': '2'});
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return AdminTab();
                              },
                            ));
                          },
                          child: Container(
                            width: screenSize.width / 2.3,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(222, 224, 10, 10),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                                child: Text(
                              "Reject",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('doctorlist')
                                .doc(widget.id)
                                .update({'status': '1'});
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return AdminTab();
                              },
                            ));
                          },
                          child: Container(
                            width: screenSize.width / 2.3,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(222, 1, 154, 100),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                                child: Text(
                              "Approve",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if(statusText=='1')
               Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
               
                      Expanded(
                        child: Container(
                          width: screenSize.width / 2.3,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(222, 1, 154, 100),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: Text(
                            "Approved",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                 if(statusText=='2')
               Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
               
                      Expanded(
                        child: Container(
                          width: screenSize.width / 2.3,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: Text(
                            "Rejected",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
            ]));
  }
}
