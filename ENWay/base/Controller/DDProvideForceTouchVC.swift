//
//  DDProvideForceTouchVC.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit

class DDProvideForceTouchVC: DDViewController ,  UIViewControllerPreviewingDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 9.0, *) {
            registerForPreviewing(with: self, sourceView: view)
        
        }
        // Do any additional setup after loading the view.
    }
    /// Create a previewing view controller to be shown at "Peek".
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {//可重写
        // Obtain the index path and the cell that was pressed.
        //        guard let indexPath = tableView.indexPathForRow(at: location),
        //        let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        //        // Create a detail view controller and set its properties.
        //        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return nil }
        //        let previewDetail = sampleData[(indexPath as NSIndexPath).row]
        //        detailViewController.sampleTitle = previewDetail.title
        /*
         Set the height of the preview by setting the preferred content size of the detail view controller.
         Width should be zero, because it's not used in portrait.
         */
        ///:可判断location的位置 , 在判断是否需要执行forcetouch//暂未实现
        let detailViewController = DDProvideForceTouchVC()
        detailViewController.title = "3D touch to vc"
        detailViewController.view.backgroundColor = UIColor.red
        detailViewController.title = "vcTitle"
        detailViewController.preferredContentSize = CGSize(width: 300, height: 400)
        
        // Set the source rect to the cell frame, so surrounding elements are blurred.
        //        previewingContext.sourceRect = cell.frame
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = CGRect(x:UIScreen.main.bounds.size.width/2, y:UIScreen.main.bounds.size.width/2, width: 0 , height: 0  )
        } else {
            // Fallback on earlier versions
        }
        return nil //return detailViewController//暂时不要3d touch
    }
    
    
    /// Present the view controller for the "Pop" action.
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {//可重写
        // Reuse the "Peek" view controller for presentation.
        show(viewControllerToCommit, sender: self)
    }
    @available(iOS 9.0, *)
    override var previewActionItems : [UIPreviewActionItem] {//UIViewController 自带属性,用以返回peek上划后下面显示的标题,在要pop的控制器中重写以提供实现
        func previewActionForTitle(_ title: String, style: UIPreviewAction.Style = .default) -> UIPreviewAction {
            return UIPreviewAction(title: title, style: style) { previewAction, viewController in
                //         guard let detailViewController = viewController as? GDOperatVC/*,
                //         let sampleTitle = detailViewController.sampleTitle */else { return }//获取目标控制器的标题
                //                    print("\(previewAction.title) triggered from `DetailViewController` for item: \(sampleTitle)")
//                print("\(previewAction.title) triggered from `DetailViewController` for item: \("xxxxxxxx")")
            }
        }
        let action1 = previewActionForTitle("Default Action")
        let action2 = previewActionForTitle("Destructive Action", style: .destructive)
        
        let subAction1 = previewActionForTitle("Sub Action 1")
        let subAction2 = previewActionForTitle("Sub Action 2")
        let groupedActions = UIPreviewActionGroup(title: "Sub Actions…", style: .default, actions: [subAction1, subAction2] )
//        return [action1, action2, groupedActions]
            return [action1, action2]
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
