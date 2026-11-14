import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:resize/resize.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileCircleAvatar extends ConsumerWidget {
  final String? imageUrl;
  final double radius;

  const ProfileCircleAvatar({Key? key, this.imageUrl, this.radius = 30.0})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CircleAvatar(
      radius: radius.w,
      backgroundColor: Colors.grey[300],
      child: ClipOval(
        child:
            imageUrl == null || imageUrl!.isEmpty
                ? Icon(Icons.person, size: radius.w, color: Colors.grey[700])
                : CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  width: radius * 2,
                  height: radius * 2,
                  placeholder:
                      (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: radius * 2,
                          height: radius * 2,
                          color: Colors.white,
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Icon(
                        Icons.person,
                        size: radius.w,
                        color: Colors.grey[700],
                      ),
                ),
      ),
    );
  }
}
