//
//  ImportImageViewController.h
//  Test
//

#import <UIKit/UIKit.h>

@interface ImportImageViewController : UIViewController<UITextFieldDelegate>

// Fields of the view that the user will fill in
@property (nonatomic, retain) IBOutlet UITextField * tfName;
@property (nonatomic, retain) IBOutlet UITextView * tvURL;

// Method called when the user presses the Done button 
- (IBAction)btDone_clicked:(id)sender;

@end
