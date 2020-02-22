import 'package:flutter/material.dart';
import 'package:lawyer_client_app/constant.dart';

class Client_HomePage extends StatelessWidget {

  Widget cards(image, title) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6.0,
          ),
        ],
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Image.asset(
              image,
              height: 80,
            ),
            SizedBox(
              height: 10,
            ),
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Constant.appColor)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70.withOpacity(0.9),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  color: Constant.appColor,
                ),
                width: double.infinity,
              ),
              Container(
                margin: EdgeInsets.only(left: 90, bottom: 20),
                width: 299,
                height: 279,
                decoration: BoxDecoration(
                    color: Constant.appColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(160),
                        bottomLeft: Radius.circular(290),
                        bottomRight: Radius.circular(160),
                        topRight: Radius.circular(10))),
              ),
              CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Good Morning",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                          Text("Everyone",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(26.0),
                    sliver: SliverGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 10,
                      children: <Widget>[
                        cards('images/wallet2.png', 'My Request'),
                        cards('images/wallet3.png', 'My Session'),
                        cards('images/wallet3.png', 'Chat'),
                        cards(
                            'images/wallet2.png', 'Profile'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

