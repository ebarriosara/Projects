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
    
    // Get the image that will be shown
    UIImage * image;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imPath]) {
    
        image = [UIImage imageWithContentsOfFile:imPath];
    
    } else {

        // If the image hasn't been saved, we show the placeholder image because it should be downloading in background.
        // The user will have to go back to the library and select the row again to see it.
        NSString * path = [[NSBundle mainBundle] pathForResource:@"PlaceholderImage" ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:path];
        
    }
    
    // Create the imageView
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    [self.scrollView addSubview:self.imageView];
    
    // Set the size of the scrollView
    self.scrollView.contentSize = image.size;
    
    // Add gesture recognizers to detect when the user taps
    UITapGestureRecognizer * doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer * twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    
    // Set the scrollView's delegate
    self.scrollView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Update the scale of the scrollView depending on the size of its image
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 2.0f;
    self.scrollView.zoomScale = minScale;
    
    // Center the contents of the scrollView
    [self centerScrollView];
}

// Center the contents of the scrollView
- (void)centerScrollView {
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

// Method triggered when the user taps with two fingers
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {

    // Zoom out smoothly
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];

}

// Method triggered when the user double taps
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
   
    // Get the location where the user thas tapped
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    // Calculate the new scale
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // Set the size
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
    
}

#pragma mark - Events

- (IBAction)btShare_clicked:(id)sender {
    
    // Share the image using ActivityViewController. If the user has Facebook or Twitter installed in
    // their phone, then those social networks will appear to share the image on them.
    UIActivityViewController * activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.imageView.image] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - UIScrollView Delegate

// These method allows the user to zoom and tap
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // Center the contents when the user zooms
    [self centerScrollView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
