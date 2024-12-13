import 'package:flutter/material.dart';
class NoDataWidget extends StatelessWidget {

  String text='';
  NoDataWidget({this.text=''});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/no_files.png',height: 150,width: 150,),
          SizedBox(height: 10,),
          Text(text, style: TextStyle(
            fontSize: 18,
            color: Colors.black54
          ),),
        ],
      ),
    );
  }
}
