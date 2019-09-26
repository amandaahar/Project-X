//
//  CreditsViewController.swift
//  ProjectX
//
//  Created by Alejandro Hernandez on 22/09/19.
//  Copyright © 2019 Charge. All rights reserved.
//

import UIKit
import Pastel

class CreditsViewController: UIViewController {

    @IBOutlet weak var aadhya : UILabel!
    @IBOutlet weak var amanda : UILabel!
    @IBOutlet weak var alejandro : UILabel!
    @IBOutlet weak var titleView : UILabel!

    @IBOutlet weak var centerHorizontalConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pastel = PastelView(frame: self.view.frame)
      
        self.view.insertSubview(pastel, at: 0)
        pastel.startAnimation()
      
        self.titleView.layer.borderColor = UIColor.white.cgColor
        self.titleView.layer.borderWidth = 1.4
        self.titleView.layer.cornerRadius = 10
        
        // create a view with size 400 x 400
      // create a view with size 400 x 400
     

//     let myViewAmanda = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
//    let myViewAadhya = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
//    let myViewAlejandro = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
//
//      // Create a gradient layer
//      let gradient = CAGradientLayer()
//
//      // gradient colors in order which they will visually appear
//      gradient.colors = [UIColor.white.cgColor, UIColor.blue.cgColor]
//
//      // Gradient from left to right
//      gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
//      gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
//
//      // set the gradient layer to the same size as the view
//      gradient.frame = myViewAmanda.bounds
//      // add the gradient layer to the views layer for rendering
//      myViewAmanda.layer.addSublayer(gradient)
//      
//
//        // Tha magic! Set the label as the views mask
//        myViewAmanda.layer.mask = amanda.layer
//        self.view.addSubview(myViewAmanda)
//         
//        myViewAadhya.layer.addSublayer(gradient)
//        
//
//          // Tha magic! Set the label as the views mask
//          myViewAadhya.layer.mask = aadhya.layer
//          self.view.addSubview(myViewAadhya)
//        
//        myViewAlejandro.layer.addSublayer(gradient)
//        
//
//          // Tha magic! Set the label as the views mask
//          myViewAlejandro.layer.mask = alejandro.layer
//          self.view.addSubview(myViewAlejandro)

        

        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func moveLabel() {
          UIView.animate(withDuration: 2.0) {
              self.centerHorizontalConstraint.constant -= 50
              self.view.layoutIfNeeded()
          }
      }

}
