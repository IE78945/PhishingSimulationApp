import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:phishing_simulation_app/constant.dart';
import 'package:phishing_simulation_app/models/simulation_model.dart';
import 'package:http/http.dart' as http;

class ViewEmail extends StatefulWidget {
  SimulationModel simulation;

  ViewEmail ({Key? key, required this.simulation}) : super(key: key);

  @override
  State<ViewEmail> createState() => _ViewEmailState();
}

class _ViewEmailState extends State<ViewEmail> {

  String email = "";
  bool isEmailFetched = false;

  @override
  void initState() {
    super.initState();
    fetchEmail(); // Fetch simulations when the screen loads
  }

  Future<void> fetchEmail() async {
    // Fetch the content of the file using a network request
    final response = await http.get(Uri.parse(widget.simulation.EmailTemplateFileDownloadUrl));
    // Update the simulations list with the fetched data
    if (response.statusCode == 200) {
      // Return the content of the file as a string
      setState(() {
        email = response.body;
        isEmailFetched= true;
      });
    } else {
      // Handle error
      throw Exception('Failed to read string from Firebase Storage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isEmailFetched?
                Html(
                  data: email,
                ):CircularProgressIndicator(color: Colors.blue,),


                //Button
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyLightBlue,
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Icons.check,
                      color: MyWhite,
                    ),
                    label: const Text("OK"),
                  ),
                ),

              ],
            ),

        ),

      ],
    );
  }
}
