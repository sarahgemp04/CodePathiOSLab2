//
//  PhotoDetailsViewController.swift
//  Lab1Tumblr
//
//  Created by Sarah Gemperle on 1/30/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoDetailsViewController: UIViewController {
    
    var photoURL: URL!
    
    @IBOutlet weak var photoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoView.setImageWith(photoURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
