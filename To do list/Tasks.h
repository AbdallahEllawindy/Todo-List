//
//  Tasks.h
//  To do list
//
//  Created by Abdallah on 30/08/2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tasks : NSObject
@property NSString* name;
@property NSString* disc;
@property NSString* periority;
@property NSString* state;
@property NSDate* date;

-(void)encodeWithCoder: (NSCoder *)encoder;



@end

NS_ASSUME_NONNULL_END
