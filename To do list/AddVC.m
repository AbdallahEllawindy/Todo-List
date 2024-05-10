//
//  AddVC.m
//  To do list
//
//  Created by Abdallah on 30/08/2023.
//

#import "AddVC.h"
#import "ViewController.h"
#import "Tasks.h"

#pragma mark - interface & implementation
@interface AddVC()
@property (weak, nonatomic) IBOutlet UITextField *name_field;
@property (weak, nonatomic) IBOutlet UITextField *desc_field;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority_segment;
@property (weak, nonatomic) IBOutlet UIDatePicker *date_input;

@property NSMutableArray<Tasks*> * arr;
@property NSUserDefaults * defaults;
@end

@implementation AddVC

- (void) load {
    _defaults = [NSUserDefaults standardUserDefaults];
    
//    NSError * error;
    NSData * savedData = [_defaults objectForKey:@"tasksArr"];
    
//    NSSet * set = [NSSet setWithArray:
//                   @[[NSMutableArray class], [Tasks class]]];
    
    _arr = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:savedData];
    
    if (_arr == nil) {
        printf ("nill inside load\n");
        _arr = [NSMutableArray<Tasks*> new];
    }
//    printf("inside load \n");
//    for (int i=0;i<_arr.count;++i) {
//        NSLog(@"%@", _arr[i].name);
//    }
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
    }

- (IBAction)add_item:(id)sender {
    Tasks* t = [Tasks new];
        /*
     @property NSString * name;
     @property NSString * desc;
     @property NSString * priority;
     @property NSString * state;
     @property NSDate * date;
     */
    t.name = _name_field.text;
    t.disc = _desc_field.text;
    NSArray<NSString*>* values = @[@"low", @"medium", @"high"];
    t.periority = values[(int)_priority_segment.selectedSegmentIndex];
    t.state=@"todo";
    t.date = _date_input.date;
    
//    NSLog(@"%@", t.name);
//    NSLog(@"%@", t.desc);
//    NSLog(@"%@", t.priority);
//    NSLog(@"%@", t.state);
//    NSLog(@"%@", t.date);
    [_arr addObject:t];
    [self save];
  
    [self.navigationController popViewControllerAnimated:true];
    
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self load];
    

}


@end
