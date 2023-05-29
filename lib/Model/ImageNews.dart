class ImageNews {
  String image;
  bool video;
  String prevVideo;
  ImageNews({this.image, this.video, this.prevVideo});

  factory ImageNews.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> fields = json;

    ImageNews imageNews = ImageNews(
      image: fields['img'].toString(),
      video: fields['video'],
      prevVideo: fields['prevVideo'],
    );

    return imageNews;
  }
}
