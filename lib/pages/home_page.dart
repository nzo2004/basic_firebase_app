import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //FiresStore burdan bağlarız
  final _firestore = FirebaseFirestore.instance;

  TextEditingController namedController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //Koleksiyona burdan erişiriz.
    CollectionReference moviesRef = _firestore.collection('movies');
    //Koleksiyonun içindeki Dökümasyona ulaşmamıza yarar.
    var babaRef = moviesRef.doc('Baba');
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                //Neyi dinlediğimiz biligisi , hangi streami
                stream: moviesRef.snapshots(),
                //Streamden yer yeri veri aktığında aşağıdaki metodu çalışıtırır
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  //asyncSnapshot datasının dökümasyonunun çekeriz.
                  List listOfDocumentSnap = asyncSnapshot.data.docs;

                  if (asyncSnapshot.hasError) {
                    return Container(
                      child: Text("Veriler gelmiyor"),
                    );
                  } else if (asyncSnapshot.hasData) {
                    return Flexible(
                      child: ListView.builder(
                        //listOfDocumentSnap kaçta tane varsa o kadar olsun deriz
                        itemCount: listOfDocumentSnap.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(
                                  '${listOfDocumentSnap[index].data()['name']}'),
                              subtitle: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Çıkış Yılı:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      '${listOfDocumentSnap[index].data()['year']}'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Rating:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      '${listOfDocumentSnap[index].data()['rating']}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete_outlined,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  //Listedeki bu elemanı referanstan bağla ve onu sil
                                  await listOfDocumentSnap[index]
                                      .reference
                                      .delete();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 90),
                child: Form(
                    child: Column(
                  children: [
                    //Yazdığımız veriyi burdan alırız
                    //controller = verdiğimiz değerden çekeriz veriyi
                    TextFormField(
                      controller: namedController,
                      decoration: InputDecoration(hintText: 'Film Adı'),
                    ),
                    TextFormField(
                      controller: yearController,
                      decoration:
                          InputDecoration(hintText: 'hangi yıl da çıktı'),
                    ),
                    TextFormField(
                      controller: ratingController,
                      decoration: InputDecoration(hintText: 'Rating Puanı'),
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            print(namedController.text);
            print(yearController.text);
            print(ratingController.text);

            //TextFormField veriyi kullanmak için map oluşturmalıyız.
            Map<String, dynamic> movieData = {
              'name': namedController.text,
              'year': yearController.text,
              'rating': ratingController.text
            };

            //Nereye yazmak istediğimizi söyleriz
            moviesRef.doc(namedController.text).set(movieData);

            namedController.clear();
            yearController.clear();
            ratingController.clear();
          },
        ),
      ),
    );
  }
}
