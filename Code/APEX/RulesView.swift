import SwiftUI

struct RulesView: View {
    @State private var selectedCategory: TrainingRule.Category? = nil
    @State private var selectedRule: TrainingRule? = nil

    var filtered: [TrainingRule] {
        guard let cat = selectedCategory else { return TrainingRules.all }
        return TrainingRules.all.filter { $0.category == cat }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Intro
                    AppCard {
                        HStack(spacing: 14) {
                            Image(systemName: "book.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.gradientMint)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Training Principles").font(.headlineLarge).foregroundColor(.textPrimary)
                                Text("Research-backed rules every athlete should know. Tap any rule to read the science.")
                                    .font(.bodySmall).foregroundColor(.textSecondary)
                            }
                        }
                    }

                    // Category filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            FilterChip(title: "All", isSelected: selectedCategory == nil, color: .accentMint) {
                                selectedCategory = nil
                            }
                            ForEach(TrainingRule.Category.allCases, id: \.self) { cat in
                                FilterChip(title: cat.rawValue, isSelected: selectedCategory == cat, color: cat.color) {
                                    selectedCategory = selectedCategory == cat ? nil : cat
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, -20)

                    // Rules
                    VStack(spacing: 12) {
                        ForEach(filtered) { rule in
                            RuleCard(rule: rule) { selectedRule = rule }
                        }
                    }

                    // Sources
                    AppCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Key References").font(.headlineSmall).foregroundColor(.textSecondary)
                            ForEach(TrainingRules.references, id: \.self) { ref in
                                HStack(spacing: 8) {
                                    Circle().fill(Color.textMuted.opacity(0.5)).frame(width: 5, height: 5)
                                    Text(ref).font(.caption).foregroundColor(.textMuted)
                                }
                            }
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding(20)
            }
            .appScreen()
            .navigationTitle("Rules")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
        }
        .sheet(item: $selectedRule) { rule in
            RuleDetailSheet(rule: rule)
        }
    }
}

struct FilterChip: View {
    let title: String, isSelected: Bool, color: Color
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.headlineSmall)
                .foregroundColor(isSelected ? .black : .textSecondary)
                .padding(.horizontal, 16).padding(.vertical, 8)
                .background(isSelected ? color : Color.appCard)
                .clipShape(Capsule())
        }
    }
}

struct RuleCard: View {
    let rule: TrainingRule
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            AppCard {
                HStack(spacing: 14) {
                    Image(systemName: rule.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(rule.category.color)
                        .frame(width: 48, height: 48)
                        .background(rule.category.color.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(rule.title).font(.headlineLarge).foregroundColor(.textPrimary)
                            Spacer()
                            TagBadge(text: rule.category.rawValue, color: rule.category.color)
                        }
                        Text(rule.description)
                            .font(.bodySmall).foregroundColor(.textSecondary)
                            .lineLimit(2)
                    }
                }
            }
        }
    }
}

struct RuleDetailSheet: View {
    let rule: TrainingRule
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Icon + category
                        HStack(spacing: 14) {
                            Image(systemName: rule.icon)
                                .font(.system(size: 36, weight: .semibold))
                                .foregroundColor(rule.category.color)
                                .frame(width: 72, height: 72)
                                .background(rule.category.color.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            VStack(alignment: .leading, spacing: 6) {
                                TagBadge(text: rule.category.rawValue, color: rule.category.color)
                                Text(rule.title).font(.displaySmall).foregroundColor(.textPrimary)
                            }
                        }

                        // Description
                        Text(rule.description)
                            .font(.bodyLarge).foregroundColor(.textPrimary)

                        // Research backing
                        AppCard {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "doc.text.magnifyingglass")
                                        .foregroundColor(.accentPurple)
                                    Text("Research Backing").font(.headlineLarge).foregroundColor(.textPrimary)
                                }
                                Text(rule.researchBacking)
                                    .font(.bodySmall).foregroundColor(.textSecondary)
                            }
                        }

                        Spacer(minLength: 30)
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Rule Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundColor(.accentMint)
                }
            }
        }
    }
}

// MARK: - Training Rules Data

struct TrainingRules {
    static let all: [TrainingRule] = [
        TrainingRule(
            title: "Progressive Overload",
            description: "To build muscle or strength, you must consistently increase the demands placed on your muscles over time — more weight, more reps, or shorter rest.",
            category: .progressive,
            icon: "arrow.up.forward",
            researchBacking: "Schoenfeld (2010) demonstrated that progressive overload is the primary stimulus for skeletal muscle hypertrophy. Even small weekly increases of 2.5 kg compound dramatically over months."
        ),
        TrainingRule(
            title: "The 48-Hour Recovery Rule",
            description: "Allow at least 48 hours before training the same muscle group again. Muscle protein synthesis peaks 24–36 hours post-exercise and needs time to complete.",
            category: .recovery,
            icon: "clock.arrow.circlepath",
            researchBacking: "Phillips et al. (1997) showed MPS remains elevated for 24–48h after resistance exercise. Training too soon interrupts this anabolic window."
        ),
        TrainingRule(
            title: "Protein: 1.6–2.2g/kg/day",
            description: "For muscle building, aim for 1.6–2.2g of protein per kg of bodyweight daily. Distribute across 3–5 meals for optimal muscle protein synthesis.",
            category: .nutrition,
            icon: "fork.knife",
            researchBacking: "Morton et al. (2018) meta-analysis of 49 studies: protein supplementation beyond 1.62 g/kg/day produced no further increases in lean mass. Current ISSN position: 1.4–2.0 g/kg for exercising adults."
        ),
        TrainingRule(
            title: "Sleep: 7–9 Hours",
            description: "Growth hormone is primarily released during deep sleep. Cutting sleep even to 6 hours reduces testosterone by up to 15% and impairs recovery.",
            category: .recovery,
            icon: "bed.double.fill",
            researchBacking: "Leproult & Van Cauter (2011): one week of sleep restriction to 5h/night reduced testosterone by 10–15%. Walker (2017): deep sleep stages are when 95% of GH pulses occur."
        ),
        TrainingRule(
            title: "Mind-Muscle Connection",
            description: "Focusing on the working muscle during exercise increases its activation. Attentional focus (internal vs. external) changes muscle recruitment patterns.",
            category: .technique,
            icon: "brain.head.profile",
            researchBacking: "Calatayud et al. (2016): internal focus instruction during bench press increased pec activation by 22% compared to external focus. Schoenfeld & Contreras (2016) review confirmed this effect."
        ),
        TrainingRule(
            title: "Compound Movements First",
            description: "Perform multi-joint exercises (squats, deadlifts, bench, rows) before isolation movements. You'll have maximum energy and neural drive for the exercises that matter most.",
            category: .technique,
            icon: "figure.strengthtraining.traditional",
            researchBacking: "Simão et al. (2012) RCT: performing compound exercises before isolation produced greater strength and hypertrophy gains across 12 weeks compared to reversed order."
        ),
        TrainingRule(
            title: "Caloric Surplus for Muscle",
            description: "You cannot maximally build muscle in a deficit. A modest surplus of 200–500 kcal/day is the sweet spot — aggressive bulking adds fat without additional muscle.",
            category: .nutrition,
            icon: "flame.fill",
            researchBacking: "Hall et al. (2012) showed diminishing returns beyond 500 kcal surplus. Barakat et al. (2020) recommends a 350–500 kcal surplus, gaining 0.25–0.5% bodyweight/week."
        ),
        TrainingRule(
            title: "Consistency Beats Perfection",
            description: "Showing up 80% of the time for a year beats the 'perfect' program you follow for 4 weeks. Missing one workout is irrelevant; missing weeks is not.",
            category: .mindset,
            icon: "checkmark.seal.fill",
            researchBacking: "Adherence research consistently shows compliance is the #1 predictor of outcome. A study by Dishman et al. (2009) found habit formation through consistency is the strongest predictor of long-term training."
        ),
        TrainingRule(
            title: "Deload Every 4–8 Weeks",
            description: "Planned deload weeks (50–60% of normal volume/intensity) prevent overtraining, reduce injury risk, and supercompensate performance when you return to full training.",
            category: .recovery,
            icon: "arrow.down.to.line",
            researchBacking: "Meeusen et al. (2013) European College consensus: systematic deloads prevent non-functional overreaching. Performance gains are often realised the week after a deload."
        ),
        TrainingRule(
            title: "Train Injured Areas Carefully",
            description: "Complete rest rarely heals injuries. Light, pain-free movement maintains blood flow and prevents atrophy. Modify, don't stop.",
            category: .technique,
            icon: "waveform.path.ecg",
            researchBacking: "Rees et al. (2009) showed controlled movement during rehabilitation preserves muscle mass and accelerates tendon healing. Always work within a pain-free range."
        )
    ]

    static let references: [String] = [
        "Schoenfeld BJ (2010). The Mechanisms of Muscle Hypertrophy. J Strength Cond Res.",
        "Morton et al. (2018). A systematic review, meta-analysis of protein supplementation. Br J Sports Med.",
        "Phillips SM et al. (1997). Mixed muscle protein synthesis after resistance exercise. Am J Physiol.",
        "Walker M (2017). Why We Sleep. Penguin Press.",
        "ISSN Position Stand: Protein and Exercise (2017). J Int Soc Sports Nutr."
    ]
}
