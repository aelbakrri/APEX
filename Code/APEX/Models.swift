import Foundation
import SwiftUI
import Combine

// MARK: - User Profile

struct UserProfile: Codable, Identifiable {
    var id = UUID()
    var name: String = ""
    var age: Int = 25
    var heightCm: Double = 175
    var weightKg: Double = 75
    var gender: Gender = .male
    var goals: [FitnessGoal] = []
    var experienceLevel: ExperienceLevel = .intermediate
    var workoutsPerWeek: Int = 4
    var availableEquipment: [Equipment] = Equipment.allCases
    var injuries: [Injury] = []
    var dietaryPreference: DietaryPreference = .none
    var dailyCalorieTarget: Int = 2500
    var onboardingComplete: Bool = false

    enum Gender: String, Codable, CaseIterable {
        case male = "Male", female = "Female", other = "Other"
    }

    enum FitnessGoal: String, Codable, CaseIterable {
        case buildMuscle    = "Build Muscle"
        case loseFat        = "Lose Fat"
        case recomposition  = "Body Recomposition"
        case strength       = "Increase Strength"
        case endurance      = "Improve Endurance"
        case maintenance    = "Maintenance"
        var icon: String {
            switch self {
            case .buildMuscle:   return "figure.strengthtraining.traditional"
            case .loseFat:       return "flame.fill"
            case .recomposition: return "arrow.triangle.2.circlepath"
            case .strength:      return "dumbbell.fill"
            case .endurance:     return "figure.run"
            case .maintenance:   return "checkmark.circle.fill"
            }
        }
    }

    enum ExperienceLevel: String, Codable, CaseIterable {
        case beginner     = "Beginner"
        case intermediate = "Intermediate"
        case advanced     = "Advanced"
        var description: String {
            switch self {
            case .beginner:     return "< 1 year training"
            case .intermediate: return "1–3 years training"
            case .advanced:     return "3+ years training"
            }
        }
    }

    enum Equipment: String, Codable, CaseIterable {
        case barbell       = "Barbell"
        case dumbbell      = "Dumbbells"
        case cables        = "Cable Machine"
        case machines      = "Machines"
        case pullupBar     = "Pull-up Bar"
        case resistanceBand = "Resistance Bands"
        case kettlebell    = "Kettlebell"
        case bodyweight    = "Bodyweight Only"
        var icon: String {
            switch self {
            case .barbell:       return "dumbbell.fill"
            case .dumbbell:      return "dumbbell.fill"
            case .cables:        return "cable.connector"
            case .machines:      return "gearshape.fill"
            case .pullupBar:     return "figure.pull.ups"
            case .resistanceBand: return "circle.dotted"
            case .kettlebell:    return "dumbbell"
            case .bodyweight:    return "figure.strengthtraining.functional"
            }
        }
    }

    enum DietaryPreference: String, Codable, CaseIterable {
        case none        = "No Preference"
        case vegetarian  = "Vegetarian"
        case vegan       = "Vegan"
        case glutenFree  = "Gluten-Free"
        case dairyFree   = "Dairy-Free"
        case keto        = "Keto"
        case halal       = "Halal"
    }
}

// MARK: - Injury

struct Injury: Codable, Identifiable, Hashable {
    var id = UUID()
    var bodyPart: BodyPart
    var severity: Severity
    var notes: String = ""

    enum BodyPart: String, Codable, CaseIterable {
        case shoulder = "Shoulder", knee = "Knee", back = "Lower Back",
             upperBack = "Upper Back", hip = "Hip", elbow = "Elbow",
             wrist = "Wrist", ankle = "Ankle", neck = "Neck"
        var icon: String {
            switch self {
            case .shoulder: return "figure.walk"
            case .knee: return "figure.walk.circle"
            case .back, .upperBack: return "figure.walk.arrival"
            default: return "figure.walk"
            }
        }
        // Which exercise tags to avoid per body part
        var avoidTags: [String] {
            switch self {
            case .shoulder:  return ["overhead press", "upright row", "dips", "behind neck"]
            case .knee:      return ["deep squat", "leg press heavy", "lunge"]
            case .back:      return ["deadlift heavy", "good morning", "hyperextension"]
            case .upperBack: return ["barbell row", "pull-up heavy"]
            case .elbow:     return ["tricep extension", "curl supinated"]
            case .wrist:     return ["wrist curl", "barbell curl"]
            case .hip:       return ["squat deep", "hip flexor"]
            case .ankle:     return ["calf raise heavy", "jump"]
            case .neck:      return ["behind neck press", "neck extension"]
            }
        }
    }

    enum Severity: String, Codable, CaseIterable {
        case mild     = "Mild"
        case moderate = "Moderate"
        case severe   = "Severe"
        var color: Color {
            switch self {
            case .mild:     return .accentOrange
            case .moderate: return Color(hex: "#F59E0B")
            case .severe:   return .accentRed
            }
        }
    }
}

// MARK: - Exercise

struct Exercise: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var muscleGroups: [MuscleGroup]
    var equipment: [UserProfile.Equipment]
    var tags: [String]
    var sets: Int
    var reps: String          // e.g. "8-12" or "AMRAP"
    var restSeconds: Int
    var notes: String = ""
    var videoURL: String = "" // placeholder for demo video link
    var isInjuryAdapted: Bool = false

    enum MuscleGroup: String, Codable, CaseIterable {
        case chest = "Chest", back = "Back", shoulders = "Shoulders",
             biceps = "Biceps", triceps = "Triceps", forearms = "Forearms",
             quads = "Quads", hamstrings = "Hamstrings", glutes = "Glutes",
             calves = "Calves", core = "Core", fullBody = "Full Body"
        var color: Color {
            switch self {
            case .chest, .back:    return .accentMint
            case .shoulders, .biceps, .triceps: return .accentPurple
            case .quads, .hamstrings, .glutes:  return .accentOrange
            default: return .textSecondary
            }
        }
    }
}

// MARK: - Workout Log

struct WorkoutSet: Codable, Identifiable {
    var id = UUID()
    var setNumber: Int
    var targetReps: String
    var completedReps: Int?
    var weightKg: Double?
    var isCompleted: Bool = false
    var rpe: Int?  // Rate of Perceived Exertion 1-10
    var notes: String = ""
}

struct ExerciseLog: Codable, Identifiable {
    var id = UUID()
    var exerciseId: UUID
    var exerciseName: String
    var sets: [WorkoutSet]
    var previousBest: WorkoutSet?  // for progressive overload comparison
}

struct WorkoutSession: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var workoutPlanId: UUID
    var workoutName: String
    var exercises: [ExerciseLog]
    var durationSeconds: Int = 0
    var notes: String = ""
    var isCompleted: Bool = false

    var totalVolume: Double {
        exercises.flatMap(\.sets).compactMap { set in
            guard let reps = set.completedReps, let weight = set.weightKg else { return nil as Double? }
            return Double(reps) * weight
        }.reduce(0, +)
    }
}

// MARK: - Workout Plan

struct WorkoutDay: Codable, Identifiable {
    var id = UUID()
    var dayName: String
    var focusAreas: [Exercise.MuscleGroup]
    var exercises: [Exercise]
    var estimatedMinutes: Int
    var isRestDay: Bool = false
    var weekday: Int  // 1 = Monday
}

struct WorkoutPlan: Codable, Identifiable {
    var id = UUID()
    var name: String
    var goal: UserProfile.FitnessGoal
    var daysPerWeek: Int
    var days: [WorkoutDay]
    var createdAt: Date = Date()
    var researchSource: String = ""
    var notes: String = ""
}

// MARK: - Meal Plan

struct Meal: Codable, Identifiable {
    var id = UUID()
    var name: String
    var mealTime: MealTime
    var calories: Int
    var proteinG: Double
    var carbsG: Double
    var fatG: Double
    var ingredients: [String]
    var prepMinutes: Int
    var instructions: String

    enum MealTime: String, Codable, CaseIterable {
        case breakfast = "Breakfast"
        case morningSnack = "Morning Snack"
        case lunch = "Lunch"
        case afternoonSnack = "Afternoon Snack"
        case dinner = "Dinner"
        case preworkout = "Pre-Workout"
        case postworkout = "Post-Workout"
        var icon: String {
            switch self {
            case .breakfast: return "sun.rise.fill"
            case .morningSnack: return "leaf.fill"
            case .lunch: return "sun.max.fill"
            case .afternoonSnack: return "carrot.fill"
            case .dinner: return "moon.fill"
            case .preworkout: return "bolt.fill"
            case .postworkout: return "arrow.up.heart.fill"
            }
        }
    }
}

struct DayMealPlan: Codable, Identifiable {
    var id = UUID()
    var dayName: String
    var meals: [Meal]
    var totalCalories: Int { meals.reduce(0) { $0 + $1.calories } }
    var totalProtein: Double { meals.reduce(0) { $0 + $1.proteinG } }
    var totalCarbs: Double { meals.reduce(0) { $0 + $1.carbsG } }
    var totalFat: Double { meals.reduce(0) { $0 + $1.fatG } }
}

struct MealPlan: Codable, Identifiable {
    var id = UUID()
    var name: String
    var targetCalories: Int
    var targetProteinG: Double
    var days: [DayMealPlan]
    var createdAt: Date = Date()
    var researchSource: String = ""
}

// MARK: - Progress Tracking

struct BodyMeasurement: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var weightKg: Double?
    var bodyFatPercent: Double?
    var bicepCm: Double?
    var chestCm: Double?
    var waistCm: Double?
    var hipCm: Double?
    var thighCm: Double?
    var calfCm: Double?
    var neckCm: Double?
    var photoPath: String?   // local file path for progress photo
    var mood: Int?           // 1-5
    var energyLevel: Int?    // 1-5
    var notes: String = ""
}

// MARK: - Training Rules

struct TrainingRule: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var category: Category
    var icon: String
    var researchBacking: String

    enum Category: String, CaseIterable {
        case recovery   = "Recovery"
        case nutrition  = "Nutrition"
        case technique  = "Technique"
        case progressive = "Progressive Overload"
        case mindset    = "Mindset"
        var color: Color {
            switch self {
            case .recovery:   return .accentMint
            case .nutrition:  return .accentOrange
            case .technique:  return .accentPurple
            case .progressive: return Color(hex: "#06B6D4")
            case .mindset:    return Color(hex: "#EC4899")
            }
        }
    }
}

// MARK: - AI Conversation

struct AIMessage: Identifiable, Codable {
    var id = UUID()
    var role: Role
    var content: String
    var timestamp: Date = Date()

    enum Role: String, Codable { case user, assistant }
}

// MARK: - App State

class AppState: ObservableObject {
    @Published var userProfile: UserProfile = UserProfile()
    @Published var workoutPlan: WorkoutPlan? = nil
    @Published var mealPlan: MealPlan? = nil
    @Published var workoutSessions: [WorkoutSession] = []
    @Published var measurements: [BodyMeasurement] = []
    @Published var aiMessages: [AIMessage] = []
    @Published var currentTab: Tab = .home
    @Published var isOnboarded: Bool = false

    enum Tab: Int, CaseIterable {
        case home, workout, nutrition, progress, rules
        var title: String {
            switch self {
            case .home:      return "Home"
            case .workout:   return "Train"
            case .nutrition: return "Meals"
            case .progress:  return "Progress"
            case .rules:     return "Rules"
            }
        }
        var icon: String {
            switch self {
            case .home:      return "house.fill"
            case .workout:   return "dumbbell.fill"
            case .nutrition: return "fork.knife"
            case .progress:  return "chart.line.uptrend.xyaxis"
            case .rules:     return "list.bullet.clipboard.fill"
            }
        }
    }

    // Sample data generator
    func loadSampleData() {
        workoutPlan = SampleData.workoutPlan
        mealPlan = SampleData.mealPlan
        measurements = SampleData.measurements
    }
}
