# APEX — iOS Fitness App

## Getting Started in Xcode

1. Open Xcode → **File → New → Project → iOS App**
2. Name it **APEX**, set language to **Swift**, interface to **SwiftUI**
3. Delete the default `ContentView.swift`
4. Drag all `.swift` files from this folder into the project navigator
5. Make sure "Add to target: APEX" is checked for each file
6. Press **⌘R** to run in the simulator

## File Structure

| File | Purpose |
|------|---------|
| `FitnessApp.swift` | App entry point, tab bar |
| `Theme.swift` | Colors, fonts, reusable UI components |
| `Models.swift` | All data models + AppState |
| `SampleData.swift` | Sample workout plan, meals, measurements |
| `OnboardingView.swift` | 5-step onboarding flow |
| `HomeView.swift` | Dashboard — today's workout, stats |
| `WorkoutView.swift` | Plan overview, active workout logging, AI adapt |
| `MealPlanView.swift` | Weekly meal plan with macros |
| `ProgressView.swift` | Check-ins, charts, progress photos |
| `RulesView.swift` | Research-backed training rules |

## Features Built

- ✅ Multi-step onboarding (name, age, height, weight, goal, experience, equipment, injuries, diet)
- ✅ Injury tracking with adapted workouts (flagged with ⚡ badge)
- ✅ AI workout adaptation ("I don't have a barbell today")
- ✅ Active workout logging — sets, reps, weight per exercise
- ✅ Rest timer with visual countdown
- ✅ Progressive overload tracking (previous best shown per exercise)
- ✅ Research-backed workout plan (Upper/Lower split, 4 days/week)
- ✅ 7-day meal plan with macros (protein, carbs, fat, calories)
- ✅ Expandable meal cards with ingredients + prep instructions
- ✅ Weekly progress check-in (weight, measurements, photos, mood)
- ✅ Progress chart with line graph
- ✅ 10 training rules with research citations
- ✅ Dark theme with mint/purple/orange palette

## Connecting Real AI (Next Step)

Replace the `generateAdaptation()` function in `WorkoutView.swift` with a real API call:

```swift
// In AIAdaptSheet, replace the mock with:
func adaptWorkout() {
    let url = URL(string: "https://api.anthropic.com/v1/messages")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer YOUR_API_KEY", forHTTPHeaderField: "x-api-key")
    // ... send user profile + current workout + message
}
```

## Color Palette

| Token | Hex | Use |
|-------|-----|-----|
| `appBackground` | `#0A0A0F` | Screen backgrounds |
| `appCard` | `#1C1C2E` | Card backgrounds |
| `accentMint` | `#00E5A0` | Primary CTAs, active states |
| `accentPurple` | `#7C3AED` | Secondary accent |
| `accentOrange` | `#F97316` | Progress, calories, warnings |
| `accentRed` | `#EF4444` | Injuries, errors |
