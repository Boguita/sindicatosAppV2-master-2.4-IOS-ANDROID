import 'package:flutter/material.dart';
import 'package:sindicatos/Components/FullScreenUrl.dart';

import 'package:sindicatos/Model/ImageNews.dart';
import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Components/PageHeader.dart';
import '../../Components/LoadingComponent.dart';
import '../../Model/CustomMenuItem.dart';
import '../../Model/History.dart';
import '../../Model/User.dart';

import '../../Network/HistoryCalls.dart';
import 'CustomDecorate.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

import 'package:animate_do/animate_do.dart';


class YearData {
  final String year;
  final Color color;
  final int image;
  final List title;
  final List desc;
  bool isExpanded; 

  YearData({this.year, this.color, this.image, this.title, this.desc, this.isExpanded = false});
}

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key, this.user,this.isExpanded = false, this.currentYear}) : super(key: key);
  final bool isExpanded;
  final String currentYear;
  

  final User user;
  final List<YearData> years = [
    YearData(year: '1920', color: Color(0xFFFF6847), image: 8, title:[1,2], desc: [2,4]),
    YearData(year: '1944', color: Color(0xFF7EDA99),image: 7, title:[5,6], desc: [6,7]),
    YearData(year: '1947', color: Color(0xFF8A5EC1),image: 10, title:[8,10], desc: []),
    YearData(year: '1988', color: Color(0xFFF98D9C),image: 6, title:[11,12], desc: [12,13]),
    YearData(year: '1991', color: Color(0xFFFF6847),image: 1,title:[14,15], desc: [15,16]),
    YearData(year: '1995', color: Color(0xFF7EDA99),image: 4, title:[19,20], desc: [21,22]),
    YearData(year: '1996', color: Color(0xFF8A5EC1),image: 3, title:[23,24], desc: [24,25]),
    YearData(year: '2001', color: Color(0xFFF98D9C),image: 7, title:[30,31], desc: [31,33]),
    YearData(year: '2002', color: Color(0xFFFF6847),image: 5, title:[34,35], desc: [35,36]),
    YearData(year: '2003', color: Color(0xFF7EDA99),image: 11, title:[37,39], desc: []),
    YearData(year: '2004', color: Color(0xFF8A5EC1),image: 0, title:[40,42], desc: []),
    YearData(year: '2012', color: Color(0xFFF98D9C),image: 12, title:[43,44], desc: [44,47]),
    YearData(year: '2017', color: Color(0xFFFF6847),image: 14, title:[48,49], desc: [49,54]),
    YearData(year: '2017', color: Color(0xFF8A5EC1),image: 2, title:[55,56], desc: [56,58]),
    YearData(year: '2020', color: Color(0xFF7EDA99),image: 13, title:[59,60], desc: [60,63])
  ];

  @override
  _HistoryPageState createState() => _HistoryPageState();

  

}

class _HistoryPageState extends State<HistoryPage>  with SingleTickerProviderStateMixin {
  final Future<History> fetchHistoryFuture = fetchHistory();
  History history;
  bool isExpanded = false;

  int selectedCardIndex = -1;

  
  // void _handkeExpansion(int index, bool isExpanded) {
   
  // }
  

  @override
  void initState() {
    super.initState();
    
    fetchHistoryFuture.then((fetchedHistory) {
      setState(() {
         history = fetchedHistory; 
      });
    });
   
    
  }

Widget buildCustomWidget() {
  return Column(
    children: widget.years.map((yearData) {
      int cardIndex = widget.years.indexOf(yearData);
   final List<int> titleList = yearData.title.cast<int>();
      final List<int> descList = yearData.desc.cast<int>();

      final List<String> contentLines = history.content.split('\n');

      String titleHtml = '';
      if (titleList[0] >= 0 && titleList[1] < contentLines.length) {
        titleHtml = contentLines.sublist(titleList[0], titleList[1] ).join('\n');
      }

   String descHtml = '';
if (yearData.isExpanded && descList.isNotEmpty && descList[0] >= 0 && descList[1] < contentLines.length) {
  descHtml = contentLines.sublist(descList[0], descList[1]).join('\n');
} else if (!yearData.isExpanded && descList.isNotEmpty && descList[0] >= 0 && descList[0] < contentLines.length) {
  descHtml = contentLines[descList[0]];
}


      return GestureDetector(
        onTap: () {
          setState(() {
            selectedCardIndex = cardIndex;
          });
        },
        child:
      Column(
        children: [
          SizedBox(
            child: CustomDecoratedBox(
              year: yearData.year,
       
              color: yearData.color.value,
     
              isSelected: cardIndex == selectedCardIndex,
            ),
          ),
          SizedBox(
            width: 285,
            child: Card(
              margin: EdgeInsets.only(top: 0, left: 30, right: 0, bottom: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0),
                ),
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              child: Stack(
                children: [Column(
                  children: [
                    SizedBox(
                      height: 180.0,
                       child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: _getCarousel(history.images, yearData.image),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                    child: Html(
                      data: titleHtml,
                      onLinkTap: (src, RenderContext contextc, Map<String, String> attributes, dom.Element element) async {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext contet) => FullScreenUrl(imageUrl: src)));
                      },
                      style: {
                        "p": Style(
                          fontSize: FontSize(14),
                          maxLines: 7,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      },
                    ),
                  ),
                 if (descHtml.isNotEmpty)
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedCardIndex = cardIndex;
                                yearData.isExpanded = !yearData.isExpanded;
                                print(yearData.isExpanded);
                              });
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  child: Html(
                                    data: descHtml,
                                    onLinkTap: (src, RenderContext contextc, Map<String, String> attributes, dom.Element element) async {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext contet) => FullScreenUrl(imageUrl: src)));
                                    },
                                      style: {
                        "p": Style(
                          fontSize: FontSize(14),
                          maxLines: yearData.isExpanded ? null : 4,
                          textOverflow: yearData.isExpanded? null : TextOverflow.ellipsis,
                        ),
                      },
                    ),
                                  ),
                       
                              ],
                            ),
                          ),
                if(yearData.isExpanded && descList.isNotEmpty) 
                 Icon(
                  
                  Icons.arrow_drop_up_rounded
                  
                  ),
                if(!yearData.isExpanded && descList.isNotEmpty)
                Icon(Icons.arrow_drop_down_rounded)
                

                


                ],


              ),
                ],
              ),
        
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
       ),
      );
    }).toList(),
  );
}





  _getCarousel(List<ImageNews> imagesUrls, number) {
    if (imagesUrls.isNotEmpty) {
      final imageUrl = imagesUrls[number].image;
      return Image(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
        image: AssetImage('assets/images/no-image.jpg'),
        fit: BoxFit.cover,
      );
    }
  }



 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 75),
        child: CustomAppBar(),
      ),
      backgroundColor: Colors.grey[300],
      drawer: new AppDrawer(
        user: widget.user,
      ),
      body: new Container(
        decoration: new BoxDecoration(color: Colors.white),
        child: new Container(
          child: Column(
            children: <Widget>[              
              Container(                
                decoration: new BoxDecoration(
                    color: Color(0xFF5EA0D6),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(30.0),
                      topRight: const Radius.circular(30.0),
                    )),
                child: Column(
                  children: <Widget>[
                    PageHeader(
                      menuItem: CustomMenuItem.get(
                          CustomMenuItemType.history, widget.user),
                    ),
                    SizedBox(height: 20.0)
                  ],
                ),
              ),
              Expanded(
                child: history == null
                    ? LoadingComponent()
                    : ListView(
                        children: <Widget>[
                          ClipRRect(
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Stack(
                                      children: [
                                        
                                        SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 0.0),
                                                    
                                                child: SizedBox(
                                                  // Definir altura de la tarjeta
                                                  width: 390.0,
                                                  child: Column(
                                                    children: [                                                      
                                                      SizedBox(
                                                        height: 20.0,
                                                      ),
                                                       FadeIn(
                                                          child:
                                                      Container(
                                                        // Definir altura de la tarjeta
                                                        
                                                        child: Container(    
                                                                                      
                                                          child: 
                                                            buildCustomWidget(),

                                                          
                                                        ),
                                                      ),
                                                      ),                                                  
                                                    ],
                                                  ),
                                                
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                       
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
