import Foundation
import Alamofire

class NetworkConfig {
    static let shared = NetworkConfig()
    
    // MARK: Базовый URL
    var baseURL: URL {
#if DEBUG
        return URL(string: "https://dev.example.com")!
#elseif RELEASE
        return URL(string: "https://prod.example.com")!
#endif
    }
    
    // MARK: Управление доверием
    func createTrustManager() -> ServerTrustManager {
#if RELEASE
        return ServerTrustManager(evaluators: ["bankok.akbars.ru": PublicKeysTrustEvaluator()])
#else
        return ServerTrustManager(evaluators: ["217.198.15.118": DisabledTrustEvaluator()])
#endif
    }
    
    // MARK: Сколько секунд ждем ответа
    let timeoutInterval: TimeInterval = 30
    
    // MARK: Словарь ошибок
    let errorMessages: [Int: String] = [
        400: "Bad Request",
        401: "Unauthorized",
        403: "Forbidden",
        404: "Not Found"
    ]
    
    let unknownError = "Unknown Error"
    
    // MARK: Предопределённые Headers
    var defaultHeaders: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-App-Platform": "iOS",
        "X-App-Version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    ]
    // Авторизационные токены (Authorization, SessionToken) Прокидываем снаружи
    // "DeviceToken" Прокидываем снаружи
    // "X-Timezone" Прокидываем снаружи
    
    // MARK: Методы для управления заголовками
    func addDefaultHeader(field: String, value: String) {
        defaultHeaders.update(name: field, value: value)
    }
    
    func removeDefaultHeader(field: String) {
        defaultHeaders.remove(name: field)
    }

    private init() {}
}
