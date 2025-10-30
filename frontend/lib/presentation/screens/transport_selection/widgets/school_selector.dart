import 'package:flutter/material.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';
import 'package:streetsmart/data/models/school_model.dart';

class SchoolSelector extends StatelessWidget {
  final List<School> schools;
  final School? selectedSchool;
  final Function(School?) onSchoolSelected;

  const SchoolSelector({
    super.key,
    required this.schools,
    required this.selectedSchool,
    required this.onSchoolSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<School>(
          value: selectedSchool,
          hint: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Select your school'),
          ),
          isExpanded: true,
          icon: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.arrow_drop_down),
          ),
          items: schools.map((School school) {
            return DropdownMenuItem<School>(
              value: school,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      school.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (school.address != null)
                      Text(
                        school.address!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: onSchoolSelected,
        ),
      ),
    );
  }
}
