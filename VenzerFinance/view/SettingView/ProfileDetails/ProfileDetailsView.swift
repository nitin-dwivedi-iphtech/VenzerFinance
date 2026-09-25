//
//  ProfileDetailsView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//
import SwiftUI

struct PersonalDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject  var viewModel:SettingViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                profileHeaderCard
                    .padding(.top, 8)
                
                VStack(spacing: 14) {
                    customInputField(title: "Full name", text: $viewModel.fullName, icon: "person.fill")
                    customInputField(title: "Phone", text: $viewModel.phone, icon: "phone.fill", keyboardType: .phonePad)
                    customInputField(title: "Email", text: $viewModel.email, icon: "envelope.fill", keyboardType: .emailAddress)
                }
                .padding(16)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black.opacity(0.06), lineWidth: 1))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
                .padding(.horizontal, 16)

                Button {
                    if viewModel.isValid() {
                        viewModel.savePersonalDetails()
                    }
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Text("Save changes").font(.system(size: 16, weight: .semibold))
                        Image(systemName: "arrow.right").font(.system(size: 13, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color("CardColor"), in: Capsule())
                    .shadow(color: Color("CardColor").opacity(0.25), radius: 10, x: 0, y: 6)
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Personal details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 16, weight: .semibold)).foregroundColor(.black)
                        .frame(width: 36, height: 36).background(Color.white, in: Circle())
                        .overlay(Circle().stroke(Color.black.opacity(0.06), lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
                }
            }
        }
        .background { CustomBackgroundView() }
    }
    
    private var profileHeaderCard: some View {
        VStack(spacing: 12) {
            ZStack {
                VStack(spacing: 0) {
                    Color("InsideCarTopColor").frame(height: 50)
                    Color("InsideCarBottomColor").frame(height: 50)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(spacing: 10) {
                    ZStack(alignment: .bottomTrailing) {
                        Image("image")
                            .resizable().scaledToFill()
                            .frame(width: 84, height: 84).clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 3))
                            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                        Circle()
                            .fill(Color("CardColor"))
                            .frame(width: 26, height: 26)
                            .overlay(Image(systemName: "camera.fill").font(.system(size: 11, weight: .semibold)).foregroundColor(.white))
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .offset(x: 2, y: 2)
                    }
                    .padding(.top, 12)

                    VStack(spacing: 2) {
                        Text(viewModel.fullName.isEmpty ? "—" : viewModel.fullName).font(.system(size: 16, weight: .bold)).foregroundColor(.black)
                        Text(viewModel.email.isEmpty ? "—" : viewModel.email).font(.system(size: 12)).foregroundColor(.gray).lineLimit(1)
                    }

                    Button {
                        // change photo
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "photo.on.rectangle.angled").font(.system(size: 12, weight: .semibold))
                            Text("Change photo").font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 14).padding(.vertical, 7)
                        .background(Color.white, in: Capsule())
                        .overlay(Capsule().stroke(Color.black.opacity(0.06), lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
                    }
                    .padding(.vertical, 14)
                }
            }
            .frame(height: 190)
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, 16)
    }
    
    private func customInputField(
        title: String,
        text: Binding<String>,
        icon: String = "pencil",
        keyboardType: UIKeyboardType = .default,
        showEditButton: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Circle().fill(Color("InsideCarBottomColor").opacity(0.18)).frame(width: 22, height: 22)
                    .overlay(Image(systemName: icon).font(.system(size: 10, weight: .semibold)).foregroundColor(Color("CardColor")))
                Text(title).font(.system(size: 11, weight: .semibold)).foregroundColor(.gray).tracking(0.2)
            }

            HStack(spacing: 10) {
                TextField("", text: text)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .keyboardType(keyboardType)

                if showEditButton {
                    Button("Edit") {}
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color("CardColor"))
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(Color("InsideCarTopColor"), in: Capsule())
                } else {
                    Image(systemName: "pencil").font(.system(size: 11)).foregroundColor(.gray.opacity(0.5))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.06), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
    }
}

//#Preview {
//    NavigationStack {
//        PersonalDetailsView()
//    }
//}
