import Foundation

extension Double {
    var formattedMiles: String {
        "\(formatted(.number.precision(.fractionLength(1)))) mi"
    }

    var formattedMinutes: String {
        "\(formatted(.number.precision(.fractionLength(0)))) min"
    }

    var formattedPace: String {
        guard isFinite, self > 0 else { return "--" }
        let wholeMinutes = Int(self)
        let seconds = Int(((self - Double(wholeMinutes)) * 60).rounded())
        return "\(wholeMinutes):\(String(format: "%02d", seconds)) /mi"
    }
}
