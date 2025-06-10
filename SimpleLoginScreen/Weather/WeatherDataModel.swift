//
//  WeatherDataModel.swift
//  SimpleLoginScreen
//
//  Created by snlcom on 6/1/25.
//

import Foundation

struct OpenWeatherResponse: Decodable {
    let name: String
    let main: OpenWeatherMain
    let weather: [OpenWeatherWeather]
}


struct OpenWeatherMain: Decodable {
    let temp: Double
}

struct OpenWeatherWeather: Decodable {
    let description: String
    let main: String
}

struct OpenWeatherForecastResponse: Decodable {
    let list: [ForecastItem]
    let city: City
}

struct ForecastItem: Decodable {
    let main: OpenWeatherMain
    let weather: [OpenWeatherWeather]
    let dt_txt: String
}

struct City: Decodable {
    let name: String
}

public struct Weather {
    let location: String
    let temperature: String
    let description: String
    let main: String
    
    init(response: OpenWeatherResponse) {
        location = response.name
        temperature = "\(Int(response.main.temp))"
        description = response.weather.first?.description ?? ""
        main = response.weather.first?.main ?? ""
    }
    
}

func advice(for weather: Weather) -> String {
    let main = weather.main
    let temp = Int(weather.temperature) ?? 0

    switch main {
    case "Rain":
        return "비가 예상됩니다. 작업장 바닥 미끄럼 주의 및 방수 조치 바랍니다."
    case "Snow":
        return "눈이 내릴 수 있습니다. 작업장 및 통로 제설, 빙판길 미끄럼 사고에 주의하세요."
    case "Thunderstorm":
        return "천둥·번개가 예상됩니다. 크레인, 고소작업 등 고소작업은 중지하고, 실내에서 대기하세요."
    case "Drizzle":
        return "이슬비가 내릴 수 있습니다. 전기기구 방수 및 미끄럼 사고에 주의하세요."
    case "Clear":
        if temp >= 30 {
            return "폭염 주의! 작업 중 충분한 수분 섭취와 휴식을 취하세요. 햇볕에 장시간 노출되지 않도록 하세요."
        } else if temp <= 0 {
            return "한파 주의! 방한복 착용 및 동파 예방 조치 바랍니다."
        } else {
            return "쾌청한 날씨입니다. 기본 안전수칙을 준수하며 작업하세요."
        }
    case "Clouds":
        return "구름 많은 날씨입니다. 기상 변화에 유의하며 작업하세요."
    default:
        break
    }
    if temp >= 30 {
        return "폭염 주의! 작업 중 충분한 수분 섭취와 휴식을 취하세요."
    } else if temp <= 0 {
        return "한파 주의! 방한복 착용 및 동파 예방 조치 바랍니다."
    }
    return "특별한 기상 위험은 없으나, 항상 안전수칙을 준수하세요."
}
