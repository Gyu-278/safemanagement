//
//  Today'sweather.swift
//  SimpleLoginScreen
//
//  Created by snlcom on 6/1/25.
//


import SwiftUI

struct WeatherView: View {
    var openWeatherResponse: OpenWeatherResponse
    private let iconList = [
        "Clear": "☀️",
        "Clouds": "☁️",
        "Mist": "☁️",
        "": "?",
        "Drizzle": "🌧",
        "Thunderstorm": "⛈",
        "Rain": "🌧",
        "Snow": "🌨"
    ]
    var body: some View {
        let weather = Weather(response: openWeatherResponse)
        VStack(spacing: 4) { // 전체 간격도 조정 가능
            Text(weather.location)
                .font(.largeTitle)
                .padding(.bottom, 2) // 하단에만 약간의 여백
            Text(weather.temperature)
                .font(.system(size: 75))
                .bold()
                .padding(.bottom, 2)
            Text(iconList[weather.main] ?? "")
                .font(.system(size: 100))
                // .padding() 제거 또는 .padding(.bottom, 2)
            Text(weather.description)
                .font(.largeTitle)
                .padding(.top, 8) // 설명과 위 요소 사이만 조금 띄움
        }
    }
}
