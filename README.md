# VenzerFinance

A SwiftUI personal finance app for tracking balances, sending money between users, moving money between own accounts, converting currencies, and visualizing spending.

- **Stack:** SwiftUI, Core Data, Swift Charts, UserNotifications
- **Language:** Swift 5 · **iOS:** 26.5+ · **Xcode:** 16+ · **Version:** 1.0
- **Bundle ID:** `com.iphtech.nitin.VenzerFinance`
- **Scale:** 84 Swift files · ~9,680 LOC

## Features

- **Auth:** Sign up / login with Core Data `User`, duplicate-email guard, per-user session (`AppState` + `UserDefaults`).
- **Home dashboard:** Balance card, month expense, recent transaction, 7×20 activity heatmap, last-7 transactions.
- **Balance overview:** Hero chart card, metric tabs (overview / breakdown / activity / rates / accounts), month spent / transfer count / largest transfer, live USD rate.
- **Transactions:** Full history with search + `All / Week / Month` filter, day-grouped (`Today / Yesterday`), sent/received counts, totals.
- **Send money:** Send to other app users with recipient picker, balance + recipient validation, dual debit/credit records.
- **Move money:** Transfer between own accounts with from/to picker, swap, quick amounts, same-account + insufficient-balance guards.
- **Currency converter:** Live rates via ExchangeRate-API, per-country fee table, swipe-to-convert. Fails safe — no conversion when `rate <= 0`, loading, or fee wipes balance.
- **Charts / Insights:** 3/6/12-month sent-vs-received bars, 5-day momentum area chart, flow donut, peak month / active day / net flow.
- **Settings / Account hub:** Profile + photo (PhotosPicker), multi-account CRUD, primary account, preferences (debit alerts, dark mode), logout.
- **Debit notifications:** Local notification on every debit (`sendMoney` / `transferMoney`) with `Bank ••1234`, amount, available balance. Toggle in Settings → Preferences. Foreground banner supported.

## Architecture

```
VenzerFinanceApp → SplashScreen → ContentView → AuthView | TabView
TabView: Welcome / BalanceOverview / Chart / Setting
```

- **MVVM:** Each screen has a `ViewModel` (`Welcome`, `BalanceOverview`, `AllTransactions`, `Chart`, `Transaction`, `Deposit`, `CurrencyConverter`, `Setting`, `Auth`).
- **Services:**
  - `DbService` — Core Data facade for `User / Account / Transaction`. All mutations `saveData()` + post `.balanceDidChange`.
  - `ApiService` — `GET {base}/{code}` → `CurrencyExchange` → `conversionRates[to]`.
  - `AppState` — singleton session (`user`, `isLoggedIn`, `selectedAccountId`).
  - `NotificationManager` — `UNUserNotificationCenter` wrapper + delegate, `debitNotificationsEnabled` flag.
- **Reactivity:** ViewModels subscribe to `NotificationCenter.balanceDidChange` and refresh.

## Core Data

`VenzerFinance/model/Model.xcdatamodeld`

- `User(id, email, password, name, country, phone, image)`
- `Account(id, account_no, bankName, balance: Double, currency, user_id, isPrimary)`
- `Transaction(id, account_id, user_id, amount: String, type: credit/debit, timestamp)`

## Project structure

```
VenzerFinance/
  VenzerFinanceApp.swift  ContentView.swift
  core/       Constants, Extension, Helper, Persistence, NotificationManager, shape/CardShape
  state/      AppState
  model/      CountryEnums, CurrencyExchange, RecipientItem, TabEnum, TransactionItem, Model.xcdatamodeld
  service/    DbService, ApiService
  viewModel/  Auth, Welcome, BalanceOverview, AllTransactions, Chart, Transaction, Deposit, CurrencyConverter, Setting
  view/
    SplashScreen  AuthView  BottomTabView  WelcomeView  BalanceOverview
    AllTransactions  ChartView  TransactionView  DepositView
    CurrencyConverterView  SettingView  CustomViews
  Assets.xcassets/
```

## Getting started

1. Clone and open:
   ```bash
   open VenzerFinance.xcodeproj
   ```
2. Select scheme **VenzerFinance** → iPhone Simulator (e.g. iPhone 17 Pro) → Run (`⌘R`).
3. Sign up with name / email / password / country → add account in Settings → send / move / convert.

No packages, no extra setup. Core Data store is created on first launch with lightweight migration.

## Configuration

- **Currency API:** `core/Constants.swift` → `currencyConversionBaseUrl` contains an ExchangeRate-API key. Replace with your own for production:
  ```swift
  https://v6.exchangerate-api.com/v6/<KEY>/latest/
  ```
- **Fees:** `core/Helper.swift` → `ExchangeRateHelper.rawConversionFee(for:to:)`.
- **Flags / colors:** `Assets.xcassets/Images|Color`.
- **Notifications:** `NotificationManager.debitNotificationsKey = "debitNotificationsEnabled"` (default ON). Permission is requested on first launch.

## Validations

- Send / Move: `amount > 0`, `amount <= balance`, recipient / both accounts selected, different accounts (`objectID` + `account_no`).
- Amount input sanitized (digits + single `.`, 2 decimals, max 10 chars).
- Converter: `balance > 0`, `rate > 0`, `!isLoading`, `converted > 0` — otherwise shows `—` + alert, never wipes balance.
- Auth / accounts: non-empty check, duplicate email / `account_no` guard.

Known gaps: no email-format or password-strength rules, `balanceText` numeric check is lenient.

## Permissions

- **Notifications:** alert / sound / badge (debit alerts).
- **Photos:** profile photo picker (read-only).

## Demo

https://github.com/user-attachments/assets/145e87d5-a024-4481-b627-56df40ef4507






