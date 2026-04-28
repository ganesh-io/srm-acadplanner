import SwiftUI

struct AnimatedProgressBar: View {
    let progress: Double
    let height: CGFloat
    let gradient: LinearGradient
    
    @State private var animatedProgress: Double = 0
    
    init(progress: Double, height: CGFloat = 8,
         gradient: LinearGradient = AppTheme.primaryGradient) {
        self.progress = progress
        self.height = height
        self.gradient = gradient
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.white.opacity(0.08))
                
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(gradient)
                    .frame(width: geometry.size.width * animatedProgress)
                
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(gradient)
                    .frame(width: geometry.size.width * animatedProgress)
                    .blur(radius: 6)
                    .opacity(0.5)
            }
        }
        .frame(height: height)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
                animatedProgress = progress
            }
        }
    }
}
