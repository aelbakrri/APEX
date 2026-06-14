import SwiftUI

// MARK: - Onboarding Container

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentStep = 0
    @State private var profile = UserProfile()
    @State private var animateIn = false

    private let totalSteps = 6

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                HStack(spacing: 6) {
                    ForEach(0..<totalSteps, id: \.self) { i in
                        Capsule()
                            .fill(i <= currentStep ? Color.accentMint : Color.appCard)
                            .frame(height: 4)
                            .animation(.easeInOut(duration: 0.3), value: currentStep)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Step content
                TabView(selection: $currentStep) {
                    WelcomeStep(onNext: nextStep).tag(0)
                    PersonalInfoStep(profile: $profile, onNext: nextStep, onBack: prevStep).tag(1)
                    GoalStep(profile: $profile, onNext: nextStep, onBack: prevStep).tag(2)
                    ExperienceEquipmentStep(profile: $profile, onNext: nextStep, onBack: prevStep).tag(3)
                    InjuriesStep(profile: $profile, onNext: nextStep, onBack: prevStep).tag(4)
                    DietaryStep(profile: $profile, onFinish: finish, onBack: prevStep).tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.35), value: currentStep)
            }
        }
        .opacity(animateIn ? 1 : 0)
        .onAppear { withAnimation(.easeIn(duration: 0.4)) { animateIn = true } }
    }

    func nextStep() { withAnimation { currentStep = min(currentStep + 1, totalSteps - 1) } }
    func prevStep()  { withAnimation { currentStep = max(currentStep - 1, 0) } }
    func finish() {
        profile.onboardingComplete = true
        appState.userProfile = profile
        appState.isOnboarded = true
        appState.loadSampleData()
    }
}

// MARK: - Step 0: Welcome

struct WelcomeStep: View {
    var onNext: () -> Void
    @State private var pulse = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Logo / hero
            ZStack {
                Circle()
                    .fill(Color.accentMint.opacity(0.08))
                    .frame(width: 200, height: 200)
                    .scaleEffect(pulse ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulse)
                Circle()
                    .fill(Color.accentMint.opacity(0.15))
                    .frame(width: 150, height: 150)
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 64, weight: .medium))
                    .foregroundStyle(Color.gradientMint)
            }
            .onAppear { pulse = true }

            Spacer().frame(height: 40)

            Text("APEX")
                .font(.custom("DMSans-Black", size: 48))
                .foregroundStyle(Color.gradientMint)

            Text("Your intelligent training partner")
                .font(.bodyLarge)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.top, 8)

            Spacer().frame(height: 48)

            VStack(alignment: .leading, spacing: 16) {
                FeaturePill(icon: "dumbbell.fill",           text: "AI-personalised workouts",   color: .accentMint)
                FeaturePill(icon: "fork.knife",              text: "Research-backed meal plans",  color: .accentPurple)
                FeaturePill(icon: "chart.line.uptrend.xyaxis", text: "Progressive overload tracking", color: .accentOrange)
                FeaturePill(icon: "waveform.path.ecg",       text: "Injury-aware adaptations",   color: .accentRed)
            }
            .padding(.horizontal, 32)

            Spacer()

            PrimaryButton(title: "Get Started", action: onNext)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
        }
    }
}

struct FeaturePill: View {
    let icon: String, text: String, color: Color
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(text)
                .font(.bodyLarge)
                .foregroundColor(.textPrimary)
        }
    }
}

// MARK: - Step 1: Personal Info

struct PersonalInfoStep: View {
    @Binding var profile: UserProfile
    var onNext: () -> Void
    var onBack: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                StepHeader(step: 1, title: "About You", subtitle: "This helps us personalise your plan")

                VStack(spacing: 16) {
                    // Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name").font(.headlineSmall).foregroundColor(.textSecondary)
                        TextField("Your name", text: $profile.name)
                            .appTextField()
                    }

                    // Age
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Age").font(.headlineSmall).foregroundColor(.textSecondary)
                            Spacer()
                            Text("\(profile.age) yrs").font(.headlineSmall).foregroundColor(.accentMint)
                        }
                        Slider(value: Binding(get: { Double(profile.age) }, set: { profile.age = Int($0) }), in: 16...70, step: 1)
                            .tint(.accentMint)
                    }

                    // Height + Weight
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Height (cm)").font(.headlineSmall).foregroundColor(.textSecondary)
                            TextField("cm", value: $profile.heightCm, format: .number)
                                .appTextField()
                                .keyboardType(.decimalPad)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Weight (kg)").font(.headlineSmall).foregroundColor(.textSecondary)
                            TextField("kg", value: $profile.weightKg, format: .number)
                                .appTextField()
                                .keyboardType(.decimalPad)
                        }
                    }

                    // Gender
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gender").font(.headlineSmall).foregroundColor(.textSecondary)
                        HStack(spacing: 10) {
                            ForEach(UserProfile.Gender.allCases, id: \.self) { g in
                                SelectionChip(title: g.rawValue, isSelected: profile.gender == g) {
                                    profile.gender = g
                                }
                            }
                        }
                    }
                }

                Spacer(minLength: 20)
                StepNavigation(onBack: onBack, onNext: onNext, canProceed: !profile.name.isEmpty)
            }
            .padding(24)
        }
    }
}

// MARK: - Step 2: Goals

struct GoalStep: View {
    @Binding var profile: UserProfile
    var onNext: () -> Void
    var onBack: () -> Void

    var canProceed: Bool { profile.goals.count >= 2 }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                StepHeader(step: 2, title: "Your Goals", subtitle: "Pick at least 2 — we'll balance your plan around them")

                // Selection hint
                HStack(spacing: 6) {
                    ForEach(0..<3) { i in
                        Capsule()
                            .fill(i < profile.goals.count ? Color.accentMint : Color.appCard)
                            .frame(height: 4)
                    }
                    Text(profile.goals.count < 2 ? "Select \(2 - profile.goals.count) more" : "\(profile.goals.count) selected ✓")
                        .font(.caption)
                        .foregroundColor(canProceed ? .accentMint : .textMuted)
                        .animation(.easeInOut, value: profile.goals.count)
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(UserProfile.FitnessGoal.allCases, id: \.self) { goal in
                        GoalCard(goal: goal, isSelected: profile.goals.contains(goal)) {
                            if profile.goals.contains(goal) {
                                profile.goals.removeAll { $0 == goal }
                            } else {
                                profile.goals.append(goal)
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Days per week").font(.headlineSmall).foregroundColor(.textSecondary)
                        Spacer()
                        Text("\(profile.workoutsPerWeek) days").font(.headlineSmall).foregroundColor(.accentMint)
                    }
                    Slider(value: Binding(get: { Double(profile.workoutsPerWeek) }, set: { profile.workoutsPerWeek = Int($0) }), in: 2...6, step: 1)
                        .tint(.accentMint)
                    HStack {
                        Text("2").font(.caption).foregroundColor(.textMuted)
                        Spacer()
                        Text("6").font(.caption).foregroundColor(.textMuted)
                    }
                }

                StepNavigation(onBack: onBack, onNext: onNext, canProceed: canProceed)
            }
            .padding(24)
        }
    }
}

struct GoalCard: View {
    let goal: UserProfile.FitnessGoal
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: goal.icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(isSelected ? Color.gradientMint : LinearGradient(colors: [.textSecondary], startPoint: .top, endPoint: .bottom))
                        .frame(maxWidth: .infinity)

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.accentMint)
                            .font(.system(size: 16))
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                Text(goal.rawValue)
                    .font(.headlineSmall)
                    .foregroundColor(isSelected ? .textPrimary : .textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 8)
            .background(isSelected ? Color.accentMint.opacity(0.12) : Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? Color.accentMint : Color.clear, lineWidth: 1.5)
            )
            .animation(.spring(response: 0.25), value: isSelected)
        }
    }
}

// MARK: - Step 3: Experience + Equipment

struct ExperienceEquipmentStep: View {
    @Binding var profile: UserProfile
    var onNext: () -> Void
    var onBack: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                StepHeader(step: 3, title: "Experience & Kit", subtitle: "We'll match exercises to your level")

                // Experience level
                VStack(alignment: .leading, spacing: 10) {
                    Text("Experience Level").font(.headlineSmall).foregroundColor(.textSecondary)
                    VStack(spacing: 10) {
                        ForEach(UserProfile.ExperienceLevel.allCases, id: \.self) { level in
                            Button {
                                profile.experienceLevel = level
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(level.rawValue).font(.headlineLarge).foregroundColor(.textPrimary)
                                        Text(level.description).font(.bodySmall).foregroundColor(.textSecondary)
                                    }
                                    Spacer()
                                    if profile.experienceLevel == level {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.accentMint)
                                            .font(.title3)
                                    }
                                }
                                .padding(16)
                                .background(profile.experienceLevel == level ? Color.accentMint.opacity(0.1) : Color.appCard)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(profile.experienceLevel == level ? Color.accentMint : Color.clear, lineWidth: 1.5))
                            }
                        }
                    }
                }

                // Equipment
                VStack(alignment: .leading, spacing: 10) {
                    Text("Available Equipment").font(.headlineSmall).foregroundColor(.textSecondary)
                    Text("Select everything available to you").font(.bodySmall).foregroundColor(.textMuted)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(UserProfile.Equipment.allCases, id: \.self) { eq in
                            let isOn = profile.availableEquipment.contains(eq)
                            Button {
                                if isOn { profile.availableEquipment.removeAll { $0 == eq } }
                                else    { profile.availableEquipment.append(eq) }
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: eq.icon)
                                        .font(.caption)
                                        .foregroundColor(isOn ? .accentMint : .textSecondary)
                                    Text(eq.rawValue)
                                        .font(.bodySmall)
                                        .foregroundColor(isOn ? .textPrimary : .textSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .background(isOn ? Color.accentMint.opacity(0.1) : Color.appCard)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(isOn ? Color.accentMint.opacity(0.5) : Color.clear, lineWidth: 1))
                            }
                        }
                    }
                }

                StepNavigation(onBack: onBack, onNext: onNext, canProceed: !profile.availableEquipment.isEmpty)
            }
            .padding(24)
        }
    }
}

// MARK: - Step 4: Injuries

struct InjuriesStep: View {
    @Binding var profile: UserProfile
    var onNext: () -> Void
    var onBack: () -> Void
    @State private var showingAddInjury = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                StepHeader(step: 4, title: "Injuries & Limits", subtitle: "We'll adapt every workout to keep you safe")

                if profile.injuries.isEmpty {
                    AppCard {
                        VStack(spacing: 12) {
                            Image(systemName: "waveform.path.ecg")
                                .font(.system(size: 36))
                                .foregroundColor(.textMuted)
                            Text("No injuries added")
                                .font(.bodyLarge).foregroundColor(.textSecondary)
                            Text("If you have any injuries or pain, add them here so APEX can avoid aggravating them")
                                .font(.bodySmall).foregroundColor(.textMuted).multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                } else {
                    VStack(spacing: 10) {
                        ForEach(profile.injuries) { injury in
                            InjuryRow(injury: injury) {
                                profile.injuries.removeAll { $0.id == injury.id }
                            }
                        }
                    }
                }

                Button {
                    showingAddInjury = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add injury / limitation")
                    }
                    .font(.headlineSmall)
                    .foregroundColor(.accentMint)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Color.accentMint.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                AppCard {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundColor(.accentMint)
                            .font(.title2)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("You can skip this").font(.headlineSmall).foregroundColor(.textPrimary)
                            Text("Add injuries anytime from the Settings screen. APEX will always adapt your plan.").font(.bodySmall).foregroundColor(.textSecondary)
                        }
                    }
                }

                StepNavigation(onBack: onBack, onNext: onNext, canProceed: true, nextTitle: "Continue")
            }
            .padding(24)
        }
        .sheet(isPresented: $showingAddInjury) {
            AddInjurySheet { injury in
                profile.injuries.append(injury)
            }
        }
    }
}

struct InjuryRow: View {
    let injury: Injury
    let onDelete: () -> Void
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(injury.bodyPart.rawValue).font(.headlineSmall).foregroundColor(.textPrimary)
                TagBadge(text: injury.severity.rawValue, color: injury.severity.color)
            }
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.textMuted)
                    .font(.title3)
            }
        }
        .padding(14)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct AddInjurySheet: View {
    var onAdd: (Injury) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var bodyPart: Injury.BodyPart = .shoulder
    @State private var severity: Injury.Severity = .mild
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Body Part").font(.headlineSmall).foregroundColor(.textSecondary)
                        Picker("Body Part", selection: $bodyPart) {
                            ForEach(Injury.BodyPart.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 120)
                        .clipped()
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Severity").font(.headlineSmall).foregroundColor(.textSecondary)
                        HStack(spacing: 10) {
                            ForEach(Injury.Severity.allCases, id: \.self) { s in
                                SelectionChip(title: s.rawValue, isSelected: severity == s, color: s.color) { severity = s }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (optional)").font(.headlineSmall).foregroundColor(.textSecondary)
                        TextField("e.g. pain when lifting overhead", text: $notes)
                            .appTextField()
                    }

                    PrimaryButton(title: "Add Injury") {
                        onAdd(Injury(bodyPart: bodyPart, severity: severity, notes: notes))
                        dismiss()
                    }
                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("Add Injury")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }.foregroundColor(.textSecondary)
                }
            }
        }
    }
}

// MARK: - Step 5: Dietary

struct DietaryStep: View {
    @Binding var profile: UserProfile
    var onFinish: () -> Void
    var onBack: () -> Void
    @State private var isGenerating = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                StepHeader(step: 5, title: "Nutrition Preferences", subtitle: "Your meal plan will respect these")

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(UserProfile.DietaryPreference.allCases, id: \.self) { pref in
                        SelectionChip(title: pref.rawValue, isSelected: profile.dietaryPreference == pref, fullWidth: true) {
                            profile.dietaryPreference = pref
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Daily Calorie Target").font(.headlineSmall).foregroundColor(.textSecondary)
                        Spacer()
                        Text("\(profile.dailyCalorieTarget) kcal").font(.headlineSmall).foregroundColor(.accentOrange)
                    }
                    Slider(value: Binding(get: { Double(profile.dailyCalorieTarget) }, set: { profile.dailyCalorieTarget = Int($0) }), in: 1500...4000, step: 50)
                        .tint(.accentOrange)
                    Text("Tip: APEX calculates your TDEE automatically — this is your starting point").font(.caption).foregroundColor(.textMuted)
                }

                Spacer(minLength: 16)

                PrimaryButton(title: isGenerating ? "Building your plan…" : "Build My Plan 🚀", isLoading: isGenerating) {
                    isGenerating = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        isGenerating = false
                        onFinish()
                    }
                }

                Button(action: onBack) {
                    Text("Back")
                        .font(.headlineSmall)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                }
            }
            .padding(24)
        }
    }
}

// MARK: - Shared Components

struct StepHeader: View {
    let step: Int, title: String, subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Step \(step) of 5").font(.label).foregroundColor(.accentMint).tracking(1)
            Text(title).font(.displayMedium).foregroundColor(.textPrimary)
            Text(subtitle).font(.bodyLarge).foregroundColor(.textSecondary)
        }
    }
}

struct StepNavigation: View {
    var onBack: () -> Void
    var onNext: () -> Void
    var canProceed: Bool = true
    var nextTitle: String = "Continue"

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundColor(.textSecondary)
                    .frame(width: 54, height: 54)
                    .background(Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            PrimaryButton(title: nextTitle, action: onNext)
                .opacity(canProceed ? 1 : 0.4)
                .disabled(!canProceed)
        }
    }
}

struct SelectionChip: View {
    let title: String
    let isSelected: Bool
    var color: Color = .accentMint
    var fullWidth: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headlineSmall)
                .foregroundColor(isSelected ? color : .textSecondary)
                .frame(maxWidth: fullWidth ? .infinity : nil)
                .padding(.horizontal, fullWidth ? 16 : 18)
                .padding(.vertical, 10)
                .background(isSelected ? color.opacity(0.12) : Color.appCard)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(isSelected ? color.opacity(0.6) : Color.clear, lineWidth: 1.5))
        }
    }
}
