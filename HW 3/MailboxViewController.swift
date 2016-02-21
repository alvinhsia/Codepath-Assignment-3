//
//  MailboxViewController.swift
//  HW 3
//
//  Created by Alvin Hsia on 2/16/16.
//  Copyright © 2016 Alvin Hsia. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

class MailboxViewController: UIViewController, UIGestureRecognizerDelegate {
    var mailboxGrey = UIColor.init(hexString: "E3E3E3")
    var mailboxBlue = UIColor.init(hexString: "68B8DA")
    var mailboxYellow = UIColor.init(hexString: "FBD30D")
    var mailboxBrown = UIColor.init(hexString: "D9A671")
    var mailboxGreen = UIColor.init(hexString: "6CDB5B")
    var mailboxRed = UIColor.init(hexString: "ED5329")

    @IBOutlet weak var MailboxScrollView: UIScrollView!
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var rightMessageIconImageView: UIImageView!
    @IBOutlet weak var leftMessageIconImageView: UIImageView!

    @IBOutlet weak var rescheduleView: UIView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!

    var messageOriginalCenter: CGPoint!
    var messageRight: CGPoint!
    var messageLeft: CGPoint!
    var rightMessageIconOriginalCenter: CGPoint!
    var leftMessageIconOriginalCenter: CGPoint!
    
    var feedOriginalCenter: CGPoint!
    var feedUp: CGPoint!
    
    var contentViewOriginalCenter: CGPoint!
    var contentViewRight: CGPoint!
    
    override func viewWillAppear(animated: Bool) {
        rescheduleView.alpha = 0
        listView.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        MailboxScrollView.contentSize = CGSize(width: 320, height: 1367)
        
        rightMessageIconImageView.alpha = 0.3
        leftMessageIconImageView.alpha = 0.3
        
        messageRight = CGPointMake(640, messageImageView.center.y)
        messageLeft = CGPointMake(-640, messageImageView.center.y)
        
        messageBackgroundView.backgroundColor = mailboxGrey
        
        // create menu screen edge pan gesture recognizer
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        contentView.addGestureRecognizer(edgeGesture)
        
        contentViewRight = CGPointMake(contentView.center.x + 240, contentView.center.y)
    }

    @IBAction func onMessagePan(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            
            // set the original center to starting center
            messageOriginalCenter = messageImageView.center
            leftMessageIconOriginalCenter = leftMessageIconImageView.center
            rightMessageIconOriginalCenter = rightMessageIconImageView.center
            feedOriginalCenter = feedImageView.center
        }
            
        else if sender.state == UIGestureRecognizerState.Changed {
            
            // move the message around
            messageImageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            
            // if half left, turn the background yellow and icon moves with message
            if messageImageView.center.x < 100 && messageImageView.center.x > -100 {
                UIView.animateWithDuration(0, animations: { () -> Void in
            
                    self.messageBackgroundView.backgroundColor = self.mailboxYellow
                    self.rightMessageIconImageView.alpha = 0
                    self.leftMessageIconImageView.center = CGPoint (x: self.leftMessageIconOriginalCenter.x + (translation.x + 60), y: self.leftMessageIconOriginalCenter.y)
                    self.leftMessageIconImageView.image = UIImage(named: "later_icon")
                    self.leftMessageIconImageView.alpha = 1
                })
            }
            
            // if full left, turn the background brown and change icon to list
            else if messageImageView.center.x < -100 {
                UIView.animateWithDuration(0, animations: { () -> Void in

                    self.messageBackgroundView.backgroundColor = self.mailboxBrown
                    self.rightMessageIconImageView.alpha = 0
                    self.leftMessageIconImageView.center = CGPoint (x: self.leftMessageIconOriginalCenter.x + (translation.x + 60), y: self.leftMessageIconOriginalCenter.y)
                    self.leftMessageIconImageView.image = UIImage(named: "list_icon")
                    self.leftMessageIconImageView.alpha = 1
                })
            }
            
            // if half right, turn the background green and icon moves with message
            else if messageImageView.center.x > 220 && messageImageView.center.x < 420 {
                UIView.animateWithDuration(0, animations: { () -> Void in
                    
                    self.messageBackgroundView.backgroundColor = self.mailboxGreen
                    self.leftMessageIconImageView.alpha = 0
                    self.rightMessageIconImageView.center = CGPoint (x: self.rightMessageIconOriginalCenter.x + (translation.x - 60), y: self.rightMessageIconOriginalCenter.y)
                    self.rightMessageIconImageView.image = UIImage(named: "archive_icon")
                    self.rightMessageIconImageView.alpha = 1
                })
            }
            
            
            // if full right, turn the background red and change icon to x
            else if messageImageView.center.x > 420 {
                UIView.animateWithDuration(0, animations: { () -> Void in
                    
                    self.messageBackgroundView.backgroundColor = self.mailboxRed
                    self.leftMessageIconImageView.alpha = 0
                    self.rightMessageIconImageView.center = CGPoint (x: self.rightMessageIconOriginalCenter.x + (translation.x - 60), y: self.rightMessageIconOriginalCenter.y)
                    self.rightMessageIconImageView.image = UIImage(named: "delete_icon")
                    self.rightMessageIconImageView.alpha = 1
                })
            }
            
        }
            
        else if sender.state == UIGestureRecognizerState.Ended {

            // if half left, snap it to left and show reschedule options
            if messageImageView.center.x < 100 && messageImageView.center.x > -100 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageImageView.center = self.messageLeft
                    self.leftMessageIconImageView.alpha = 0
                    }, completion: { (Bool) -> Void in
                        // make reschedule view appear
                        self.rescheduleView.alpha = 1
                })
            }
            
            // if full left, snap it to left and show list options
            else if messageImageView.center.x < -100 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageImageView.center = self.messageLeft
                    self.leftMessageIconImageView.alpha = 0
                    }, completion: { (Bool) -> Void in
                        // make list view appear
                        self.listView.alpha = 1
                })
            }
            
            // if half right, snap it to right and archive
            if messageImageView.center.x > 220 && messageImageView.center.x < 420 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageImageView.center = self.messageRight
                    self.rightMessageIconImageView.alpha = 0
                    }, completion: { (Bool) -> Void in
                        // scroll feed up
                        
                        UIView.animateWithDuration(0.2, delay: 0.1, options: [], animations: { () -> Void in
                            self.feedImageView.center = CGPoint(x: self.feedOriginalCenter.x, y: self.feedOriginalCenter.y - 86)
                            }, completion: nil)
                })
            }
                
            // if full right, snap it to right and delete
            else if messageImageView.center.x > 420 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageImageView.center = self.messageRight
                    self.rightMessageIconImageView.alpha = 0
                    }, completion: { (Bool) -> Void in
                        // scroll feed up
                        UIView.animateWithDuration(0.2, delay: 0.1, options: [], animations: { () -> Void in
                            self.feedImageView.center = CGPoint(x: self.feedOriginalCenter.x, y: self.feedOriginalCenter.y - 86)
                            }, completion: nil)
                })
            }
            
            // else, snap back to center
            else {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageImageView.center = self.messageOriginalCenter
                })
            }
            
        }
        
        
    }
    
    @IBAction func onReschedulePress(sender: UIButton) {
        rescheduleView.alpha = 0
        
        // complete the hide animation
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.feedImageView.center = CGPoint(x: self.feedOriginalCenter.x, y: self.feedOriginalCenter.y - 86)
            }) { (Bool) -> Void in
        // return to normal state; reset icon alpha values and view background colors
                self.messageImageView.center = self.messageOriginalCenter
                self.messageBackgroundView.backgroundColor = self.mailboxGrey
                self.leftMessageIconImageView.alpha = 0.3
                self.rightMessageIconImageView.alpha = 0.3
                self.leftMessageIconImageView.center = self.leftMessageIconOriginalCenter
                
                UIView.animateWithDuration(0.2, delay: 0.1, options: [], animations: { () -> Void in
                    self.feedImageView.center = self.feedOriginalCenter
                    }, completion: nil)
        }
    }

    @IBAction func onListPress(sender: UIButton) {
        listView.alpha = 0
        messageImageView.center = messageOriginalCenter
        
        // complete the hide animation
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.feedImageView.center = CGPoint(x: self.feedOriginalCenter.x, y: self.feedOriginalCenter.y - 86)
            }) { (Bool) -> Void in
                // return to normal state; reset icon alpha values and view background colors
                self.messageImageView.center = self.messageOriginalCenter
                self.messageBackgroundView.backgroundColor = self.mailboxGrey
                self.leftMessageIconImageView.alpha = 0.3
                self.rightMessageIconImageView.alpha = 0.3
                self.leftMessageIconImageView.center = self.leftMessageIconOriginalCenter
                self.leftMessageIconImageView.image = UIImage(named: "later_icon")
                
                UIView.animateWithDuration(0.2, delay: 0.1, options: [], animations: { () -> Void in
                    self.feedImageView.center = self.feedOriginalCenter
                    }, completion: nil)
        }
    }
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {

        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            contentViewOriginalCenter = contentView.center
        }
            
        else if sender.state == UIGestureRecognizerState.Changed {
            UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                self.contentView.center = CGPoint(x: self.contentViewOriginalCenter.x + translation.x, y: self.contentView.center.y)
                }, completion: nil)
        }
            
        else if sender.state == UIGestureRecognizerState.Ended {
            if velocity.x > 0 {
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.contentView.center = self.contentViewRight
                    }, completion: nil)
            }
            
            else if velocity.x < 0 {
                UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.contentView.center = self.contentViewOriginalCenter
                    }, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
