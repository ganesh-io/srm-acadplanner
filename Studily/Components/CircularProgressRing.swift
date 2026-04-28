import SwiftUI

struct CircularProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    let gradient: LinearGradient
    let size: CGFloat
    
    @State private var animatedProgress: Double = 0
    
    init(progress: Double, size: CGFloat = 160, lineWidth: CGFloat = 12,
         gradient: LinearGradient = AppTheme.primaryGradient) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
        self.gradient = gradient
    }
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: lineWidth)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(gradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            // Glow effect
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(gradient, style: StrokeStyle(lineWidth: lineWidth + 6, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .blur(radius: 8)
                .opacity(0.4)
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).delay(0.3)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newValue in
            withAnimation(.easeInOut(duration: 0.6)) {
                animatedProgress = newValue
            }
        }
    }
}
