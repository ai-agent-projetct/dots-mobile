import 'package:flutter/material.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:resize/resize.dart';

class MultiSelectDropdown extends StatefulWidget {
  final String title;
  final List<String> items;
  final List<String> selectedItems;
  final Function(List<String>) onSelectionChanged;
  final String? hintText;
  final bool Function()? onTap; // return bool instead of void

  const MultiSelectDropdown({
    Key? key,
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
    this.hintText,
    this.onTap,
  }) : super(key: key);

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  bool _isExpanded = false;
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isExpanded) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height + 5.0),
              child: Material(
                borderRadius: BorderRadius.vertical(),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: AppColors.greyBorder, width: 1),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final isSelected = widget.selectedItems.contains(item);
                      return InkWell(
                        onTap: () => _toggleItem(item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            border:
                                index < widget.items.length - 1
                                    ? Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    )
                                    : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? AppColors.primary
                                            : Colors.grey.shade400,
                                  ),
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                ),
                                child:
                                    isSelected
                                        ? const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: Colors.white,
                                        )
                                        : null,
                              ),
                              const SizedBox(width: 10),

                              Expanded(
                                child: AppText(item, textStyle: TextStyle()),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
    );
  }

  void _toggleItem(String item) {
    List<String> updatedSelection = List.from(widget.selectedItems);

    if (updatedSelection.contains(item)) {
      updatedSelection.remove(item);
    } else {
      updatedSelection.add(item);
    }

    widget.onSelectionChanged(updatedSelection);

    // Force rebuild of the overlay to update checkboxes
    if (_isExpanded) {
      _removeOverlay();
      _showOverlay();
    }
  }

  String _getDisplayText() {
    if (widget.selectedItems.isEmpty) {
      return widget.hintText ?? widget.title;
    } else {
      return widget.selectedItems.join(', ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            final shouldProceed = widget.onTap!();
            if (!shouldProceed)
              return; // Stop dropdown opening if returns false
          }

          _toggleDropdown();
        },
        child: Container(
          key: _dropdownKey,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: AppColors.backGroundGrey,
            border: Border.all(color: AppColors.greyBorder),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText(
                  _getDisplayText(),
                  textStyle: TextStyle(
                    color:
                        widget.selectedItems.isEmpty
                            ? AppColors.hintColor
                            : AppColors.black,
                  ),
                ),
              ),
              Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SingleSelectDropdown extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? selectedItem;
  final Function(String?) onSelectionChanged;
  final String? hintText;
  final bool Function()? onTap; // return bool instead of void

  const SingleSelectDropdown({
    Key? key,
    required this.title,
    required this.items,
    this.selectedItem,
    required this.onSelectionChanged,
    this.hintText,
    this.onTap,
  }) : super(key: key);

  @override
  State<SingleSelectDropdown> createState() => _SingleSelectDropdownState();
}

class _SingleSelectDropdownState extends State<SingleSelectDropdown> {
  bool _isExpanded = false;
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isExpanded) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height + 5.0),
              child: Material(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: AppColors.greyBorder, width: 1),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final isSelected = widget.selectedItem == item;

                      return InkWell(
                        onTap: () => _selectItem(item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color:
                                // isSelected
                                //     ? Colors.red.shade50
                                //     :
                                Colors.transparent,
                            border:
                                index < widget.items.length - 1
                                    ? Border(
                                      bottom: BorderSide(
                                        color: AppColors.greyBorder,
                                      ),
                                    )
                                    : null,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color:
                                        isSelected
                                            ? AppColors.primary
                                            : AppColors.hintColor,
                                    fontFamily: AppStringsKey.poppins,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                              // if (isSelected)
                              //   Icon(
                              //     Icons.check,
                              //     size: 18,
                              //     color: AppColors.primary,
                              //   ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
    );
  }

  void _selectItem(String item) {
    widget.onSelectionChanged(item);
    _removeOverlay();
    setState(() {
      _isExpanded = false;
    });
  }

  String _getDisplayText() {
    if (widget.selectedItem == null || widget.selectedItem!.isEmpty) {
      return widget.hintText ?? widget.title;
    } else {
      return widget.selectedItem!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          // If onTap callback exists and it returns false, block dropdown opening
          if (widget.onTap != null) {
            final shouldProceed = widget.onTap!();
            if (!shouldProceed) return; // Stop opening dropdown
          }

          _toggleDropdown(); // Only open if allowed
        },
        child: Container(
          key: _dropdownKey,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: AppColors.backgroundGrey,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText(
                  _getDisplayText(),
                  textStyle: TextStyle(
                    color:
                        (widget.selectedItem == null ||
                                widget.selectedItem!.isEmpty)
                            ? AppColors.hintColor
                            : AppColors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
