import 'package:driver/app/models/my_driver_model.dart';
import 'package:flutter/material.dart';

class DriverDetailsView extends StatelessWidget {
  final MyDriverModel driver;

  const DriverDetailsView({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    final driverDetails = {
      'Name': driver.name ?? 'Unknown',
      'Email': driver.email ?? 'N/A',
      'Phone': driver.phone ?? 'N/A',
      'Country Code': driver.countryCode ?? 'N/A',
      'Referral Code': driver.referralCode ?? 'N/A',
      'Owner Id': driver.ownerId ?? "N/A",
      'Verified': driver.verified == true ? 'Yes' : 'No',
      'Gender': driver.gender ?? 'N/A',
      'Date of Birth':
          driver.dateOfBirth != null ? driver.dateOfBirth.toString() : 'N/A',
      'Profile': driver.profile ?? 'N/A',
      'Status': driver.status ?? 'N/A',
      'Year of Experience': driver.yearOfExperience.toString(),
      'Created At': driver.createdAt?.toString() ?? 'N/A',
      'Updated At': driver.updatedAt?.toString() ?? 'N/A',
      // Add more properties as needed
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('${driver.name} Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Table(
            border: TableBorder.all(),
            children: driverDetails.entries.map((entry) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(entry.key),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(entry.value),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
