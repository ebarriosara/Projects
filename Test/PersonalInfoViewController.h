//
//  PersonalInfoViewController.h
//  Test
//
//  Created by Gemma Prado Robles on 20/09/14.
//
//

#import <UIKit/UIKit.h>

@interface PersonalInfoViewController : UIViewController

// Elements of the view that should be updated
@property (nonatomic, retain) IBOutlet UILabel * lbName;
@property (nonatomic, retain) IBOutlet UITextView * tvInfo;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;

@end
