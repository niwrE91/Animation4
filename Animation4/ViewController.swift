//
//  ViewController.swift
//  Animation4
//
//  Created by Erwin Warkentin on 27.06.19.
//  Copyright © 2019 Erwin Warkentin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//background
    let bgImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "fb_core_data_bg"))
        return imageView
    }()
    
//pop up a box
    let iconsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
//        let redView = UIView()
//        redView.backgroundColor = .red
//        let blueView = UIView()
//        blueView.backgroundColor = .blue
//        let grayView = UIView()
//        grayView.backgroundColor = .gray
//        let yellowView = UIView()
//        yellowView.backgroundColor = .yellow
//        let arrangedSubviews = [redView, blueView, yellowView, grayView]
       
//configuration options
        let iconHeight: CGFloat = 30
        let padding: CGFloat = 6
        
        let images = [#imageLiteral(resourceName: "blue_like"), #imageLiteral(resourceName: "red_heart"), #imageLiteral(resourceName: "cry_laugh"), #imageLiteral(resourceName: "surprised"), #imageLiteral(resourceName: "cry"), #imageLiteral(resourceName: "angry")]
        
//tell the box witch Colors are in the box
        let arrangedSubviews = images.map({ (image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2
//required  for hit testing
            imageView.isUserInteractionEnabled = true
            return imageView
        })
        
////tell the box witch Colors are in the box
//        let arrangedSubviews = [UIColor.red, .blue, .gray, .yellow, .orange].map({ (color) -> UIView in
//            let v = UIView()
//            v.backgroundColor = color
//            v.layer.cornerRadius = iconHeight / 2
//            return v
//        })
        
//creat a Stack view to contain
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        

        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)
        
        let numIcons = CGFloat(arrangedSubviews.count)
        let width = numIcons * iconHeight + (numIcons + 1) * padding
        
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        containerView.layer.cornerRadius = containerView.frame.height / 2
        
//shadow
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        stackView.frame = containerView.frame
        return containerView
    
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImageView)
        bgImageView.frame = view.frame
        
        setupLongPressGesture()
        
    }
    
//long press on screen
    fileprivate func setupLongPressGesture(){
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
//what happend when the screen is long pressed
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
            
//conditions when is no longer pressed
        } else if gesture.state == .ended {
//clean up the animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
        
                self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: 50)
                self.iconsContainerView.alpha = 0
                
            }, completion: { (_) in
                self.iconsContainerView.removeFromSuperview()
            })
            
//condition when hovering
        }else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    
//hit test when i hover over a icon
    fileprivate func handleGestureChanged(gesture: UILongPressGestureRecognizer){
        let pressedLocation = gesture.location(in: self.iconsContainerView)
        print(pressedLocation)
        
//fixed so that you don´t have to hover exactly over the emojis
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconsContainerView.frame.height / 2)
        
        let hitTestView = iconsContainerView.hitTest(fixedYLocation, with: nil)
//Animation from hit test
        if hitTestView is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
               hitTestView?.transform = CGAffineTransform(translationX: 0, y: -30)
                
            })
        }
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer){
        
            view.addSubview(iconsContainerView)
//tells the console where we tap on the screen
            let pressedLocation = gesture.location(in: self.view)
            print(pressedLocation)
            
//transformation of the showen box
            let centeredX = (view.frame.width - iconsContainerView.frame.width) / 2
            
//Alpha
            iconsContainerView.alpha = 0
//begining position of the box
            self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
//Animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.iconsContainerView.alpha = 1
//end position of the box
                self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconsContainerView.frame.height)
            })
    }
    
//hide status bar only for this background
    override var prefersStatusBarHidden: Bool { return true }


}

