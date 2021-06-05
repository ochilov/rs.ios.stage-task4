import Foundation

private struct RomanSymbol {
	
}

public extension Int {
	
	var roman: String? {
		if self < 1 || 4000 <= self {
			return nil
		}
		var remainder = self
		var romanNumb = ""
		for sym in Self.romanSymbolsTable.reversed() {
			let symCount = remainder / sym.value
			romanNumb += String(repeating: sym.symbol, count: symCount)
			remainder %= sym.value
			if remainder >= sym.value - sym.prefixValue {
				romanNumb += sym.prefixSymbol + sym.symbol
				remainder -= sym.value - sym.prefixValue
			}
		}
		return romanNumb
	}
	
	private struct RomanSymbol {
		let symbol: String
		let value: Int
		let prefixSymbol: String
		let prefixValue: Int
	}
	private static let romanSymbolsTable = [
		RomanSymbol(symbol: "I", value:    1, prefixSymbol:  "", prefixValue:   0),
		RomanSymbol(symbol: "V", value:    5, prefixSymbol: "I", prefixValue:   1),
		RomanSymbol(symbol: "X", value:   10, prefixSymbol: "I", prefixValue:   1),
		RomanSymbol(symbol: "L", value:   50, prefixSymbol: "X", prefixValue:  10),
		RomanSymbol(symbol: "C", value:  100, prefixSymbol: "X", prefixValue:  10),
		RomanSymbol(symbol: "D", value:  500, prefixSymbol: "C", prefixValue: 100),
		RomanSymbol(symbol: "M", value: 1000, prefixSymbol: "C", prefixValue: 100),
	]
}
