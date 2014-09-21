//
//  PicturesLibraryTableViewController.m
//  Test
//

#import "PicturesLibraryTableViewController.h"
#import "PicturesLibraryTableViewCell.h"
#import "ImageDetailsViewController.h"

@interface PicturesLibraryTableViewController () {
    // Array with the meta-information of the images
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
    
    // Get the meta-information of the images from the Document Directory.
    // This information is stored in the file named InfoImages.plist.    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    NSString * path = [documentDirectory stringByAppendingPathComponent:@"InfoImages.plist"];    
    infoImages = [NSArray arrayWithContentsOfFile:path];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Update the meta-information with a new size when the user imports a new image
- (void)updateMetaInfoForIndex:(int)index withSize:(int)size {

    // Get the path of the InfoImages.plist file
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    NSString * path = [documentDirectory stringByAppendingPathComponent:@"InfoImages.plist"];
    
    // Get the current version of the file
    NSMutableArray * array = [NSMutableArray arrayWithContentsOfFile:path];
    
    // Add the dictionary to the array with the meta-information
    NSMutableDictionary * dict = [array objectAtIndex:index];
    [dict setObject:[NSString stringWithFormat:@"%d bytes", size] forKey:@"Size"];
    
    [array replaceObjectAtIndex:index withObject:[NSDictionary dictionaryWithDictionary:dict]];
    
    // Replace the content of the InfoImages.plist with the new array
    [array writeToFile:path atomically:YES];
    
    // Update the infoImages
    infoImages = [NSArray arrayWithContentsOfFile:path];
    
    // Reload the data to update the rows
    [self.tableView reloadData];
    
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
    
    // Firstly, check if the image has already been downloaded and saved in the document directory
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    // We will consider all the images with jpg format
    NSString * imPath = [documentDirectory stringByAppendingPathComponent:[[dict objectForKey:@"Name"] stringByAppendingString:@".jpg"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imPath]) {
        
        // The image hasn't been downloaded before, so set the placeholder image and download in background
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"PlaceholderImage" ofType:@"png"];
        cell.imageView.image = [UIImage imageWithContentsOfFile:path];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
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
                
                // If the image has been imported to the library by the user, we need to update its size
                // in the meta-information
                if ([[dict objectForKey:@"Size"] isEqualToString:@"0 bytes"]) {
                    [self updateMetaInfoForIndex:[indexPath row] withSize:[data length]];
                }
            });
        
            // Finally, check that any other thread has saved the same image and save the image in the documents directory for the next time.
            // We will use jpg format
            if (![[NSFileManager defaultManager] fileExistsAtPath:imPath]) {
                [UIImageJPEGRepresentation(image, 1.0) writeToFile:imPath atomically:YES];
            }
            
        });

    } else {
        
        NSLog(@"The image %@ exists", [dict objectForKey:@"Name"]);
        
        // If the image has been downloaded, assign it
        cell.imageView.image = [UIImage imageWithContentsOfFile:imPath];
        
    }
    
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showImage"]) {
        // When the user selects a row, the segue will be performed.
        // We need to set the meta-information of the selected image
        // before the Image Details view controller appears.
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        ImageDetailsViewController * vc = [segue destinationViewController];
        vc.dictImage = [infoImages objectAtIndex:[indexPath row]];
    }
    
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
