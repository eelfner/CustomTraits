//
//  Copyright © 2018 zCage.com Apps LLC. All rights reserved.
//

import UIKit
/**
 * This class enables easier dynamic control of AutoLayout parameters based on _actual_ view sizes.
 * By having UIViewControllers subclass this class, storyboards can be built with greater control
 * for a wider range of display options including iPhone vs. iPad, landscape vs. portrait, and all
 * the split view options.
 *
 * Returned trait size class:
 *                            Width(hor.)  Height(vert.)
 *   All iPhone in Portrait       C          R   - Includes SlideOver and SplitView as desired!
 *   All iPhone in Landscape      C          C   - Overrides 6+, 7+ horizontal size class of R
 *   All iPad   in Portrait       R          R
 *   All iPad   in Landscape      R          C   - Overrides iPad vertical size class of R
 *
 * This allows AutoLayout settings to be based on orientation (vertical size class) and
 * general amount of UI real estate available (iPhone vs. iPad, horizontal size class) or both.
 *
 *   General Rules
 *      Width Size Class: C=iPhone, R=iPad
 *      Height Size Class: C=Landscape, R=Portrait
 *
 * Case1: Common UI for iPhone&iPad, but differ based on Portrait vs. Landscape. Use iPhoneSE P & L.
 * To visualize in IB:
 *   --Simulate--  --Use--
 *    iPhone-P   iPhoneSE-P (C,R)
 *    iPhone-L   iPhoneSE-L (C,C)
 *
 * OR--Simulate--  --Use--
 *    iPad-P     iPad-P     (R,R) Also look at using iPad-L at 2/3 adaptation which is almost square!
 *    iPad-L     iPhone7+-L (R,C) Yes, this is a bit odd!
 *
 * It is expected that if the UI differ dramatically between iPhone and iPad, you'd probably
 * want to use 2 different storyboards. Even in that case, this class could be used because
 * it will allow you to easily differentiate between iPad vs. iPhone and P vs. L, either separately or together.
 *
 * Case2(less common): Common UI for orientation, but differ based on iPhone vs. iPad.
 * To visualize in IB, use any iPhone P and iPad P.:
 *   --Simulate--  --Use--
 *    iPhone-P   iPhoneSE-P (C,R)
 *    iPad-P     iPad-P     (R,R)
 *
 * Case3(even less common): Differ based on both orientation and iPhone vs. iPad.
 * There are 4 main types here. To visualize in IB:
 *   --Simulate--  --Use--
 *    iPhone-P   iPhoneSE-P (C,R)
 *    iPhone-L   iPhoneSE-L (C,C)
 *    iPad-P     iPad-P     (R,R) Also look at using iPad-L at 2/3 adaptation which is almost square!
 *    iPad-L     iPhone7+-L (R,C) Yes, this is a bit odd!
 *
 */
let IPHONE_PLUS_WIDTH = 414                  // For reference only.
let IPAD_SMALL_WIDTH_POINTS = 768

// SplitView point sizes with x.xx = aspect ratio
let IPAD_097P_SPLIT_1THIRD_POINTS = (320, 1024) // 0.31  iPhone-like
let IPAD_097P_SPLIT_2THIRD_POINTS = (438, 1024) // 0.42  iPhone-like
let IPAD_097L_SPLIT_1THIRD_POINTS = (320, 768)  // 0.42  iPhone-like
let IPAD_097L_SPLIT_INHALF_POINTS = (507, 768)  // 0.66  iPad-like
let IPAD_097L_SPLIT_2THIRD_POINTS = (694, 768)  // 0.90  iPad-like

let IPAD_105P_SPLIT_1THIRD_POINTS = (320, 1112) // 0.29  iPhone-like
let IPAD_105P_SPLIT_2THIRD_POINTS = (504, 1112) // 0.45  inBetween
let IPAD_105L_SPLIT_1THIRD_POINTS = (320, 834)  // 0.38  iPhone-like
let IPAD_105L_SPLIT_INHALF_POINTS = (551, 834)  // 0.66  iPad-like
let IPAD_105L_SPLIT_2THIRD_POINTS = (782, 834)  // 0.92  iPad-like

let IPAD_129P_SPLIT_1THIRD_POINTS = (375, 1366) // 0.27  iPhone-like
let IPAD_129P_SPLIT_2THIRD_POINTS = (639, 1366) // 0.46  inBetween
let IPAD_129L_SPLIT_1THIRD_POINTS = (375, 1024) // 0.37  iPhone-like
let IPAD_129L_SPLIT_INHALF_POINTS = (678, 1024) // 0.66  iPad-like
let IPAD_129L_SPLIT_2THIRD_POINTS = (981, 1024) // 0.95  iPad-like


public class OrientationSizeTraitViewController: UIViewController {
    let kBigViewBreak = IPAD_097L_SPLIT_INHALF_POINTS.0  // Recommended. All iPad portrait split views are considered iPhone like execept 2/3 on 12.9" iPad.
    
    override public var traitCollection: UITraitCollection {
        //print("OrientationSizeTraitViewController::Frame: \(view.frame)")
        let horizontalSizeClass: UIUserInterfaceSizeClass = isBigView() ? .regular : .compact
        let verticalSizeClass: UIUserInterfaceSizeClass = isPortrait() ? .regular : .compact
        
        let horizontalTraitCollection = UITraitCollection(horizontalSizeClass: horizontalSizeClass)
        let verticalTraitCollection = UITraitCollection(verticalSizeClass: verticalSizeClass)
        
        return UITraitCollection(traitsFrom: [horizontalTraitCollection, verticalTraitCollection])
    }
    private func isPortrait() -> Bool {
        return view.frame.height > view.frame.width
    }
    private func isBigView() -> Bool {
        // Note: I could see cases where you might also want to use aspect ratio here plus some minimal size.
        return min(view.frame.width, view.frame.height) >= CGFloat(kBigViewBreak)
    }
}
