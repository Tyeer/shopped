import 'package:flutter/material.dart';

class AboutView extends StatefulWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          centerTitle: true,
          title: const Text("About App"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
            ),
          )),

     body:   Container(
        child: new ListView(
        children: <Widget>[
        Column(
        children: <Widget>[

          BottomSection()
        ])]))

    );
  }
}
class BottomSection extends StatefulWidget {
  @override
  _BottomSectionState createState() => new _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection>
    with TickerProviderStateMixin {
  late List<Tab> _tabs;
  late List<Widget> _pages;
  late TabController _controller;

  @override
  void initState() {

    super.initState();
    _tabs = [
      new Tab(child: Text('About Us', style: TextStyle(color: Color(0xff17259C)),), ),

      new Tab(child: Text('About  Developers', style: TextStyle(color: Color(0xff17259C)),),),
    ];
    _pages = [
      Gallery(),

      About(),
    ];
    _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TabBar(
            indicatorColor: Color(0xff17259C),
            controller: _controller,
            tabs: _tabs,
            labelColor: Theme.of(context).accentColor,
            labelStyle: TextStyle(
              color: Color(0xff17259C),
            ),

          ),
          new SizedBox.fromSize(
            size: const Size.fromHeight(300.0),

            child: new TabBarView(

              controller: _controller,

              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}

//==============================================================================

//===================
// Build Gallery Tab
//===================
class Gallery extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
        child: new ListView(
            children: <Widget>[

              Column(
                  children: <Widget>[


                  ])
            ])
    );




  }
}


class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return new Center(
      child: Container(

      ),
    );
  }
}