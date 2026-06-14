import SwiftUI

@main
struct FitnessApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Root Router

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.isOnboarded {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

// MARK: - Main Tab View

struct MainTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView(selection: $appState.currentTab) {
            ForEach(AppState.Tab.allCases, id: \.self) { tab in
                tabContent(for: tab)
                    .tabItem {
                        Label(tab.title, systemImage: tab.icon)
                    }
                    .tag(tab)
            }
        }
        .tint(.accentMint)
        // Dark tab bar styling
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.appSurface)
            appearance.stackedLayoutAppearance.selected.iconColor   = UIColor(Color.accentMint)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.accentMint)]
            appearance.stackedLayoutAppearance.normal.iconColor     = UIColor(Color.textMuted)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes  = [.foregroundColor: UIColor(Color.textMuted)]
            UITabBar.appearance().standardAppearance   = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    @ViewBuilder
    func tabContent(for tab: AppState.Tab) -> some View {
        switch tab {
        case .home:      HomeView()
        case .workout:   WorkoutView()
        case .nutrition: MealPlanView()
        case .progress:  ProgressTrackingView()
        case .rules:     RulesView()
        }
    }
}
