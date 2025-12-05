import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false

    var body: some View {
        ZStack {
            if isLoggedIn {
                WelcomeView()
                    .transition(.asymmetric(insertion: .slide, removal: .opacity))
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
                    .transition(.asymmetric(insertion: .slide, removal: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isLoggedIn)
    }
}

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var isRememberMe = false
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false
    @State private var successMessage = ""
    @State private var showPassword = false
    @State private var animateLogo = false
    @State private var animateFields = false
    @State private var animateButton = false

    var body: some View {
        ZStack {
            // Background gradient (matching HTML design)
            LinearGradient(gradient: Gradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")]),
                         startPoint: .topLeading,
                         endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                Spacer()

                // Login container (matching HTML glassmorphism)
                VStack(spacing: 20) {
                    // Top gradient border
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.clear)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")]),
                                                 startPoint: .leading,
                                                 endPoint: .trailing))

                    // Logo section
                    VStack(spacing: 10) {
                        Image(systemName: "clock")
                            .font(.system(size: 48))
                            .foregroundColor(Color(hex: "667eea"))
                            .scaleEffect(animateLogo ? 1.0 : 0.5)
                            .opacity(animateLogo ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.6), value: animateLogo)

                        Text("TimeCraft")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "333333"))
                            .offset(y: animateLogo ? 0 : 20)
                            .opacity(animateLogo ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8).delay(0.2), value: animateLogo)

                        Text("Master Your Time")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "666666"))
                            .offset(y: animateLogo ? 0 : 20)
                            .opacity(animateLogo ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8).delay(0.4), value: animateLogo)
                    }
                    .padding(.bottom, 20)

                    // Error/Success messages
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(Color(hex: "dc2626"))
                            .font(.system(size: 14))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "fee2e2"))
                            .cornerRadius(8)
                    }

                    if showSuccess {
                        Text(successMessage)
                            .foregroundColor(Color(hex: "059669"))
                            .font(.system(size: 14))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "d1fae5"))
                            .cornerRadius(8)
                    }

                    // Login form
                    VStack(spacing: 0) {
                        // Email field
                        ZStack(alignment: .leading) {
                            HStack(spacing: 0) {
                                Spacer().frame(width: 48)
                                TextField("Email address", text: $email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .padding(.vertical, 16)
                                    .padding(.trailing, 16)
                            }
                            .padding(.horizontal, 16)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "e1e5e9"), lineWidth: 2)
                            )

                            Image(systemName: "envelope")
                                .foregroundColor(Color(hex: "999999"))
                                .font(.system(size: 18))
                                .frame(width: 20)
                                .padding(.leading, 16)
                        }
                        .padding(.bottom, 24)

                        // Password field
                        ZStack(alignment: .leading) {
                            HStack(spacing: 0) {
                                Spacer().frame(width: 48)
                                if showPassword {
                                    TextField("Password", text: $password)
                                        .padding(.vertical, 16)
                                        .padding(.trailing, 16)
                                } else {
                                    SecureField("Password", text: $password)
                                        .padding(.vertical, 16)
                                        .padding(.trailing, 16)
                                }
                            }
                            .padding(.horizontal, 16)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "e1e5e9"), lineWidth: 2)
                            )

                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash" : "lock")
                                    .foregroundColor(Color(hex: "999999"))
                                    .font(.system(size: 18))
                                    .frame(width: 20)
                            }
                            .padding(.leading, 16)
                        }
                        .padding(.bottom, 24)

                        // Form options
                        HStack {
                            HStack(spacing: 8) {
                                Image(systemName: isRememberMe ? "checkmark.square.fill" : "square")
                                    .foregroundColor(isRememberMe ? Color(hex: "667eea") : Color(hex: "666666"))
                                    .font(.system(size: 18))
                                    .onTapGesture {
                                        isRememberMe.toggle()
                                    }

                                Text("Remember me")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "666666"))
                            }

                            Spacer()

                            Button(action: {
                                // Handle forgot password
                                showSuccessMessage("Password reset link sent to your email")
                            }) {
                                Text("Forgot password?")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "667eea"))
                            }
                        }
                        .padding(.bottom, 24)

                        // Login button
                        Button(action: login) {
                            if isLoading {
                                HStack {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                    Text("Signing In...")
                                        .fontWeight(.semibold)
                                }
                            } else {
                                HStack {
                                    Image(systemName: "sign-in-alt")
                                        .font(.system(size: 16))
                                    Text("Sign In")
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")]),
                                                 startPoint: .leading,
                                                 endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .font(.system(size: 16))
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .disabled(isLoading)
                    }
                    .padding(.horizontal, 32)

                    // Divider
                    ZStack {
                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color(hex: "e1e5e9"))
                            Spacer()
                        }

                        Text("or continue with")
                            .foregroundColor(Color(hex: "999999"))
                            .font(.system(size: 14))
                            .padding(.horizontal, 16)
                            .background(Color.white.opacity(0.95))
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 24)

                    // Social login
                    HStack(spacing: 16) {
                        SocialButton(icon: "g.circle.fill", text: "Google", action: loginWithGoogle)
                        SocialButton(icon: "applelogo", text: "Apple", action: loginWithApple)
                    }
                    .padding(.horizontal, 32)

                    // Sign up link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(Color(hex: "666666"))
                        Button(action: {
                            // Navigate to sign up
                            showSuccessMessage("Signup functionality would be implemented here")
                        }) {
                            Text("Sign up")
                                .foregroundColor(Color(hex: "667eea"))
                                .fontWeight(.semibold)
                        }
                    }
                    .font(.system(size: 14))
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                }
                .background(Color.white.opacity(0.95))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .animation(.easeOut(duration: 0.3), value: showError)
        .animation(.easeOut(duration: 0.3), value: showSuccess)
        .onAppear {
            animateLogo = true
            // Auto-focus first input (simulate)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Focus would be handled by UIKit integration
            }
        }
    }

    private func login() {
        // Reset messages
        showError = false
        showSuccess = false

        // Basic validation
        guard !email.isEmpty else {
            showErrorMessage("Please enter your email")
            return
        }

        guard !password.isEmpty else {
            showErrorMessage("Please enter your password")
            return
        }

        // Email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
            showErrorMessage("Please enter a valid email address")
            return
        }

        // Simulate login
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false

            // Demo credentials
            if email == "demo@timecraft.com" && password == "demo123" {
                showSuccessMessage("Login successful! Redirecting...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    // Navigate to main app
                    isLoggedIn = true
                }
            } else {
                showErrorMessage("Invalid email or password")
            }
        }
    }

    private func loginWithGoogle() {
        showSuccessMessage("Google login not implemented yet")
    }

    private func loginWithApple() {
        showSuccessMessage("Apple login not implemented yet")
    }

    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
        showSuccess = false
    }

    private func showSuccessMessage(_ message: String) {
        successMessage = message
        showSuccess = true
        showError = false
    }
}

struct WelcomeView: View {
    @State private var animateLogo = false
    @State private var animateText = false
    @State private var animateButton = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")]),
                         startPoint: .topLeading,
                         endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Spacer()

                // Welcome content
                VStack(spacing: 20) {
                    // Animated logo
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .scaleEffect(animateLogo ? 1.0 : 0.5)
                        .opacity(animateLogo ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6), value: animateLogo)

                    // Welcome text
                    VStack(spacing: 10) {
                        Text("Welcome!")
                            .font(.system(size: 32))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .offset(y: animateText ? 0 : 50)
                            .opacity(animateText ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8).delay(0.3), value: animateText)

                        Text("You have successfully logged in to TimeCraft")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .offset(y: animateText ? 0 : 50)
                            .opacity(animateText ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8).delay(0.5), value: animateText)
                    }
                    .padding(.horizontal, 40)

                    // Continue button
                    Button(action: {
                        // Handle continue to main app
                        print("Continue to main app")
                    }) {
                        Text("Continue")
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "667eea"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal, 40)
                    .offset(y: animateButton ? 0 : 50)
                    .opacity(animateButton ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8).delay(0.7), value: animateButton)
                }

                Spacer()
            }
        }
        .onAppear {
            animateLogo = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animateText = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                animateButton = true
            }
        }
    }
}

struct SocialButton: View {
    let icon: String
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(text)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white)
            .foregroundColor(Color(hex: "666666"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "e1e5e9"), lineWidth: 2)
            )
        }
    }
}

// Color extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
