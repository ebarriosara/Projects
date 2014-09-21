//
//  PersonalInfoViewController.h
//  Test
//

#import <UIKit/UIKit.h>

@interface PersonalInfoViewController : UIViewController

// Elements of the view that should be updated
@property (nonatomic, retain) IBOutlet UILabel * lbName;
@property (nonatomic, retain) IBOutlet UITextView * tvInfo;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;

// Method triggered when the UISlider changes
- (IBAction)sliderValueChanged:(id)sender;

@end
