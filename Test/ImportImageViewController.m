//
//  ImportImageViewController.m
//  Test
//
//  Created by Gemma Prado Robles on 20/09/14.
//
//

#import "ImportImageViewController.h"

@interface ImportImageViewController ()

@end

@implementation ImportImageViewController

@synthesize tfName, tvURL;

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
    // Delegate for dismissing the keyboard
    tfName.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNewImage {
    
    // Get the path of the InfoImages.plist file
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    NSString * path = [documentDirectory stringByAppendingPathComponent:@"InfoImages.plist"];
    
    // Get the current version of the file
    NSMutableArray * array = [NSMutableArray arrayWithContentsOfFile:path];
    
    // Get the current date
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YY"];
    NSString * dateString = [dateFormatter stringFromDate:date];
    
    // Create a new dictionary with the meta-information of the new image
    NSArray * objects = [NSArray arrayWithObjects:tfName.text, tvURL.text, @"0 bytes", dateString, nil];
    NSArray * keys = [NSArray arrayWithObjects:@"Name", @"URL", @"Size", @"Date", nil];
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
            
    // Add the dictionary to the array with the meta-information
    [array addObject:dict];
            
    // Replace the content of the InfoImages.plist with the new array
    [array writeToFile:path atomically:YES];
    
}

#pragma mark - Events

// Called when the user presses Done. A new image should be added to the library.
- (IBAction)btDone_clicked:(id)sender {
    
    // Check if the name and the URL have been written
    
    if ([tvURL.text length] > 0 && [tfName.text length] > 0) {
    
        // Add the new image
        [self addNewImage];
    
        // Go back to the main menu
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        // Show an alert telling the user to write the name and the URL
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Please, you need to write the name of the image and its URL" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}

#pragma mark - UITextFieldDelegate

// It is necessary for dismissing the keyboard when the user has finished editing the text field
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
