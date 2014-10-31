//
//  ExampleTableViewController.m
//  coredata
//
//  Created by Caland on 14/10/31.
//  Copyright (c) 2014年 Caland. All rights reserved.
//

#import "ExampleTableViewController.h"
#import "DataManager.h"

@interface ExampleTableViewController ()

//@step1
@property (retain, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
//@step3
@property (nonatomic, retain, readonly) NSFetchedResultsController *fetchedResultsController;


@end

@implementation ExampleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //@step5 validate the fetchResultsController
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();//生成crash log 并屯出
    }
}


#pragma mark - Propertity Method

//@step2 init it
- (NSManagedObjectContext*) managedObjectContext
{
    return [[DataManager defaultInstance] objectContext];
}
//@step4 init fetchResultsController
- (NSFetchedResultsController *) fetchedResultsController
{
    if (!_fetchedResultsController) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        //编辑其需要查询的对象的名称
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"APLEvent" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        // 设置batch size 为一个合适的值
        [fetchRequest setFetchBatchSize:20];
        
        // Sort using the timeStamp property.
        // 使用APLEvent的哪一个属性来进行
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor ]];
        
        // Use the sectionIdentifier property to group into sections.
        // 使用Section 标识用来进行属性分组
        _fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:self.managedObjectContext
                                     sectionNameKeyPath:@"sectionIdentifier"
                                     cacheName:@"Root"];
        _fetchedResultsController.delegate = self;
        
        return _fetchedResultsController;
    }
    return fetchedResultsController;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[self.fetchedResultsController sections] count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    NSInteger count = [sectionInfo numberOfObjects];
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JustaReuseIdentifier" forIndexPath:indexPath];
    
    APLEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = event.title;
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    
 
    static NSDateFormatter *formatter = nil;
    
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setCalendar:[NSCalendar currentCalendar]];
        
        NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"MMMM YYYY" options:0 locale:[NSLocale currentLocale]];
        [formatter setDateFormat:formatTemplate];
    }
    
    NSInteger numericSection = [[theSection name] integerValue];
    NSInteger year = numericSection / 1000;
    NSInteger month = numericSection - (year * 1000);
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = year;
    dateComponents.month = month;
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    NSString *titleString = [formatter stringFromDate:date];
    
    return titleString;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - NSFetchResultsController delegate methods
/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

/**
 *  修改了某些对象，见CoreDataBooks
 */
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:{
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
            
        case NSFetchedResultsChangeDelete:{
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
