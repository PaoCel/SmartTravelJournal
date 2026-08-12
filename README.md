# Smart Travel Journal

Capstone project of the *Developing iOS Apps with Swift* specialization.
A travel journal that keeps trips, journal entries with mood and photo, the place
each entry was written, the weather at that place, a map of the whole trip,
charts over time, and AI summaries and tags generated on device.

Built with SwiftUI, SwiftData, MVVM with `@Observable`, MapKit, CoreLocation,
Swift Charts, async/await networking and Foundation Models. First-party
frameworks only, no external dependencies.

## Requirements

- Xcode 26, iOS 26 SDK
- iPhone 16 simulator (iOS 26.4) or a device
- Apple Intelligence enabled for real AI summaries and tags; without it the app
  falls back to static content, which is the expected behaviour on the Simulator

## OpenWeatherMap key

The app builds and runs without a key: the weather section shows a message with a
Retry button instead of the forecast.

To see real weather:

1. Open `SmartTravelJournal.xcodeproj`.
2. Select the **SmartTravelJournal** target, then **Build Settings**.
3. Search for `OpenWeatherMapAPIKey` and replace `YOUR_API_KEY_HERE` with an
   active key from [openweathermap.org](https://openweathermap.org/api) (free tier).

The value ends up in the generated Info.plist and is read at runtime by
`Services/AppSecrets.swift`. Never commit a real key.

## Structure

```
SmartTravelJournal/
├── Models/       Trip, JournalEntry, Mood, weather and AI response types
├── Services/     networking, location, Foundation Models, errors, timeout
├── ViewModels/   @Observable classes, one per domain
├── Views/        screens and reusable components
└── Resources/    string catalog (plural rules)
```

Trips, entries and the AI cache are persisted with SwiftData. ViewModels never
hold the `ModelContext`: they receive it from the view when they need to write.

## Screens

- **Trips** — list with search, create, edit, swipe to delete
- **Trip detail** — cover, stats, AI summary card with retry, entries with search
- **Entry editor** — text, date, GPS coordinates, live weather, mood, photo
- **Map** — one annotation per entry, mood colours, style picker, user location
- **Charts** — entries over time, mood trend, totals
