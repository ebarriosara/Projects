//
//  PersonalInfoViewController.m
//  Test
//
//  Created by Gemma Prado Robles on 20/09/14.
//
//

#import "PersonalInfoViewController.h"

@interface PersonalInfoViewController () {
    NSDictionary * dictInfo;
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
