import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';

final TextStyle dropdownMenuItem = TextStyle(color: Colors.black, fontSize: 18);

bool _hearted = false;


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: ()
                {
                  print("Change the fiter mode");
                },
              )
            ],
            centerTitle: true,
            backgroundColor: Color(0xff696b9e),
            title: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white70,
                    width: 1.0,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: Text(
                "Distrowatch Page-Hit Ranking",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'JosefinSans',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: Container(
            child: FutureBuilder(
                future: initiate(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<List<Map<String, dynamic>>> data = snapshot.data;
                    return ListView.builder(
                      itemCount: data[0].length,
                      itemBuilder: (BuildContext contu, int position) {
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: ExpandablePanel(
                                  collapsed: CardLayout(
                                    position: position,
                                    data: data,
                                    context: contu,
                                  ),
                                  expanded: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.black38,
                                          width: 1.0,
                                          style: BorderStyle.solid),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(18)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                icon: Icon(Icons.info),
                                                onPressed: () {
                                                  print(
                                                      "pressed info on # $position");
                                                     
                                                  showDialog(
                                                      context: contu,
                                                      builder: (contu) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            data[0][position]["title"],
                                                              ),
                                                          content: Container(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Expanded(
                                                                child: FutureBuilder(
                                                                  future: _getInfo(data, position),
                                                                  builder: (context, snappy)
                                                                  {
                                                                    if(! snappy.hasData)
                                                                    {return 
                                                                    Center(child: CircularProgressIndicator(),);
                                                                       
                                                                    }

                                                                    else
                                                                    return ListView(
                                                                        children: <Widget>[
                                                                          Text(
                                                                         snappy.data
                                                                        ),
                                                                        ],
                                                                      );
                                                                    

                                                                  },
                                                                )
                                                              )
                                                            ],
                                                          )
                                                          ),
                                                          
                                                        );
                                                      });
                                                },
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                icon: Icon(
                                                    Icons.favorite_border,
                                                    color: _hearted
                                                        ? Colors.red
                                                        : Colors.black),
                                                onPressed: () {
                                                  print(
                                                      "pressed fav on # $position");

                                                  setState(() {
                                                    _hearted = !_hearted;
                                                  });
                                                },
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                icon: Icon(Icons.exit_to_app),
                                                onPressed: () {
                                                  print(
                                                      "pressed open url on # $position");

                                                  _launchURL(data[0][position]
                                                      ['address']);
                                                },
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  tapHeaderToExpand: true,
                                  hasIcon: true,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}

// Widget createCards(BuildContext contu, data) {
//   return
// }

class CardLayout extends StatelessWidget {
  const CardLayout({Key key, this.data, this.context, this.position})
      : super(key: key);

  final int position;
  final BuildContext context;
  final List<List<Map<String, dynamic>>> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Colors.black38, width: 1.0, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.all(
          Radius.circular(18.0),
        ),
        borderOnForeground: true,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text(
                "#${position + 1}",
                style: TextStyle(
                  fontFamily: 'Solway',
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  data[0][position]["title"],
                  style: TextStyle(
                    fontFamily: 'Solway',
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                data[1][position]["hitsCount"],
                style: TextStyle(
                  fontFamily: 'Solway',
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

_launchURL(link) async {
  String url = 'https://www.distrowatch.com/' + link;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<List<List<Map<String, dynamic>>>> initiate() async {
  // Make API call to Hackernews homepage
  var client = Client();
  Response response = await client.get('https://distrowatch.com');

  // Use html parser
  var document = parse(response.body);
  List links = document.querySelectorAll('td.phr2 > a ');
  List hits = document.querySelectorAll('td.phr3');

  List<Map<String, dynamic>> linkMap = [];

  for (var link in links) {
    linkMap.add({
      'title': link.text,
      'address': link.attributes['href'],
    });
  }
  List<Map<String, dynamic>> linkMap1 = [];

  for (var hit in hits) {
    linkMap1.add({
      'hitsCount': hit.text,
    });
  }
  print(linkMap.length);
  print(linkMap1.length);

  Response resp =
      await client.get("https://www.distrowatch.com/" + linkMap[0]['address']);

  var doc = parse(resp.body);
  List paras = doc.querySelectorAll('td.TablesTitle');
  List<Map<String, dynamic>> paraMap = [];

  for (var para in paras) {
    paraMap.add({
      'info': para.text,
    });
  }

  // print(paraMap);

  return [linkMap, linkMap1];
}

 Future<String> _getInfo( List<List<Map<String,dynamic>>> map, int position) async {
 
  var client = Client();
 String dest = "https://www.distrowatch.com/"+map[0][position]['address'];
 print(dest);
   Response resp = await client.get(dest);

   var doc = parse(resp.body);
   print(resp.body);
  List paras = doc.querySelectorAll('td.TablesTitle');
  List<Map<String, dynamic>> paraMap = [];

  for (var para in paras) {
    paraMap.add({
      'info': para.text,

    });
  }

  //print(paraMap[position]['info']);

  return paraMap[position]['info'];
}
