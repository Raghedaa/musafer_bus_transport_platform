import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';

class CustomTextFormField<T> extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool? isExpanded;
  final VoidCallback? onEditingComplete;
  final List<DropdownMenuItem<T>>? dropdownItems;
  final T? dropdownValue;
  final void Function(T?)? onDropdownChanged;
  final String? Function(T?)? dropdownValidator;

  final String? initialValue;
  final String? initialDropdownHint;

  const CustomTextFormField({
    super.key,
    required this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.onChanged,
    this.maxLines,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.dropdownValidator,

    this.onEditingComplete,
    this.isExpanded,
    this.initialValue,
    this.initialDropdownHint,
  });

  @override
  Widget build(BuildContext context) {
    if (dropdownItems != null) {
      return DropdownButtonFormField<T>(
        value: dropdownValue,
        items: dropdownItems,
        onChanged: onDropdownChanged,
        validator: dropdownValidator,
        isExpanded: isExpanded ?? false,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColor.darkgreen),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColor.darkgreen)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColor.darkgreen), // شلنا const
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColor.darkgreen), // شلنا const
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: AppColor.darkgreen,
              width: 2,
            ),
          ),
          floatingLabelStyle: TextStyle(color: AppColor.darkgreen), // شلنا const
        ),
        hint: initialDropdownHint != null
            ? Text(
          initialDropdownHint!,
          style: TextStyle(color: AppColor.darkgreen),
        )
            : null,
      );
    }

    return TextFormField(
      cursorColor: AppColor.darkgreen,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      maxLines: obscureText ? 1 : maxLines,
      initialValue: initialValue,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColor.darkgreen), // شلنا const
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColor.darkgreen)
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
          onPressed: onSuffixPressed,
          icon: Icon(suffixIcon, color: AppColor.darkgreen),
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColor.darkgreen), // شلنا const
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColor.darkgreen), // شلنا const
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColor.darkgreen,
            width: 2,
          ),
        ),
        floatingLabelStyle: TextStyle(color: AppColor.darkgreen), // شلنا const
      ),
    );
  }
}