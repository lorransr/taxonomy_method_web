import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  static const routeName = '/about';
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('About us'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: _groupTiles(),
            ),
          )
        ],
      ),
    );
  }
}

Widget _imageLink(String resource, String link) {
  return Container(
    height: 32,
    child: TextButton(
      onPressed: () => _launchURL(link),
      child: Image.asset(
        "assets/logos/$resource.png",
      ),
    ),
  );
}

void _launchURL(String link) async =>
    await canLaunch(link) ? await launch(link) : throw 'Could not launch $link';

Widget _groupTiles() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/avatar/lorran.jpeg"),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text("Lorran Rodrigues"),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _imageLink("github", "https://github.com/lorransr"),
                _imageLink("linkedin",
                    "https://https://www.linkedin.com/in/lorranrodr/"),
                _imageLink("lattes", "https://github.com/lorransr"),
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/avatar/marcos.jpg"),
              backgroundColor: Colors.transparent,
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text("Prof. Dr. Marcos dos Santos"),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _imageLink("research_gate",
                    "https://www.researchgate.net/directory/profiles"),
                _imageLink("linkedin",
                    "https://www.linkedin.com/in/prof-dr-marcos-santos-45909763/"),
                _imageLink("lattes",
                    "http://buscatextual.cnpq.br/buscatextual/visualizacv.do?metodo=apresentar&id=K4270114H9"),
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/avatar/simoes.jpg"),
              backgroundColor: Colors.transparent,
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text("Prof. Dr. Carlos Francisco Simões Gomes"),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _imageLink("research_gate",
                    "https://www.researchgate.net/profile/Carlos-Francisco-Gomes"),
                _imageLink("linkedin",
                    "https://www.linkedin.com/in/carlos-francisco-sim%C3%B5es-gomes-7284a3b/"),
                _imageLink("lattes",
                    "http://buscatextual.cnpq.br/buscatextual/visualizacv.do?metodo=apresentar&id=K4773441T0"),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
