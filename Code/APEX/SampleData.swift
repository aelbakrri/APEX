import Foundation

// MARK: - Sample Data for preview and first-launch

struct SampleData {

    // MARK: Workout Plan
    static func workoutPlan(trainingDays: [Int], focusMuscleGroups: [Exercise.MuscleGroup] = []) -> WorkoutPlan {
        // The four movement-pattern sessions (evidence-based naming per Schoenfeld 2016,
        // NSCA CSCS, and RP Strength — push/pull/squat/hinge pattern classification)
        let sessions: [WorkoutDay] = [
                WorkoutDay(
                    dayName: "Push",
                    focusAreas: [.chest, .shoulders, .triceps],
                    exercises: [
                        Exercise(name: "Barbell Bench Press", muscleGroups: [.chest, .triceps], equipment: [.barbell], tags: ["compound", "horizontal push"], sets: 4, reps: "6-10", restSeconds: 120,
                            instructions: ["Lie flat on the bench with eyes directly under the bar", "Grip the bar slightly wider than shoulder-width, thumbs wrapped around", "Unrack and position the bar over your chest", "Lower slowly to mid-chest, elbows at about 45° from your body", "Press the bar back up explosively to full arm extension"],
                            coachingCues: ["Drive shoulder blades into the bench and keep them retracted", "Keep feet flat on the floor throughout", "Think 'push yourself away from the bar' not 'push the bar up'"]),
                        Exercise(name: "Incline Dumbbell Press", muscleGroups: [.chest, .shoulders], equipment: [.dumbbell], tags: ["compound", "upper chest"], sets: 3, reps: "10-12", restSeconds: 90,
                            instructions: ["Set bench to 30–45° incline and sit back with dumbbells at chest level", "Press dumbbells upward and slightly inward until arms are fully extended", "Lower slowly with control, elbows at 45° to your torso", "Stop when dumbbells are at chest level — don't let elbows drop below the bench"],
                            coachingCues: ["Keep wrists stacked directly over elbows", "Don't touch dumbbells at the top — maintain constant tension", "Control the descent: 2–3 seconds down"]),
                        Exercise(name: "Seated DB Overhead Press", muscleGroups: [.shoulders], equipment: [.dumbbell], tags: ["overhead press", "compound"], sets: 3, reps: "10-12", restSeconds: 90,
                            instructions: ["Sit upright with back fully supported, dumbbells at shoulder height", "Brace your core and press dumbbells overhead until arms are fully extended", "Lower back to shoulder height with control", "Keep your lower back flat against the pad — avoid arching"],
                            coachingCues: ["Press slightly behind your head, not in front of your face", "Exhale on the press, inhale on the descent", "Core stays braced to protect your lower back"]),
                        Exercise(name: "Cable Lateral Raise", muscleGroups: [.shoulders], equipment: [.cables], tags: ["isolation", "lateral delt"], sets: 3, reps: "15-20", restSeconds: 60,
                            instructions: ["Stand sideways to the cable with the pulley set at hip height", "Hold the handle with your far hand, slight bend at the elbow", "Raise your arm out to the side until parallel with the floor", "Lower slowly — resist the cable on the way down"],
                            coachingCues: ["Lead with your pinky finger to target the lateral delt", "No swinging or momentum — control the full range", "Pause at the top for a 1-second squeeze"]),
                        Exercise(name: "Tricep Pushdown (Cable)", muscleGroups: [.triceps], equipment: [.cables], tags: ["isolation", "tricep extension"], sets: 3, reps: "12-15", restSeconds: 60,
                            instructions: ["Face the cable, bar at chest height, hands shoulder-width apart palms down", "Pin your elbows tightly to your sides — they stay fixed the entire set", "Push the bar down until arms are fully extended", "Return slowly to the start, elbows still pinned"],
                            coachingCues: ["Elbows are a hinge — they must not move", "Fully extend and squeeze hard at the bottom", "Lean forward slightly for a stable base"]),
                        Exercise(name: "Overhead Tricep Extension", muscleGroups: [.triceps], equipment: [.cables, .dumbbell], tags: ["isolation", "long head"], sets: 3, reps: "12-15", restSeconds: 60,
                            instructions: ["Hold a dumbbell or rope overhead with both hands, upper arms vertical", "Lower the weight behind your head by bending at the elbows only", "Extend arms fully overhead, squeezing the triceps at the top", "Keep upper arms stationary and pointing straight up throughout"],
                            coachingCues: ["This hits the long head — critical for overall tricep size", "Don't let elbows flare out wide", "Keep ribs down and core tight to prevent arching"])
                    ],
                    estimatedMinutes: 60,
                    weekday: 0
                ),
                WorkoutDay(
                    dayName: "Legs — Squat Focus",
                    focusAreas: [.quads, .glutes, .core],
                    exercises: [
                        Exercise(name: "Back Squat", muscleGroups: [.quads, .glutes], equipment: [.barbell], tags: ["compound", "deep squat"], sets: 4, reps: "6-8", restSeconds: 180,
                            instructions: ["Set bar across your upper traps, feet shoulder-width apart, toes slightly out", "Take a deep breath, brace your core hard, and begin the descent", "Lower until thighs reach parallel to the floor or below", "Drive through your whole foot to stand, locking out hips and knees at the top"],
                            coachingCues: ["Keep your chest up and spine neutral throughout", "Knees should track in line with your toes — don't let them cave in", "'Spread the floor' with your feet as you drive up"]),
                        Exercise(name: "Leg Press", muscleGroups: [.quads, .glutes], equipment: [.machines], tags: ["compound", "leg press heavy"], sets: 3, reps: "10-12", restSeconds: 120,
                            instructions: ["Set the seat so knees are at 90° with feet on the platform", "Place feet shoulder-width apart at mid-height on the platform", "Unlock the safety handles and lower the platform until knees reach 90°", "Press through the platform until legs are almost fully extended — don't lock out"],
                            coachingCues: ["Keep your lower back flat against the pad at all times", "Higher foot placement targets more glutes, lower targets more quads", "2-second controlled descent on every rep"]),
                        Exercise(name: "Walking Lunges", muscleGroups: [.quads, .glutes, .hamstrings], equipment: [.dumbbell], tags: ["lunge", "unilateral"], sets: 3, reps: "12/leg", restSeconds: 90,
                            instructions: ["Stand tall with dumbbells at your sides", "Step forward with one leg, lowering until your back knee nearly touches the floor", "Both knees should be at 90° at the bottom of the movement", "Drive through your front heel to bring your rear foot forward and repeat on the other leg"],
                            coachingCues: ["Keep your torso upright — don't lean forward", "Front knee stays directly over the ankle, not caving inward", "Take a longer stride to increase glute involvement"]),
                        Exercise(name: "Leg Extension", muscleGroups: [.quads], equipment: [.machines], tags: ["isolation", "terminal extension"], sets: 3, reps: "15-20", restSeconds: 60,
                            instructions: ["Adjust the seat so your knees align with the machine's pivot point", "Sit with feet hooked under the pad, hands gripping the handles", "Extend legs until fully straight, squeezing your quads hard at the top", "Lower the pad slowly back to the starting position"],
                            coachingCues: ["Pause and squeeze at full extension for 1 second", "This is isolation — no need for heavy weight, focus on the burn", "Pointing toes slightly inward emphasises the outer quad"]),
                        Exercise(name: "Standing Calf Raise", muscleGroups: [.calves], equipment: [.machines], tags: ["calf raise heavy", "isolation"], sets: 4, reps: "15-20", restSeconds: 60,
                            instructions: ["Position yourself with the balls of your feet on the platform edge, heels hanging off", "Lower your heels as far as comfortable to get a deep stretch", "Drive up onto your tiptoes as high as possible", "Pause and squeeze hard at the top before lowering slowly"],
                            coachingCues: ["Full range of motion — calves need that deep stretch to grow", "3-second descent to maximise time under tension", "Varying foot angle (toes in vs out) hits different calf heads"]),
                        Exercise(name: "Plank Hold", muscleGroups: [.core], equipment: [.bodyweight], tags: ["core", "isometric"], sets: 3, reps: "45s", restSeconds: 60,
                            instructions: ["Start on your forearms with elbows directly under your shoulders", "Create a straight line from your head through your heels", "Squeeze your glutes hard and brace your core as if bracing for a punch", "Hold the position while breathing steadily throughout"],
                            coachingCues: ["Don't let your hips sag or pike upward", "Squeezing glutes maximises core activation", "Think 'protect your spine' — not just hold a position"])
                    ],
                    estimatedMinutes: 65,
                    weekday: 0
                ),
                WorkoutDay(
                    dayName: "Pull",
                    focusAreas: [.back, .biceps],
                    exercises: [
                        Exercise(name: "Weighted Pull-Up", muscleGroups: [.back, .biceps], equipment: [.pullupBar], tags: ["compound", "vertical pull"], sets: 4, reps: "6-10", restSeconds: 120,
                            instructions: ["Attach weight via belt and hang from the bar with palms facing away, slightly wider than shoulders", "Start from a dead hang with arms fully extended", "Pull your chest toward the bar by driving your elbows down and back", "Lower under full control until arms are completely straight"],
                            coachingCues: ["Initiate with your lats — think 'elbows to hips', not 'pull with your arms'", "Don't shrug your shoulders at the top", "Full dead hang at the bottom for full range of motion"]),
                        Exercise(name: "Barbell Row", muscleGroups: [.back, .biceps], equipment: [.barbell], tags: ["barbell row", "compound"], sets: 4, reps: "8-10", restSeconds: 120,
                            instructions: ["Hinge at the hips with soft knees and flat back, bar hanging from your hands", "Grip the bar slightly wider than shoulder-width, overhand", "Row the bar to your lower ribcage, keeping elbows close to your body", "Lower the bar slowly with control back to the hanging position"],
                            coachingCues: ["Back should be close to parallel to the floor for maximum lat engagement", "Don't let your lower back round under load", "Pull your elbows back and through — not up"]),
                        Exercise(name: "Cable Face Pull", muscleGroups: [.shoulders, .back], equipment: [.cables], tags: ["rear delt", "rotator cuff", "shoulder health"], sets: 3, reps: "15-20", restSeconds: 60,
                            notes: "Great for shoulder health — always include this!",
                            instructions: ["Set the cable at eye height with a rope attachment, thumbs pointing toward you", "Pull the rope toward your face, ending with hands beside your ears", "Externally rotate at the top — finish in a 'double bicep pose' position", "Return slowly, resisting the cable all the way back"],
                            coachingCues: ["External rotation at the top is the whole point of this movement", "Keep elbows high and level with your shoulders", "Prioritise quality over load — this is shoulder health work"]),
                        Exercise(name: "Dumbbell Bicep Curl", muscleGroups: [.biceps], equipment: [.dumbbell], tags: ["isolation", "curl supinated"], sets: 3, reps: "10-12", restSeconds: 60,
                            instructions: ["Stand tall with dumbbells at your sides, palms facing forward", "Keep your upper arms completely still pinned against your torso", "Curl the dumbbells to shoulder height, rotating palms upward at the top", "Lower slowly back to full extension"],
                            coachingCues: ["No swinging — if you're swinging, the weight is too heavy", "Fully extend at the bottom for complete range of motion", "Supinate (turn palm up) as you curl for peak bicep contraction"]),
                        Exercise(name: "Hammer Curl", muscleGroups: [.biceps, .forearms], equipment: [.dumbbell], tags: ["isolation", "brachialis"], sets: 3, reps: "12-15", restSeconds: 60,
                            instructions: ["Stand tall with dumbbells at your sides, palms facing your body (neutral grip)", "Keep the neutral thumbs-up grip throughout — no wrist rotation", "Curl dumbbells to shoulder height and lower slowly to full extension"],
                            coachingCues: ["Neutral grip targets the brachialis — adds serious thickness under the bicep", "Keep elbows pinned to your sides", "Control both directions — slow is better here"]),
                        Exercise(name: "Rear Delt Fly", muscleGroups: [.shoulders], equipment: [.dumbbell], tags: ["isolation", "rear delt"], sets: 3, reps: "15-20", restSeconds: 60,
                            instructions: ["Hinge forward at the hips until chest is nearly parallel to the floor", "Hold dumbbells hanging below your chest, palms facing each other", "Raise arms out to your sides with a slight bend at the elbows", "Squeeze shoulder blades together at the top, then lower slowly"],
                            coachingCues: ["Keep a soft, consistent bend in the elbows throughout", "Lead with your elbows — not your hands", "Avoid shrugging — focus on rear delts, not traps"])
                    ],
                    estimatedMinutes: 60,
                    weekday: 0
                ),
                WorkoutDay(
                    dayName: "Legs — Hinge Focus",
                    focusAreas: [.hamstrings, .glutes],
                    exercises: [
                        Exercise(name: "Romanian Deadlift", muscleGroups: [.hamstrings, .glutes, .back], equipment: [.barbell], tags: ["compound", "hip hinge"], sets: 4, reps: "8-10", restSeconds: 150,
                            instructions: ["Stand with feet hip-width apart, bar in front of your hips", "Push your hips back and lower the bar along your legs, keeping your back flat", "Stop when you feel a deep stretch in your hamstrings — usually just below the knee", "Drive your hips forward to return to standing, squeezing glutes at the top"],
                            coachingCues: ["This is a hip hinge, not a squat — your hips move back, not down", "Keep the bar dragging close to your legs throughout", "Squeeze glutes hard at the top to protect your lower back"]),
                        Exercise(name: "Leg Curl (Machine)", muscleGroups: [.hamstrings], equipment: [.machines], tags: ["isolation"], sets: 3, reps: "12-15", restSeconds: 90,
                            instructions: ["Lie face down on the machine with knees at the pivot point", "Position the pad just above your heels", "Curl your heels toward your glutes as far as possible, squeezing at the top", "Lower slowly back to the starting position"],
                            coachingCues: ["Point your toes to increase hamstring recruitment", "Don't let your hips lift off the pad", "3-second descent for maximum time under tension"]),
                        Exercise(name: "Bulgarian Split Squat", muscleGroups: [.quads, .glutes], equipment: [.dumbbell], tags: ["unilateral", "compound"], sets: 3, reps: "10/leg", restSeconds: 90,
                            instructions: ["Place your rear foot on a bench behind you, dumbbells at your sides", "Position your front foot far enough forward that your shin stays vertical at the bottom", "Lower your hips straight down until your back knee nearly touches the floor", "Drive through your front heel to return to the starting position"],
                            coachingCues: ["Upright torso emphasises quads; slight forward lean emphasises glutes", "Don't let your front knee cave inward", "Complete all reps on one leg before switching"]),
                        Exercise(name: "Hip Thrust", muscleGroups: [.glutes], equipment: [.barbell], tags: ["compound", "glute"], sets: 4, reps: "10-12", restSeconds: 90,
                            instructions: ["Sit on the floor with your upper back against a bench, bar across your hips", "Plant feet shoulder-width apart so knees are at 90° when hips are fully extended", "Drive your hips upward by squeezing your glutes hard", "Create a straight line from shoulders to knees at the top, then lower without resting"],
                            coachingCues: ["Hold and squeeze hard at the top for 1 second on every rep", "Keep your chin tucked — don't hyperextend your neck", "Drive through your heels, not your toes"]),
                        Exercise(name: "Seated Calf Raise", muscleGroups: [.calves], equipment: [.machines], tags: ["calf raise heavy"], sets: 4, reps: "15-20", restSeconds: 60,
                            instructions: ["Sit on the machine with the pad resting on your lower thighs", "Position the balls of your feet on the platform with heels hanging off", "Lower heels as far as comfortable for a full stretch", "Drive up onto your tiptoes as high as possible, pause, then lower slowly"],
                            coachingCues: ["Seated raises target the soleus — a different muscle than standing raises", "Full range of motion on every single rep", "2 seconds down, 1-second pause at the bottom, drive up"]),
                        Exercise(name: "Ab Wheel Rollout", muscleGroups: [.core], equipment: [.bodyweight], tags: ["core"], sets: 3, reps: "10-12", restSeconds: 60,
                            instructions: ["Kneel on the floor and grip the ab wheel directly under your shoulders", "Roll forward slowly, extending your body close to the floor", "Brace your core to prevent your hips from sagging", "Pull the wheel back using your abs — don't use your lower back"],
                            coachingCues: ["This is an anti-extension exercise — your job is to resist arching", "Start with a partial range of motion and increase as you get stronger", "Think 'hollow body' — posterior pelvic tilt throughout"])
                    ],
                    estimatedMinutes: 65,
                    weekday: 0
                )
        ]

        let push        = sessions[0]
        let legsSquat   = sessions[1]
        let pull        = sessions[2]
        let legsHinge   = sessions[3]

        // Two additional sessions unlocked when user has a specific focus
        let armsShoulders = WorkoutDay(
            dayName: "Arms & Shoulders",
            focusAreas: [.shoulders, .biceps, .triceps],
            exercises: [
                Exercise(name: "Seated DB Overhead Press", muscleGroups: [.shoulders], equipment: [.dumbbell], tags: ["overhead press", "compound"], sets: 4, reps: "8-10", restSeconds: 120,
                    instructions: ["Sit upright, dumbbells at shoulder height, palms facing forward", "Press overhead until arms are fully extended without locking out", "Lower back to shoulder height with a 2-second descent"],
                    coachingCues: ["Keep ribs down — don't arch your lower back", "Press in a slight arc ending with dumbbells close together at the top", "Brace your core before each press"]),
                Exercise(name: "Cable Lateral Raise", muscleGroups: [.shoulders], equipment: [.cables], tags: ["isolation", "lateral delt"], sets: 3, reps: "15-20", restSeconds: 60,
                    instructions: ["Stand sideways to the cable, pulley at hip height", "Raise your arm out to shoulder height with a slight elbow bend", "Lower slowly — resist the cable on the way down"],
                    coachingCues: ["Lead with your pinky to target the lateral delt", "No momentum — squeeze at the top for 1 second", "Keep torso still throughout"]),
                Exercise(name: "Cable Face Pull", muscleGroups: [.shoulders, .back], equipment: [.cables], tags: ["rear delt", "rotator cuff"], sets: 3, reps: "15-20", restSeconds: 60,
                    instructions: ["Set cable at eye height with a rope attachment", "Pull rope to your face, ending with hands beside your ears", "Externally rotate at the top — finish in a double-bicep position", "Return slowly under control"],
                    coachingCues: ["External rotation at the top is what makes this exercise work", "Keep elbows high throughout", "Light weight, full range — this protects your shoulders"]),
                Exercise(name: "Barbell Curl", muscleGroups: [.biceps], equipment: [.barbell], tags: ["isolation", "compound curl"], sets: 3, reps: "8-10", restSeconds: 90,
                    instructions: ["Stand tall, barbell gripped at shoulder-width with palms up", "Keep upper arms pinned to your sides throughout the entire set", "Curl the bar to shoulder height, squeezing hard at the top", "Lower slowly to full extension — don't let the weight drop"],
                    coachingCues: ["No swinging — strict form grows more muscle than heavy weight with momentum", "Fully extend at the bottom to maximise range of motion", "Supinate your wrist slightly at the top for peak contraction"]),
                Exercise(name: "Incline DB Curl", muscleGroups: [.biceps], equipment: [.dumbbell], tags: ["isolation", "long head stretch"], sets: 3, reps: "10-12", restSeconds: 60,
                    instructions: ["Set the bench to 45° and sit back, letting dumbbells hang behind your hips", "Curl both dumbbells simultaneously, rotating palms up as you lift", "Lower slowly back to the hanging position — you should feel a deep stretch"],
                    coachingCues: ["The incline position stretches the long head of the bicep — don't cut the range short", "Let gravity pull your arms fully back at the bottom", "Slow negatives are more important than the curl itself here"]),
                Exercise(name: "Skull Crusher", muscleGroups: [.triceps], equipment: [.barbell, .dumbbell], tags: ["isolation", "long head"], sets: 3, reps: "10-12", restSeconds: 60,
                    instructions: ["Lie flat on a bench, EZ-bar held above your chest with arms extended", "Lower the bar toward your forehead by bending only at the elbows", "Stop just above your forehead, then extend back to the start"],
                    coachingCues: ["Upper arms should stay completely vertical throughout", "This targets the long head — the largest portion of the tricep", "Control the descent; never let the bar drop fast near your head"]),
            ],
            estimatedMinutes: 55,
            weekday: 0
        )

        let gluteFocus = WorkoutDay(
            dayName: "Legs — Glute Focus",
            focusAreas: [.glutes, .hamstrings],
            exercises: [
                Exercise(name: "Barbell Hip Thrust", muscleGroups: [.glutes], equipment: [.barbell], tags: ["compound", "glute"], sets: 4, reps: "10-12", restSeconds: 120,
                    instructions: ["Sit with upper back against a bench, barbell padded across your hips", "Plant feet shoulder-width so knees are at 90° at the top", "Drive hips up by squeezing glutes hard — create a straight line from shoulders to knees", "Lower hips to just above the floor and repeat"],
                    coachingCues: ["Pause and squeeze for a full second at the top on every rep", "Chin stays tucked — don't hyperextend your neck", "Drive through your heels, not your toes"]),
                Exercise(name: "Sumo Deadlift", muscleGroups: [.glutes, .hamstrings, .back], equipment: [.barbell], tags: ["compound", "hip hinge"], sets: 4, reps: "6-8", restSeconds: 150,
                    instructions: ["Take a wide stance with toes pointed out 45°, bar over mid-foot", "Grip the bar inside your legs, shoulder-width", "Push the floor away and drive your hips forward as the bar passes your knees", "Lock out hips and knees simultaneously at the top"],
                    coachingCues: ["Wide stance shifts emphasis from lower back to glutes and inner hamstrings", "Keep your chest up and back flat from start to finish", "Think 'push the floor apart' as you lift"]),
                Exercise(name: "Dumbbell Romanian Deadlift", muscleGroups: [.hamstrings, .glutes], equipment: [.dumbbell], tags: ["hip hinge", "unilateral"], sets: 3, reps: "10-12", restSeconds: 90,
                    instructions: ["Hold dumbbells in front of your thighs, feet hip-width apart", "Hinge at the hips, pushing them back while lowering dumbbells along your legs", "Feel a deep hamstring stretch before driving hips forward to stand", "Squeeze glutes hard at the top"],
                    coachingCues: ["Keep dumbbells close to your legs throughout — don't let them drift forward", "Soft bend in the knees — this is a hip hinge, not a squat", "You should feel this primarily in the hamstrings and glutes, not your lower back"]),
                Exercise(name: "Cable Glute Kickback", muscleGroups: [.glutes], equipment: [.cables], tags: ["isolation", "glute"], sets: 3, reps: "15-20", restSeconds: 60,
                    instructions: ["Attach ankle cuff, face the cable machine, holding it for balance", "Keep a slight forward lean and drive your leg directly behind you", "Squeeze your glute hard at the top of the movement", "Return to the start under control and repeat"],
                    coachingCues: ["Initiate with your glute — not your lower back", "Keep your hip square to the machine throughout", "Pause at the top for maximum glute activation"]),
                Exercise(name: "Lying Leg Curl", muscleGroups: [.hamstrings], equipment: [.machines], tags: ["isolation"], sets: 3, reps: "12-15", restSeconds: 60,
                    instructions: ["Lie face down, pad positioned just above your heels", "Curl your heels toward your glutes as far as possible", "Squeeze hard at the top, then lower slowly over 3 seconds"],
                    coachingCues: ["Point toes to increase hamstring recruitment", "Don't lift your hips off the pad", "Slow controlled descent is where the growth happens"]),
                Exercise(name: "Weighted Step-Up", muscleGroups: [.glutes, .quads], equipment: [.dumbbell], tags: ["unilateral", "compound"], sets: 3, reps: "12/leg", restSeconds: 90,
                    instructions: ["Hold dumbbells at your sides, stand facing a knee-height box", "Step up with one foot, driving through that heel to bring your body up", "Bring the trailing leg up to standing on the box", "Step down with control and repeat on the same leg"],
                    coachingCues: ["Drive through your heel — not your toes — to maximise glute activation", "Keep your torso upright throughout", "Complete all reps on one leg before switching for greater glute fatigue"]),
            ],
            estimatedMinutes: 60,
            weekday: 0
        )

        // Determine focus from the user's selected muscle group priorities
        let upperGroups: Set<Exercise.MuscleGroup> = [.chest, .back, .shoulders, .biceps, .triceps, .forearms]
        let lowerGroups: Set<Exercise.MuscleGroup> = [.quads, .hamstrings, .glutes, .calves]
        let focusSet = Set(focusMuscleGroups)
        let upperScore = focusSet.intersection(upperGroups).count
        let lowerScore = focusSet.intersection(lowerGroups).count

        // Ordered session pool based on focus; truncated to the number of training days
        let pool: [WorkoutDay]
        let planName: String
        if focusMuscleGroups.isEmpty || upperScore == lowerScore {
            // Balanced default — alternates push/pull/legs patterns
            pool = [push, legsSquat, pull, legsHinge, armsShoulders, gluteFocus, push]
            planName = "Push / Pull / Legs — Hypertrophy"
        } else if upperScore > lowerScore {
            // Upper focus — more push/pull, one leg day late in the sequence
            pool = [push, pull, armsShoulders, push, pull, legsSquat, legsHinge]
            planName = "Upper Body Focus — Push / Pull Split"
        } else {
            // Lower focus — more leg days, upper work fills remaining slots
            pool = [legsSquat, legsHinge, gluteFocus, push, pull, legsSquat, legsHinge]
            planName = "Lower Body Focus — Leg Emphasis"
        }

        // Map sessions onto chosen training days; all other days become rest days
        let sortedDays = trainingDays.sorted()
        let chosenSessions = Array(pool.prefix(sortedDays.count))
        let allDays: [WorkoutDay] = (1...7).map { weekday in
            if let idx = sortedDays.firstIndex(of: weekday), idx < chosenSessions.count {
                var day = chosenSessions[idx]
                day.weekday = weekday
                return day
            }
            return WorkoutDay(dayName: "Rest Day", focusAreas: [], exercises: [],
                              estimatedMinutes: 0, isRestDay: true, weekday: weekday)
        }

        return WorkoutPlan(
            name: planName,
            goal: .buildMuscle,
            daysPerWeek: sortedDays.count,
            days: allDays,
            researchSource: "Push/Pull/Legs split based on Schoenfeld (2016), NSCA CSCS movement-pattern programming, and Krieger (2010) volume meta-analysis."
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
