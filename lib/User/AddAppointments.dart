import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcare_new/User/UserDoctorList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AddAppointments extends StatefulWidget {
  var id;
  String name;
  String department;
  String quali;
  String email;
  String location;
  String fee;
  String about;

  AddAppointments({
    super.key,
    required this.id,
    required this.name,
    required this.department,
    required this.quali,
    required this.email,
    required this.location,
    required this.fee,
    required this.about,
  });

  @override
  State<AddAppointments> createState() => _AddAppointmentsState();
}

class _AddAppointmentsState extends State<AddAppointments> {
  double rating = 3.0;
  Map<String, dynamic>? selectedPetMap;
  String? toValue;
  String? fromValue;
  String? token;
  var tok;
 double lastRating =2.0;

  @override
  void initState() {
    getToken();
    petDetails();
    getLastRating();
  }

Future<void> getLastRating() async {
  QuerySnapshot ratingSnapshot = await FirebaseFirestore.instance
      .collection('rating')
      .where('doctor_id', isEqualTo: widget.id)
      // .orderBy('timestamp', descending: true)
      .limit(1)
      .get();

  if (ratingSnapshot.docs.isNotEmpty) {
    DocumentSnapshot document = ratingSnapshot.docs.first;
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Access the rating data
    lastRating = data['rating'];
    // DateTime timestamp = data['timestamp'];

    print('Last Rating: $lastRating');
    // print('Timestamp: $timestamp');

    // Do whatever you need to do with the last rating data
  } else {
    print('No ratings found for this doctor.');
  }
}


  Future<void> getToken() async {
    String dt1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('slots')
        .where('doc_id', isEqualTo: widget.id)
        .where('date', isEqualTo: dt1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot document = snapshot.docs.first;
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      tok = (int.parse(data[' init_token'].toString()) + 1).toString();
      setState(() {
        toValue = data['to'].toString();
        fromValue = data['from'].toString();
        token = data['token'].toString();
      });
    }
  }

  Future<void> _showBookingDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Successful'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your appointment has been booked successfully.'),
                Text(
                  'Token No : ${(int.parse(tok) - int.parse(token.toString())).toString()} ',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (ctx) {
                    return UserDoctorlist();
                  }),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircleAvatar(
                  backgroundImage: AssetImage('asset/male-avatar.jpg'),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.name),
            ],
          ),
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
                          Text('Rating'),
                          RatingBar.builder(
                            initialRating: lastRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemSize: 15,
                            onRatingUpdate: (newRating) {
                              setState(() {
                                rating = newRating;
                              });
                            },
                          ),
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
                          Text(widget.location),
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
                          Text(widget.fee),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if(toValue != null)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Scheduled Time',
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('To : $toValue' ?? 'Loading...'),
                          Text('From : $fromValue' ?? 'Loading...'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'NO. OF TOKENS',
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color.fromARGB(255, 95, 62, 50),
                        ),
                        height: 50,
                        width: 50,
                        child: Center(
                          child: Text(
                            token.toString() ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              width: double.infinity,
              color: Color.fromARGB(255, 247, 238, 235),
            ),
          ),
          if(toValue != null)
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
            child: Container(
              color: Color.fromARGB(255, 247, 238, 235),
              child: DropdownButton<Map<String, dynamic>>(
                items: petDetailsList.map((Map<String, dynamic> pet) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: pet,
                    child: Text(pet['name']),
                  );
                }).toList(),
                onChanged: (selectedPet) {
                  setState(() {
                    selectedPetMap = selectedPet;
                  });
                  print(
                      'Selected Pet: ${selectedPet!['name']}, ID: ${selectedPet['id']}');
                },
                value: selectedPetMap,
                isExpanded: true,
                hint: Text(
                    'Select a pet'), // Displayed when no option is selected
              ),
            ),
          ),
          if(toValue != null)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () async {
                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    .collection('slots')
                    .where('doc_id', isEqualTo: widget.id)
                    .get();

                for (QueryDocumentSnapshot document in querySnapshot.docs) {
                  DocumentReference docRef = FirebaseFirestore.instance
                      .collection('slots')
                      .doc(document.id);

                  await docRef.update({'token': FieldValue.increment(-1)});
                }

                SharedPreferences spref = await SharedPreferences.getInstance();
                var userId = spref.getString('user_id');
                String dt1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
                String tm1 = DateFormat('HH:mm').format(DateTime.now());

                FirebaseFirestore.instance.collection('bookings').add({
                  'doctot_id': widget.id,
                  'user_id': userId,
                  'status': '0',
                  'token':
                      (int.parse(tok) - int.parse(token.toString())).toString(),
                  'date': dt1,
                  'time': tm1,
                  'pet': selectedPetMap != null ? selectedPetMap!['id'] : null,
                  'img':
                      selectedPetMap != null ? selectedPetMap!['image'] : null,
                });

                _showBookingDialog();
              },
              child: Container(
                height: 40,
                width: double.infinity,
                child: Center(child: Text('Book Now')),
                color: Colors.brown,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> petDetailsList = [];

  Future<void> petDetails() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    var sp = spref.getString('id');

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('petlist')
        .where('user_id', isEqualTo: sp)
        .get();

    setState(() {
      petDetailsList = querySnapshot.docs
          .map((doc) => {
                'name': doc['name'].toString(),
                'id': doc.id,
                'image': doc['image'].toString(),
              })
          .toList();
    });
  }
}
