// import 'dart:math';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:diyar_app/core/style/app_color.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// class CachedImage extends StatelessWidget {
//   final String url;
//   final BoxFit fit;
//   final double? height;
//   final double? width;
//   final double borderWidth;
//   final BorderRadius? borderRadius;
//   final ColorFilter? colorFilter;
//   final Alignment alignment;
//   final Widget? child;
//   final Widget? placeHolder;
//   final Color borderColor;
//   final Color? bgColor;
//   final BoxShape boxShape;
//   final bool haveRadius;

//   const CachedImage({
//     super.key,
//     required this.url,
//     this.fit = BoxFit.cover,
//     this.width,
//     this.height,
//     this.placeHolder,
//     this.borderRadius,
//     this.colorFilter,
//     this.alignment = Alignment.center,
//     this.child,
//     this.boxShape = BoxShape.rectangle,
//     this.borderColor = Colors.transparent,
//     this.borderWidth = 1,
//     this.bgColor,
//     this.haveRadius = true,
//   });

//   @override
//   Widget build(BuildContext context ) {
//     final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

//     // Handle invalid or empty URL gracefully
//     if (url.isEmpty ) {
//       return _buildErrorContainer();
//     }

//     return CachedNetworkImage(
//       imageUrl: url,
//       fit: fit,
//       width: width,
//       height: height,
//       fadeInDuration: const Duration(milliseconds: 250),
//       fadeOutDuration: const Duration(milliseconds: 250),
//       memCacheHeight: height != null
//           ? min((height! * devicePixelRatio).toInt(), 2048)
//           : null,
//       memCacheWidth: width != null
//           ? min((width! * devicePixelRatio).toInt(), 2048)
//           : null,
//       maxHeightDiskCache: height != null
//           ? min((height! * devicePixelRatio).toInt(), 2048)
//           : null,
//       maxWidthDiskCache: width != null
//           ? min((width! * devicePixelRatio).toInt(), 2048)
//           : null,

//       // ✅ Successful image load
//       imageBuilder: (context, imageProvider) => Container(
//         width: width,
//         height: height,
//         alignment: alignment,
//         decoration: BoxDecoration(
//           color: bgColor ?? Colors.transparent,
//           borderRadius: haveRadius ? borderRadius : null,
//           shape: boxShape,
//           border: Border.all(color: borderColor, width: borderWidth),
//           image: DecorationImage(
//             image: imageProvider,
//             fit: fit,
//             colorFilter: colorFilter,
//           ),
//         ),
//         child: child,
//       ),

//       // ✅ Professional Loading Placeholder
//       placeholder: (context, _) => Container(
//         width: width,
//         height: height,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: bgColor ?? AppColors.primaryColor.withOpacity(0.1),
//           borderRadius: haveRadius ? borderRadius : null,
//           shape: boxShape,
//           border: Border.all(color: borderColor, width: borderWidth),
//         ),
//         child: const SpinKitFadingCircle(color: AppColors.primaryColor, size: 30),
//       ),

//       // ✅ Professional Error Widget
//       errorWidget: (context, _, __) => _buildErrorContainer(),
//     );
//   }

//   /// 🧱 Error Widget
//   Widget _buildErrorContainer() {
//     return Container(
//       width: width,
//       height: height,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: bgColor ?? AppColors.greyColor.withOpacity(0.2),
//         borderRadius: haveRadius ? borderRadius : null,
//         shape: boxShape,
//         border: Border.all(color: borderColor, width: borderWidth),
//       ),
//       child:
//           placeHolder ??
//           FittedBox(
//             // 🔹 makes sure icon never overflows
//             child: Icon(
//               Icons.image_not_supported_outlined, // 🔹 "empty image" icon
//               color: AppColors.greyColor.withOpacity(0.7),
//             ),
//           ),
//     );
//   }
// }