import SwiftUI
import PhotosUI

struct ProgressTrackingView: View {
    @EnvironmentObject var appState: AppState
    @State private var showCheckIn = false
    @State private var selectedMetric: MetricType = .weight

    enum MetricType: String, CaseIterable {
        case weight = "Weight"
        case bicep  = "Bicep"
        case waist  = "Waist"
        case chest  = "Chest"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // Weekly check-in CTA
                    WeeklyCheckInCard(onTap: { showCheckIn = true })

                    // Latest stats
                    if let latest = appState.measurements.last {
                        LatestStatsGrid(measurement: latest)
                    }

                    // Progress chart
                    if appState.measurements.count >= 2 {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Progress Chart").font(.headlineLarge).foregroundColor(.textPrimary)
                                Spacer()
                                Picker("Metric", selection: $selectedMetric) {
                                    ForEach(MetricType.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 200)
                            }
                            ProgressChartView(measurements: appState.measurements, metric: selectedMetric)
                        }
                    }

                    // Photo timeline
                    if !appState.measurements.filter({ $0.photoPath != nil }).isEmpty {
                        PhotoTimelineView(measurements: appState.measurements)
                    }

                    // Milestone cards
                    MilestonesView()

                    // History list
                    if !appState.measurements.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Check-In History").font(.headlineLarge).foregroundColor(.textPrimary)
                            ForEach(appState.measurements.reversed()) { m in
                                MeasurementRow(measurement: m)
                            }
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding(20)
            }
            .appScreen()
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCheckIn = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.accentMint)
                    }
                }
            }
        }
        .sheet(isPresented: $showCheckIn) {
            WeeklyCheckInSheet { measurement in
                appState.measurements.append(measurement)
            }
        }
    }
}

// MARK: - Weekly Check-In Card

struct WeeklyCheckInCard: View {
    var onTap: () -> Void
    @State private var daysSinceLast = 0

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.gradientPurple.opacity(0.3))
                        .frame(width: 56, height: 56)
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Color.gradientPurple)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("Weekly Check-In").font(.headlineLarge).foregroundColor(.textPrimary)
                    Text("Photos · Measurements · Mood")
                        .font(.bodySmall).foregroundColor(.textSecondary)
                    if daysSinceLast > 0 {
                        TagBadge(text: "\(daysSinceLast) days since last check-in", color: .accentOrange)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.textMuted)
            }
            .padding(16)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.accentPurple.opacity(0.3), lineWidth: 1))
        }
    }
}

// MARK: - Latest Stats Grid

struct LatestStatsGrid: View {
    let measurement: BodyMeasurement
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Stats").font(.headlineLarge).foregroundColor(.textPrimary)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                if let w = measurement.weightKg {
                    StatCard(title: "Weight", value: String(format: "%.1f", w), unit: "kg", accent: .accentMint, icon: "scalemass.fill")
                }
                if let bf = measurement.bodyFatPercent {
                    StatCard(title: "Body Fat", value: String(format: "%.1f", bf), unit: "%", accent: .accentOrange, icon: "percent")
                }
                if let bi = measurement.bicepCm {
                    StatCard(title: "Bicep", value: String(format: "%.1f", bi), unit: "cm", accent: .accentPurple, icon: "figure.strengthtraining.traditional")
                }
                if let wa = measurement.waistCm {
                    StatCard(title: "Waist", value: String(format: "%.1f", wa), unit: "cm", accent: Color(hex: "#06B6D4"), icon: "ruler")
                }
            }
        }
    }
}

// MARK: - Progress Chart

struct ProgressChartView: View {
    let measurements: [BodyMeasurement]
    let metric: ProgressTrackingView.MetricType

    var dataPoints: [Double] {
        measurements.compactMap { m in
            switch metric {
            case .weight: return m.weightKg
            case .bicep:  return m.bicepCm
            case .waist:  return m.waistCm
            case .chest:  return m.chestCm
            }
        }
    }

    var maxVal: Double { (dataPoints.max() ?? 100) + 5 }
    var minVal: Double { max((dataPoints.min() ?? 0) - 5, 0) }

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 8) {
                GeometryReader { geo in
                    if dataPoints.count >= 2 {
                        let w = geo.size.width
                        let h = geo.size.height
                        let step = w / CGFloat(dataPoints.count - 1)
                        let range = maxVal - minVal
                        let points = dataPoints.enumerated().map { i, val in
                            CGPoint(x: CGFloat(i) * step, y: h - CGFloat((val - minVal) / range) * h)
                        }

                        ZStack {
                            // Grid lines
                            ForEach(0..<4) { i in
                                let y = h * CGFloat(i) / 3
                                Path { p in p.move(to: CGPoint(x: 0, y: y)); p.addLine(to: CGPoint(x: w, y: y)) }
                                    .stroke(Color.textMuted.opacity(0.2), lineWidth: 1)
                            }

                            // Area fill
                            Path { path in
                                path.move(to: CGPoint(x: points[0].x, y: h))
                                path.addLine(to: points[0])
                                for p in points.dropFirst() { path.addLine(to: p) }
                                path.addLine(to: CGPoint(x: points.last!.x, y: h))
                                path.closeSubpath()
                            }
                            .fill(LinearGradient(colors: [Color.accentMint.opacity(0.3), Color.accentMint.opacity(0)], startPoint: .top, endPoint: .bottom))

                            // Line
                            Path { path in
                                path.move(to: points[0])
                                for p in points.dropFirst() { path.addLine(to: p) }
                            }
                            .stroke(Color.accentMint, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))

                            // Dots
                            ForEach(points.indices, id: \.self) { i in
                                Circle()
                                    .fill(Color.accentMint)
                                    .frame(width: 8, height: 8)
                                    .position(points[i])
                            }
                        }
                    } else {
                        Text("Not enough data yet — log more check-ins")
                            .font(.bodySmall).foregroundColor(.textMuted)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
                .frame(height: 140)

                HStack {
                    if let first = dataPoints.first, let last = dataPoints.last {
                        let change = last - first
                        let isUp = change >= 0
                        HStack(spacing: 4) {
                            Image(systemName: isUp ? "arrow.up.right" : "arrow.down.right")
                            Text(String(format: "%.1f %@", abs(change), metric == .weight ? "kg" : "cm"))
                        }
                        .font(.headlineSmall)
                        .foregroundColor(metric == .waist ? (isUp ? .accentRed : .accentMint) : (isUp ? .accentMint : .accentRed))
                    }
                    Spacer()
                    Text("\(measurements.count) entries").font(.caption).foregroundColor(.textMuted)
                }
            }
        }
    }
}

// MARK: - Photo Timeline

struct PhotoTimelineView: View {
    let measurements: [BodyMeasurement]
    var withPhotos: [BodyMeasurement] { measurements.filter { $0.photoPath != nil } }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progress Photos").font(.headlineLarge).foregroundColor(.textPrimary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(withPhotos) { m in
                        VStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.appCard)
                                .frame(width: 100, height: 130)
                                .overlay(
                                    Image(systemName: "photo.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.textMuted)
                                )
                            Text(m.date, style: .date)
                                .font(.caption).foregroundColor(.textSecondary)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Milestones

struct MilestonesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Milestones").font(.headlineLarge).foregroundColor(.textPrimary)
            AppCard {
                HStack(spacing: 14) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(Color.gradientOrange)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("First Week Complete!").font(.headlineLarge).foregroundColor(.textPrimary)
                        Text("You logged your first workout session. Keep it up!").font(.bodySmall).foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }
}

// MARK: - Measurement Row

struct MeasurementRow: View {
    let measurement: BodyMeasurement
    var body: some View {
        AppCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(measurement.date, style: .date).font(.headlineSmall).foregroundColor(.textPrimary)
                    HStack(spacing: 8) {
                        if let w = measurement.weightKg {
                            TagBadge(text: "\(String(format: "%.1f", w)) kg", color: .accentMint)
                        }
                        if let b = measurement.bicepCm {
                            TagBadge(text: "\(String(format: "%.1f", b)) cm bicep", color: .accentPurple)
                        }
                    }
                }
                Spacer()
                if let mood = measurement.mood {
                    Text(moodEmoji(mood)).font(.title2)
                }
            }
        }
    }

    func moodEmoji(_ mood: Int) -> String {
        ["😔","😐","🙂","😊","🤩"][max(0, min(mood-1, 4))]
    }
}

// MARK: - Weekly Check-In Sheet

struct WeeklyCheckInSheet: View {
    var onSave: (BodyMeasurement) -> Void
    @Environment(\.dismiss) var dismiss

    @State private var weight: Double? = nil
    @State private var bicep: Double? = nil
    @State private var waist: Double? = nil
    @State private var chest: Double? = nil
    @State private var bodyFat: Double? = nil
    @State private var mood = 3
    @State private var energy = 3
    @State private var notes = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var step = 0

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                TabView(selection: $step) {
                    // Step 1: Body weight + fat
                    CheckInStep(title: "Body Metrics", icon: "scalemass.fill") {
                        VStack(spacing: 16) {
                            NumberField(label: "Weight (kg)", value: $weight)
                            NumberField(label: "Body Fat % (optional)", value: $bodyFat)
                        }
                    }
                    .tag(0)

                    // Step 2: Measurements
                    CheckInStep(title: "Measurements", icon: "ruler.fill") {
                        VStack(spacing: 16) {
                            NumberField(label: "Bicep (cm)", value: $bicep)
                            NumberField(label: "Waist (cm)", value: $waist)
                            NumberField(label: "Chest (cm)", value: $chest)
                        }
                    }
                    .tag(1)

                    // Step 3: Photo
                    CheckInStep(title: "Progress Photo", icon: "camera.fill") {
                        VStack(spacing: 16) {
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.appCard)
                                    .frame(height: 200)
                                    .overlay(
                                        VStack(spacing: 12) {
                                            Image(systemName: selectedPhoto == nil ? "camera.fill" : "checkmark.circle.fill")
                                                .font(.system(size: 40))
                                                .foregroundColor(selectedPhoto == nil ? .textMuted : .accentMint)
                                            Text(selectedPhoto == nil ? "Tap to add photo" : "Photo selected!")
                                                .font(.bodyLarge)
                                                .foregroundColor(selectedPhoto == nil ? .textMuted : .accentMint)
                                        }
                                    )
                            }
                            Text("Front, side, and back photos are most useful for tracking progress")
                                .font(.bodySmall).foregroundColor(.textMuted).multilineTextAlignment(.center)
                        }
                    }
                    .tag(2)

                    // Step 4: Mood + notes
                    CheckInStep(title: "How are you feeling?", icon: "heart.fill") {
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Mood").font(.headlineSmall).foregroundColor(.textSecondary)
                                MoodPicker(value: $mood)
                            }
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Energy Level").font(.headlineSmall).foregroundColor(.textSecondary)
                                MoodPicker(value: $energy)
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes (optional)").font(.headlineSmall).foregroundColor(.textSecondary)
                                TextField("How's training going? Any pain or highlights?", text: $notes, axis: .vertical)
                                    .lineLimit(3...6).appTextField()
                            }
                        }
                    }
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: step)
            }
            .navigationTitle("Weekly Check-In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundColor(.textSecondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if step < 3 {
                        Button("Next") {
                            withAnimation { step += 1 }
                        }.foregroundColor(.accentMint).fontWeight(.semibold)
                    } else {
                        Button("Save") {
                            let m = BodyMeasurement(
                                date: Date(),
                                weightKg: weight,
                                bodyFatPercent: bodyFat,
                                bicepCm: bicep,
                                chestCm: chest,
                                waistCm: waist,
                                mood: mood,
                                energyLevel: energy,
                                notes: notes
                            )
                            onSave(m)
                            dismiss()
                        }.foregroundColor(.accentMint).fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

struct CheckInStep<Content: View>: View {
    let title: String, icon: String
    let content: Content
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title; self.icon = icon; self.content = content()
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 14) {
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(Color.gradientMint)
                    Text(title).font(.displaySmall).foregroundColor(.textPrimary)
                }
                content
            }
            .padding(24)
        }
    }
}

struct NumberField: View {
    let label: String
    @Binding var value: Double?
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.headlineSmall).foregroundColor(.textSecondary)
            TextField("0.0", value: $value, format: .number)
                .keyboardType(.decimalPad)
                .appTextField()
        }
    }
}

struct MoodPicker: View {
    @Binding var value: Int
    let emojis = ["😔","😐","🙂","😊","🤩"]
    var body: some View {
        HStack(spacing: 12) {
            ForEach(1...5, id: \.self) { i in
                Button {
                    value = i
                } label: {
                    Text(emojis[i-1])
                        .font(.system(size: 32))
                        .padding(8)
                        .background(value == i ? Color.accentPurple.opacity(0.2) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .scaleEffect(value == i ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3), value: value)
                }
            }
        }
    }
}
