//
//  ManualView.swift
//  SimpleLoginScreen
//
//  Created by snlcom on 6/1/25.
//

// Manual/ManualView.swift
import SwiftUI

struct ManualView: View {
    @Binding var isManualCompleted: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Text("건설현장 안전 매뉴얼")
                .font(.largeTitle)
                .bold()
                .padding(.top, 40)
            
            // 이미지 표시
            Image("constructionSafety")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 5)
                .padding(.bottom, 8)
            
            // 안전 매뉴얼 내용
            VStack(alignment: .leading, spacing: 12) {
                Text("1. 보호장비 착용")
                    .font(.headline)
                Text("모든 근로자는 헬멧, 안전화, 장갑 등 보호장비를 반드시 착용해야 합니다.")
                    .font(.body)
                
                Text("2. 작업 전 안전점검")
                    .font(.headline)
                Text("기계 및 장비의 이상 유무를 확인하고, 위험요소가 없는지 점검합니다.")
                    .font(.body)
                
                Text("3. 안전수칙 준수")
                    .font(.headline)
                Text("안전 표지판을 확인하고, 정해진 통로와 방법으로 이동 및 작업합니다.")
                    .font(.body)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Spacer()
            Button("확인 완료") {
                isManualCompleted = true
                dismiss()
            }
            .buttonStyle(MyCustomButtonStyle())
            .padding(.bottom, 30)
        }
        .padding()
    }
}
