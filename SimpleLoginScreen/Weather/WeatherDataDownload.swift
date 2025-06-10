//
//  WeatherDataDownload.swift
//  SimpleLoginScreen
//
//  Created by snlcom on 6/1/25.
//

import Foundation
import CoreLocation

class WeatherDataDownload {
    
    // 발급받은 OpenWeather API 키를 입력하세요
    private let API_KEY = "d6eece567014fb74cf9295bf299bbfe"

    func getTomorrowWeather(location: CLLocationCoordinate2D) async throws -> OpenWeatherResponse {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(API_KEY)&units=metric&lang=kr"
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedUrlString) else {
            fatalError("URL 생성 실패")
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("네트워크 오류")
        }
        let decodedData = try JSONDecoder().decode(OpenWeatherForecastResponse.self, from: data)
        // 내일 날짜의 낮 12시 예보를 우선 찾고, 없으면 첫 예보 사용
        if let tomorrowForecast = decodedData.list.first(where: { isTomorrowNoon(dateString: $0.dt_txt) }) ??
                                  decodedData.list.first(where: { isTomorrow(dateString: $0.dt_txt) }) {
            let weather = OpenWeatherResponse(
                name: decodedData.city.name,
                main: tomorrowForecast.main,
                weather: tomorrowForecast.weather
            )
            return weather
        } else {
            throw NSError(domain: "No forecast for tomorrow", code: 1)
        }
    }

    // 내일 날짜의 12시 예보 판별 함수
    func isTomorrowNoon(dateString: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let forecastDate = formatter.date(from: dateString) else { return false }
        let calendar = Calendar.current
        let now = Date()
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) else { return false }
        return calendar.isDate(forecastDate, inSameDayAs: tomorrow) && calendar.component(.hour, from: forecastDate) == 12
    }

    // 내일 날짜 판별 함수
    func isTomorrow(dateString: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let forecastDate = formatter.date(from: dateString) else { return false }
        let calendar = Calendar.current
        let now = Date()
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) else { return false }
        return calendar.isDate(forecastDate, inSameDayAs: tomorrow)
    }
    
    // 한국(서울) 기준으로 날씨를 가져오는 함수
    func getWeather(location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)) async throws -> OpenWeatherResponse {
        // lang=kr 추가 (한글 응답)
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(API_KEY)&units=metric&lang=kr"
        
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedUrlString) else {
            fatalError("URL 생성 실패")
        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("네트워크 오류")
        }
        
        let decodedData = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
        return decodedData
    }
}
