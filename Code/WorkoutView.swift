import SwiftUI
import Combine

// MARK: - Workout Plan View

struct WorkoutView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedDay: WorkoutDay?
    @State private var showAIAdapt = false
    @State private var showActiveWorkout = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // AI Adapt Banner
                    AIAdaptBanner { showAIAdapt = true }

                    // Week overview
                    if let plan = appState.workoutPlan {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("This Week's Plan")
                                .font(.headlineLarge).foregroundColor(.textPrimary)
                            ForEach(plan.days.sorted { $0.weekday < $1.weekday }) { day in
                                WorkoutDayCard(day: day, isToday: isToday(weekday: day.weekday)) {
                                    selectedDay = day
                                    showActiveWorkout = true
                                }
                            }
                        }

                        // Research footer
                        AppCard {
                            HStack(spacing: 12) {
                                Image(systemName: "doc.text.magnifyingglass")
                                    .foregroundColor(.accentPurple)
                                    .font(.title3)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Evidence-Based Programming").font(.headlineSmall).foregroundColor(.textPrimary)
                                    Text(plan.researchSource.isEmpty ? "Based on Schoenfeld (2010), Krieger (2010) hypertrophy meta-analyses and NSCA guidelines." : plan.researchSource)
                                        .font(.bodySmall).foregroundColor(.textSecondary)
                                }
                            }
                        }
                    } else {
                        EmptyWorkoutState()
                    }
                }
                .padding(20)
            }
            .appScreen()
            .navigationTitle("Train")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
        }
        .sheet(isPresented: $showAIAdapt) {
            AIAdaptSheet()
        }
        .fullScreenCover(isPresented: $showActiveWorkout) {
            if let day = selectedDay {
                ActiveWorkoutView(day: day)
                    .environmentObject(appState)
            }
        }
    }

    func isToday(weekday: Int) -> Bool {
        let w = Calendar.current.component(.weekday, from: Date())
        let mapped = w == 1 ? 7 : w - 1
        return mapped == weekday
    }
}

// MARK: - AI Adapt Banner

struct AIAdaptBanner: View {
    var onTap: () -> Void
    @State private var shimmer = false

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Color.accentMint.opacity(0.2)).frame(width: 44, height: 44)
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.accentMint)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("AI Workout Adaptation")
                        .font(.headlineLarge).foregroundColor(.textPrimary)
                    Text("\"I don't have a barbell today\" — tap to adapt")
                        .font(.bodySmall).foregroundColor(.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(.textMuted)
            }
            .padding(16)
            .background(
                LinearGradient(colors: [Color.accentMint.opacity(0.12), Color.accentPurple.opacity(0.08)], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.accentMint.opacity(0.3), lineWidth: 1))
        }
    }
}

// MARK: - Workout Day Card

struct WorkoutDayCard: View {
    let day: WorkoutDay
    let isToday: Bool
    var onStart: () -> Void

    var dayName: String {
        let days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
        return days[(day.weekday - 1) % 7]
    }

    var body: some View {
        AppCard(padding: 0) {
            VStack(spacing: 0) {
                HStack {
                    // Day indicator
                    VStack(spacing: 4) {
                        Text(dayName)
                            .font(.label).foregroundColor(isToday ? .accentMint : .textSecondary)
                        if isToday {
                            Circle().fill(Color.accentMint).frame(width: 6, height: 6)
                        }
                    }
                    .frame(width: 40)

                    Rectangle().fill(Color.textMuted.opacity(0.2)).frame(width: 1, height: 44)
                        .padding(.horizontal, 8)

                    VStack(alignment: .leading, spacing: 5) {
                        Text(day.isRestDay ? "Rest Day" : day.dayName)
                            .font(.headlineLarge).foregroundColor(.textPrimary)
                        if !day.isRestDay {
                            HStack(spacing: 6) {
                                ForEach(day.focusAreas.prefix(3), id: \.self) { muscle in
                                    TagBadge(text: muscle.rawValue, color: muscle.color)
                                }
                            }
                        }
                    }

                    Spacer()

                    if !day.isRestDay {
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("\(day.estimatedMinutes) min")
                                .font(.headlineSmall).foregroundColor(.textSecondary)
                            Text("\(day.exercises.count) exercises")
                                .font(.caption).foregroundColor(.textMuted)
                        }
                    }
                }
                .padding(16)

                if !day.isRestDay {
                    Button(action: onStart) {
                        HStack {
                            Image(systemName: isToday ? "play.fill" : "eye.fill")
                            Text(isToday ? "Start Session" : "Preview")
                        }
                        .font(.headlineSmall)
                        .foregroundColor(isToday ? .black : .accentMint)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background {
                            if isToday { Color.gradientMint } else { Color.accentMint.opacity(0.1) }
                        }
                    }
                    .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 16, bottomTrailingRadius: 16))
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isToday ? Color.accentMint.opacity(0.5) : Color.clear, lineWidth: 1.5)
        )
    }
}

// MARK: - Active Workout View

struct ActiveWorkoutView: View {
    let day: WorkoutDay
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var exerciseLogs: [ExerciseLog] = []
    @State private var currentExerciseIndex = 0
    @State private var elapsedSeconds = 0
    @State private var timerRunning = true
    @State private var showFinish = false
    @State private var restTimerSeconds = 0
    @State private var showRestTimer = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var currentExercise: Exercise? {
        guard currentExerciseIndex < day.exercises.count else { return nil }
        return day.exercises[currentExerciseIndex]
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                // Header bar
                HStack {
                    Button { showFinish = true } label: {
                        Image(systemName: "xmark").font(.title3.bold()).foregroundColor(.textSecondary)
                    }
                    Spacer()
                    Text(day.dayName).font(.headlineLarge).foregroundColor(.textPrimary)
                    Spacer()
                    Text(timeString(elapsedSeconds))
                        .font(.headlineLarge).foregroundColor(.accentMint)
                        .monospacedDigit()
                }
                .padding(20)

                // Progress
                HStack(spacing: 6) {
                    ForEach(day.exercises.indices, id: \.self) { i in
                        Capsule()
                            .fill(i < currentExerciseIndex ? Color.accentMint : i == currentExerciseIndex ? Color.accentMint.opacity(0.5) : Color.appCard)
                            .frame(height: 4)
                            .animation(.easeInOut, value: currentExerciseIndex)
                    }
                }
                .padding(.horizontal, 20)

                ScrollView {
                    VStack(spacing: 20) {
                        if let exercise = currentExercise {
                            ExerciseLogCard(
                                exercise: exercise,
                                log: exerciseLogBinding(for: exercise),
                                onSetComplete: { startRestTimer(exercise.restSeconds) }
                            )
                        }

                        // Rest timer
                        if showRestTimer && restTimerSeconds > 0 {
                            RestTimerView(secondsRemaining: $restTimerSeconds)
                        }

                        // Navigation
                        HStack(spacing: 12) {
                            if currentExerciseIndex > 0 {
                                Button {
                                    currentExerciseIndex -= 1
                                } label: {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                        Text("Previous")
                                    }
                                    .font(.headlineSmall).foregroundColor(.textSecondary)
                                    .frame(maxWidth: .infinity).padding(16)
                                    .background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                            }

                            if currentExerciseIndex < day.exercises.count - 1 {
                                PrimaryButton(title: "Next Exercise") {
                                    withAnimation { currentExerciseIndex += 1 }
                                }
                            } else {
                                PrimaryButton(title: "Finish Workout 🎉", style: .orange) {
                                    finishWorkout()
                                    dismiss()
                                }
                            }
                        }
                        .padding(.bottom, 30)
                    }
                    .padding(20)
                }
            }
        }
        .onReceive(timer) { _ in
            if timerRunning { elapsedSeconds += 1 }
            if showRestTimer && restTimerSeconds > 0 { restTimerSeconds -= 1 }
            if restTimerSeconds == 0 { showRestTimer = false }
        }
        .onAppear { setupLogs() }
        .alert("Finish Workout?", isPresented: $showFinish) {
            Button("Finish & Save", role: .destructive) { finishWorkout(); dismiss() }
            Button("Cancel", role: .cancel) {}
        }
    }

    func setupLogs() {
        exerciseLogs = day.exercises.map { ex in
            ExerciseLog(
                exerciseId: ex.id,
                exerciseName: ex.name,
                sets: (1...ex.sets).map { i in
                    WorkoutSet(setNumber: i, targetReps: ex.reps)
                }
            )
        }
    }

    func exerciseLogBinding(for exercise: Exercise) -> Binding<ExerciseLog> {
        let index = exerciseLogs.firstIndex { $0.exerciseId == exercise.id } ?? 0
        return $exerciseLogs[index]
    }

    func startRestTimer(_ seconds: Int) {
        restTimerSeconds = seconds
        showRestTimer = true
    }

    func finishWorkout() {
        let session = WorkoutSession(
            date: Date(),
            workoutPlanId: appState.workoutPlan?.id ?? UUID(),
            workoutName: day.dayName,
            exercises: exerciseLogs,
            durationSeconds: elapsedSeconds,
            isCompleted: true
        )
        appState.workoutSessions.append(session)
    }

    func timeString(_ s: Int) -> String {
        String(format: "%02d:%02d", s / 60, s % 60)
    }
}

// MARK: - Exercise Log Card

struct ExerciseLogCard: View {
    let exercise: Exercise
    @Binding var log: ExerciseLog
    var onSetComplete: () -> Void

    var body: some View {
        AppCard(padding: 0) {
            VStack(spacing: 0) {
                // Exercise header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exercise.name)
                                .font(.displaySmall).foregroundColor(.textPrimary)
                            HStack(spacing: 6) {
                                ForEach(exercise.muscleGroups, id: \.self) { m in
                                    TagBadge(text: m.rawValue, color: m.color)
                                }
                            }
                        }
                        Spacer()
                        if exercise.isInjuryAdapted {
                            TagBadge(text: "Adapted", color: .accentOrange)
                        }
                    }

                    if !exercise.notes.isEmpty {
                        Text(exercise.notes)
                            .font(.bodySmall).foregroundColor(.textSecondary)
                            .padding(10)
                            .background(Color.appCardElevated)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(16)

                Divider().background(Color.textMuted.opacity(0.3))

                // Set headers
                HStack {
                    Text("Set").frame(width: 40)
                    Text("Target").frame(maxWidth: .infinity)
                    Text("Reps").frame(maxWidth: .infinity)
                    Text("Weight (kg)").frame(maxWidth: .infinity)
                    Text("Done").frame(width: 50)
                }
                .font(.caption).foregroundColor(.textMuted)
                .padding(.horizontal, 16).padding(.vertical, 10)
                .background(Color.appCardElevated)

                // Sets
                ForEach($log.sets) { $set in
                    SetRow(set: $set, targetReps: exercise.reps, onComplete: {
                        if set.isCompleted { onSetComplete() }
                    })
                    if set.id != log.sets.last?.id {
                        Divider().background(Color.textMuted.opacity(0.2)).padding(.leading, 16)
                    }
                }

                // Previous best
                if let best = log.previousBest {
                    HStack {
                        Image(systemName: "trophy.fill").foregroundColor(.accentOrange).font(.caption)
                        Text("PR: \(best.completedReps ?? 0) reps × \(String(format: "%.1f", best.weightKg ?? 0)) kg")
                            .font(.caption).foregroundColor(.accentOrange)
                        Spacer()
                    }
                    .padding(.horizontal, 16).padding(.vertical, 10)
                    .background(Color.accentOrange.opacity(0.08))
                }
            }
        }
    }
}

struct SetRow: View {
    @Binding var set: WorkoutSet
    let targetReps: String
    var onComplete: () -> Void

    var body: some View {
        HStack {
            Text("\(set.setNumber)")
                .font(.headlineSmall)
                .foregroundColor(set.isCompleted ? .accentMint : .textSecondary)
                .frame(width: 40)

            Text(targetReps)
                .font(.bodySmall).foregroundColor(.textSecondary)
                .frame(maxWidth: .infinity)

            // Reps input
            TextField("0", value: $set.completedReps, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.headlineLarge)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(Color.appCardElevated)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            // Weight input
            TextField("0", value: $set.weightKg, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .font(.headlineLarge)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(Color.appCardElevated)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            // Complete toggle
            Button {
                set.isCompleted.toggle()
                onComplete()
            } label: {
                Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(set.isCompleted ? .accentMint : .textMuted)
            }
            .frame(width: 50)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(set.isCompleted ? Color.accentMint.opacity(0.05) : Color.clear)
        .animation(.easeInOut(duration: 0.2), value: set.isCompleted)
    }
}

// MARK: - Rest Timer

struct RestTimerView: View {
    @Binding var secondsRemaining: Int

    var body: some View {
        AppCard {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.accentPurple.opacity(0.2), lineWidth: 4)
                        .frame(width: 56, height: 56)
                    Circle()
                        .trim(from: 0, to: CGFloat(secondsRemaining) / 90.0)
                        .stroke(Color.accentPurple, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 56, height: 56)
                        .rotationEffect(.degrees(-90))
                    Text("\(secondsRemaining)s")
                        .font(.headlineSmall).foregroundColor(.accentPurple)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Rest Time").font(.headlineLarge).foregroundColor(.textPrimary)
                    Text("Get ready for your next set").font(.bodySmall).foregroundColor(.textSecondary)
                }
                Spacer()
                Button {
                    secondsRemaining = 0
                } label: {
                    Text("Skip")
                        .font(.headlineSmall).foregroundColor(.accentMint)
                        .padding(.horizontal, 16).padding(.vertical, 8)
                        .background(Color.accentMint.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
        }
    }
}

// MARK: - AI Adapt Sheet

struct AIAdaptSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @State private var message = ""
    @State private var isLoading = false
    @State private var response = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Tell APEX what's different today:")
                        .font(.headlineLarge).foregroundColor(.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Quick suggestions
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(quickSuggestions, id: \.self) { s in
                                Button { message = s } label: {
                                    Text(s).font(.bodySmall).foregroundColor(.textPrimary)
                                        .padding(.horizontal, 14).padding(.vertical, 8)
                                        .background(Color.appCard).clipShape(Capsule())
                                }
                            }
                        }
                    }

                    TextField("e.g. I don't have a barbell today…", text: $message, axis: .vertical)
                        .lineLimit(3...6)
                        .appTextField()

                    if !response.isEmpty {
                        AppCard {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "wand.and.stars").foregroundColor(.accentMint)
                                    Text("APEX Adaptation").font(.headlineSmall).foregroundColor(.accentMint)
                                }
                                Text(response).font(.bodyLarge).foregroundColor(.textPrimary)
                            }
                        }
                    }

                    PrimaryButton(title: isLoading ? "Adapting…" : "Rebuild My Workout", isLoading: isLoading, action: adaptWorkout)
                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("AI Adapt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundColor(.accentMint)
                }
            }
        }
    }

    var quickSuggestions: [String] {
        ["No barbell today", "Shoulder is sore", "Only 30 minutes", "Home workout only", "No machines available"]
    }

    func adaptWorkout() {
        guard !message.isEmpty else { return }
        isLoading = true
        // In production: call OpenAI / Claude API with user context
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            response = generateAdaptation(for: message)
            isLoading = false
        }
    }

    func generateAdaptation(for input: String) -> String {
        let lower = input.lowercased()
        if lower.contains("barbell") || lower.contains("no barbell") {
            return "Got it! I've swapped barbell movements for dumbbell equivalents:\n• Barbell Bench → Dumbbell Press\n• Barbell Row → One-Arm Dumbbell Row\n• Back Squat → Goblet Squat\n\nAll rep ranges maintained. Volume is equivalent. Tap 'Apply Changes' to update today's session."
        } else if lower.contains("shoulder") {
            return "Shoulder noted! I've removed overhead pressing and replaced with:\n• Front raises → Cable lateral raise (lower angle)\n• OHP → Incline dumbbell fly\n\nAll shoulder-impingement movements have been flagged. Focus on scapular health today."
        } else if lower.contains("30 min") || lower.contains("time") {
            return "Short on time? I've trimmed today's session to a 30-minute superset format. Compound movements only — no isolation work. Every set is paired to keep rest minimal."
        } else if lower.contains("home") {
            return "Switching to home mode! Today's plan is now bodyweight + resistance band only. Progressive overload maintained using tempo manipulation and band resistance."
        }
        let goalNames = appState.userProfile.goals.map(\.rawValue).joined(separator: " & ")
        return "Plan adapted based on your input. I've modified exercises to work around your constraint while maintaining volume and intensity for your \(goalNames) goals."
    }
}

// MARK: - Empty State

struct EmptyWorkoutState: View {
    var body: some View {
        AppCard {
            VStack(spacing: 16) {
                Image(systemName: "dumbbell").font(.system(size: 48)).foregroundColor(.textMuted)
                Text("No Plan Yet").font(.displaySmall).foregroundColor(.textPrimary)
                Text("Complete onboarding to generate your personalised workout plan")
                    .font(.bodyLarge).foregroundColor(.textSecondary).multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity).padding(.vertical, 20)
        }
    }
}
