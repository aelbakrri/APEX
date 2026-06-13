import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var greeting = ""

    private var firstName: String { appState.userProfile.name.components(separatedBy: " ").first ?? "Athlete" }
    private var todayWorkout: WorkoutDay? {
        let weekday = Calendar.current.component(.weekday, from: Date()) // 1=Sun
        let mappedDay = weekday == 1 ? 7 : weekday - 1  // 1=Mon
        return appState.workoutPlan?.days.first { $0.weekday == mappedDay }
    }
    private var weeklyVolume: Double {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        return appState.workoutSessions.filter { $0.date >= startOfWeek }.reduce(0) { $0 + $1.totalVolume }
    }
    private var workoutsThisWeek: Int {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        return appState.workoutSessions.filter { $0.date >= startOfWeek && $0.isCompleted }.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greeting).font(.bodySmall).foregroundColor(.textSecondary)
                        Text(firstName).font(.displayLarge).foregroundStyle(Color.gradientMint)
                    }
                    Spacer()
                    Button {
                        appState.currentTab = .progress
                    } label: {
                        Circle()
                            .fill(Color.appCard)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.textSecondary)
                            )
                    }
                }

                // Stats row
                HStack(spacing: 12) {
                    StatCard(title: "This Week", value: "\(workoutsThisWeek)/\(appState.userProfile.workoutsPerWeek)", unit: "sessions", accent: .accentMint, icon: "dumbbell.fill")
                    StatCard(title: "Volume", value: String(format: "%.0f", weeklyVolume), unit: "kg", accent: .accentPurple, icon: "chart.bar.fill")
                }

                // Today's workout card
                if let workout = todayWorkout {
                    TodayWorkoutCard(day: workout)
                } else {
                    RestDayCard()
                }

                // Quick stats
                HStack(spacing: 12) {
                    QuickStatButton(icon: "bolt.fill", label: "AI Adapt", color: .accentMint) {
                        appState.currentTab = .workout
                    }
                    QuickStatButton(icon: "fork.knife", label: "Today's Meals", color: .accentOrange) {
                        appState.currentTab = .nutrition
                    }
                    QuickStatButton(icon: "photo.on.rectangle.angled", label: "Check-In", color: .accentPurple) {
                        appState.currentTab = .progress
                    }
                }

                // Recent progress
                if !appState.workoutSessions.isEmpty {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Recent Sessions")
                            .font(.headlineLarge).foregroundColor(.textPrimary)
                        ForEach(appState.workoutSessions.suffix(3).reversed()) { session in
                            RecentSessionRow(session: session)
                        }
                    }
                }

                // Motivation quote
                MotivationCard()

                Spacer(minLength: 20)
            }
            .padding(20)
        }
        .appScreen()
        .onAppear {
            let hour = Calendar.current.component(.hour, from: Date())
            greeting = hour < 12 ? "Good morning," : hour < 17 ? "Good afternoon," : "Good evening,"
        }
    }
}

// MARK: - Today's Workout Card

struct TodayWorkoutCard: View {
    let day: WorkoutDay
    @EnvironmentObject var appState: AppState

    var body: some View {
        AppCard(padding: 0) {
            VStack(spacing: 0) {
                // Top banner
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("TODAY").font(.label).foregroundColor(.accentMint).tracking(2)
                        Text(day.dayName).font(.displaySmall).foregroundColor(.textPrimary)
                        HStack(spacing: 8) {
                            ForEach(day.focusAreas, id: \.self) { muscle in
                                TagBadge(text: muscle.rawValue, color: muscle.color)
                            }
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundColor(.textMuted)
                        Text("\(day.estimatedMinutes) min")
                            .font(.headlineSmall)
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(16)
                .background(Color.gradientPurple.opacity(0.15))

                // Exercise preview
                VStack(spacing: 0) {
                    ForEach(day.exercises.prefix(3)) { exercise in
                        HStack {
                            Circle()
                                .fill(Color.accentMint.opacity(0.2))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "figure.strengthtraining.traditional")
                                        .font(.system(size: 13))
                                        .foregroundColor(.accentMint)
                                )
                            VStack(alignment: .leading, spacing: 2) {
                                Text(exercise.name).font(.bodySmall).foregroundColor(.textPrimary)
                                Text("\(exercise.sets) × \(exercise.reps)").font(.caption).foregroundColor(.textSecondary)
                            }
                            Spacer()
                            if exercise.isInjuryAdapted {
                                Image(systemName: "waveform.path.ecg")
                                    .font(.caption)
                                    .foregroundColor(.accentOrange)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        if exercise.id != day.exercises.prefix(3).last?.id {
                            Divider().background(Color.textMuted.opacity(0.3)).padding(.leading, 64)
                        }
                    }
                    if day.exercises.count > 3 {
                        Text("+\(day.exercises.count - 3) more exercises")
                            .font(.caption).foregroundColor(.textMuted)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                    }
                }

                // Start button
                Button {
                    appState.currentTab = .workout
                } label: {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start Workout")
                    }
                    .font(.headlineLarge)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background(Color.gradientMint)
                }
                .clipShape(RoundedRectangle(cornerRadius: 0))
                .clipShape(
                    UnevenRoundedRectangle(bottomLeadingRadius: 16, bottomTrailingRadius: 16)
                )
            }
        }
    }
}

struct RestDayCard: View {
    var body: some View {
        AppCard {
            HStack(spacing: 16) {
                Image(systemName: "bed.double.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.accentMint)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Rest Day").font(.displaySmall).foregroundColor(.textPrimary)
                    Text("Recovery is where the gains are made. Eat well, sleep 8+ hours, and hydrate.")
                        .font(.bodySmall).foregroundColor(.textSecondary)
                }
            }
        }
    }
}

// MARK: - Quick Action Buttons

struct QuickStatButton: View {
    let icon: String, label: String, color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(color)
                    .frame(width: 48, height: 48)
                    .background(color.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                Text(label)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Recent Session Row

struct RecentSessionRow: View {
    let session: WorkoutSession
    var body: some View {
        AppCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.workoutName).font(.headlineSmall).foregroundColor(.textPrimary)
                    Text(session.date, style: .date).font(.bodySmall).foregroundColor(.textSecondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(String(format: "%.0f kg", session.totalVolume))
                        .font(.headlineSmall).foregroundColor(.accentMint)
                    Text("total volume").font(.caption).foregroundColor(.textMuted)
                }
            }
        }
    }
}

// MARK: - Motivation Card

struct MotivationCard: View {
    private let quotes = [
        ("The only bad workout is the one that didn't happen.", "Unknown"),
        ("Progressive overload is the cornerstone of hypertrophy.", "Dr. Brad Schoenfeld"),
        ("Strength doesn't come from what you can do. It comes from overcoming what you thought you couldn't.", "Rikki Rogers"),
        ("Eat to perform, not to impress.", "APEX Principle"),
        ("Sleep is the most underrated performance enhancer.", "Dr. Matthew Walker")
    ]

    private var quote: (String, String) {
        quotes[Calendar.current.component(.day, from: Date()) % quotes.count]
    }

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: "quote.bubble.fill")
                    .font(.title2)
                    .foregroundStyle(Color.gradientMint)
                Text(quote.0)
                    .font(.bodyLarge)
                    .foregroundColor(.textPrimary)
                    .italic()
                Text("— \(quote.1)")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
    }
}
