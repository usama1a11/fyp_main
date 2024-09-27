/*import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:furnitureworldapplication/Screen/Add_to_cart/loading_widgets.dart';*/
// import 'package:furnitureworldapplication/Screen/Components/loading_widgets.dart';
// import 'package:persistent_shopping_cart_example/res/components/loading_widget.dart';
/*class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width, height, borderRadius, iconSize;
  const NetworkImageWidget(
      {Key? key,
        required this.imageUrl,
        this.width = 40,
        this.height = 40,
        this.borderRadius = 18,
        this.iconSize = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: LoadingWidget(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.error_outline,
              size: iconSize,
            )),
      ) ,
    );
  }
}*/
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  const ImageWidget({
    required this.imageUrl,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the imageUrl contains 'http' to determine if it's a network image
    bool isNetwork = imageUrl.startsWith('http');

    return Container(
      height: height,
      width: width,
      child: isNetwork
          ? Image.network(
        imageUrl,
        fit: BoxFit.cover,
      )
          : Image.asset(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
