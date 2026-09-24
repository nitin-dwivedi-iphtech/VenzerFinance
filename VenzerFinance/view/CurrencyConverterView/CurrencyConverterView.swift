//
//  CurrencyConverterView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 22/09/26.
//

import SwiftUI

struct CurrencyConverterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var fromCountryCurrency: Country = .india
    @State private var toCountryCurrency: Country = .usa
    @State private var dragOffset: CGFloat = 0
    @State private var isConverted: Bool = false
    @State private var showAmountSheet = false
    
    @StateObject private var viewModel = CurrencyConverterViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                flagHeader
                heading

                amountButton
                
                VStack(spacing: -25) {
                    conversionCard(country: fromCountryCurrency, direction: .inward, from: true)
                    conversionCard(country: toCountryCurrency, direction: .inward, from: false)
                }
                .overlay {
                    swapButton
                }
                
                expenseText
                swipeActionView
                
                Spacer()
            }
        }
        .background { CustomBackgroundView() }
        .task {
            await viewModel.fetchRate(from: fromCountryCurrency, to: toCountryCurrency)
        }
        .onChange(of: fromCountryCurrency) { _, newFrom in
            Task { await viewModel.fetchRate(from: newFrom, to: toCountryCurrency) }
        }
        .onChange(of: toCountryCurrency) { _, newTo in
            Task { await viewModel.fetchRate(from: fromCountryCurrency, to: newTo) }
        }
        .sheet(isPresented: $showAmountSheet) {
            AmountInputSheet(amountText: $viewModel.amountText, fromCountry: fromCountryCurrency, toCountry: toCountryCurrency, rate: viewModel.rate)
                
        }
    }
    
    // MARK: - Subviews
    
    private var flagHeader: some View {
        HStack(spacing: -8) {
            ForEach(Array(Country.allCases.enumerated()), id: \.element.id) { index, country in
                flagImage(flag: country.flagImageName)
                    .zIndex(Double(Country.allCases.count - index))
            }
        }
    }
    
    private var swapButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                let temp = fromCountryCurrency
                fromCountryCurrency = toCountryCurrency
                toCountryCurrency = temp
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                Text("Swap")
                    .foregroundStyle(.black)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Capsule().fill(Color.white))
            .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
        }
        .padding(.vertical, -12)
        .zIndex(1)
    }

    @ViewBuilder
    private func flagImage(flag: String) -> some View {
        Image(flag)
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 3))
            .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
    }

    private var heading: some View {
        VStack {
            Text("Currency Converter")
                .font(.system(size: 28, weight: .medium))
            Text("Instantly swaps between currencies worldwide")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
        }
        .padding(.vertical, 10)
    }

    private var amountButton: some View {
        Button { showAmountSheet = true } label: {
            HStack(spacing: 8) {
                Image(systemName: "pencil.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color("CardColor"))
                Text("Amount: \(fromCountryCurrency.currencySymbol)\(viewModel.amountText)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.white, in: Capsule())
            .overlay(Capsule().stroke(Color.black.opacity(0.06), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
        }
        .padding(.bottom, 2)
    }

    @ViewBuilder
    private func conversionCard(country: Country, direction: NotchedCardShape.NotchDirection = .inward, from: Bool) -> some View {
        let textColor: Color = from ? .black : .white
        let cardPosition: NotchedCardShape.NotchPosition = from ? .top : .bottom
        let backgroundColor: String = from ? "InsideCarBottomColor" : "CardColor"
        
        VStack {
            HStack {
                Text(from ? "You Pay" : "You Get")
                    .font(.system(size: 15))
                    .foregroundStyle(textColor.opacity(0.7))
                
                Spacer()
                
                Image(systemName: from ? "square.and.arrow.up" : "square.and.arrow.down")
                    .font(.system(size: 15))
                    .foregroundStyle(textColor)
            }
            
            Rectangle()
                .fill(textColor.opacity(0.15))
                .frame(height: 1)
                .padding(.vertical, 8)
            
            HStack {
                customPicker(selection: from ? $fromCountryCurrency : $toCountryCurrency)
                    .padding(.trailing, 5)
                    .background(Color.white, in: Capsule())
                
                Spacer()
                
                HStack(spacing: 2) {
                    Text(country.currencySymbol)
                        .foregroundStyle(textColor.opacity(0.5))
                        .offset(y: -3)
                    
                    if from {
                        Text(viewModel.amountText)
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(textColor)
                    } else {
                        Text(viewModel.getConvertedValue(from: fromCountryCurrency, to: toCountryCurrency))
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(textColor)
                    }
                }
            }
            
            HStack {
                Text("Current Balance")
                    .font(.system(size: 15))
                    .foregroundStyle(textColor.opacity(0.7))
                
                Spacer()
                
                HStack(spacing: 2) {
                    Text(country.currencySymbol)
                        .font(.system(size: 10))
                        .foregroundStyle(textColor.opacity(0.6))
                    
                    Text(from ? viewModel.amountText : viewModel.getConvertedValue(from: fromCountryCurrency, to: toCountryCurrency))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(textColor.opacity(0.6))
                }
            }
            .padding(.vertical, 8)
        }
        .padding()
        .background(Color(backgroundColor))
        .clipShape(NotchedCardShape(position: cardPosition, direction: direction))
        .padding()
    }

    @ViewBuilder
    private func customPicker(selection: Binding<Country>) -> some View {
        Menu {
            Picker("Select Country", selection: selection) {
                ForEach(Country.allCases) { item in
                    Text("\(item.currencyCode) - \(item.currency)").tag(item)
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(selection.wrappedValue.flagImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 22, height: 22)
                    .clipShape(Circle())
                
                Text(selection.wrappedValue.currencyCode)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
            )
        }
    }

    private var expenseText: some View {
        VStack {
            HStack {
                Text("Exchange Rate")
                    .font(.system(size: 15))
                Spacer()
                Text("1 \(fromCountryCurrency.currencyCode) = \(String(format: "%.4f", viewModel.rate)) \(toCountryCurrency.currencyCode)")
                    .font(.system(size: 17))
            }
            .padding(.horizontal)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Exchange Fee")
                        .font(.system(size: 15))
                    Text("Applied based on amount & currency")
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                }
                Spacer()
                Text("\(Helper.ExchangeRateHelper.currencyConversionCharges(for: fromCountryCurrency, to: toCountryCurrency)) \(fromCountryCurrency.currencyCode)")
            }
            .padding()
            
            Divider().padding(.horizontal)
            
            HStack {
                Text("Total")
                    .font(.system(size: 15))
                Spacer()
                Text("\(toCountryCurrency.currencySymbol) \(viewModel.getConvertedValue(from: fromCountryCurrency, to: toCountryCurrency))")
                    .font(.system(size: 17))
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
        .padding()
    }

    private var swipeActionView: some View {
        GeometryReader { geometry in
            let buttonDiameter: CGFloat = 44
            let leadPadding: CGFloat = 6
            let maxDragWidth = geometry.size.width - buttonDiameter - (leadPadding * 2)
            
            ZStack(alignment: .leading) {
                Text(isConverted ? "Converted!" : "Swipe")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .opacity(1 - Double(dragOffset / (maxDragWidth * 0.7)))
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(Color("CardColor"), in: Capsule())
                
                Circle()
                    .fill(Color.white)
                    .frame(width: buttonDiameter, height: buttonDiameter)
                    .overlay(
                        Image(systemName: isConverted ? "checkmark" : "chevron.forward.2")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color("CardColor"))
                    )
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 1, y: 1)
                    .offset(x: dragOffset + leadPadding)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.width > 0 && value.translation.width <= maxDragWidth {
                                    dragOffset = value.translation.width
                                }
                            }
                            .onEnded { value in
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    if value.translation.width > maxDragWidth * 0.7 {
                                        dragOffset = maxDragWidth
                                        isConverted = true
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            withAnimation(.easeInOut) {
                                                dragOffset = 0
                                                isConverted = false
                                                dismiss()
                                            }
                                        }
                                    } else {
                                        dragOffset = 0
                                    }
                                }
                            }
                    )
            }
        }
        .frame(height: 56)
        .padding(.horizontal, 30)
    }
}

#Preview {
    CurrencyConverterView()
}
