import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
            backgroundColor: const Color.fromARGB(255, 10, 4, 37),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            width: 350,
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 10, 4, 37)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 21, 20, 20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  ''' This is a waste collection app that can be used to invoke a trash collection request to the agent and if the recyclable waste is properly segregated by the user before giving to the collection agent, then certain points are given to the user based on the quality of waste segregation and weight of the recyclable waste, these points can be exchanged to purchase different sponsored coupons which can be later redeemed at their respected stores.\  ''',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
