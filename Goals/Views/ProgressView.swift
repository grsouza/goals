//
//  ProgressView.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

final class ProgressView: UIView {

    private let circularLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private var progressLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        setupLabel()
        setupCircularLayer()
        setupProgressLayer()
    }

    private func setupLabel() {
        progressLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width / 2, height: 60))
        progressLabel.textColor = Color.primaryGreen
        progressLabel.textAlignment = .center
        progressLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 26)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressLabel)

        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    private func setupCircularLayer() {
        let startAngle: CGFloat = 0
        let endAngle = CGFloat(Double.pi * 2)
        let centerPoint = CGPoint(x: frame.width/2, y: frame.height/2)

        circularLayer.path = UIBezierPath(
            arcCenter: centerPoint,
            radius: frame.width / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        ).cgPath
        circularLayer.backgroundColor = UIColor.clear.cgColor
        circularLayer.fillColor = nil
        circularLayer.strokeColor = Color.gray.cgColor
        circularLayer.lineWidth = 2.0
        circularLayer.strokeStart = 0.0
        circularLayer.strokeEnd = 1.0

        layer.addSublayer(circularLayer)
    }

    private func setupProgressLayer() {
        let startAngle = CGFloat(-Double.pi / 2)
        let endAngle = CGFloat(Double.pi * 2) + startAngle
        let centerPoint = CGPoint(x: frame.width/2, y: frame.height/2)

        progressLayer.path = UIBezierPath(
            arcCenter: centerPoint,
            radius: frame.width / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
            ).cgPath
        progressLayer.backgroundColor = UIColor.clear.cgColor
        progressLayer.fillColor = nil
        progressLayer.strokeColor = Color.primaryGreen.cgColor
        progressLayer.lineWidth = 4.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0

        layer.addSublayer(progressLayer)
    }

    private func setLabelText(to value: Double) {
        let value = (value * 100).rounded(to: 2)
        progressLabel.text = "\(value)%"
    }

    func animate(to value: CGFloat) {
        let value = sanitize(value: value)
        setLabelText(to: Double(value))

        progressLayer.strokeEnd = 0.0

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = value
        animation.duration = 0.3
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        progressLayer.add(animation, forKey: "strokeEnd")
    }

    private func sanitize(value: CGFloat) -> CGFloat {
        var value = value
        if value < 0 {
            value = 0
        }
        if value > 1 {
            value = 1
        }
        return value
    }
}
