//
//  ImageDetailsViewController.h
//  Test
//

#import <UIKit/UIKit.h>

@interface ImageDetailsViewController : UIViewController<UIScrollViewDelegate>

// IBOutlets for updating all the elements of the view
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UILabel * lbName;
@property (nonatomic, retain) IBOutlet UILabel * lbSize;
@property (nonatomic, retain) IBOutlet UILabel * lbDate;

// NSDictionary with the meta-information of the image
@property (nonatomic, retain) NSDictionary * dictImage;

// Method for sharing the photograph
- (IBAction)btShare_clicked:(id)sender;

@end
