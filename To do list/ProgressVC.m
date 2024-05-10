//
//  ProgressVC.m
//  To do list
//
//  Created by Abdallah on 30/08/2023.
//

#import "ProgressVC.h"
#import "Tasks.h"
#import "EditVC.h"

#pragma mark - interface & implementation
@interface ProgressVC ()
@property (weak, nonatomic) IBOutlet UITableView *progressTableView;


@property NSMutableArray<Tasks*> * arr;
@property NSMutableArray<NSNumber*> * view_indices;
@property NSMutableArray<NSNumber*> * low_priority_view_indices;
@property NSMutableArray<NSNumber*> * medium_priority_view_indices;
@property NSMutableArray<NSNumber*> * high_priority_view_indices;
@property NSUserDefaults * defaults;
@property bool is_sort_mode;

@end

@implementation ProgressVC
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_is_sort_mode) {
        if (section == 0) {
            return @"high priority";
        }
        else if (section == 1) {
            return @"medium priority";
        }
        else if (section == 2) {
            return @"low priority";
        }
    }
    else {
    return @"all priorities";
    }
    return @"all priorities";
}

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
        if ([_arr[i].state isEqualToString:@"in_progress"]) {
            [_view_indices addObject:[NSNumber numberWithInt:i]];
        }
    }
    _low_priority_view_indices = [NSMutableArray<NSNumber*> new];
    _medium_priority_view_indices = [NSMutableArray<NSNumber*> new];
    _high_priority_view_indices = [NSMutableArray<NSNumber*> new];
    
    for (int i=0;i<_view_indices.count;++i) {
        if ([_arr[[_view_indices[i] intValue]].periority isEqualToString:@"low"]) {
            [_low_priority_view_indices addObject:[NSNumber numberWithInt:[_view_indices[i] intValue]]];
        }
        else if ([_arr[[_view_indices[i] intValue]].periority isEqualToString:@"medium"]) {
            [_medium_priority_view_indices addObject:[NSNumber numberWithInt:[_view_indices[i] intValue]]];
        }
        else if ([_arr[[_view_indices[i] intValue]].periority isEqualToString:@"high"]) {
            [_high_priority_view_indices addObject:[NSNumber numberWithInt:[_view_indices[i] intValue]]];
        }
    }
}


- (void) save {
//    printf ("inside save\n");
//    for (int i=0;i<_arr.count;++i) {
//        NSLog(@"%@", _arr[i].name);
//    }
//    NSError * error;
    NSData * archiveData = [NSKeyedArchiver archivedDataWithRootObject:_arr];
    [_defaults setObject:archiveData forKey:@"tasksArr"];
    [_defaults synchronize];
//    [self load];
}

- (IBAction)sortBtnTapped:(id)sender {
    _is_sort_mode = !_is_sort_mode; // reverse it
    [self load];
    [_progressTableView reloadData];
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    _progressTableView.delegate=self;
    _progressTableView.dataSource=self;
    _is_sort_mode = false;

    [self load];
}
- (void) viewWillAppear:(BOOL)animated {
    [self load];
    [_progressTableView reloadData];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_is_sort_mode) {
        return 3;
    }
    else {
        return 1;
    }

    return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_is_sort_mode) {
        if (section == 0) {
            return [_high_priority_view_indices count];
        }
        else if (section == 1) {
            return [_medium_priority_view_indices count];
        }
        else if (section == 2) {
            return [_low_priority_view_indices count];
        }
    }
    else {
        return [_view_indices count];
    }
    //return [_arr count];
    return [_view_indices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (_is_sort_mode) {
        NSMutableString * pr;
        if (indexPath.section == 0) {
            cell.textLabel.text=_arr[[_high_priority_view_indices[indexPath.row] intValue]].name;
//            cell.imageView.image = [UIImage imageNamed:@"high"];
        }
        else if (indexPath.section == 1) {
            cell.textLabel.text=_arr[[_medium_priority_view_indices[indexPath.row] intValue]].name;
//            cell.imageView.image = [UIImage imageNamed:@"medium"];
        }
        else if (indexPath.section == 2) {
            cell.textLabel.text=_arr[[_low_priority_view_indices[indexPath.row] intValue]].name;
//            cell.imageView.image = [UIImage imageNamed:@"low"];
        }
    }
    else {
        cell.textLabel.text=_arr[[_view_indices[indexPath.row] intValue]].name;
        if ([_arr[[_view_indices[indexPath.row] intValue]].periority isEqualToString: @"high"]) {
//            cell.imageView.image = [UIImage imageNamed:@"high"];
        }
        else if ([_arr[[_view_indices[indexPath.row] intValue]].periority isEqualToString:@"medium"]) {
//            cell.imageView.image = [UIImage imageNamed:@"medium"];
        }
        else if ([_arr[[_view_indices[indexPath.row] intValue]].periority isEqualToString: @"low" ]) {
//            cell.imageView.image = [UIImage imageNamed:@"low"];
        }
    }
    //cell.textLabel.text=_arr[[_view_indices[indexPath.row] intValue]].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditVC"];
    if (_is_sort_mode) {
        if (indexPath.section == 0) {
            vc.recieve = [_high_priority_view_indices[indexPath.row] intValue];
        }
        else if (indexPath.section == 1) {
            vc.recieve = [_medium_priority_view_indices[indexPath.row] intValue];
        }
        else if (indexPath.section == 2) {
            vc.recieve = [_low_priority_view_indices[indexPath.row] intValue];
        }
    }
    else {
        vc.recieve = [_view_indices[indexPath.row] intValue];
        
    }
    //edit_vc.my_index = [_view_indices[indexPath.row] intValue];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
//         [self.monthTitle removeObjectAtIndex:indexPath.row];
        if (_is_sort_mode) {
            if (indexPath.section == 0) {
                [_arr removeObjectAtIndex:[_high_priority_view_indices[indexPath.row] intValue]];
                [_high_priority_view_indices removeObjectAtIndex:indexPath.row];
                [self save];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
            }
            else if (indexPath.section == 1) {
                [_arr removeObjectAtIndex:[_medium_priority_view_indices[indexPath.row] intValue]];
                [_medium_priority_view_indices removeObjectAtIndex:indexPath.row];
                [self save];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
            }
            else if (indexPath.section == 2) {
                [_arr removeObjectAtIndex:[_low_priority_view_indices[indexPath.row] intValue]];
                [_low_priority_view_indices removeObjectAtIndex:indexPath.row];
                [self save];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
            }
        }
        else {
            [_arr removeObjectAtIndex:[_view_indices[indexPath.row] intValue]];
            [_view_indices removeObjectAtIndex:indexPath.row];
            [self save];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
        }
    }
    else if (editingStyle==UITableViewCellEditingStyleInsert)
    {
    }
}




@end
