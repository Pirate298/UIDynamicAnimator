//
//  ViewController.swift
//  UIDynamicAnimator
//
//  Created by PIRATE on 10/27/16.
//  Copyright © 2016 PIRATE. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UICollisionBehaviorDelegate {
    
    
    var ball = UIImageView()
    var animator = UIDynamicAnimator()
    var attachmentBehavior: UIAttachmentBehavior!
    var pushBehavior : UIPushBehavior!
    var brick = UIImageView()
    
    @IBOutlet weak var brickV1: UIView!
    @IBOutlet weak var brickV2: UIView!
    @IBOutlet weak var brickV3: UIView!
    @IBOutlet weak var brickV4: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ball = UIImageView(frame: CGRect(x: 200, y: 100, width: 40, height: 40))
        self.ball.layer.cornerRadius = 40/2
        self.ball.clipsToBounds = true
        self.ball.image = UIImage(named: "ball.jpg")
        self.view.addSubview(self.ball)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        let gravityBehavior = UIGravityBehavior(items: [self.ball])
        
        //gravityBehavior.angle = 0
        // gravityBehavior.magnitude = 0.5
        // gravityBehavior.gravityDirection = CGVector(dx: 0 , dy: 10)
        
        
        animator.addBehavior(gravityBehavior)
        let collisionBehavior = UICollisionBehavior(items: [self.ball,self.brickV1,self.brickV2,self.brickV3,self.brickV4])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionDelegate = self
        animator.addBehavior(collisionBehavior)
        
        attachmentBehavior = UIAttachmentBehavior(item: self.ball, attachedToAnchor: self.ball.center)
        attachmentBehavior.length = 50
        attachmentBehavior.frequency = 10
        attachmentBehavior.damping = 10
        animator.addBehavior(attachmentBehavior)
        
        //Push
        self.pushBehavior = UIPushBehavior(items: [self.ball], mode: .continuous )
        self.animator.addBehavior(self.pushBehavior)
        
        //UIdynamicItemBehavior
        let ballProterty = UIDynamicItemBehavior(items: [self.ball])
        //ballProterty.elasticity = 1
        ballProterty.allowsRotation = true
        self.animator.addBehavior(ballProterty)
        
        // Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        self.view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePush(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        
    }
//    func collisionBehavior( behavior: UICollisionBehavior, beganContactFor: UIDynamicItem, withBoundaryIdentifier: NSCopying?, at: CGPoint) {
//        print(withBoundaryIdentifier)
//    }
    func handlePan(gesture: UIPanGestureRecognizer)
    {
        attachmentBehavior.anchorPoint = gesture.location(in: self.view)
    }
    
    func handlePush (gesture : UITapGestureRecognizer)
    {
        let p = gesture.location(in: self.view)
        let o = self.ball.center
        let distance = sqrtf(powf(Float(p.x) - Float(o.x), 2.0) + powf(Float(p.y) - Float(o.y), 2.0))
        let angle = atan2(p.y - o.y, p.x - o.x)
        pushBehavior.magnitude = CGFloat(distance/100.0)
        pushBehavior.angle = angle
    }
    
}

