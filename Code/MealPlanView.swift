import SwiftUI

struct MealPlanView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedDayIndex = 0

    var today: DayMealPlan? {
        appState.mealPlan?.days[safe: selectedDayIndex]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let plan = appState.mealPlan {

                        // Macro summary for today
                        if let day = today {
                            MacroSummaryCard(day: day, target: plan.targetCalories)
                        }

                        // Day selector
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(plan.days.indices, id: \.self) { i in
                                    Button {
                                        withAnimation { selectedDayIndex = i }
                                    } label: {
                                        Text(plan.days[i].dayName)
                                            .font(.headlineSmall)
                                            .foregroundColor(i == selectedDayIndex ? .black : .textSecondary)
                                            .padding(.horizontal, 16).padding(.vertical, 8)
                                            .background(i == selectedDayIndex ? Color.accentMint : Color.appCard)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.horizontal, -20)

                        // Meals for selected day
                        if let day = today {
                            VStack(spacing: 14) {
                                ForEach(day.meals) { meal in
                                    MealCard(meal: meal)
                                }
                            }
                        }

                        // Research note
                        AppCard {
                            HStack(spacing: 12) {
                                Image(systemName: "flask.fill")
                                    .foregroundColor(.accentOrange).font(.title3)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Nutrition Science").font(.headlineSmall).foregroundColor(.textPrimary)
                                    Text("Protein targets based on Morton et al. (2018): 1.62g/kg/day optimal for hypertrophy. Meal timing from Aragon & Schoenfeld (2013).")
                                        .font(.bodySmall).foregroundColor(.textSecondary)
                                }
                            }
                        }

                    } else {
                        EmptyMealPlanState()
                    }
                }
                .padding(20)
            }
            .appScreen()
            .navigationTitle("Meals")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
        }
    }
}

// MARK: - Macro Summary Card

struct MacroSummaryCard: View {
    let day: DayMealPlan
    let target: Int

    var caloriePercent: Double { Double(day.totalCalories) / Double(target) }

    var body: some View {
        AppCard {
            VStack(spacing: 16) {
                HStack {
                    Text("Today's Nutrition").font(.headlineLarge).foregroundColor(.textPrimary)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(day.totalCalories)").font(.displaySmall).foregroundStyle(Color.gradientOrange)
                        Text("/ \(target) kcal").font(.caption).foregroundColor(.textSecondary)
                    }
                }

                // Calorie bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.appCardElevated).frame(height: 8)
                        Capsule()
                            .fill(Color.gradientOrange)
                            .frame(width: min(geo.size.width * caloriePercent, geo.size.width), height: 8)
                            .animation(.easeInOut(duration: 0.5), value: caloriePercent)
                    }
                }
                .frame(height: 8)

                // Macro breakdown
                HStack(spacing: 0) {
                    MacroPill(label: "Protein", value: String(format: "%.0fg", day.totalProtein), color: .accentMint)
                    Divider().frame(height: 30).background(Color.textMuted.opacity(0.3))
                    MacroPill(label: "Carbs", value: String(format: "%.0fg", day.totalCarbs), color: .accentPurple)
                    Divider().frame(height: 30).background(Color.textMuted.opacity(0.3))
                    MacroPill(label: "Fat", value: String(format: "%.0fg", day.totalFat), color: .accentOrange)
                }
            }
        }
    }
}

struct MacroPill: View {
    let label: String, value: String, color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.headlineLarge).foregroundColor(color)
            Text(label).font(.caption).foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Meal Card

struct MealCard: View {
    let meal: Meal
    @State private var isExpanded = false

    var body: some View {
        AppCard(padding: 0) {
            VStack(spacing: 0) {
                Button {
                    withAnimation(.spring(response: 0.35)) { isExpanded.toggle() }
                } label: {
                    HStack(spacing: 14) {
                        // Meal time icon
                        Image(systemName: meal.mealTime.icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.accentOrange)
                            .frame(width: 44, height: 44)
                            .background(Color.accentOrange.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(meal.mealTime.rawValue)
                                .font(.caption).foregroundColor(.textSecondary).tracking(1)
                            Text(meal.name)
                                .font(.headlineLarge).foregroundColor(.textPrimary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text("\(meal.calories) kcal")
                                .font(.headlineSmall).foregroundColor(.accentOrange)
                            Text("\(meal.prepMinutes) min")
                                .font(.caption).foregroundColor(.textMuted)
                        }

                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption.bold()).foregroundColor(.textMuted)
                    }
                    .padding(16)
                }

                if isExpanded {
                    VStack(alignment: .leading, spacing: 16) {
                        Divider().background(Color.textMuted.opacity(0.3))

                        // Macros
                        HStack(spacing: 0) {
                            MacroPill(label: "Protein", value: String(format: "%.0fg", meal.proteinG), color: .accentMint)
                            MacroPill(label: "Carbs", value: String(format: "%.0fg", meal.carbsG), color: .accentPurple)
                            MacroPill(label: "Fat", value: String(format: "%.0fg", meal.fatG), color: .accentOrange)
                        }
                        .padding(.horizontal, 16)

                        // Ingredients
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients").font(.headlineSmall).foregroundColor(.textSecondary)
                            ForEach(meal.ingredients, id: \.self) { ingredient in
                                HStack(spacing: 8) {
                                    Circle().fill(Color.accentMint.opacity(0.5)).frame(width: 6, height: 6)
                                    Text(ingredient).font(.bodySmall).foregroundColor(.textPrimary)
                                }
                            }
                        }
                        .padding(.horizontal, 16)

                        // Instructions
                        if !meal.instructions.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("How to Prepare").font(.headlineSmall).foregroundColor(.textSecondary)
                                Text(meal.instructions).font(.bodySmall).foregroundColor(.textPrimary)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
        }
    }
}

struct EmptyMealPlanState: View {
    var body: some View {
        AppCard {
            VStack(spacing: 16) {
                Image(systemName: "fork.knife").font(.system(size: 48)).foregroundColor(.textMuted)
                Text("No Meal Plan").font(.displaySmall).foregroundColor(.textPrimary)
                Text("Complete onboarding to generate your personalised meal plan")
                    .font(.bodyLarge).foregroundColor(.textSecondary).multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity).padding(.vertical, 20)
        }
    }
}

// MARK: - Array safe subscript

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
