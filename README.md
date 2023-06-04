# A-EYE mobile

## Development Environment
- Flutter 3.3.10 
- Dart 2.18.6 

## Application Version

- Android
  - minSdkVersion : 31 (Please use upper version of Android 12)
  - 
- IOS
  - Make sure you have the Xcode version 14.0 or above installed on your computer.
  - IOS version with 16.2 (recommend to use simulator with iPhone 14 Pro Max with iOS 16.2)

## Required permission
- Notification (Needed) : It is used for push message about falling alert.

## License
The following libraries are used in this project.
- Youtube player flutter
- syncfusion flutter charts
- flutter local notifications
- firebase messaging

## Getting started
  - For IOS, recommend to build in Xcode with simulator iPhone 14 Pro Max with iOS 16.2
  - For android, you can install the aeye apk on here "https://drive.google.com/file/d/1qW2Co4vmBm9KzQfyYaS4zRNjopmG-RXN/view?usp=sharing"

## Usage
<p>

<img src="https://user-images.githubusercontent.com/106396244/229190824-e5b1b7cd-558d-4609-8e0a-324780282804.gif" width="200px" />
<img src="https://user-images.githubusercontent.com/106396244/229361505-5c6263f4-f4ab-4f49-92c5-96f26d5c9566.gif" width="200px" />
<img src="https://user-images.githubusercontent.com/106396244/229361529-2252bf37-63d0-4c85-9392-c0cbbdd2cc35.gif" width="200px" />
<img src="https://user-images.githubusercontent.com/106396244/229361937-7212060f-37d5-4ed6-93d3-2e432315bdaf.gif" width="200px" />


</p>

- Login
  - After signing up and signing in, the user should choose the role between main caregiver and sub caregiver.
  - Main caregiver gets identification code that should be shared to sub caregiver. The code identifies that they are parent.
  - Sub caregiver should input the identification code that would be shared by the main caregiver. 
  - Sub caregiver is restricted to write the diary. Other functions are all available to both.

- Baby Monitoring
  - Video
    - View baby's monitoring video. (With technical issue, the recorded video is viewed now. It would be updated soon)  
  - SOS
    - Clicking sos button on alert page, move to the google map to view the nearby hospital.

- Emotion diary
  - Diary
    - After writing the diary, the user can choose the emoticon based on the emotion by Google Natural Language API.
  - Comment
    - The caregivers can comment for today's diary. 
    - This is restricted until writing the diary.

