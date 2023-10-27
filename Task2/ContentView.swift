import SwiftUI


struct ContentView: View {
    @GestureState private var position: CGSize = .zero
    @State private var invert: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            ZStack {
                Color.blue
                Canvas { context, _ in
                    let circle1 = context.resolveSymbol(id: 0)!
                    let circle2 = context.resolveSymbol(id: 1)!
                    
                    context.addFilter(.alphaThreshold(min: 0.9, color: .white))
                    context.addFilter(.blur(radius: 12))
                    
                    context.drawLayer { contex2 in
                        contex2.draw(circle1, at: center)
                        contex2.draw(circle2, at: center)
                    }
                } symbols: {
                    Circle()
                        .frame(width: 160, height: 160, alignment: .center)
                        .tag(0)
                        .offset(invert ? position : .zero)
                    Circle()
                        .frame(width: 160, height: 160, alignment: .center)
                        .tag(1)
                        .offset(invert ? .zero : position)
                }
                .gesture(
                    DragGesture()
                        .updating($position) { value, state, _ in
                            state = value.translation
                        }
                )
                .animation(.spring, value: position)
            }
            .ignoresSafeArea()
        }
    }
}
