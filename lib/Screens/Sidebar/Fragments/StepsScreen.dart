import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:ngo_app/Constants/StringConstants.dart';


class StepsScreen extends StatefulWidget {
  @override
  _StepsScreenState createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen>  {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
      color: Colors.transparent,
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Start a Fundraiser in three simple steps", style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 13.0),),
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("assets/images/ic_start_fundraiser_step.png",height: 55,width: 50,),
                    SizedBox(width: MediaQuery.of(context).size.width * .03 ,),
                     Text("Start your fundraiser",style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  margin:  EdgeInsets.only(left: 24,),
                  padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: DottedDecoration(
                    color: Colors.blue,
                    strokeWidth: 2,
                    linePosition: LinePosition.left,
                      ),
                  child:  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('It’ll take only 2 minutes. Just tell us a few details about you and the ones you are raising funds for.'),
                  ),
                ),
                SizedBox(height:MediaQuery.of(context).size.height * .02  ,),
                Row(
                  children: [
                    Image.asset("assets/images/ic_choose_purpose.png",height: 55,width: 50,),
                    SizedBox(width: MediaQuery.of(context).size.width * .03,),
                     Text("Share your fundraiser",style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  margin:  EdgeInsets.only(left: 24,top: 5),
                  padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: DottedDecoration(
                    color: Colors.blue,
                    strokeWidth: 2,
                    linePosition: LinePosition.left,
                  ),
                  child:  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      children: [
                        Text('All you need to do is share the fundraiser with your friends and family. In no time, support will start pouring in.'),
                        SizedBox(height:MediaQuery.of(context).size.height * .01 ,),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 70, 5),
                          child: Text("Share your fundraiser directly from dashboard on social media.",
                              style: TextStyle(fontSize: 5,fontWeight: FontWeight.bold,color: Colors.grey),),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height:MediaQuery.of(context).size.height * .02 ,),
                Row(
                  children: [
                    Image.asset("assets/images/ic_pay_step.png",height: 55,width: 50,),
                    SizedBox(width: MediaQuery.of(context).size.width * .03 ,),
                    Text("Withdraw Funds",style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  margin:  EdgeInsets.only(left: 24,top: 5),
                  padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: DottedDecoration(
                    color: Colors.blue,
                    strokeWidth: 2,
                    linePosition: LinePosition.left,
                  ),
                  child:  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      children: [
                        Text('The funds raised can be withdrawn without any hassle directly to your bank account.'),
                        SizedBox(height:MediaQuery.of(context).size.height * .01 ,),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 110, 5),
                          child: Text("It takes only 5 minutes to withdraw funds on NGO.",
                            style: TextStyle(fontSize: 5,fontWeight: FontWeight.bold,color: Colors.grey),),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

