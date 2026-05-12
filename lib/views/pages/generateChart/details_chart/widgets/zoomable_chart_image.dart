// lib/views/pages/generateChart/details_chart/widgets/zoomable_chart_image.dart
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:photo_view/photo_view.dart';

class ZoomableChartImage extends StatefulWidget {
  final String imageUrl;
  final String fallbackAssetImage;
  final double height;
  final Color loadingColor;

  const ZoomableChartImage({
    super.key,
    required this.imageUrl,
    this.fallbackAssetImage = "assets/images/chartimage.png",
    required this.height,
    this.loadingColor = const Color(0xFF9A3BFF),
  });

  @override
  State<ZoomableChartImage> createState() => _ZoomableChartImageState();
}

class _ZoomableChartImageState extends State<ZoomableChartImage> {
  late PhotoViewController _photoViewController;

  @override
  void initState() {
    super.initState();
    // Start with a generic 1.0 scale which maps to the initial "contained" fit
    _photoViewController = PhotoViewController(initialScale: 1.0);
  }

  @override
  void dispose() {
    _photoViewController.dispose();
    super.dispose();
  }

  /// Incremental zoom-in with a faster, multiplication-based approach
  void _zoomIn() {
    double currentScale = _photoViewController.scale ?? 1.0;
    _photoViewController.scale = currentScale * 1.3;
  }

  /// Zoom-out that allows returning to the initial state safely
  void _zoomOut() {
    double currentScale = _photoViewController.scale ?? 1.0;
    // Attempt to zoom out by the same ratio
    double newScale = currentScale / 1.3;
    
    // PhotoView will automatically respect the minScale (contained) boundary.
    // We just need to make sure we don't accidentally get stuck at a value just above 1.0
    if (newScale < 1.05) {
      _photoViewController.scale = 1.0;
    } else {
      _photoViewController.scale = newScale;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          PhotoView(
            imageProvider: widget.imageUrl.startsWith('assets/')
                ? AssetImage(widget.imageUrl) as ImageProvider
                : widget.imageUrl.isNotEmpty
                    ? NetworkImage(widget.imageUrl)
                    : AssetImage(widget.fallbackAssetImage) as ImageProvider,
            controller: _photoViewController,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 5.0,
            initialScale: PhotoViewComputedScale.contained,
            basePosition: Alignment.center,
            backgroundDecoration: const BoxDecoration(color: Colors.transparent),
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                color: widget.loadingColor,
                strokeWidth: ResponsiveHelper.width(4),
              ),
            ),
            errorBuilder: (context, error, stackTrace) => Center(
              child: Icon(Icons.error, color: Colors.red, size: ResponsiveHelper.iconSize(50)),
            ),
          ),
          // Zoom controls overlay
          Positioned(
            right: ResponsiveHelper.padding(16),
            bottom: ResponsiveHelper.padding(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _zoomButton(
                  icon: Icons.add,
                  onTap: _zoomIn,
                ),
                SizedBox(height: ResponsiveHelper.space(12)),
                _zoomButton(
                  icon: Icons.remove,
                  onTap: _zoomOut,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _zoomButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.padding(10)),
        decoration: BoxDecoration(
          color: CustomColors.secondbackgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: ResponsiveHelper.iconSize(24),
        ),
      ),
    );
  }
}
