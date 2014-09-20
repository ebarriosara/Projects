//
//  PicturesLibraryTableViewController.m
//  Test
//

#import "PicturesLibraryTableViewController.h"
#import "PicturesLibraryTableViewCell.h"

@interface PicturesLibraryTableViewController () {
    NSArray * infoImages;
}

@end

@implementation PicturesLibraryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"InfoImages" ofType:@"plist"];
    infoImages = [NSArray arrayWithContentsOfFile:path];
    
    //[self downloadImagesInBackground];
    
}

- (void)downloadImagesInBackground {
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];

    for (int i = 0; i < [infoImages count]; i++) {
        
        
        NSDictionary * dict = [infoImages objectAtIndex:i];
        
        // Check if the image has already been downloaded. We will save all the images with jpg format
        NSString * imPath = [documentsDirectory stringByAppendingPathComponent:[[dict objectForKey:@"Name"] stringByAppendingString:@".jpg"]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:imPath]) {
            
            NSLog(@"File %@ doesn't exist", [dict objectForKey:@"Name"]);
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData * data = [NSData dataWithContentsOfURL:[dict objectForKey:@"URL"]];
                UIImage * image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            });
            
        } else {
            
            NSLog(@"File %@ exists", [dict objectForKey:@"Name"]);
        }
        
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [infoImages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PicturesLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    // Get the meta-information of the image
    NSDictionary * dict = [infoImages objectAtIndex:[indexPath row]];
    // Set the name
    cell.lbName.text = [dict objectForKey:@"Name"];
    
    // Set the image
    cell.imageView.image = nil;
    
    // Firstly, check if the image has already been downloaded and saved in the document directory
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    // We will consider all the images with jpg format
    NSString * imPath = [documentDirectory stringByAppendingPathComponent:[[dict objectForKey:@"Name"] stringByAppendingString:@".jpg"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imPath]) {
        
        // The image hasn't been downloaded before, so download it in background
        
        NSLog(@"The image %@ doesn't exist", [dict objectForKey:@"Name"]);
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSURL * url = [NSURL URLWithString:[dict objectForKey:@"URL"]];
            NSData * data = [NSData dataWithContentsOfURL:url];
            UIImage * image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Assign the image in the main UI thread
                PicturesLibraryTableViewCell * cellVisible = (id)[tableView cellForRowAtIndexPath:indexPath];
                if (cellVisible) {
                    // Update the cell only if it is visible. It might be invisible when the image finishes downloading
                    cellVisible.imageView.image = image;
                }
            });
        
            // Finally, save the image in the documents directory for the next time.
            // We will use jpg format
            [UIImageJPEGRepresentation(image, 1.0) writeToFile:imPath atomically:YES];

        });

    } else {
        
        NSLog(@"The image %@ exists", [dict objectForKey:@"Name"]);
        
        // If the image has been downloaded, assign it
        cell.imageView.image = [UIImage imageWithContentsOfFile:imPath];
        
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
