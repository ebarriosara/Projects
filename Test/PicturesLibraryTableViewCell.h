//
//  PicturesLibraryTableViewCell.h
//  Test
//

#import <UIKit/UIKit.h>

// This class represents our custom cell in the table
@interface PicturesLibraryTableViewCell : UITableViewCell

// Elements of the cell that should be updated
@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UILabel * lbName;

@end
