import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'Company_model.dart';
import 'Product_model.dart';

enum data { product, company }

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: firstpage(),
  ));
}

class firstpage extends StatefulWidget {
  const firstpage({Key? key}) : super(key: key);

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {

  TextEditingController tname = TextEditingController();
  FocusNode tnode = FocusNode();

  data selectvalue = data.company;
  String f1 = "myfamily";

  int selectitem = 0;
  List<String> sort1 = ["SORT  A  to  Z"];
  List<String> sort2 = ["SORT  Z  to  A"];

  List<CompanyCountry> companyCountry = [];
  List<ProductCountry> productCountry = [];
  List<CompanyData>? comuserDetails = [];
  List<ProductData>? prouserDetails = [];
  CompanyModel companyModel = CompanyModel();
  ProductModel productModel = ProductModel();

  SpeechToText speechtotext = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  var vl = null;
  var vl1 = null;

  int page = 1;
  bool NextPage = true;
  bool LoadMoredata = false;

  bool nodata=false;

  bool isStart = false;

  ScrollController controller = ScrollController(initialScrollOffset: 0);

  Future<ProductModel> prodata(
      String? searchKeyword, String? pageNo, String? firstCountry) async {
    print('Search key $searchKeyword');
    print('page $pageNo');
    print('country222222 $firstCountry');
    page = int.parse(pageNo!);

    final response = await http.post(
        Uri.parse('https://bbe.ezl.mybluehost.me/anb/productSearch.php'),
        body: {
          'searchKeyword': searchKeyword,
          'pageNo': page.toString(),
          'firstCountry': "",
        });

    print('##131313##${response.body}');
    print('111productpages${productModel.pages}');

    page = page + 1;

    print('Page No $pageNo');

    if (response.statusCode == 200) {
      productModel = ProductModel.fromJson(jsonDecode(response.body));
      print('Product pages ${productModel.pages}');
      print('Product country ${productModel.productCountry}');

      setState(() {
        LoadMoredata = false;
        if(productModel.data!.isEmpty){
          nodata=true;
        }
        else{
          nodata=false;
        }

      });

      return ProductModel.fromJson(jsonDecode(response.body));
    } else {
      // setState((){
      //   nodata=true;
      // });
      throw Exception('Failed to create album.');
    }
  }

  Future<CompanyModel> comdata(
      String? pageNo, String? searchKeyword, String? firstCountry) async {
    print('33Search key $searchKeyword');
    print('page $pageNo');
    print('firstCountry $firstCountry');
    page = int.parse(pageNo!);
    final response = await http.post(
        Uri.parse('https://bbe.ezl.mybluehost.me/anb/companySearch.php'),
        body: {
          'searchKeyword': searchKeyword,
          'pageNo': page.toString(),
          'firstCountry': firstCountry,
        });
    print('###comresponse##${response.body}');

    print('compaypages11${companyModel.pages}');
    page = page + 1;

    print('Page No $pageNo');

    if (response.statusCode == 200) {
      companyModel = CompanyModel.fromJson(jsonDecode(response.body));
      print('Company pages ${companyModel.pages}');
      print('Company country ${companyModel.companyCountry}');

      setState(() {
        LoadMoredata = false;
        if(companyModel.data!.isEmpty){
          nodata=true;
        }
        else{
          nodata=false;
        }

      });

        return CompanyModel.fromJson(jsonDecode(response.body));
    } else {
      // setState((){
      //   nodata=true;
      // });

      throw Exception('Failed to create album.');
    }
  }

  void _loadmore() async {

    if (NextPage == true &&
        LoadMoredata == false &&
        controller.position.extentAfter < 20) {
      setState(() {
        LoadMoredata = true;
        print('trueeeeee');
      });

      print('Load More $LoadMoredata');
      print('PAGE $page');

      if (selectvalue == data.product) {
        prodata("", page.toString(),vl == null ? '' : vl).then((value) {
          print("value ${value.data}");

          setState(() {
            prouserDetails!.addAll(value.data!);

            print('ProUserDetains1111 $prouserDetails');

            if(value.pages==page){
              NextPage = false;
            }
          });
          print("lengthpageee111 ${prouserDetails?.length}");
        });

      }
      if (selectvalue == data.company) {
        comdata(page.toString(),"", vl == null ? '' : vl)
            .then((value) {
          print("value ${value.data}");

          setState(() {
            comuserDetails!.addAll(value.data!);
            print('ComUserDetains111 $comuserDetails');

            if(value.pages==page){
              NextPage = false;
            }
          });
          print("lenghtpagecccooo ${comuserDetails?.length}");
        });

      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('comPage $page');
    comdata(page.toString(), tname.text, '').then((value) {
      print("#######111 ${value.data}");

      setState(() {
        comuserDetails?.addAll(value.data!);
        companyCountry.addAll(value.companyCountry!);
      });

      print("lenght ${comuserDetails?.length}");
    });

    controller = ScrollController()..addListener(_loadmore);

    _initSpeech();
  }

  @override
  void dispose() {
    controller.removeListener(_loadmore);
    super.dispose();
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     selectitem = index;
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff6F7069),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_to_photos_outlined),
            label: 'SORT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_alt_outlined),
            label: 'FILTER',
          ),
        ],
        currentIndex: selectitem,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedFontSize: 17,
        unselectedFontSize: 14,
        onTap: (int) {

          setState(() {
            selectitem = int;
          });
          print('Selected page $selectitem');
          if (selectitem == 0) {
            {
              showModalBottomSheet(
                  backgroundColor: Colors.black,
                  context: context,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(26))),
                  builder: (context) => Container(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          height: 180,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      tnode.unfocus();
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(200,10,10, 10),
                                      width: 40,
                                      color: Colors.black,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.yellow.shade200,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: 60,
                                      child: Text(
                                        "Close",
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: Colors.yellow.shade200),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                  child: ListView.builder(
                                padding: const EdgeInsets.all(6),
                                shrinkWrap: true,
                                itemCount: sort1.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    child: Card(
                                      margin: EdgeInsets.all(6),
                                      shadowColor: Color(0xffF9FC9F),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: Colors.black,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                comuserDetails?.sort((a, b) {
                                                  return a.companyName!
                                                      .toLowerCase()
                                                      .compareTo(b.companyName!
                                                          .toLowerCase());
                                                });
                                                prouserDetails?.sort((a, b) {
                                                  return a.productName!
                                                      .toLowerCase()
                                                      .compareTo(b.productName!
                                                          .toLowerCase());
                                                });
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: 270,
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.all(8),
                                              child: Text(
                                                sort1.first,
                                                style: TextStyle(
                                                    fontFamily: f1,
                                                    fontSize: 17,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )),
                              Expanded(
                                  child: ListView.builder(
                                padding: const EdgeInsets.all(6),
                                shrinkWrap: true,
                                itemCount: sort2.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    child: Card(
                                      margin: EdgeInsets.all(6),
                                      shadowColor: Color(0xffF9FC9F),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: Colors.black,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                comuserDetails?.sort((a, b) {
                                                  return b.companyName!
                                                      .toLowerCase()
                                                      .compareTo(a.companyName!
                                                          .toLowerCase());
                                                });
                                                prouserDetails?.sort((a, b) {
                                                  return b.productName!
                                                      .toLowerCase()
                                                      .compareTo(a.productName!
                                                          .toLowerCase());
                                                });
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: 270,
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.all(8),
                                              child: Text(
                                                sort2.first,
                                                style: TextStyle(
                                                    fontFamily: f1,
                                                    fontSize: 17,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ))
                            ],
                          ),
                        ),
                      ));
            }
          }
          if (selectitem == 1) {
            showModalBottomSheet(
                backgroundColor: Colors.black,
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(26))),
                builder: (context) => Container(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        height: 370,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(200, 10, 10, 10),
                                  width: 40,
                                  color: Colors.black,
                                  child: Icon(
                                    Icons.reorder,
                                    color: Colors.yellow.shade200,
                                    size: 26,
                                  ),
                                ),
                                //                                                    reset button
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                       vl = null;
                                       tnode.unfocus();
                                      comdata('1', tname.text, '').then((value) {
                                        print("####### ${value.data}");

                                        setState(() {
                                          comuserDetails?.addAll(value.data!);
                                          companyCountry.addAll(value.companyCountry!);
                                        });
                                      });
                                      NextPage=true;
                                      comuserDetails?.clear();
                                      companyCountry.clear();
                                    });

                                    setState((){
                                         vl = null;
                                        // tnode.unfocus();
                                      prodata(tname.text, page.toString(), "")
                                          .then((value) {
                                        print("prodata11100 ${value.data}");
                                        setState(() {
                                          prouserDetails?.addAll(value.data!);
                                           productCountry.addAll(value.productCountry!);
                                          // NextPage=false;
                                        });
                                      });
                                      prouserDetails?.clear();
                                      productCountry.clear();
                                      print("lenght ${prouserDetails?.length}");
                                    });
                                      NextPage=true;
                                    tname.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(5)),
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 60,
                                    child: Text(
                                      "Reset",
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.yellow.shade200),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //                                              reset company
                            SizedBox(
                              height: 10,
                            ),
                            selectvalue == data.company
                                ? Expanded(
                                    child: ListView.builder(
                                    padding: const EdgeInsets.all(6),
                                    shrinkWrap: true,
                                    itemCount: companyCountry.length,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        child: Card(
                                          margin: EdgeInsets.all(6),
                                          shadowColor: Color(0xffF9FC9F),
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          color: Colors.black,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  print(
                                                      'searchTextValue ${tname.text}');
                                                  setState(() {
                                                    vl = companyCountry[index].firstCountry;
                                                  });
                                                  setState(() {
                                                    // comuserDetails?.clear();
                                                    comdata('1', tname.text, vl).then((value) {
                                                      setState(() {
                                                        comuserDetails?.addAll(value.data!);
                                                        print(
                                                            "value data777: ${value.data}");
                                                        companyCountry.addAll(value.companyCountry!);
                                                      });
                                                      print(
                                                          "lenght on cococo ${comuserDetails?.length}");
                                                    });
                                                  });
                                                  comuserDetails!.clear();
                                                  companyCountry.clear();
                                                  tnode.unfocus();
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: 270,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin: EdgeInsets.all(8),
                                                  child: Text(
                                                    companyCountry[index].firstCountry!,
                                                    style: TextStyle(
                                                        fontFamily: f1,
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ))
                                : Expanded(
                                    child: ListView.builder(
                                    padding: const EdgeInsets.all(6),
                                    shrinkWrap: true,
                                    itemCount: productCountry.length,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        child: Card(
                                          margin: EdgeInsets.all(6),
                                          shadowColor: Color(0xffF9FC9F),
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          color: Colors.black,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  print(
                                                      'searchTextValue2 ${tname.text}');
                                                  // var value;
                                                  setState(() {
                                                    vl = productCountry[index].firstCountry;
                                                  });

                                                  setState(() {
                                                    prodata(tname.text, page.toString(),vl).then((value) {
                                                      print("value data999: ${value.data}");
                                                      setState(() {
                                                        prouserDetails?.addAll(value.data!);
                                                        productCountry.addAll(value.productCountry!);
                                                      });
                                                      print(
                                                          "lenght on pppcccoooo ${prouserDetails?.length}");
                                                    });
                                                  });
                                                  prouserDetails?.clear();
                                                  productCountry.clear();
                                                  tnode.unfocus();
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: 180,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin: EdgeInsets.all(8),
                                                  child: Text(
                                                    productCountry[index].firstCountry!,
                                                    style: TextStyle(
                                                        fontFamily: f1,
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ))
                          ],
                        ),
                      ),
                    ));
          }
        },
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              // height: 140,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(70))),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //                                                      textfield
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        height: 48,
                        width: 328,
                        child: TextField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(17)
                          ],
                          controller: tname,
                          //focusNode: tnode,

                          // textInputAction: TextInputAction.done,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          onChanged: (value) {
                            print('valueeeee $value');
                            //                                                      search in textfiled
                            if (selectvalue == data.company) {
                              comdata('1', tname.text,''.toLowerCase())
                                  .then((value) {
                                print("value data33: ${value.data}");
                                setState(() {
                                  comuserDetails?.addAll(value.data!);
                                  companyCountry.addAll(value.companyCountry!);
                                  speechtotext;

                                });
                                print("lenght on c ${comuserDetails?.length}");
                                  });
                              comuserDetails?.clear();
                              companyCountry.clear();
                            }
                            if (selectvalue == data.product) {
                              prodata(tname.text, page.toString(),''.toLowerCase())
                                  .then((value) {
                                print("value data22: ${value.data}");

                                setState(() {
                                  prouserDetails?.addAll(value.data!);
                                  productCountry.addAll(value.productCountry!);
                                  print('12productdetails $prouserDetails');
                                });
                                print("lenght pppp${prouserDetails?.length}");
                              });
                              prouserDetails?.clear();
                              productCountry.clear();
                            }

                            },
                          //                                                        alert dialog
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                size: 33,
                                color: Colors.white,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  startListening();
                                  print('@@isStart :$isStart');

                                  tname.clear();
                                  // tnode.unfocus();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content:  Container(
                                            width: 150,
                                            height: 200,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 15),
                                                Container(height: 120,width: 120,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage("images/blue.gif"))),
                                                ),
                                                 SizedBox(height: 17),
                                                //                                                 ok button
                                                TextButton(
                                                    onPressed: () {

                                                      Navigator.pop(context);
                                                      if (selectvalue == data.company) {
                                                        comuserDetails = [];
                                                        companyCountry = [];
                                                        comdata('1', tname.text,''.toLowerCase())
                                                            .then((value) {
                                                          print("value data3434: ${value.data}");
                                                          setState(() {
                                                            comuserDetails?.addAll(value.data!);
                                                            companyCountry.addAll(value.companyCountry!);

                                                          });
                                                          print("lenght on c ${comuserDetails?.length}");
                                                        });
                                                        // comuserDetails?.clear();
                                                        // companyCountry.clear();
                                                      }
                                                      if (selectvalue == data.product) {
                                                        prouserDetails = [];
                                                        productCountry = [];
                                                        prodata(tname.text, page.toString(),''.toLowerCase())
                                                            .then((value) {
                                                          print("value data22: ${value.data}");

                                                          setState(() {
                                                            prouserDetails?.addAll(value.data!);
                                                            productCountry.addAll(value.productCountry!);
                                                            print('12productdetails $prouserDetails');
                                                          });
                                                          print("lenght pppp${prouserDetails?.length}");
                                                        });
                                                      }
                                                      // prouserDetails?.clear();
                                                      // productCountry.clear();
                                                    },
                                                    child: const Text("OK",
                                                        style: TextStyle(
                                                            fontSize: 17,color: Colors.black)))
                                              ],
                                            ),
                                          ),
                                          elevation: 35,
                                          backgroundColor: Color(0xffA8A6A0),
                                        );
                                      });
                                },
                                child: Icon(
                                  Icons.mic,
                                  size: 33,
                                  color: Color(0xff75c7fa),
                                ),
                              ),
                              fillColor: Color(0xff6F7069),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: Colors.white38))
                          ),

                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //                                                                         radio button
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            height: 25,
                            width: 100,
                            child: Text(
                              "Search By -",
                              style: TextStyle(
                                  fontFamily: f1,
                                  fontSize: 21,
                                  color: Colors.yellow.shade200),
                            ),
                          ),
                        ],
                      ),
                      Radio<data>(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.yellow.shade200),
                        value: data.product,
                        groupValue: selectvalue,
                        onChanged: (data? value) {
                          setState(() {
                            prouserDetails = [];
                            selectvalue = value!;
                            page = 1;
                            prodata(tname.text, page.toString(),"").then((value) {
                              print("#3333#${value.data}");

                              setState(() {
                                prouserDetails?.addAll(value.data!);
                                  productCountry.addAll(value.productCountry!);
                                print('UserDetains11122 $prouserDetails');

                                NextPage = true;

                              });
                              print("####44${prouserDetails?.length}");
                            });
                            // prouserDetails!.clear();
                            productCountry.clear();
                          });
                          // tname.clear();
                        },
                      ),
                      Text(
                        'Product',
                        style: TextStyle(
                            fontFamily: f1, fontSize: 18, color: Colors.white),
                      ),
                      Radio<data>(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.yellow.shade200),
                        value: data.company,
                        groupValue: selectvalue,
                        onChanged: (data? value) {
                          setState(() {
                            comuserDetails = [];
                            selectvalue = value!;
                            page = 1;

                            print('TNAME $tname');
                            comdata(page.toString(), tname.text, '').then((value) {
                              print("value ${value.data}");
                              setState(() {
                                comuserDetails?.addAll(value.data!);
                                // companyCountry.addAll(value.companyCountry!);
                                print('UserDetains $comuserDetails');
                                NextPage = true;

                              });
                              print("lenght ${comuserDetails?.length}");
                            });
                            // tname.clear();
                          });
                        },

                      ),
                      Text(
                        'Company',
                        style: TextStyle(
                            fontFamily: f1, fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

                    selectvalue == data.product
                        ? prouserDetails!.isNotEmpty
                        ? Expanded(
                        child: Container(
                          height: 490,
                          child: Column(
                            children: [
                              Expanded(
                                  child: ListView.builder(
                                controller: controller,
                                padding: const EdgeInsets.all(6),
                                shrinkWrap: true,
                                itemCount: prouserDetails?.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: EdgeInsets.all(5),
                                    shadowColor: Color(0xffF9FC9F),
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.black,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: Icon(Icons.add_shopping_cart,
                                              size: 23,
                                              color: Color(0xffA39515)),
                                        ),
                                        Container(
                                          width: 260,
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.all(6),
                                          child: Text(
                                            prouserDetails?[index]
                                                    .productName ?? "",
                                            style: TextStyle(
                                                fontFamily: f1,
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )),
                              if (LoadMoredata == true)
                                Center(
                                    child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.yellow),
                                  strokeWidth: 3,
                                )),
                              if (NextPage == false)
                                Container(
                                  height: 30 ,
                                  width: 160,
                                  color: Colors.black,
                                  child: Center(
                                    child: Text('Finish Data',style: TextStyle(fontSize: 20,color: Colors.yellow.shade200),),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                        : nodata
                        ? Container(
                  height: 30,
                  width: 150,
                  color: Colors.black,
                  child: Center(
                    child: Text('No Data Found',style: TextStyle(fontSize: 17,color: Colors.yellow),),
                  ),
                )
                        : LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        color: Colors.white,
                        minHeight: 8)



                    : comuserDetails!.isNotEmpty
                    ? Expanded(
                        child: Container(
                          height: 520,
                          child: Column(
                            children: [
                              Expanded(
                                  child: ListView.builder(
                                controller: controller,
                                padding: const EdgeInsets.all(6),
                                shrinkWrap: true,
                                itemCount: comuserDetails?.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: EdgeInsets.all(5),
                                    shadowColor: Color(0xffF9FC9F),
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.black,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: Icon(Icons.apartment_rounded,
                                                size: 23,
                                                color: Color(0xffA39515)),
                                          ),
                                          Container(
                                            width: 260,
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.all(6),
                                            child: Text(
                                              comuserDetails?[index]
                                                      .companyName ??
                                                  "",
                                              style: TextStyle(
                                                  fontFamily: f1,
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ]),
                                  );
                                },
                              )),

                              if (LoadMoredata == true)
                                Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.yellow),
                                    strokeWidth: 3,
                                  ),
                                ),

                              if (NextPage == false)
                                Container(
                                  height: 30,
                                  width: 150,
                                  color: Colors.black,
                                  child: Center(
                                    child: Text('Finish Data',style: TextStyle(fontSize: 20,color: Colors.yellow.shade200),),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    : nodata
                    ? Container(
                  height: 30,
                  width: 150,
                  color: Colors.black,
                  child: Center(
                    child: Text('No Data Found',style: TextStyle(fontSize: 17,color: Colors.yellow),),
                  ),
                )
                    : LinearProgressIndicator(
                         backgroundColor: Colors.grey,
                         color: Colors.white,
                         minHeight: 8),


          ],
        ),
      ),
    );
  }

  void _initSpeech() async {
    speechEnabled = await speechtotext.initialize();
    setState(() {});
  }

   startListening()  {
    print('@@start');
    isStart = true;
     speechtotext.listen(onResult: onSpeechResult);
     // tnode.hasFocus;
     setState((){});
  }

  void stopListening() async {
    setState(() {
      isStart = false;
    });
    await speechtotext.stop();
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    print('@@result111 ${result.recognizedWords}');
    setState(() {
      tname.text = result.recognizedWords;
      lastWords = result.recognizedWords;
    });
  }
}
