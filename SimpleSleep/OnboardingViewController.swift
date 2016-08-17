//
//  OnboardingViewController.swift
//  SimpleSleep
//
//  Created by Blair Altland on 8/10/16.
//  Copyright © 2016 Blairaltland. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    
    func getFirstSlide() -> FirstSlideViewController {
        return storyboard!.instantiateViewController(withIdentifier: "FirstSlide") as! FirstSlideViewController
    }

    func getSecondSlide() -> SecondSlideViewController {
        return storyboard!.instantiateViewController(withIdentifier: "SecondSlide") as! SecondSlideViewController
    }
    
    func getThirdSlide() -> ThirdSlideViewController {
        return storyboard!.instantiateViewController(withIdentifier: "ThirdSlide") as! ThirdSlideViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self

        setViewControllers([getFirstSlide()], direction: .forward, animated: false, completion: nil)
        view.backgroundColor = .darkGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
extension OnboardingViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: ThirdSlideViewController.self) {
            // 2 -> 1
            return getSecondSlide()
        } else if viewController.isKind(of: SecondSlideViewController.self) {
            // 1 -> 0
            return getFirstSlide()
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: FirstSlideViewController.self) {
            // 0 -> 1
            return getSecondSlide()
        } else if viewController.isKind(of: SecondSlideViewController.self) {
            // 1 -> 2
            return getThirdSlide()
        } else {
            // 2 -> end of the road
            return nil
        }
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

}
