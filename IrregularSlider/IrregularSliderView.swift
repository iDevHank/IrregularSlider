//
//  IrregularSliderView.swift
//  IrregularSlider
//
//  Created by Hank on 09/02/2017.
//  Copyright © 2017 iDevHank. All rights reserved.
//

import UIKit

private struct IrregularSliderViewConstants {
    internal static let spacing: CGFloat = 15
    internal static let labelWidth: CGFloat = 160
    internal static let coordinateLabelWidth: CGFloat = 80
    internal static let labelHeight: CGFloat = 20
    internal static let sliderHeight: CGFloat = 20
    internal static let coordinateViewHeight: CGFloat = 15
    internal static let lineHeight: CGFloat = 10
    internal static let fontSize: CGFloat = 13
}

open class IrregularSliderView: UIView {

    public var value: Float {
        set {
            slider.selectedValue = newValue
            updateDisplayLabel(value: Int(newValue))
        }
        get {
            return slider.selectedValue
        }
    }
    public lazy var slider: IrregularSlider = self.makeSlider()
    fileprivate lazy var label: UILabel = self.makeLabel()
    fileprivate var coordinateView: UIView!
    fileprivate var anchorPointLabelView: UIView!
    fileprivate var anchorPoints: [Float]!

    public convenience init(frame: CGRect, anchorPoints: [Float]) {
        self.init(frame: frame)
        self.anchorPoints = anchorPoints
        setupView(with: anchorPoints)
    }

}

// MARK: - User Interface
extension IrregularSliderView {

    fileprivate func updateDisplayLabel(value: Int) {
        label.text = value.description
    }

    fileprivate func setupView(with anchorPoints: [Float]) {
        addSubview(label)
        addSubview(slider)
        makeCoordinateView()
        makeAnchorPointLabelView()
    }

    fileprivate func makeSlider() -> IrregularSlider {
        let slider = IrregularSlider(frame: CGRect(x: 0, y: IrregularSliderViewConstants.labelHeight + IrregularSliderViewConstants.spacing / 2, width: self.bounds.size.width, height: IrregularSliderViewConstants.sliderHeight), anchorPoints: self.anchorPoints)
        slider.delegate = self
        return slider
    }

    fileprivate func makeLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: IrregularSliderViewConstants.lineHeight, y: 0, width: IrregularSliderViewConstants.labelWidth, height: IrregularSliderViewConstants.labelHeight))
        label.font = .systemFont(ofSize: IrregularSliderViewConstants.fontSize)
        label.textColor = .lightGray
        return label
    }

    private func makeCoordinateView() {
        coordinateView = UIView(frame: CGRect(x: IrregularSliderViewConstants.spacing, y: IrregularSliderViewConstants.labelHeight + IrregularSliderViewConstants.sliderHeight + IrregularSliderViewConstants.spacing, width: slider.bounds.size.width - 2 * IrregularSliderViewConstants.spacing, height: IrregularSliderViewConstants.coordinateViewHeight))
        let distance = coordinateView.bounds.size.width / CGFloat(anchorPoints.count - 1)
        for index in 0..<anchorPoints.count {
            let line = separateLine()
            line.frame = CGRect(x: CGFloat(index) * distance, y: 0, width: 1, height: IrregularSliderViewConstants.lineHeight)
            coordinateView.layer.addSublayer(line)
        }
        addSubview(coordinateView)
    }

    private func makeAnchorPointLabelView() {
        anchorPointLabelView = UIView(frame: CGRect(x: IrregularSliderViewConstants.spacing, y: IrregularSliderViewConstants.labelHeight + IrregularSliderViewConstants.sliderHeight + IrregularSliderViewConstants.coordinateViewHeight + IrregularSliderViewConstants.spacing, width: coordinateView.bounds.size.width, height: IrregularSliderViewConstants.coordinateViewHeight))
        let distance = anchorPointLabelView.bounds.size.width / CGFloat(anchorPoints.count - 1)
        for index in 0..<anchorPoints.count {
            let label = anchorPointLabel(point: anchorPoints[index])
            label.frame = CGRect(x: 0, y: 0, width: IrregularSliderViewConstants.coordinateLabelWidth, height: IrregularSliderViewConstants.coordinateViewHeight)
            label.center.x = CGFloat(index) * distance
            anchorPointLabelView.addSubview(label)
        }
        addSubview(anchorPointLabelView)
    }

    private func anchorPointLabel(point: Float) -> UILabel {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: IrregularSliderViewConstants.fontSize)
        label.textColor = .lightGray
        label.text = Int(point).description
        return label
    }

    private func separateLine() -> CALayer {
        let line = CALayer()
        line.backgroundColor = UIColor.lightGray.cgColor
        return line
    }
}

// MARK: - IrregularSliderProtocol
extension IrregularSliderView: IrregularSliderProtocol {
    public func irregularSlider(_ slider: IrregularSlider, didChangeValue value: Float) {
        updateDisplayLabel(value: Int(value))
    }
}
