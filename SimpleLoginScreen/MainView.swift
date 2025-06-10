import SwiftUI

struct MainView: View {
    enum SheetType: String, Identifiable, Hashable {
        case weather, manual, safeManagement
        var id: String { rawValue }
    }

    let username: String
    @State private var shownSheet: SheetType?
    @State private var isManualCompleted = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Welcome, \(username)!")
                    .font(.title)
                    .padding()
                    .multilineTextAlignment(.center)

                List {
                    Text("공지사항 1.매일 아침 안전 교육 완료하기")
                    Text("공지사항 2.날씨에 따른 작업 별 위험도 확인하기")
                }
                .frame(height: 100)
                .listStyle(.plain)

                Button("Manual for Safety") {
                    shownSheet = .manual
                }
                .buttonStyle(MyCustomButtonStyle())

                Button("Today's Weather") {
                    shownSheet = .weather
                }
                .buttonStyle(MyCustomButtonStyle())
                .disabled(!isManualCompleted)

                Button("Safe Management") {
                    shownSheet = .safeManagement
                }
                .buttonStyle(MyCustomButtonStyle())
                .disabled(!isManualCompleted)

                NavigationLink(
                    destination: CommunityChatView(username: username),
                    label: {
                        Text("Community")
                    }
                )
                .buttonStyle(MyCustomButtonStyle())
                .disabled(!isManualCompleted)

                NavigationLink("Go to Report Page", destination: ReportView())
                    .disabled(!isManualCompleted)
            }
            .padding()
            .sheet(item: $shownSheet) { sheet in
                switch sheet {
                case .manual:
                    ManualView(isManualCompleted: $isManualCompleted)
                case .weather:
                    FirstView()
                case .safeManagement:
                    SafeManagementView()
                }
            }
        }
    }
}


struct ReportView: View {
    var body: some View {
        Text("여기는 신고 페이지입니다.")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(username: "Group4_Owner")
    }
}

struct MyCustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 30)
            .background(configuration.isPressed ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
