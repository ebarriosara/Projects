//
//  PersonalInfoViewController.m
//  Test
//

#import "PersonalInfoViewController.h"

@interface PersonalInfoViewController () {
    // Dictionary that contains the personal information
    NSDictionary * dictInfo;
    // Previous value of the UISlider to avoid updating the text view when it is not necessary
    float prevValue;
}

@end

@implementation PersonalInfoViewController

@synthesize imageView, lbName, tvInfo;

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
    
    // Get the information
    NSString * path = [[NSBundle mainBundle] pathForResource:@"PersonalInfo" ofType:@"plist"];
    dictInfo = [NSDictionary dictionaryWithContentsOfFile:path];
    self.lbName.text = [dictInfo objectForKey:@"Name"];
    self.tvInfo.text = [[dictInfo objectForKey:@"Texts"] objectForKey:@"2003"];
    path = [[NSBundle mainBundle] pathForResource:[dictInfo objectForKey:@"Image"] ofType:@"jpg"];
    self.imageView.image = [UIImage imageWithContentsOfFile:path];
    
    // Initialize variables
    prevValue = 0.0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events

// Method triggered when the UISlider changes
- (IBAction)sliderValueChanged:(id)sender {
    
    UISlider * slider = (UISlider *)sender;
    
    // Set the corresponding text depending on the value of the UISlider
    if (slider.value <= 1.0 && prevValue > 1.0) {
    
        self.tvInfo.text = [[dictInfo objectForKey:@"Texts"] objectForKey:@"2003"];
    
    } else if (slider.value > 1.0 && slider.value <= 2.0 &&
               (prevValue <= 1.0 || prevValue > 2.0)) {
        
        self.tvInfo.text = [[dictInfo objectForKey:@"Texts"] objectForKey:@"2008"];
        
    } else if (slider.value > 2.0 && slider.value <= 3.0 && prevValue <= 2.0) {
        
        self.tvInfo.text = [[dictInfo objectForKey:@"Texts"] objectForKey:@"2014"];
        
    }
    
    // Update the previous value for the next call
    prevValue = slider.value;
    
}

@end
