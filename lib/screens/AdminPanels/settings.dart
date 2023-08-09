import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  String selectedOption = 'Account Settings';

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Column(
        children: [
          Row(
            children: [
              _buildToggleButton('Account Settings'),

              _buildToggleButton('White List'),
            ],
          ),
          SizedBox(height:MediaQuery.of(context).size.height* 0.05 ),
          selectedOption == 'Account Settings'
              ? _AccountSettingsSubInterface()
              : _WhiteListSubInterface(),

        ],
      ),
    );
  }


  Widget _AccountSettingsSubInterface() {
    return Container();
  }

  Widget _WhiteListSubInterface() {
    return Container();
  }

  Widget _buildToggleButton(String option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = option;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: selectedOption == option
              ? Border(bottom: BorderSide(width: 2, color: Colors.blue))
              : null,
        ),
        child: Text(
          option,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: selectedOption == option ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }
}
