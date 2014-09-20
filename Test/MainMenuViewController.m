//
//  ViewController.m
//  Test
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // When the app starts, we have to check if the meta-information has been copied onto the
    // Document Directory, so that it can be modified to add new images.
    
    // Get the path of the file in the Document Directory
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    NSString * finalPath = [documentDirectory stringByAppendingPathComponent:@"InfoImages.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    // If the file doesn't exist, copy it
    if (![fileManager fileExistsAtPath:finalPath]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"InfoImages" ofType:@"plist"];
        if (![fileManager copyItemAtPath:path toPath:finalPath error:&error]) {
            NSLog(@"Fail when trying to copy InfoImages.plist to Document Directory");
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Hide the navigation bar initially
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Show the navigation bar when a new view will appear
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
