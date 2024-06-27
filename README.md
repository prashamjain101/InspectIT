# InspectIT - Hospital Inspection App

## Overview
The InspectIT App is a SwiftUI-based application designed to streamline the process of hospital inspections. The app allows users to create, manage, and complete inspections, ensuring all necessary data is collected and easily accessible. The app features a dynamic interface, offline capabilities, and real-time status updates.

## Features
- **Inspection Management**: Create, edit, and delete inspection drafts and completed inspections.
- **Real-Time Network Status**: Display online/offline status using a dynamic banner.
- **Segmentation Control**: Easily switch between draft and completed inspections using a segmented control.
- **Detailed Inspection View**: Expandable and collapsible inspection details with real-time updates.
- **Offline Capability**: Continue inspections even when offline, can be upgraded with automatic syncing when back online.

## Requirements
- iOS 15.2+
- Xcode 13.2.1+
- Swift 5.3+

## Installation
1. Clone the repository:
   ```
   git clone https://github.com/yourusername/hospital-inspection-app.git
   ```
Open the project in Xcode:
   ```
   cd hospital-inspection-app
   open HospitalInspectionApp.xcodeproj
   ```

Build and run the project on your preferred simulator or device.
## Usage
Home Screen: View a list of draft and completed inspections.
Add New Inspection: Tap the plus button to create a new inspection.
Inspection Details: Tap on an inspection to view and edit its details.

## Code Structure
HomeView: The main view containing the segmented control and inspection list.
InspectionView: The detailed view for individual inspections.
InspectionViewModel: Handles the logic and data for inspections.
Reachability: Monitors and updates the network connection status.
InspectionNetworkService: Manages network requests related to inspections.

## Contributing
Contributions are welcome! Please submit a pull request or open an issue to discuss your ideas.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

## Contact
For any questions or feedback, feel free to contact Prasham at prashamjain101@gmail.com
