import Foundation
import EventKit
import SwiftUI

// MARK: - Calendar Sync Service

class CalendarSyncService: ObservableObject {
    private let store = EKEventStore()
    private let calendarKey = "apex_calendar_identifier"

    @Published var status: EKAuthorizationStatus = EKEventStore.authorizationStatus(for: .event)

    func requestPermission() async -> Bool {
        return await withCheckedContinuation { continuation in
            store.requestAccess(to: .event) { [weak self] granted, _ in
                DispatchQueue.main.async {
                    self?.status = EKEventStore.authorizationStatus(for: .event)
                    continuation.resume(returning: granted)
                }
            }
        }
    }

    func scheduleWorkouts(plan: WorkoutPlan, at time: Date) throws {
        let calendar = try apexCalendar()
        removeExistingEvents(in: calendar)

        for day in plan.days where !day.isRestDay {
            let event = EKEvent(eventStore: store)
            event.title = "\(day.dayName) — APEX"
            event.calendar = calendar
            event.startDate = nextOccurrence(of: day.weekday, at: time)
            event.endDate = event.startDate.addingTimeInterval(TimeInterval(day.estimatedMinutes * 60))
            event.addAlarm(EKAlarm(relativeOffset: -30 * 60))
            event.recurrenceRules = [
                EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: nil)
            ]
            try store.save(event, span: .futureEvents)
        }
    }

    func removeExistingEvents(in calendar: EKCalendar) {
        let end = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        let predicate = store.predicateForEvents(withStart: Date(), end: end, calendars: [calendar])
        store.events(matching: predicate).forEach { try? store.remove($0, span: .futureEvents) }
    }

    // MARK: - Private

    private func apexCalendar() throws -> EKCalendar {
        if let id = UserDefaults.standard.string(forKey: calendarKey),
           let existing = store.calendar(withIdentifier: id) {
            return existing
        }
        let cal = EKCalendar(for: .event, eventStore: store)
        cal.title = "APEX Workouts"
        cal.cgColor = UIColor(Color.accentMint).cgColor
        cal.source = preferredSource()
        try store.saveCalendar(cal, commit: true)
        UserDefaults.standard.set(cal.calendarIdentifier, forKey: calendarKey)
        return cal
    }

    private func preferredSource() -> EKSource {
        store.sources.first { $0.sourceType == .calDAV && $0.title == "iCloud" }
            ?? store.sources.first { $0.sourceType == .calDAV }
            ?? store.sources.first { $0.sourceType == .local }
            ?? store.sources[0]
    }

    // App weekday (1=Mon…7=Sun) → Calendar weekday (1=Sun, 2=Mon…7=Sat)
    private func nextOccurrence(of appWeekday: Int, at time: Date) -> Date {
        let tc = Calendar.current.dateComponents([.hour, .minute], from: time)
        var comps = DateComponents()
        comps.weekday = (appWeekday % 7) + 1
        comps.hour = tc.hour
        comps.minute = tc.minute
        comps.second = 0
        return Calendar.current.nextDate(after: Date(), matching: comps, matchingPolicy: .nextTime) ?? Date()
    }
}

// MARK: - Calendar Sync Sheet

struct CalendarSyncSheet: View {
    let plan: WorkoutPlan
    @StateObject private var service = CalendarSyncService()
    @State private var workoutTime: Date = {
        Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date()
    }()
    @State private var isSyncing = false
    @State private var showSuccess = false
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss

    var trainingDays: [WorkoutDay] { plan.days.filter { !$0.isRestDay } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Workouts to be scheduled
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Workouts to schedule")
                            .font(.headlineLarge).foregroundColor(.textPrimary)
                        ForEach(trainingDays) { day in
                            HStack(spacing: 12) {
                                Image(systemName: "calendar.badge.clock")
                                    .foregroundColor(.accentMint)
                                    .font(.title3)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(day.dayName)
                                        .font(.headlineSmall).foregroundColor(.textPrimary)
                                    Text("\(weekdayName(day.weekday)) · \(day.estimatedMinutes) min")
                                        .font(.bodySmall).foregroundColor(.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "arrow.2.squarepath")
                                    .font(.caption)
                                    .foregroundColor(.textMuted)
                            }
                            .padding(12)
                            .background(Color.appCard)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }

                    // Time picker
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Workout time")
                            .font(.headlineLarge).foregroundColor(.textPrimary)
                        DatePicker("", selection: $workoutTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .tint(.accentMint)
                    }
                    .padding(16)
                    .background(Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // Info note
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.accentPurple)
                        Text("Workouts are added as weekly recurring events in a dedicated 'APEX Workouts' calendar, with a 30-minute reminder before each session.")
                            .font(.bodySmall).foregroundColor(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(14)
                    .background(Color.accentPurple.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    if let error = errorMessage {
                        Text(error)
                            .font(.bodySmall).foregroundColor(.accentRed)
                            .padding(12)
                            .background(Color.accentRed.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    PrimaryButton(title: isSyncing ? "Adding to Calendar…" : "Add to Calendar", isLoading: isSyncing) {
                        Task { await syncToCalendar() }
                    }
                    .padding(.bottom, 20)
                }
                .padding(20)
            }
            .appScreen()
            .navigationTitle("Calendar Sync")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }.foregroundColor(.accentMint)
                }
            }
            .alert("Added to Calendar", isPresented: $showSuccess) {
                Button("Done") { dismiss() }
            } message: {
                Text("Your \(trainingDays.count) weekly workouts have been scheduled with 30-minute reminders.")
            }
        }
    }

    private func syncToCalendar() async {
        isSyncing = true
        errorMessage = nil

        let granted = await service.requestPermission()
        guard granted else {
            errorMessage = "Calendar access denied. Go to Settings → Privacy & Security → Calendars and allow APEX."
            isSyncing = false
            return
        }

        do {
            try service.scheduleWorkouts(plan: plan, at: workoutTime)
            isSyncing = false
            showSuccess = true
        } catch {
            errorMessage = error.localizedDescription
            isSyncing = false
        }
    }

    private func weekdayName(_ weekday: Int) -> String {
        ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"][(weekday - 1) % 7]
    }
}
