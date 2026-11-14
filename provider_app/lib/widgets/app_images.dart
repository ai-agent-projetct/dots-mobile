import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/constants/app_images.dart' show AppImages;
import 'package:provider/widgets/loading_widget.dart';
import 'package:resize/resize.dart';

class AppNetworkImage extends ConsumerWidget {
  final String url;
  final double? height;
  final double? width;
  final String placeholderImage;
  final String errorImage;
  final bool showPlaceholder;
  final BoxFit? fit;
  final Color? color;
  final BoxShape boxShape;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.placeholderImage = AppImages.profile,
    this.errorImage = AppImages.profile,
    this.showPlaceholder = false,
    this.fit = BoxFit.cover,
    this.color,
    this.boxShape = BoxShape.rectangle,
  });

  bool get isValidUrl {
    if (url.toLowerCase() == 'null' || url.isEmpty) return false;
    Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return false;

    final imageExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.webp'];
    String path = uri.path.toLowerCase();
    return imageExtensions.any((ext) => path.endsWith(ext));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isValidUrl) {
      return Image.asset(
        placeholderImage,
        height: height,
        width: width,
        fit: fit,
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      width: width ?? ResizeUtil().screenWidth,
      decoration: BoxDecoration(shape: boxShape),
      child: CachedNetworkImage(
        imageUrl: url,
        height: height,
        cacheKey: url,
        width: width,
        fit: fit,
        color: color,
        errorWidget: (context, error, _) {
          return Icon(Icons.error);
        },
        placeholder: (context, url) {
          return showPlaceholder
              ? Image.asset(
                placeholderImage,
                height: height,
                width: width,
                fit: BoxFit.cover,
              )
              : LoadingWidget();
        },
      ),
    );
  }
}
