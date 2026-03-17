import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import '../../utils/color.dart';

/// A reusable pagination widget that displays page numbers with navigation
class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          _buildNavigationButton(
            icon: Icons.chevron_left,
            onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          ),
          SizedBox(width: ResponsiveHelper.space(8)),
          
          // Page numbers
          ..._buildPageNumbers(),
          
          SizedBox(width: ResponsiveHelper.space(8)),
          // Next button
          _buildNavigationButton(
            icon: Icons.chevron_right,
            onTap: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pages = [];
    
    int startPage = 1;
    int endPage = totalPages;
    
    if (totalPages > 5) {
      if (currentPage <= 3) {
        endPage = 4;
      } else if (currentPage >= totalPages - 2) {
        startPage = totalPages - 3;
      } else {
        startPage = currentPage - 1;
        endPage = currentPage + 1;
      }
    }
    
    if (startPage > 1) {
      pages.add(_buildPageButton(1));
      if (startPage > 2) {
        pages.add(_buildEllipsis());
      }
    }
    
    for (int i = startPage; i <= endPage; i++) {
      pages.add(_buildPageButton(i));
    }
    
    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pages.add(_buildEllipsis());
      }
      pages.add(_buildPageButton(totalPages));
    }
    
    return pages;
  }

  Widget _buildPageButton(int page) {
    final isSelected = page == currentPage;
    final double btnSize = ResponsiveHelper.width(36);
    
    return GestureDetector(
      onTap: isSelected ? null : () => onPageChanged(page),
      child: Container(
        width: btnSize,
        height: btnSize,
        margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(4)),
        decoration: BoxDecoration(
          color: isSelected
              ? CustomColors.primaryColor
              : CustomColors.secondbackgroundColor,
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8)),
          border: Border.all(
            color: isSelected
                ? CustomColors.primaryColor
                : const Color(0xFF2F3448),
          ),
        ),
        child: Center(
          child: Text(
            '$page',
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFFB0B4C8),
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    final double btnSize = ResponsiveHelper.width(36);
    return Container(
      width: btnSize,
      height: btnSize,
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(4)),
      child: Center(
        child: Text(
          '...',
          style: TextStyle(
            color: Color(0xFFB0B4C8),
            fontSize: ResponsiveHelper.fontSize(14),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;
    final double btnSize = ResponsiveHelper.width(36);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: btnSize,
        height: btnSize,
        decoration: BoxDecoration(
          color: CustomColors.secondbackgroundColor,
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8)),
          border: Border.all(color: const Color(0xFF2F3448)),
        ),
        child: Center(
          child: Icon(
            icon,
            size: ResponsiveHelper.iconSize(20),
            color: isEnabled
                ? CustomColors.primaryColor
                : const Color(0xFF4A4E5F),
          ),
        ),
      ),
    );
  }
}
