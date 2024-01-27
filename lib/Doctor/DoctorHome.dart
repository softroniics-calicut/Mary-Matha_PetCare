import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petcare_new/Doctor/DoctorProfileView.dart';
import 'package:petcare_new/Doctor/graph.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  @override
  void initState() {
    getData();
    tokenCount();
  }

  var init_token;
  var token;
  void tokenCount() async {
    try {
      String dt1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
      SharedPreferences spref = await SharedPreferences.getInstance();
      var sp = spref.getString('id');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('slots')
          .where('doc_id', isEqualTo: sp)
          .where('date', isEqualTo: dt1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Iterate through each document in the snapshot
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          // Print the entire data of the document
          print('Document data: ${document.data()}');

          // If 'token' is a field in the document, print its value
          token = document.get('token').toString();
          init_token = document.get(' init_token').toString();
          print('Token: $init_token');

          // You can add more print statements for other fields if needed
          // For example, if 'name' is another field, you can print it like this:
          // if (document.data().containsKey('name')) {
          //   var name = document.get('name').toString();
          //   print('Name: $name');
          // }
        }
      } else {
        print('No matching documents found.');
      }
    } catch (error) {
      print('Error fetching token count: $error');
      // Handle the error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    double value = 3.5;
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      // SizedBox(child: logout1()),
      Container(
        height: 170,
        color: Color.fromRGBO(255, 231, 223, 1),
        child: Padding(
          padding: const EdgeInsets.only(right: 32, left: 32, top: 30),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                children: [
                  Container(
                    
                    height: 47,
                    width: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white, width: 1.5)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //  init_token != null?
                  
                ],
              ),
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 163, 202, 234),
                    backgroundImage: AssetImage(
                      "asset/doctor.png",
                    ),
                    radius: 40,
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 55, top: 34),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileView()));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ]),
          ]),
        ),
      ),
      Expanded(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: bookingsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  print('object');
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Graph(
                      pet_id: '${bookingsList[index]['pet']}',
                    );
                  }));
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          print('object');
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return Graph(
                              pet_id: '${bookingsList[index]['pet']}',
                            );
                          }));
                        },
                        child: SizedBox(
                          width: 130,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              "${bookingsList[index]['img']}",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Text("Token : ${bookingsList[index]['token']}"),
                      Text("${bookingsList[index]['date']}"),
                      // Text("${bookingsList[index]['time']}"),
                    ],
                  ),
                  height: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color.fromARGB(255, 195, 194, 194),
                      width: 1,
                    ),
                    color: Color.fromRGBO(250, 241, 238, 1),
                  ),
                ),
              ),
            );
          },
        ),
      )
    ])));
  }

  List<Map<String, dynamic>> bookingsList = [];

  Future<void> getData() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    var sp = spref.getString('id');
    print('--------------------------$sp');

    // Get the current date in the format used in Firestore
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('doctot_id', isEqualTo: sp)
        .where('date',
            isEqualTo: currentDate) // Add this filter for the current date
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        // Clear the existing data
        // bookingsList.clear();

        // Process the data and add it to the list
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic> bookingData =
              document.data() as Map<String, dynamic>;
          bookingsList.add(bookingData);
          print(bookingsList);
        }
      });
    } else {
      print('No bookings found for the doctor on the current date.');
    }
  }
}
