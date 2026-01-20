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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          _buildNavigationButton(
            icon: Icons.chevron_left,
            onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          ),
          const SizedBox(width: 8),
          
          // Page numbers
          ..._buildPageNumbers(),
          
          const SizedBox(width: 8),
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
    
    // Determine which page numbers to show
    int startPage = 1;
    int endPage = totalPages;
    
    // If total pages > 5, show limited pages with ellipsis
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
    
    // First page + ellipsis if needed
    if (startPage > 1) {
      pages.add(_buildPageButton(1));
      if (startPage > 2) {
        pages.add(_buildEllipsis());
      }
    }
    
    // Middle pages
    for (int i = startPage; i <= endPage; i++) {
      pages.add(_buildPageButton(i));
    }
    
    // Ellipsis + last page if needed
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
    
    return GestureDetector(
      onTap: isSelected ? null : () => onPageChanged(page),
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? CustomColors.primaryColor
              : CustomColors.secondbackgroundColor,
          borderRadius: BorderRadius.circular(8),
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
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: const Center(
        child: Text(
          '...',
          style: TextStyle(
            color: Color(0xFFB0B4C8),
            fontSize: 14,
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
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: CustomColors.secondbackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2F3448)),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: isEnabled
                ? CustomColors.primaryColor
                : const Color(0xFF4A4E5F),
          ),
        ),
      ),
    );
  }
}
