//
//  FirstView.swift
//  SimpleLoginScreen
//
//  Created by snlcom on 6/1/25.

import SwiftUI
import CoreLocationUI

struct FirstView: View {
    @EnvironmentObject var locationManager: LocationManager

    var body: some View {
        // 위치가 있으면 날씨 화면, 없으면 위치 요청 화면
        if locationManager.location != nil {
            // 날씨 화면으로 전환 (ContentWeatherView는 이미 구현되어 있다고 가정)
            ContentWeatherView()
                .environmentObject(locationManager)
        } else {
            VStack {
                Text("Weather")
                    .font(.largeTitle)
                    .padding()
                    .multilineTextAlignment(.center)
                
                LocationButton(.shareCurrentLocation) {
                    // 액션 비워도 됨
                }
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.bottom, 20)
                
                Text("위치 정보를 허용해주세요.")
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                
                Button("위치 권한 거부하기") {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                }
                .foregroundColor(.red)
                .padding(.top, 10)
                .padding(.horizontal)
                
                Text("위치 권한을 거부하면 서울 날씨가 표시됩니다.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }
        }
    }
}

