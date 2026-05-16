# Runner Hub

Runner Hub is a starter iOS app for runners who want progress tracking, upcoming race/event planning, local running groups, trail notes, and equipment mileage in one place.

## What is included

- **Progress dashboard** with weekly mileage, total mileage, average pace, run count, and recent run notes.
- **Add Run flow** that stores distance, duration, mood, and notes locally.
- **Upcoming Events** list with sample event dates, distances, locations, and registration links.
- **Local Groups** directory for meetups, pace ranges, locations, and contact details.
- **Running Trails** directory with distance, difficulty, location, and notes.
- **Equipment tracker** with mileage progress and replacement targets for shoes and gear.
- **Local persistence** using a JSON file in the app's Documents directory so you can run it on your iPhone without a backend.

## Run locally on an iPhone 16 Pro Max

1. Open `Runner.xcodeproj` in Xcode on a Mac.
2. Select the `Runner` target and open **Signing & Capabilities**.
3. Choose your Apple Developer team. A free personal team works for local device deployment.
4. If needed, change the bundle identifier from `com.example.RunnerHub` to something unique, such as `com.yourname.RunnerHub`.
5. Connect your iPhone 16 Pro Max with USB or pair it wirelessly in Xcode.
6. Select your iPhone as the run destination.
7. Press **Run**. If iOS asks you to trust the developer profile, follow the prompt in Settings.

## Next feature ideas

- Add edit/delete screens for every category.
- Integrate MapKit for trail maps and nearby running routes.
- Add EventKit reminders for upcoming races and group runs.
- Sync with HealthKit or WorkoutKit after adding the required privacy descriptions.
- Replace demo community data with a backend or curated local source.
