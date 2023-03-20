import Foundation
// swiftlint:disable switch_case_on_newline numbers_smell
enum APIError: Error {
	case unknownResponse
	case networkError(Error)
	case requestError(Int)
	case serverError(Int)
	case decodingError(DecodingError)
	case dataConversionError(String)
	case unhandledResponse
	case errorMessage(String)
}

extension APIError: CustomStringConvertible {
	static func error(from response: URLResponse?) -> APIError? {
		guard let http = response as? HTTPURLResponse else {
			return .unknownResponse
		}

		switch http.statusCode {
		case 200...299: return nil
		case 400...499: return .requestError(http.statusCode)
		case 500...599: return .serverError(http.statusCode)
		default: return .unhandledResponse
		}
	}

	private var localizedDescription: String {
		switch self {
		case .unknownResponse: return "Unknown Response"
		case .networkError(let error): return "Network Error: \(error.localizedDescription)"
		case .requestError(let statusCode): return "HTTP \(statusCode)"
		case .serverError(let statusCode): return "Server error (HTTP \(statusCode))"
		case .decodingError(let decodingError): return "Decoding error: \(decodingError)"
		case .dataConversionError(let message): return "\(message)"
		case .unhandledResponse: return "Unhandled response"
		case .errorMessage(let message): return "\(message)"
		}
	}

	var description: String {
		localizedDescription
	}
}
