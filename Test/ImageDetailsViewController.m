//
//  ImageDetailsViewController.m
//  Test
//

#import "ImageDetailsViewController.h"

@interface ImageDetailsViewController ()

@end

@implementation ImageDetailsViewController

@synthesize dictImage, scrollView, imageView, lbName, lbSize, lbDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Set the meta-information
    self.lbName.text = [@"Name: " stringByAppendingString:[self.dictImage objectForKey:@"Name"]];
    self.lbSize.text = [@"Size: " stringByAppendingString:[self.dictImage objectForKey:@"Size"]];
    self.lbDate.text = [@"Date: " stringByAppendingString:[self.dictImage objectForKey:@"Date"]];
    
    // Check if the image has been saved in the document directory
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    NSString * imPath = [documentDirectory stringByAppendingPathComponent:[[self.dictImage objectForKey:@"Name"] stringByAppendingString:@".jpg"]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imPath]) {
        // Set the image
        self.imageView.image = [UIImage imageWithContentsOfFile:imPath];
    }

    // If the image hasn't been saved, we do nothing because it should be downloading in background.
    // The user will have to go back to the library and select the row again to see it.
    
    // The scrollView will be used to do the zooming and panning
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 3.0;
    self.scrollView.delegate = self;
    
    [self.scrollView setZoomScale:1.0];
}

#pragma mark - Events

- (IBAction)btShare_clicked:(id)sender {
    
    // Share the image using ActivityViewController. If the user has Facebook or Twitter installed in
    // their phone, then those social networks will appear to share the image on them.
    UIActivityViewController * activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.imageView.image] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - UIScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
    CGSize size = view.frame.size;
    if (size.height >= self.scrollView.frame.size.height) {
        self.scrollView.contentInset = UIEdgeInsetsZero;
    } else {
        CGFloat delta = self.scrollView.frame.size.height/2 - view.frame.size.height/2;
        self.scrollView.contentInset = UIEdgeInsetsMake(delta, 0, delta, 0);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
