//
//  ContentView.swift
//  WeSplit
//
//  Created by Juan Carlos Robledo Morales on 19/08/24.
//

import SwiftUI


struct TipSelectionView: View {
    @Binding var tipPercentage: Int
    @Environment(\.presentationMode) var presentationMode
    var checkAmount: Double

    var body: some View {
        List(0..<101) { percentage in
            let tipValue = checkAmount / 100 * Double(percentage)
            Text("\(percentage)% (Tip total: \(tipValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD")))")
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    tipPercentage = percentage
                    presentationMode.wrappedValue.dismiss()
                }
        }
        .navigationTitle("Select Tip Percentage")
    }
}



struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool

    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount

        return amountPerPerson
    }

    var grandTotal: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let total = checkAmount + tipValue

        return total
    }

    var body: some View {
        NavigationStack{
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                VStack {
                                    Section(header: Text("How much do you want to tip?")
                                        .frame(maxWidth: .infinity, alignment: .center)) {
                                        NavigationLink(destination: TipSelectionView(tipPercentage: $tipPercentage, checkAmount: checkAmount)) {
                                            Text("\(tipPercentage)%")
                                                .foregroundColor(.purple)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                }
                Section(header: Text("Amount per person")) {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                
                Section(header: Text("Total amount")) {
                                    Text(grandTotal, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .foregroundColor(tipPercentage == 0 ? .red : .primary)
                }
                if tipPercentage == 0 {
                    VStack {
                        Text("You are not leaving a tip 😅")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                } else {
                    
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
