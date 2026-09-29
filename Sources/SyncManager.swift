import Foundation
import Combine

class SyncManager: ObservableObject {
    static let shared = SyncManager()
    
    @Published var notes: String = UserDefaults.standard.string(forKey: "notes") ?? "" {
        didSet {
            UserDefaults.standard.set(notes, forKey: "notes")
            if isSyncing {
                pushToFirebase(text: notes)
            }
        }
    }
    
    @Published var roomCode: String = ""
    @Published var isSyncing: Bool = false
    
    private let projectId = "privacy-overlay-4cf1f"
    private var timer: Timer?
    private var lastLocalUpdate: TimeInterval = 0
    private var lastRemoteUpdate: TimeInterval = 0
    
    func toggleSync() {
        if isSyncing {
            stopSync()
        } else {
            startSync()
        }
    }
    
    private func startSync() {
        // Generate random 4 digit code
        roomCode = String(format: "%04d", Int.random(in: 1000...9999))
        isSyncing = true
        lastLocalUpdate = Date().timeIntervalSince1970
        
        // Initial push
        pushToFirebase(text: notes)
        
        // Start polling every 1.5 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] _ in
            self?.pollFirebase()
        }
    }
    
    private func stopSync() {
        isSyncing = false
        roomCode = ""
        timer?.invalidate()
        timer = nil
    }
    
    private func pushToFirebase(text: String) {
        guard isSyncing, !roomCode.isEmpty else { return }
        
        let currentTimestamp = Date().timeIntervalSince1970
        lastLocalUpdate = currentTimestamp
        
        let url = URL(string: "https://firestore.googleapis.com/v1/projects/\(projectId)/databases/(default)/documents/rooms/\(roomCode)?updateMask.fieldPaths=text&updateMask.fieldPaths=timestamp")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "fields": [
                "text": ["stringValue": text],
                "timestamp": ["doubleValue": currentTimestamp]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request).resume()
    }
    
    private func pollFirebase() {
        guard isSyncing, !roomCode.isEmpty else { return }
        
        let url = URL(string: "https://firestore.googleapis.com/v1/projects/\(projectId)/databases/(default)/documents/rooms/\(roomCode)")!
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let self = self else { return }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let fields = json["fields"] as? [String: Any],
               let timestampDict = fields["timestamp"] as? [String: Any],
               let remoteTimestamp = timestampDict["doubleValue"] as? Double,
               let textDict = fields["text"] as? [String: Any],
               let remoteText = textDict["stringValue"] as? String {
                
                DispatchQueue.main.async {
                    // Only update if the remote data is newer than our last local edit, and newer than what we last pulled
                    if remoteTimestamp > self.lastLocalUpdate && remoteTimestamp > self.lastRemoteUpdate {
                        self.lastRemoteUpdate = remoteTimestamp
                        // Prevent didSet from triggering a push back
                        let wasSyncing = self.isSyncing
                        self.isSyncing = false
                        self.notes = remoteText
                        self.isSyncing = wasSyncing
                    }
                }
            }
        }.resume()
    }
}
