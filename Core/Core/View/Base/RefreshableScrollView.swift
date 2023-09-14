//
//  LegacyScrollView.swift
//  Core
//
//  Created by  Stepanok Ivan on 14.09.2023.
//

import SwiftUI
import Combine

public struct RefreshableScrollView<Content: View>: View {
    @StateObject private var viewModel = RefreshableScrollViewModel()
    
    private let content: () -> Content
    private let showsIndicators: Bool
    private let onRefresh: () async -> Void
    
   public init(showsIndicators: Bool = true, @ViewBuilder content: @escaping () -> Content, onRefresh: @escaping () async -> Void) {
        self.content = content
        self.showsIndicators = showsIndicators
        self.onRefresh = onRefresh
    }
    
    private var topGeometryReader: some View {
        GeometryReader { geometry in
            Color.clear
                .framePreferenceKey(geometry.frame(in: .global)) { frame in
                    self.viewModel.update(topFrame: frame)
                }
        }
    }
    
    private var scrollViewGeometryReader: some View {
        GeometryReader { geometry in
            Color.clear
                .framePreferenceKey(geometry.frame(in: .global)) { frame in
                    self.viewModel.update(scrollFrame: frame)
                }
        }
    }
    
    public var body: some View {
        VStack() {
            ActivityIndicator(size: self.$viewModel.progressViewHeight, isAnimating: self.$viewModel.isRefreshing)
                .frame(width: self.viewModel.progressViewHeight, height: self.viewModel.progressViewHeight)
                .background { self.topGeometryReader }
            
            ScrollView(.vertical, showsIndicators: self.showsIndicators) {
                self.content()
                    .background { self.scrollViewGeometryReader }
            }
        }
        .onChange(of: self.viewModel.isRefreshing) { isRefreshing in
            guard isRefreshing else { return }
            
            Task {
                await self.onRefresh()
                
                // In case the async method returns quickly.
                // We want to keep it refreshing for some time so it is smooth.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.viewModel.endRefreshing()
                }
            }
        }
    }
}

struct RefreshableScrollView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshableScrollView(showsIndicators: true) {
            Text("Hi")
            Text("World")
            Text("Hello")
        } onRefresh: {
            print("Refreshing")
        }
    }
}

final class RefreshableScrollViewModel: ObservableObject {
    @Published var progressViewHeight: CGFloat = 0
    @Published var isRefreshing = false
    
    let progressViewMaxHeight: CGFloat
    private let scrollPositionSubject = CurrentValueSubject<CGFloat, Never>(0)
    private let closingAnimationDuration: Double = 0.15
    private var subscriptions: Set<AnyCancellable> = []
    
    private var topYValue: CGFloat?
    private var scrollYValue: CGFloat?
    private var startingDistance: CGFloat?
    private var isClosing = false
    
    /// - Parameter activityIndicatorStyle: Used to derive the size of the indicator. Might be better to get in another way. In case Apple changes the sizes
    init(activityIndicatorStyle: UIActivityIndicatorView.Style = .medium) {
        self.progressViewMaxHeight = activityIndicatorStyle == .large ? 35 : 27
        self.reactToScrollEnding()
    }
    
    private func reactToScrollEnding() {
        self.scrollPositionSubject
            .debounce(for: 0.1, scheduler: RunLoop.main, options: nil)
            .sink { [weak self] _ in
                guard self?.progressViewHeight != 0,
                      self?.isRefreshing != true
                else { return }
                
                self?.reset()
            }
            .store(in: &self.subscriptions)
    }
    
    /// Updates the progressViewHeight and progressViewIsAnimating properties based on the given topFrame and any existing scrollYValue, if any
    /// - Parameter topFrame: CGRect
    func update(topFrame: CGRect) {
        let topY = topFrame.minY
        self.topYValue = topY
        guard let scrollY = self.scrollYValue else { return }
        
        self.update(topY: topY, scrollY: scrollY)
    }
    
    /// Updates the progressViewHeight and progressViewIsAnimating properties based on the given scrollFrame and any existing topYValue, if any
    /// - Parameter scrollFrame: CGRect
    func update(scrollFrame: CGRect) {
        let scrollY = scrollFrame.minY
        self.scrollYValue = scrollY
        self.scrollPositionSubject.send(scrollY)
        guard let topY = self.topYValue else { return }
        
        self.update(topY: topY, scrollY: scrollY)
    }
    
    /// Stops refreshing and hides the progress view
    func endRefreshing() {
        self.reset()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.closingAnimationDuration) {
            self.isRefreshing = false
        }
    }
    
    private func reset() {
        self.isClosing = true
        let topY = self.topYValue ?? 0
        let startDistance = self.startingDistance ?? 0
        let startingScrollYValue = topY + startDistance
        self.scrollYValue = startingScrollYValue
        
        withAnimation(.linear(duration: self.closingAnimationDuration)) {
            self.progressViewHeight = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.closingAnimationDuration) {
            self.isClosing = false
        }
    }
    
    private func update(topY: CGFloat, scrollY: CGFloat) {
        // Don't react to updates while animating closed
        guard !self.isClosing else { return }
        
        let newDistance = max(scrollY - topY, 0)
        
        if self.startingDistance == nil {
            self.startingDistance = newDistance
        }
        
        let differenceFromStart = newDistance - self.startingDistance!
        let constrainedDifference = min(max(differenceFromStart, 0), self.progressViewMaxHeight)
        
        // Don't change the height of the progress view if we are refreshing
        guard !isRefreshing else { return }
        
        DispatchQueue.main.async {
            self.progressViewHeight = constrainedDifference
            self.isRefreshing = constrainedDifference == self.progressViewMaxHeight
        }
    }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    func framePreferenceKey(_ value: CGRect, onFrameChange: @escaping (CGRect) -> Void) -> some View {
        self
            .preference(key: FramePreferenceKey.self, value: value)
            .onPreferenceChange(FramePreferenceKey.self, perform: onFrameChange)
    }
}

final class ActivityIndicator: UIViewRepresentable {
    @Binding var size: CGFloat
    @Binding var isAnimating: Bool
    private let style: UIActivityIndicatorView.Style
    
    init(style: UIActivityIndicatorView.Style = .medium, size: Binding<CGFloat>, isAnimating: Binding<Bool>) {
        self._size = size
        self._isAnimating = isAnimating
        self.style = style
    }
    
    func makeUIView(context: Context) -> UIView {
        let activityIndicator = UIActivityIndicatorView(style: self.style)
        activityIndicator.hidesWhenStopped = false

        if self.isAnimating {
            activityIndicator.startAnimating()
        }

        let containerView = UIView()
        containerView.layer.cornerRadius = self.size / 2
        containerView.clipsToBounds = true
        
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator
            .centerXAnchor
            .constraint(equalTo: containerView.centerXAnchor)
            .isActive = true
        activityIndicator
            .centerYAnchor
            .constraint(equalTo: containerView.centerYAnchor)
            .isActive = true
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.layer.cornerRadius = self.size / 2
        
        guard let activityIndicator = uiView.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView
        else { return }
        
        if self.isAnimating {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
