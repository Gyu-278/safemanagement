//
//  ContentView.swift
//  SimpleLoginScreen
//
//  Created by snlcom on 6/1/25.
//

import SwiftUI
import CoreLocation

struct EquatableCoordinate: Equatable {
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: EquatableCoordinate, rhs: EquatableCoordinate) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

struct ContentWeatherView: View {
    @EnvironmentObject var locationManager : LocationManager
    var weatherDataDownload = WeatherDataDownload()
    @State var openWeatherResponse : OpenWeatherResponse?
    @State var tomorrowWeatherResponse : OpenWeatherResponse?
    @State var showTomorrow = false

    var body: some View {
        VStack {
            if let location = locationManager.location {
                if showTomorrow {
                    if let tomorrowWeatherResponse = tomorrowWeatherResponse {
                        WeatherView(openWeatherResponse: tomorrowWeatherResponse)
                        VStack(alignment: .center, spacing: 0) {
                            Text(advice(for: Weather(response: tomorrowWeatherResponse)))
                                .font(.headline)
                                .foregroundColor(.orange)
                                .multilineTextAlignment(.center)
                                .padding(.top, 24) // 상단 여백만
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 2)
                            Spacer()
                            Button("오늘 날씨") {
                                showTomorrow = false
                            }
                            .padding(.bottom, 24)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 50, alignment: .top) // 회색 칸 자체 높이 + 위 정렬
                        .frame(maxHeight: 200)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 30)
                    } else {
                        ProgressView()
                            .task(id: EquatableCoordinate(coordinate: location)) {
                                tomorrowWeatherResponse = try? await weatherDataDownload.getTomorrowWeather(location: location)
                            }
                    }
                } else {
                    if let openWeatherResponse = openWeatherResponse {
                        WeatherView(openWeatherResponse: openWeatherResponse)
                        VStack(alignment: .center, spacing: 0) {
                            Text(advice(for: Weather(response: openWeatherResponse)))
                                .font(.headline)
                                .foregroundColor(.orange)
                                .multilineTextAlignment(.center)
                                .padding(.top, 24)
                                .padding(.horizontal, 2)
                            Spacer()
                            Button("내일 날씨") {
                                showTomorrow = true
                            }
                            .padding(.bottom, 24)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 50, alignment: .top)
                        .frame(maxHeight: 200)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 30)
                    } else {
                        ProgressView()
                            .task(id: EquatableCoordinate(coordinate: location)) {
                                openWeatherResponse = try? await weatherDataDownload.getWeather(location: location)
                            }
                    }
                }
            } else {
                if locationManager.isLoading {
                    ProgressView()
                } else {
                    FirstView()
                }
            }
        }
    }
}
