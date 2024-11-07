//
//  RoundTextField.swift
//  Free-Viewing
//
//  Created by Gloria on 27/03/2024.
//

import SwiftUI

struct RoundTextField: View {
    @Binding var text: String
    let placeholder: LocalizedStringResource
    
    let onClick: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack() {
            TextField(placeholder.key, text: $text, prompt: Text(placeholder)                .foregroundStyle(.gray)
            )
            .font(.system(size: 16))
            .foregroundStyle(.white)
            .frame(height: 48)
            .padding(.leading, 12)
            .focused($isFocused)
            
            Button(action: {
                onClick()
            }) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            .padding(.trailing, 15)
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(isFocused ? Color.white : Color.gray, lineWidth: 2))
        .onTapGesture {
            isFocused = true
        }
    }
}

struct RoundTextField_Previews: PreviewProvider {
    @State static var text = ""
    
    static var previews: some View {
        RoundTextField(text: $text, placeholder: "name", onClick: {
            
        })
    }
}



