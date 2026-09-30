//
//  ChartTheme.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 29/09/26.
//

import SwiftUI

func sentColor(for scheme: ColorScheme) -> Color {
    Color("ChartSentColor")
}

func receivedColor(for scheme: ColorScheme) -> Color {
    Color("ChartReceivedColor")
}

func sentTint(for scheme: ColorScheme) -> Color {
    sentColor(for: scheme)
}

func sentSoft(for scheme: ColorScheme) -> Color {
    sentColor(for: scheme).opacity(scheme == .dark ? 0.18 : 0.1)
}

func receivedTint(for scheme: ColorScheme) -> Color {
    receivedColor(for: scheme)
}

func receivedSoft(for scheme: ColorScheme) -> Color {
    receivedColor(for: scheme).opacity(scheme == .dark ? 0.18 : 0.12)
}

func gridColor(for scheme: ColorScheme) -> Color {
    scheme == .dark ? Color.white.opacity(0.07) : Color.black.opacity(0.05)
}

func axisColor(for scheme: ColorScheme) -> Color {
    scheme == .dark ? Color.white.opacity(0.45) : Color.black.opacity(0.4)
}
