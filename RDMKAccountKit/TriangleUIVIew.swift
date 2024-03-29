//
//  TriangleView.swift
//  TTTT
//
//  Created by Nafis Islam on 9/11/19.
//  Copyright © 2019 Nafis Islam. All rights reserved.
//

import UIKit

@IBDesignable
class LeftTriangleView : UIView {
    var _color: UIColor! = UIColor.blue
    var _margin: CGFloat! = 0

    @IBInspectable var margin: Double {
        get { return Double(_margin)}
        set { _margin = CGFloat(newValue)}
    }


    @IBInspectable var fillColor: UIColor? {
        get { return _color }
        set{ _color = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        context.move(to: CGPoint(x: rect.minX + _margin, y: rect.maxY - _margin))
        context.addLine(to: CGPoint(x: rect.maxX - _margin, y: rect.minY - _margin))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.minY + _margin))
        context.closePath()

        context.setFillColor(_color.cgColor)
        context.fillPath()
    }
}


@IBDesignable
class RightTriangleView : UIView {
    var _color: UIColor! = UIColor.blue
    var _margin: CGFloat! = 0

    @IBInspectable var margin: Double {
        get { return Double(_margin)}
        set { _margin = CGFloat(newValue)}
    }


    @IBInspectable var fillColor: UIColor? {
        get { return _color }
        set{ _color = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        context.move(to: CGPoint(x: rect.minX + _margin, y: rect.minY - _margin))
        context.addLine(to: CGPoint(x: rect.maxX - _margin, y: rect.maxY - _margin))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + _margin))
        context.closePath()

        context.setFillColor(_color.cgColor)
        context.fillPath()
    }
}


@IBDesignable
class TopTriangleView : UIView {
    var _color: UIColor! = UIColor.red
    var _margin: CGFloat! = 0

    @IBInspectable var margin: Double {
        get { return Double(_margin)}
        set { _margin = CGFloat(newValue)}
    }


    @IBInspectable var fillColor: UIColor? {
        get { return _color }
        set{ _color = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        context.move(to: CGPoint(x: rect.minX + _margin, y: rect.minY - _margin))
        context.addLine(to: CGPoint(x: rect.midX + 50 - _margin, y: rect.maxY - _margin))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + _margin))
        context.closePath()

        context.setFillColor(_color.cgColor)
        context.fillPath()
    }
}

