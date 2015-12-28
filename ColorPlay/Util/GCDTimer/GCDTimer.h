//
//  GCDTimer.h
//  StroopPlay
//
//  Created by huangzhifei on 15/09/10
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

/**
 sample:
    
    //.h
        GCDTimer *timer
    
    //.m
     UILabel *label = [UILabel new];
     label.text = @"Hello!";
     [self.view addSubview:label];
     
     timer = [GCDTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^{
        counter++;
        label.text = [NSString stringWithFormat:@"counter %d", counter];
     }];
 
 */

@interface GCDTimer : NSObject

/**
 *  custom thread perform block, instance method
 *
 *  @param seconds delay seconds
 *  @param repeats repeat
 *  @param queue   custom thread
 *  @param block   custom block
 *
 *  @return self
 */
- (instancetype) initScheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                            repeats:(BOOL)repeats queue:(dispatch_queue_t)queue
                                              block:(dispatch_block_t)block;

/**
 *  custom thread perform block, class Method
 *
 *  @param seconds delay seconds
 *  @param repeats repeat
 *  @param queue   custom thread
 *  @param block   custom block
 *
 *  @return self
 */
+ (instancetype) scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                        repeats:(BOOL)repeats queue:(dispatch_queue_t)queue
                                          block:(dispatch_block_t)block;


/**
 *  main queue - UI thread perform block, instance method
 *
 *  @param seconds delay seconds
 *  @param repeats repeat
 *  @param block   custom block
 *
 *  @return self
 */
- (instancetype) initScheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                            repeats:(BOOL)repeats
                                              block:(dispatch_block_t)block;

/**
 *  main queue - UI thread perform block, class method
 *
 *  @param seconds delay seconds
 *  @param repeats repeat
 *  @param block   custom thread
 *
 *  @return self
 */
+ (instancetype) scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                        repeats:(BOOL)repeats
                                          block:(dispatch_block_t)block;

/**
 *  cancel timer
 */
- (void) invalidate;

@end
