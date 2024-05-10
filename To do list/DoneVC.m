//
//  DoneVC.m
//  To do list
//
//  Created by Abdallah on 30/08/2023.
//

#import "DoneVC.h"
#import "Tasks.h"
#import "EditVC.h"


#pragma mark - interface & implementation
@interface DoneVC ()
@property NSMutableArray<Tasks*> *arr;
@property NSMutableArray<NSNumber*> *view_indices;
@property NSUserDefaults * defaults;
@property (weak, nonatomic) IBOutlet UITableView *doneTableView;

@end

@implementation DoneVC
- (void) load {
    _defaults = [NSUserDefaults standardUserDefaults];
    NSData * savedData = [_defaults objectForKey:@"tasksArr"];
//    NSSet * set = [NSSet setWithArray:
//                   @[[NSMutableArray class], [Tasks class]]];
    _arr = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:savedData];
    
    if (_arr == nil) {
        _arr = [NSMutableArray<Tasks*> new];
    }
    _view_indices = [NSMutableArray<NSNumber*> new];
    for (int i=0;i<_arr.count;++i) {
        if ([_arr[i].state isEqualToString:@"done"]) {
            [_view_indices addObject:[NSNumber numberWithInt:i]];
        }
    }
}
- (void) save {
//    [_defaults setObject:archiveData forKey:@"tasks_arr"];
    NSData * archiveData = [NSKeyedArchiver archivedDataWithRootObject:_arr];
    [_defaults setObject:archiveData forKey:@"tasksArr"];
    [_defaults synchronize];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    _doneTableView.delegate=self;
    _doneTableView.dataSource=self;
    [self load];

}
- (void) viewWillAppear:(BOOL)animated {
    [self load];
    [_doneTableView reloadData];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_view_indices count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text=_arr[[_view_indices[indexPath.row] intValue]].name;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditVC * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditVC"];
    
    vc.recieve = [_view_indices[indexPath.row] intValue];
    _arr[[_view_indices[indexPath.row]intValue]].state=@"";
    [self.navigationController pushViewController:vc animated:(true)];
  
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
//         [self.monthTitle removeObjectAtIndex:indexPath.row];
        [_arr removeObjectAtIndex:[_view_indices[indexPath.row] intValue]];
        [_view_indices removeObjectAtIndex:indexPath.row];
        [self save];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }
    else if (editingStyle==UITableViewCellEditingStyleInsert)
    {
    }
}

@end
