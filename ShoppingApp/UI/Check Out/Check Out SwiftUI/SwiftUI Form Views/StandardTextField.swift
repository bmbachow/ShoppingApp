//
//  StandardTextField.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import SwiftUI
import Combine

struct StandardTextField: View {
    
    enum TextFieldType {
        case anyInput
        case cardNumber
        case bankACcountNumber
        case bankRoutingNumber
        case zipCode
        case none
        
        func filterRule(_ character: Character) -> Bool {
            switch self {
            case .anyInput, .none:
                return true
            case .cardNumber, .bankACcountNumber, .bankRoutingNumber, .zipCode:
                return character.isNumber
            }
        }
        
        func validationRule(_ string: String) -> Bool {
            if string.contains(where: {!self.filterRule($0)}) {
                return false
            }
            return string.count >= self.minimumLength && string.count <= self.maximumLength
        }
        
        var minimumLength: Int {
            switch self {
            case .anyInput:
                return 1
            case .cardNumber:
                return 13
            case .bankACcountNumber:
                return 8
            case .bankRoutingNumber:
                return 9
            case .zipCode:
                return 5
            case .none:
                return 0
            }
        }
        
        var maximumLength: Int {
            switch self {
            case .anyInput:
                return 200
            case .cardNumber:
                return 19
            case .bankACcountNumber:
                return 18
            case .bankRoutingNumber:
                return 9
            case .zipCode:
                return 5
            case .none:
                return Int.max
            }
        }
    }
    
    var invalidImage: some View = Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.yellow)
    var validImage: some View = Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
    
    let titleKey: LocalizedStringKey
    private var text: Binding<String>
    
    static let standardFontSize: CGFloat = 17
    let fontSize: CGFloat
    
    @State var inputIsValid = false
    
    let textFieldType: StandardTextField.TextFieldType    
    init(_ titleKey: LocalizedStringKey, text: Binding<String>, textFieldType: TextFieldType, fontSize: CGFloat? = nil) {
        let fontSize = fontSize ?? StandardTextField.standardFontSize
        self.titleKey = titleKey
        self.text = text
        self.textFieldType = textFieldType
        self.fontSize = fontSize
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 0.5)
                .frame(height: self.fontSize + 24)
                .foregroundColor(.white)
            
            TextField(self.titleKey, text: self.text)
                .font(Font(UIConstants.standardFont(size: self.fontSize, style: .regular)))
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                .onReceive(Just(self.text.wrappedValue)) { newValue in
                    self.text.wrappedValue = self.text.wrappedValue.filter({self.textFieldType.filterRule($0)})
                    
                    self.text.wrappedValue = String(self.text.wrappedValue.prefix(self.textFieldType.maximumLength))
                    
                    self.inputIsValid = self.textFieldType.validationRule(self.text.wrappedValue)
                }
            if self.textFieldType != .none {
                HStack {
                    Spacer()
                    if self.inputIsValid {
                        self.validImage
                    } else {
                        self.invalidImage
                    }
                    Spacer()
                        .frame(width: self.fontSize/2)
                }
            }
        }
        .onAppear(perform: {
            self.inputIsValid = self.textFieldType.validationRule(self.text.wrappedValue)
        })
    }
}

/*
struct StandardTextField_Previews: PreviewProvider {
    static var previews: some View {
        StandardTextField()
    }
}
*/
