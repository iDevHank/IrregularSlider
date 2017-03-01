//
//  IrregularSlider.swift
//  IrregularSlider
//
//  Created by Hank on 09/02/2017.
//  Copyright © 2017 iDevHank. All rights reserved.
//

import UIKit

public protocol IrregularSliderProtocol: class {
    func irregularSlider(_ slider: IrregularSlider, didChangeValue value: Float)
}

open class IrregularSlider: UISlider {

    public var selectedValue: Float {
        set {
            self.value = fakeValue(for: newValue)
        }
        get {
            return realValue(for: self.value)
        }
    }

    public weak var delegate: IrregularSliderProtocol? = nil

    public convenience init(frame: CGRect, anchorPoints: [Float]) {
        self.init(frame: frame)
        setupAnchorPoints(anchorPoints)
    }

    fileprivate var realPoints: [Float]!

    fileprivate lazy var fakePoints: [Float] = {
        let unit = (self.maximumValue - self.minimumValue) / Float(self.realPoints.count - 1)
        return (0..<self.realPoints.count).map { self.minimumValue + unit * Float($0) }
    }()

    fileprivate static let stickiness: Float = 6

    private func setupAnchorPoints(_ points: [Float]) {
        assert(points.count > 1, "IrregularSlider: Anchor points must contain more than 1 point.")
        realPoints = points
        minimumValue = points.first!
        maximumValue = points.last!
    }

}

// MARK: - Value Converter
extension IrregularSlider {

    fileprivate func realValue(for value: Float) -> Float {
        return convertValue(value, in: fakePoints, with: realPoints)
    }

    fileprivate func fakeValue(for value: Float) -> Float {
        return convertValue(value, in: realPoints, with: fakePoints)
    }

    private func convertValue(_ value: Float, in array: [Float], with referenceArray: [Float]) -> Float {
        if value == minimumValue || value == maximumValue {
            return value
        }
        let index = array.indexOfLeftPointInAscendingArray(for: value)
        let leftValue = array[index]
        let rightValue = array[index + 1]
        let referenceLeftValue = referenceArray[index]
        let referenceRightValue = referenceArray[index + 1]
        return referenceLeftValue + (value - leftValue) / (rightValue - leftValue) * (referenceRightValue - referenceLeftValue)
    }

}

// MARK: - Stickiness
extension IrregularSlider {

    fileprivate func stickDistance(form value: Float, to anchorPoint: Float) -> Float {
        guard let index = fakePoints.index(of: anchorPoint) else {
            return 0
        }
        if value > anchorPoint || index == 0 {
            return (fakePoints[index + 1] - fakePoints[index]) / IrregularSlider.stickiness
        } else {
            return (fakePoints[index] - fakePoints[index - 1]) / IrregularSlider.stickiness
        }
    }

    fileprivate func closestAnchorPoint() -> Float? {
        for anchorPoint in fakePoints {
            if abs(value - anchorPoint) < stickDistance(form: value, to: anchorPoint) {
                return anchorPoint
            }
        }
        return nil
    }

    fileprivate func stick() {
        if let point = closestAnchorPoint() {
            setValue(point, animated: true)
        }
    }

}

// MARK: - Override Methods
extension IrregularSlider {

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        stick()
        delegate?.irregularSlider(self, didChangeValue: selectedValue)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        stick()
        delegate?.irregularSlider(self, didChangeValue: selectedValue)
    }

}
