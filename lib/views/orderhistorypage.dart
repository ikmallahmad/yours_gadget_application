import 'package:flutter/material.dart';
import 'to_receive_page.dart';
import 'complete_page.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _underlineAnimation;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _underlineAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 4,
          flexibleSpace: Container(
            height: 140,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.asset(
                'images/logo.png',
                height: 160,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Order History",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isComplete = false;
                  });
                  _controller.forward(from: 0);
                },
                child: Column(
                  children: [
                    Text(
                      'To Receive',
                      style: TextStyle(
                        color: _isComplete ? Colors.black : Colors.black,
                        fontSize: 16,
                        fontWeight: _isComplete ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isComplete = true;
                  });
                  _controller.forward(from: 0);
                },
                child: Column(
                  children: [
                    Text(
                      'Complete',
                      style: TextStyle(
                        color: _isComplete ? Colors.black : Colors.black,
                        fontSize: 16,
                        fontWeight: _isComplete ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: _isComplete ? CompletePage() : ToReceivePage(),
          ),
        ],
      ),
    );
  }
}
