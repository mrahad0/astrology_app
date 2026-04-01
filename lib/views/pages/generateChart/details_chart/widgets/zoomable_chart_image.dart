// lib/views/pages/generateChart/details_chart/widgets/zoomable_chart_image.dart
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/utils/color.dart';

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
  late TransformationController _transformationController;
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _transformationController.addListener(_onScaleChanged);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onScaleChanged);
    _transformationController.dispose();
    super.dispose();
  }

  void _onScaleChanged() {
    _currentScale = _transformationController.value.getMaxScaleOnAxis();
  }

  void _zoomIn() {
    if (_currentScale < 3.0) {
      _applyZoom(1.5);
    }
  }

  void _zoomOut() {
    if (_currentScale > 1.0) {
      // If we go below 1.0, reset safely
      if (_currentScale / 1.5 < 1.0) {
        _transformationController.value = Matrix4.identity();
      } else {
        _applyZoom(1 / 1.5);
      }
    }
  }

  void _applyZoom(double zoomFactor) {
    // Zoom around the center of the widget safely
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final Offset center = renderBox.size.center(Offset.zero);
    
    final Matrix4 matrix = _transformationController.value.clone();
    
    matrix.translate(center.dx, center.dy);
    matrix.scale(zoomFactor);
    matrix.translate(-center.dx, -center.dy);
    
    _transformationController.value = matrix;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: widget.height,
        width: MediaQuery.of(context).size.width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Using InteractiveViewer enables robust native panning anywhere when zoomed in!
            InteractiveViewer(
              transformationController: _transformationController,
              minScale: 1.0,
              maxScale: 3.0,
              panEnabled: true,
              scaleEnabled: true,
              clipBehavior: Clip.none,
              child: Center(
                child: widget.imageUrl.isNotEmpty
                    ? Image.network(
                        widget.imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: widget.loadingColor,
                              strokeWidth: ResponsiveHelper.width(4),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(Icons.error,
                                color: Colors.red,
                                size: ResponsiveHelper.iconSize(50)),
                          );
                        },
                      )
                    : Image.asset(
                        widget.fallbackAssetImage,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            // Zoom controls overlay
            Positioned(
              right: ResponsiveHelper.padding(10),
              bottom: ResponsiveHelper.padding(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _zoomButton(
                    icon: Icons.add,
                    onTap: _zoomIn,
                  ),
                  SizedBox(height: ResponsiveHelper.space(8)),
                  _zoomButton(
                    icon: Icons.remove,
                    onTap: _zoomOut,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _zoomButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.padding(6)),
        decoration: BoxDecoration(
          color: CustomColors.secondbackgroundColor.withValues(alpha: 0.8),
          shape: BoxShape.circle,
          border: Border.all(color: CustomColors.primaryColor, width: 1.5),
        ),
        child: Icon(
          icon,
          color: CustomColors.primaryColor,
          size: ResponsiveHelper.iconSize(20),
        ),
      ),
    );
  }
}
