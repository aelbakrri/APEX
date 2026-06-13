import Foundation

// MARK: - Sample Data for preview and first-launch

struct SampleData {

    // MARK: Workout Plan
    static var workoutPlan: WorkoutPlan {
        WorkoutPlan(
            name: "Upper/Lower Split — Hypertrophy",
            goal: .buildMuscle,
            daysPerWeek: 4,
            days: [
                WorkoutDay(
                    dayName: "Upper A — Push Focus",
                    focusAreas: [.chest, .shoulders, .triceps],
                    exercises: [
                        Exercise(name: "Barbell Bench Press",       muscleGroups: [.chest, .triceps], equipment: [.barbell], tags: ["compound", "horizontal push"], sets: 4, reps: "6-10",  restSeconds: 120),
                        Exercise(name: "Incline Dumbbell Press",    muscleGroups: [.chest, .shoulders], equipment: [.dumbbell], tags: ["compound", "upper chest"], sets: 3, reps: "10-12", restSeconds: 90),
                        Exercise(name: "Seated DB Overhead Press",  muscleGroups: [.shoulders], equipment: [.dumbbell], tags: ["overhead press", "compound"], sets: 3, reps: "10-12", restSeconds: 90),
                        Exercise(name: "Cable Lateral Raise",       muscleGroups: [.shoulders], equipment: [.cables], tags: ["isolation", "lateral delt"], sets: 3, reps: "15-20", restSeconds: 60),
                        Exercise(name: "Tricep Pushdown (Cable)",   muscleGroups: [.triceps], equipment: [.cables], tags: ["isolation", "tricep extension"], sets: 3, reps: "12-15", restSeconds: 60),
                        Exercise(name: "Overhead Tricep Extension", muscleGroups: [.triceps], equipment: [.cables, .dumbbell], tags: ["isolation", "long head"], sets: 3, reps: "12-15", restSeconds: 60)
                    ],
                    estimatedMinutes: 60,
                    weekday: 1
                ),
                WorkoutDay(
                    dayName: "Lower A — Quad Focus",
                    focusAreas: [.quads, .glutes, .core],
                    exercises: [
                        Exercise(name: "Back Squat",          muscleGroups: [.quads, .glutes], equipment: [.barbell], tags: ["compound", "deep squat"], sets: 4, reps: "6-8",   restSeconds: 180),
                        Exercise(name: "Leg Press",           muscleGroups: [.quads, .glutes], equipment: [.machines], tags: ["compound", "leg press heavy"], sets: 3, reps: "10-12", restSeconds: 120),
                        Exercise(name: "Walking Lunges",      muscleGroups: [.quads, .glutes, .hamstrings], equipment: [.dumbbell], tags: ["lunge", "unilateral"], sets: 3, reps: "12/leg", restSeconds: 90),
                        Exercise(name: "Leg Extension",       muscleGroups: [.quads], equipment: [.machines], tags: ["isolation", "terminal extension"], sets: 3, reps: "15-20", restSeconds: 60),
                        Exercise(name: "Standing Calf Raise", muscleGroups: [.calves], equipment: [.machines], tags: ["calf raise heavy", "isolation"], sets: 4, reps: "15-20", restSeconds: 60),
                        Exercise(name: "Plank Hold",          muscleGroups: [.core], equipment: [.bodyweight], tags: ["core", "isometric"], sets: 3, reps: "45s", restSeconds: 60)
                    ],
                    estimatedMinutes: 65,
                    weekday: 2
                ),
                WorkoutDay(
                    dayName: "Rest Day",
                    focusAreas: [],
                    exercises: [],
                    estimatedMinutes: 0,
                    isRestDay: true,
                    weekday: 3
                ),
                WorkoutDay(
                    dayName: "Upper B — Pull Focus",
                    focusAreas: [.back, .biceps],
                    exercises: [
                        Exercise(name: "Weighted Pull-Up",       muscleGroups: [.back, .biceps], equipment: [.pullupBar], tags: ["compound", "vertical pull"], sets: 4, reps: "6-10", restSeconds: 120),
                        Exercise(name: "Barbell Row",            muscleGroups: [.back, .biceps], equipment: [.barbell], tags: ["barbell row", "compound"], sets: 4, reps: "8-10", restSeconds: 120),
                        Exercise(name: "Cable Face Pull",        muscleGroups: [.shoulders, .back], equipment: [.cables], tags: ["rear delt", "rotator cuff", "shoulder health"], sets: 3, reps: "15-20", restSeconds: 60,
                                 notes: "Great for shoulder health — always include this!", isInjuryAdapted: false),
                        Exercise(name: "Dumbbell Bicep Curl",    muscleGroups: [.biceps], equipment: [.dumbbell], tags: ["isolation", "curl supinated"], sets: 3, reps: "10-12", restSeconds: 60),
                        Exercise(name: "Hammer Curl",            muscleGroups: [.biceps, .forearms], equipment: [.dumbbell], tags: ["isolation", "brachialis"], sets: 3, reps: "12-15", restSeconds: 60),
                        Exercise(name: "Rear Delt Fly",          muscleGroups: [.shoulders], equipment: [.dumbbell], tags: ["isolation", "rear delt"], sets: 3, reps: "15-20", restSeconds: 60)
                    ],
                    estimatedMinutes: 60,
                    weekday: 4
                ),
                WorkoutDay(
                    dayName: "Lower B — Posterior Chain",
                    focusAreas: [.hamstrings, .glutes],
                    exercises: [
                        Exercise(name: "Romanian Deadlift",      muscleGroups: [.hamstrings, .glutes, .back], equipment: [.barbell], tags: ["compound", "hip hinge"], sets: 4, reps: "8-10", restSeconds: 150),
                        Exercise(name: "Leg Curl (Machine)",     muscleGroups: [.hamstrings], equipment: [.machines], tags: ["isolation"], sets: 3, reps: "12-15", restSeconds: 90),
                        Exercise(name: "Bulgarian Split Squat",  muscleGroups: [.quads, .glutes], equipment: [.dumbbell], tags: ["unilateral", "compound"], sets: 3, reps: "10/leg", restSeconds: 90),
                        Exercise(name: "Hip Thrust",             muscleGroups: [.glutes], equipment: [.barbell], tags: ["compound", "glute"], sets: 4, reps: "10-12", restSeconds: 90),
                        Exercise(name: "Seated Calf Raise",      muscleGroups: [.calves], equipment: [.machines], tags: ["calf raise heavy"], sets: 4, reps: "15-20", restSeconds: 60),
                        Exercise(name: "Ab Wheel Rollout",       muscleGroups: [.core], equipment: [.bodyweight], tags: ["core"], sets: 3, reps: "10-12", restSeconds: 60)
                    ],
                    estimatedMinutes: 65,
                    weekday: 5
                ),
                WorkoutDay(
                    dayName: "Rest Day",
                    focusAreas: [],
                    exercises: [],
                    estimatedMinutes: 0,
                    isRestDay: true,
                    weekday: 6
                ),
                WorkoutDay(
                    dayName: "Rest Day",
                    focusAreas: [],
                    exercises: [],
                    estimatedMinutes: 0,
                    isRestDay: true,
                    weekday: 7
                )
            ],
            researchSource: "Based on Schoenfeld (2016) upper/lower split science, NSCA Essentials of Strength Training, and Krieger (2010) meta-analysis on volume per muscle group."
        )
    }

    // MARK: Meal Plan
    static var mealPlan: MealPlan {
        MealPlan(
            name: "Muscle-Building Meal Plan",
            targetCalories: 2800,
            targetProteinG: 175,
            days: [
                DayMealPlan(
                    dayName: "Mon",
                    meals: [
                        Meal(name: "Greek Yoghurt Protein Bowl",
                             mealTime: .breakfast, calories: 520, proteinG: 45, carbsG: 55, fatG: 10,
                             ingredients: ["300g Greek yoghurt (0%)", "40g oats", "1 scoop whey protein", "1 banana", "30g mixed berries", "15g honey"],
                             prepMinutes: 5,
                             instructions: "Mix yoghurt with protein powder. Top with oats, banana, berries, and honey. No cooking needed."),
                        Meal(name: "Chicken & Rice",
                             mealTime: .lunch, calories: 680, proteinG: 55, carbsG: 80, fatG: 12,
                             ingredients: ["200g chicken breast", "150g white rice (dry)", "100g broccoli", "15ml olive oil", "salt, pepper, garlic powder"],
                             prepMinutes: 25,
                             instructions: "Cook rice. Season and grill chicken breast 6-7 min per side. Steam broccoli. Drizzle with olive oil."),
                        Meal(name: "Pre-Workout Shake + Banana",
                             mealTime: .preworkout, calories: 280, proteinG: 28, carbsG: 35, fatG: 3,
                             ingredients: ["1 scoop whey protein", "250ml skimmed milk", "1 large banana"],
                             prepMinutes: 2,
                             instructions: "Blend or shake protein with milk. Have 45-60 minutes before training."),
                        Meal(name: "Post-Workout: Salmon & Sweet Potato",
                             mealTime: .postworkout, calories: 620, proteinG: 42, carbsG: 65, fatG: 18,
                             ingredients: ["180g salmon fillet", "200g sweet potato", "100g asparagus", "10ml olive oil", "lemon juice"],
                             prepMinutes: 30,
                             instructions: "Roast sweet potato at 200°C for 25 min. Pan-sear salmon 4 min each side. Steam asparagus."),
                        Meal(name: "Cottage Cheese & Almonds",
                             mealTime: .dinner, calories: 320, proteinG: 28, carbsG: 12, fatG: 14,
                             ingredients: ["200g cottage cheese", "30g almonds", "5g cinnamon"],
                             prepMinutes: 2,
                             instructions: "Combine and serve. Cottage cheese is high in casein — ideal before bed for overnight muscle protein synthesis.")
                    ]
                ),
                DayMealPlan(dayName: "Tue", meals: [
                    Meal(name: "Egg White Omelette",
                         mealTime: .breakfast, calories: 480, proteinG: 40, carbsG: 45, fatG: 12,
                         ingredients: ["4 whole eggs + 4 egg whites", "50g spinach", "50g feta", "2 slices wholemeal toast"],
                         prepMinutes: 10,
                         instructions: "Whisk eggs and whites. Cook spinach. Pour eggs over, fold in feta. Serve with toast."),
                    Meal(name: "Tuna & Pasta",
                         mealTime: .lunch, calories: 640, proteinG: 52, carbsG: 75, fatG: 10,
                         ingredients: ["2 tins tuna in water", "150g pasta", "50g sweetcorn", "2 tbsp light mayo", "cherry tomatoes"],
                         prepMinutes: 15, instructions: "Cook pasta. Drain tuna. Mix all ingredients cold for a protein pasta salad."),
                    Meal(name: "Beef Mince & Veg",
                         mealTime: .dinner, calories: 720, proteinG: 60, carbsG: 50, fatG: 20,
                         ingredients: ["250g lean beef mince (5% fat)", "100g brown rice", "1 bell pepper", "onion", "tomato passata", "mixed spices"],
                         prepMinutes: 25, instructions: "Brown mince with onion and pepper. Add passata and spices. Simmer 15 min. Serve over brown rice.")
                ]),
                DayMealPlan(dayName: "Wed", meals: [
                    Meal(name: "Protein Pancakes",
                         mealTime: .breakfast, calories: 560, proteinG: 48, carbsG: 60, fatG: 12,
                         ingredients: ["2 scoops protein powder", "2 eggs", "100g oats blended", "100ml almond milk", "maple syrup to taste"],
                         prepMinutes: 15, instructions: "Blend oats to flour. Mix all ingredients. Cook on medium heat. Serve with a small amount of maple syrup."),
                    Meal(name: "Turkey & Avocado Wrap",
                         mealTime: .lunch, calories: 650, proteinG: 48, carbsG: 55, fatG: 18,
                         ingredients: ["150g turkey breast", "1 large wholemeal wrap", "½ avocado", "lettuce", "tomato", "mustard"],
                         prepMinutes: 10, instructions: "Layer ingredients in wrap. Roll tightly. Cut in half."),
                    Meal(name: "White Fish & Quinoa",
                         mealTime: .dinner, calories: 580, proteinG: 52, carbsG: 55, fatG: 10,
                         ingredients: ["200g cod or haddock", "150g quinoa (dry)", "100g green beans", "lemon", "herbs"],
                         prepMinutes: 25, instructions: "Cook quinoa per packet. Bake fish at 180°C for 15 min. Steam green beans. Season with lemon and herbs.")
                ]),
                DayMealPlan(dayName: "Thu", meals: [
                    Meal(name: "Overnight Oats",
                         mealTime: .breakfast, calories: 540, proteinG: 38, carbsG: 65, fatG: 12,
                         ingredients: ["80g oats", "200ml skimmed milk", "1 scoop protein powder", "1 tbsp chia seeds", "berries", "almond butter"],
                         prepMinutes: 5, instructions: "Mix all ingredients the night before. Refrigerate. Eat cold with fresh berries."),
                    Meal(name: "Chicken Stir Fry",
                         mealTime: .lunch, calories: 670, proteinG: 58, carbsG: 72, fatG: 14,
                         ingredients: ["200g chicken breast", "noodles", "mixed veg", "soy sauce", "sesame oil", "ginger", "garlic"],
                         prepMinutes: 20, instructions: "Slice chicken thin. Stir fry on high heat with veg and sauce. Serve with noodles."),
                    Meal(name: "Lean Beef Tacos",
                         mealTime: .dinner, calories: 680, proteinG: 52, carbsG: 60, fatG: 18,
                         ingredients: ["220g lean beef mince", "3 corn tortillas", "salsa", "low-fat cheese", "jalapeños", "lettuce"],
                         prepMinutes: 20, instructions: "Brown mince with taco seasoning. Fill tortillas. Top with salsa, cheese, lettuce.")
                ]),
                DayMealPlan(dayName: "Fri", meals: [
                    Meal(name: "Scrambled Eggs & Smoked Salmon",
                         mealTime: .breakfast, calories: 510, proteinG: 45, carbsG: 30, fatG: 20,
                         ingredients: ["4 eggs", "80g smoked salmon", "2 slices rye bread", "cream cheese", "capers"],
                         prepMinutes: 10, instructions: "Scramble eggs gently. Toast rye bread. Top with cream cheese, smoked salmon, and capers."),
                    Meal(name: "Prawn & Rice Bowl",
                         mealTime: .lunch, calories: 620, proteinG: 50, carbsG: 70, fatG: 10,
                         ingredients: ["200g king prawns", "150g white rice", "edamame", "cucumber", "soy sauce", "rice vinegar"],
                         prepMinutes: 20, instructions: "Cook rice. Season and pan-fry prawns 2 min each side. Build bowl with all ingredients."),
                    Meal(name: "Protein Pizza Night",
                         mealTime: .dinner, calories: 720, proteinG: 55, carbsG: 75, fatG: 20,
                         ingredients: ["high-protein pizza base", "tomato sauce", "mozzarella", "chicken breast", "peppers", "mushrooms"],
                         prepMinutes: 25, instructions: "Build pizza on base. Bake at 220°C for 12-15 min. Track macros carefully on treat meals.")
                ]),
                DayMealPlan(dayName: "Sat", meals: [
                    Meal(name: "Big Protein Breakfast",
                         mealTime: .breakfast, calories: 680, proteinG: 55, carbsG: 55, fatG: 22,
                         ingredients: ["4 eggs scrambled", "200g turkey sausages", "2 wholemeal toast", "grilled tomato", "mushrooms", "baked beans"],
                         prepMinutes: 20, instructions: "Grill sausages and tomatoes. Scramble eggs. Serve with toast and beans."),
                    Meal(name: "Meal Prep: Batch chicken",
                         mealTime: .lunch, calories: 650, proteinG: 60, carbsG: 65, fatG: 12,
                         ingredients: ["250g chicken breast", "sweet potato", "broccoli", "olive oil"],
                         prepMinutes: 40, instructions: "Batch cook for the week. Season chicken, roast alongside sweet potato cubes for 25 min at 200°C."),
                    Meal(name: "Steak & Veg",
                         mealTime: .dinner, calories: 720, proteinG: 65, carbsG: 40, fatG: 25,
                         ingredients: ["220g sirloin steak", "200g mixed roasted veg", "100g new potatoes"],
                         prepMinutes: 25, instructions: "Bring steak to room temp. Pan-sear 3 min each side for medium. Rest 5 min. Serve with roasted veg.")
                ]),
                DayMealPlan(dayName: "Sun", meals: [
                    Meal(name: "Smoothie Bowl",
                         mealTime: .breakfast, calories: 490, proteinG: 38, carbsG: 60, fatG: 10,
                         ingredients: ["1 scoop vanilla protein", "200ml oat milk", "frozen berries", "½ banana", "granola", "nut butter"],
                         prepMinutes: 5, instructions: "Blend protein, milk, and frozen fruit thick. Top with granola and a drizzle of nut butter."),
                    Meal(name: "Sunday Roast Chicken",
                         mealTime: .lunch, calories: 760, proteinG: 65, carbsG: 60, fatG: 20,
                         ingredients: ["250g roast chicken breast", "roast potatoes", "carrots", "peas", "gravy (low fat)"],
                         prepMinutes: 60, instructions: "Traditional Sunday roast. Track carefully — this is also a recovery and refuel meal after the week."),
                    Meal(name: "Light Evening: Cottage Cheese & Fruit",
                         mealTime: .dinner, calories: 320, proteinG: 28, carbsG: 30, fatG: 8,
                         ingredients: ["250g cottage cheese", "apple slices", "30g walnuts", "cinnamon"],
                         prepMinutes: 5, instructions: "Serve cottage cheese with sliced apple and walnuts. Sprinkle cinnamon.")
                ])
            ],
            researchSource: "Macros based on ISSN Position Stand 2017, Morton et al. (2018), and Aragon & Schoenfeld (2013) nutrient timing research."
        )
    }

    // MARK: Measurements
    static var measurements: [BodyMeasurement] {
        let cal = Calendar.current
        return [
            BodyMeasurement(date: cal.date(byAdding: .weekOfYear, value: -4, to: Date())!, weightKg: 78.5, bodyFatPercent: 18.0, bicepCm: 37.0, chestCm: 99.0, waistCm: 84.0, mood: 3, energyLevel: 3),
            BodyMeasurement(date: cal.date(byAdding: .weekOfYear, value: -3, to: Date())!, weightKg: 78.9, bodyFatPercent: 17.8, bicepCm: 37.5, chestCm: 99.5, waistCm: 83.5, mood: 4, energyLevel: 4),
            BodyMeasurement(date: cal.date(byAdding: .weekOfYear, value: -2, to: Date())!, weightKg: 79.2, bodyFatPercent: 17.5, bicepCm: 38.0, chestCm: 100.0, waistCm: 83.0, mood: 4, energyLevel: 4),
            BodyMeasurement(date: cal.date(byAdding: .weekOfYear, value: -1, to: Date())!, weightKg: 79.8, bodyFatPercent: 17.2, bicepCm: 38.5, chestCm: 100.8, waistCm: 82.5, mood: 5, energyLevel: 5)
        ]
    }
}
