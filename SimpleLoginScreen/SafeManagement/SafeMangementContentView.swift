//
//  SafeMangementContentView.swift
//  SimpleLoginScreen
//
//  Created by snlcom on 6/3/25.
//
import SwiftUI
import CoreMotion
import UniformTypeIdentifiers

struct SafeManagementView: View {
    enum Mode {
        case realtime, csv
    }
    
    enum ImportType {
        case accel, gyro
    }

    func handleFileImport(_ result: Result<[URL], Error>) {
        if case .success(let urls) = result, let url = urls.first {
            if importType == .accel {
                accelURL = url
            } else if importType == .gyro {
                gyroURL = url
            }
        }
    }

    // 모드 선택
    @State private var selectedMode: Mode = .realtime
    @State private var showImporter = false
    @State private var importType: ImportType?
    @State private var accelURL: URL?
    @State private var gyroURL: URL?
    
    // 공통 상태
    @State private var resultMessage: String?
    @State private var fallDetected: Bool?
    
    // CSV 모드 전용
    @State private var accelFallCount = 0
    @State private var gyroFallCount = 0
    
    // 실시간 모드 전용
    @StateObject private var motionManager = MotionManager()
    @State private var realtimeFallCount = 0
    
    var body: some View {
        VStack(spacing: 24) {
            Picker("모드 선택", selection: $selectedMode) {
                Text("실시간 감지").tag(Mode.realtime)
                Text("CSV 분석").tag(Mode.csv)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedMode == .realtime {
                realtimeSection
            } else {
                csvSection
            }
            
            Spacer()
        }
        .onChange(of: motionManager.accelData) { _ in
            if selectedMode == .realtime {
                checkRealtimeFall()
            }
        }
        .onChange(of: motionManager.gyroData) { _ in
            if selectedMode == .realtime {
                checkRealtimeFall()
            }
        }
    }
    
    // MARK: - 실시간 센서 섹션
    var realtimeSection: some View {
        VStack(spacing: 24) {
            Text("실시간 낙상 감지")
                .font(.title2)
                .bold()
            
            Button(motionManager.isMonitoring ? "감지 중지" : "감지 시작") {
                toggleRealtimeMonitoring()
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 20)
            .background(Color(.systemGray5))
            .foregroundColor(motionManager.isMonitoring ? .red : .blue)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(motionManager.isMonitoring ? Color.red : Color.blue, lineWidth: 1)
            )
            
            if let accel = motionManager.accelData {
                Text("가속도: x: \(String(format: "%.2f", accel.acceleration.x)), y: \(String(format: "%.2f", accel.acceleration.y)), z: \(String(format: "%.2f", accel.acceleration.z))")
                    .font(.caption2)
            }
            
            if let gyro = motionManager.gyroData {
                Text("자이로: x: \(String(format: "%.2f", gyro.rotationRate.x)), y: \(String(format: "%.2f", gyro.rotationRate.y)), z: \(String(format: "%.2f", gyro.rotationRate.z))")
                    .font(.caption2)
            }
            
            let detected = fallDetected ?? false
            Text(detected ? "⚠️ 낙상 발생 (\(realtimeFallCount)회)" : "이상 없음")
                .foregroundColor(detected ? .red : .green)

        }
    }
    
    // MARK: - CSV 분석 섹션
    var csvSection: some View {
        VStack(spacing: 24) {
            Text("CSV 파일 분석")
                .font(.title2)
                .bold()
            
            Button("가속도계 CSV 선택") {
                importType = .accel
                showImporter = true
            }
            .buttonStyle(MyCustomButtonStyle())
            
            if let accelURL = accelURL {
                Text("선택된 파일: \(accelURL.lastPathComponent)")
                    .font(.caption2)
            }
            
            Button("자이로스코프 CSV 선택") {
                importType = .gyro
                showImporter = true
            }
            .buttonStyle(MyCustomButtonStyle())
            
            if let gyroURL = gyroURL {
                Text("선택된 파일: \(gyroURL.lastPathComponent)")
                    .font(.caption2)
            }
            
            if accelURL != nil && gyroURL != nil {
                Button("분석 실행") {
                    analyzeCSVFall()
                }
                .buttonStyle(MyCustomButtonStyle())
            }
            // CSV 분석 결과
            let detected = fallDetected ?? false
            Text(
                detected
                ? "⚠️ 낙상 감지 (\(accelFallCount)회/가속도, \(gyroFallCount)회/자이로)"
                : "이상 없음"
            )
            .foregroundColor(detected ? .red : .green)
        }
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [UTType.commaSeparatedText],
            allowsMultipleSelection: false
        ) { result in
            handleFileImport(result)
        }
    }
    
    // MARK: - 공통 함수
    func toggleRealtimeMonitoring() {
        if motionManager.isMonitoring {
            motionManager.stopUpdates()
            fallDetected = false
            realtimeFallCount = 0
        } else {
            motionManager.startUpdates()
        }
    }
    
    // MARK: - 실시간 분석 로직
    func checkRealtimeFall() {
        guard let accel = motionManager.accelData,
              let gyro = motionManager.gyroData else { return }
        
        let accelMag = sqrt(pow(accel.acceleration.x, 2) + pow(accel.acceleration.y, 2) + pow(accel.acceleration.z, 2))
        let gyroMag = sqrt(pow(gyro.rotationRate.x, 2) + pow(gyro.rotationRate.y, 2) + pow(gyro.rotationRate.z, 2))
        
        // 낙상 감지 기준 (값 조정 필요)
        let isFall = accelMag > 2.5 || gyroMag > 5.0
        
        DispatchQueue.main.async {
            if isFall {
                realtimeFallCount += 1
                fallDetected = true
                resultMessage = "실시간 낙상 감지 (\(realtimeFallCount)회)"
            } else {
                fallDetected = false
                resultMessage = nil
            }
        }
    }
    
    // MARK: - CSV 분석 로직
    func analyzeCSVFall() {
        guard let accelURL = accelURL, let gyroURL = gyroURL else { return }
        
        let accelResult = analyzeAccelFall(from: accelURL)
        let gyroResult = analyzeGyroFall(from: gyroURL)
        
        accelFallCount = accelResult.count
        gyroFallCount = gyroResult.count
        
        fallDetected = (accelFallCount > 0 || gyroFallCount > 0)
        resultMessage = (fallDetected ?? false)
            ? "CSV 분석 결과: 낙상 감지"
            : "CSV 분석 결과: 이상 없음"
    }
    
    // (기존 CSV 분석 함수들 유지)
    func analyzeAccelFall(from url: URL) -> [Int] {
        guard let data = try? String(contentsOf: url) else { return [] }
        let lines = data.components(separatedBy: .newlines)
        guard lines.count > 1 else { return [] }
        let header = lines[0].components(separatedBy: ",")
        guard let xIdx = header.firstIndex(where: { $0.lowercased().contains("x") }),
              let yIdx = header.firstIndex(where: { $0.lowercased().contains("y") }),
              let zIdx = header.firstIndex(where: { $0.lowercased().contains("z") }) else { return [] }
        let threshold: Double = 15.0
        var indices: [Int] = []
        for (i, line) in lines.dropFirst().enumerated() {
            let values = line.components(separatedBy: ",")
            if values.count <= max(xIdx, yIdx, zIdx) { continue }
            guard let x = Double(values[xIdx]),
                  let y = Double(values[yIdx]),
                  let z = Double(values[zIdx]) else { continue }
            let magnitude = (x * x + y * y + z * z).squareRoot()
            if magnitude > threshold {
                indices.append(i)
            }
        }
        return indices
    }
    
    func analyzeGyroFall(from url: URL) -> [Int] {
        guard let data = try? String(contentsOf: url) else { return [] }
        let lines = data.components(separatedBy: .newlines)
        guard lines.count > 1 else { return [] }
        let header = lines[0].components(separatedBy: ",")
        guard let xIdx = header.firstIndex(where: { $0.lowercased().contains("x") }),
              let yIdx = header.firstIndex(where: { $0.lowercased().contains("y") }),
              let zIdx = header.firstIndex(where: { $0.lowercased().contains("z") }) else { return [] }
        let threshold: Double = 240.0 // deg/s, 논문 기준
        var indices: [Int] = []
        for (i, line) in lines.dropFirst().enumerated() {
            let values = line.components(separatedBy: ",")
            if values.count <= max(xIdx, yIdx, zIdx) { continue }
            guard let x = Double(values[xIdx]),
                  let y = Double(values[yIdx]),
                  let z = Double(values[zIdx]) else { continue }
            let magnitude = (x * x + y * y + z * z).squareRoot()
            if magnitude > threshold {
                indices.append(i)
            }
        }
        return indices
    }

}

// MARK: - CoreMotion 관리 클래스
class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    @Published var accelData: CMAccelerometerData?
    @Published var gyroData: CMGyroData?
    @Published var isMonitoring = false
    
    func startUpdates() {
        guard !isMonitoring else { return }
        isMonitoring = true
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
        
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            self?.accelData = data
        }
        
        motionManager.startGyroUpdates(to: .main) { [weak self] data, _ in
            self?.gyroData = data
        }
    }
    
    func stopUpdates() {
        guard isMonitoring else { return }
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        isMonitoring = false
    }
}
