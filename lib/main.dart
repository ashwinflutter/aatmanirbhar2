import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  int _selectitem = 0;

  List<CompanyCountry> companyCountry = [];
  List<ProductCountry> productCountry = [];

  data _vall = data.company;
  bool status = false;
  int selectedPos = 1;
  List<CompanyData>? comuserDetails = [];
  List<ProductData>? prouserDetails = [];
  CompanyModel companyModel = CompanyModel();
  ProductModel productModel = ProductModel();
  var vl=null;
  bool sort = false;
  int page = 1;
  int limit = 20;
  bool NextPage = true;
  bool LoadMore = false;

  ScrollController _controller = ScrollController(initialScrollOffset: 0);

  Future<ProductModel> prodata(
      String? searchKeyword, String? pageNo, String? firstCountry) async {
    print('Search key $searchKeyword');
    print('page $pageNo');
    print('country222222 $firstCountry');

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
        LoadMore = false;
      });

      return ProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }

  Future<CompanyModel> comdata(
      String? pageNo, String? searchKeyword, String? firstCountry) async {
    print('Search key $searchKeyword');
    print('page $pageNo');
    print('firstCountry $firstCountry');
   page=int.parse(pageNo!);
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
        LoadMore = false;
      });

      return CompanyModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }

  void _loadmore() async {
    // print('Called123');
    if (NextPage == true &&
        LoadMore == false &&
        _controller.position.extentAfter < 20) {

      setState(() {
        LoadMore = true;
        print('trueeeeee');
      });

      print('Load More $LoadMore');
      print('PAGE $page');

      if(_vall == data.product){
        prodata("",page.toString(),vl==null?'':vl).then((value) {
          print("value ${value.data}");

          setState(() {
            prouserDetails!.addAll(value.data!);
            print('ProUserDetains1111 $prouserDetails');
          });
          print("lengthpageee111 ${prouserDetails?.length}");
        });
      }

      if(_vall == data.company){
        comdata(page.toString(), tname.text,vl==null?'':vl).then((value) {
          print("value ${value.data}");

          setState(() {
            comuserDetails!.addAll(value.data!);
            print('ComUserDetains111 $comuserDetails');
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
    comdata(page.toString(), tname.text,'').then((value) {
      print("#######111 ${value.data}");

      setState(() {
        comuserDetails?.addAll(value.data!);
        companyCountry.addAll(value.companyCountry!);
      });

      print("lenght ${comuserDetails?.length}");
    });

    // prodata("",page.toString(),"").then((value) {
    //   print("####### ${value.data}");
    //
    //   setState(() {
    //     prouserDetails?.addAll(value.data!);
    //      productCountry.addAll(value.productCountry!);
    //   });
    //
    //   print("lenght ${prouserDetails?.length}");
    // });
    _controller = ScrollController()..addListener(_loadmore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadmore);
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectitem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
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
        currentIndex: _selectitem,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedFontSize: 17,
        unselectedFontSize: 12,
        onTap: (int) {
          setState(() {
            _selectitem = int;
          });
          print('Selected page $_selectitem');
          if (_selectitem == 0) {
            {
              showModalBottomSheet(
                  backgroundColor: Colors.grey.shade300,
                  context: context,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(26))),
                  builder: (context) => Container(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          height: 150,
                          width: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    comuserDetails?.sort((a, b) {
                                      return a.companyName!
                                          .toLowerCase()
                                          .compareTo(
                                              b.companyName!.toLowerCase());
                                    });
                                    prouserDetails?.sort((a, b) {
                                      return a.productName!
                                          .toLowerCase()
                                          .compareTo(
                                              b.productName!.toLowerCase());
                                    });
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      )),
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: 120,
                                  child: Text(
                                    "SORT A to Z",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    comuserDetails?.sort((a, b) {
                                      return b.companyName!
                                          .toLowerCase()
                                          .compareTo(
                                              a.companyName!.toLowerCase());
                                    });
                                    prouserDetails?.sort((a, b) {
                                      return b.productName!
                                          .toLowerCase()
                                          .compareTo(
                                              a.productName!.toLowerCase());
                                    });
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: 120,
                                  child: Text(
                                    "SORT Z to A",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ));
            }
          }
          if (_selectitem == 1) {
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
                                    Icons.add_chart,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      vl=null;
                                      comdata('1',tname.text,'')
                                          .then((value) {
                                        print("####### ${value.data}");

                                        setState(() {
                                          comuserDetails?.addAll(value.data!);
                                          companyCountry.addAll(value.companyCountry!);
                                        });
                                      });
                                    });
                                    setState(() {
                                      prodata("",page.toString(),"")
                                          .then((value) {
                                        print("prodata111 ${value.data}");
                                        setState(() {
                                          prouserDetails?.addAll(value.data!);
                                          productCountry.addAll(value.productCountry!);
                                        });
                                      });
                                      print("lenght ${prouserDetails?.length}");
                                    });
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
                                          fontSize: 19, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            _vall == data.company
                            ?
                            Expanded(
                                child: ListView.builder(
                              padding: const EdgeInsets.all(6),
                              shrinkWrap: true,
                              itemCount: companyCountry.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  child: Card(
                                    margin: EdgeInsets.all(6),
                                    shadowColor: Colors.yellow,
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
                                            print('searchTextValue ${tname.text}');

                                            setState(() {
                                              vl = companyCountry[index].firstCountry;
                                            });
                                            setState(() {

                                              comuserDetails?.clear();
                                              comdata('1', tname.text, vl).then((value) {
                                                setState(() {
                                                  comuserDetails?.addAll(value.data!);
                                                  print("value data777: ${value.data}");
                                                  companyCountry.addAll(value.companyCountry!);
                                                });
                                                print("lenght on c ${comuserDetails?.length}");
                                              });
                                              companyCountry.clear();
                                            });

                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: 270,
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.all(8),
                                            child: Text(
                                              companyCountry[index].firstCountry!,
                                              style: TextStyle(
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
                            :
                             Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(6),
                              shrinkWrap: true,
                              itemCount: productCountry.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  child: Card(
                                    margin: EdgeInsets.all(6),
                                    shadowColor: Colors.yellow.shade300,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.white10,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            print('searchTextValue2 ${tname.text}');
                                            // var value;
                                            setState(() {
                                              vl = productCountry[index].firstCountry;
                                            });

                                            prouserDetails?.clear();
                                            setState(() {
                                              prodata("",tname.text,vl).then((value) {
                                                print(
                                                    "value data777: ${value.data}");
                                                setState(() {
                                                  prouserDetails?.addAll(value.data!);
                                                  productCountry.addAll(value.productCountry!);
                                                });
                                                print(
                                                    "lenght on p ${prouserDetails?.length}");
                                              });
                                              productCountry.clear();
                                            });

                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: 270,
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.all(8),
                                            child: Text(
                                              productCountry[index].firstCountry!,
                                              style: TextStyle(
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
                    children: [
                      Container(
                        height: 48,
                        width: 281,
                        child: TextField(
                          controller: tname,
                          onChanged: (value) {

                           if (_vall == data.product){
                             prouserDetails?.clear();
                             productCountry.clear();
                             prodata(tname.text,page.toString(),"".toLowerCase())
                                 .then((value) {print("value data22: ${value.data}");

                             setState(() {
                               prouserDetails?.addAll(value.data!);
                               productCountry.addAll(value.productCountry!);
                               print('12productdetails $prouserDetails');
                             });
                             print("lenght pppp${prouserDetails?.length}");
                             });
                           }


                            if(_vall == data.company){
                              comuserDetails?.clear();
                              companyCountry.clear();
                              comdata('1',tname.text,''.toLowerCase())
                                  .then((value) {
                                print("value data33: ${value.data}");
                                setState(() {
                                  comuserDetails?.addAll(value.data!);
                                  companyCountry.addAll(value.companyCountry!);
                                });
                                print("lenght on c ${comuserDetails?.length}");
                              });
                            }

                          },
                          decoration: InputDecoration(
                              prefixIcon: IconButton(
                                  color: Colors.white,
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.search,
                                    size: 30,
                                    color: Colors.black,
                                  )),
                              // labelText: "search",
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.brown))),
                        ),
                      ),
                      Icon(
                        Icons.mic,
                        size: 33,
                        color: Colors.white,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                              "search by:",
                              style:
                                  TextStyle(fontSize: 21, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Radio<data>(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        value: data.product,
                        groupValue: _vall,
                        onChanged: (data? value) {
                          setState(() {

                            prouserDetails = [];
                            _vall = value!;
                            page = 1;
                            prodata(tname.text,page.toString(),"").then((value) {
                              print("#3333#${value.data}");

                              setState(() {
                                prouserDetails?.addAll(value.data!);
                                  productCountry.addAll(value.productCountry!);
                                print('UserDetains11122 $prouserDetails');
                              });
                              print("####44${prouserDetails?.length}");
                            });
                          });
                        },
                      ),
                      Text(
                        'product',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      Radio<data>(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        value: data.company,
                        groupValue: _vall,
                        onChanged: (data? value) {
                          setState(() {
                            comuserDetails = [];
                            _vall = value!;
                            page = 1;

                            print('TNAME $tname');
                            comdata(page.toString(), tname.text, '').then((value) {
                              print("value ${value.data}");
                              setState(() {
                                comuserDetails?.addAll(value.data!);
                                // companyCountry.addAll(value.companyCountry!);
                                print('UserDetains $comuserDetails');
                              });
                              print("lenght ${comuserDetails?.length}");
                            });
                          });
                        },
                      ),
                      Text(
                        'company',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _vall == data.product
                ? prouserDetails!.isNotEmpty
                    ? Expanded(
                        child: Container(
                          height: 490,
                          child: Column(
                            children: [
                              Expanded(
                                  child: ListView.builder(
                                controller: _controller,
                                padding: const EdgeInsets.all(6),
                                shrinkWrap: true,
                                itemCount: prouserDetails?.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    child: Card(
                                      margin: EdgeInsets.all(5),
                                      shadowColor: Colors.yellow,
                                      elevation: 5,
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
                                                color: Colors.yellow.shade300),
                                          ),
                                          Container(
                                            width: 260,
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.all(6),
                                            child: Text(
                                              prouserDetails?[index].productName ??
                                                  "",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )),
                              if (LoadMore == true)
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                : comuserDetails!.isNotEmpty
                    ? Expanded(
                        child: Container(
                          height: 520,
                          child: Column(
                            children: [
                              Expanded(
                                  child: ListView.builder(
                                reverse: sort,
                                controller: _controller,
                                padding: const EdgeInsets.all(6),
                                shrinkWrap: true,
                                itemCount: comuserDetails?.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    child: Card(
                                      margin: EdgeInsets.all(5),
                                      shadowColor: Colors.yellow,
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: Colors.black,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              child: Icon(Icons.apartment,
                                                  size: 23,
                                                  color:
                                                      Colors.yellow.shade300),
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
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  );
                                },
                              )),
                              if (LoadMore == true)
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      )),
          ],
        ),
      ),
    );
  }
}
