//
//  Tasks.m
//  To do list
//
//  Created by Abdallah on 30/08/2023.
//

#import "Tasks.h"

@implementation Tasks
-(void)encodeWithCoder:(nonnull NSCoder *)encoder {
    [encoder encodeObject:_name forKey: @"name"];
    [encoder encodeObject:_disc forKey: @"disc"];
    [encoder encodeObject:_periority forKey: @"periority"];
    [encoder encodeObject:_state forKey: @"state"];
    [encoder encodeObject:_date forKey:@"date"];
}

-(id)initWithCoder: (NSCoder *)decoder {
    if((self = [super init])) {
        _name = [decoder decodeObjectOfClass: [NSString class] forKey:@"name"];
        _disc = [decoder decodeObjectOfClass: [NSString class] forKey:@"disc"];
        _periority = [decoder decodeObjectOfClass: [NSString class] forKey:@"periority"];
        _state = [decoder decodeObjectOfClass: [NSString class] forKey:@"state"];
        _date = [decoder decodeObjectOfClass: [NSDate class] forKey:@"date"];
    }
    return self;
}

+(BOOL)supportsSecureCoding{
    return YES;
}

@end
