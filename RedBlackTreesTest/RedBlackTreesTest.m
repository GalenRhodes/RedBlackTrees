//
//  main.m
//  RedBlackTreesTest
//
//  Created by Galen Rhodes on 3/23/18.
//  Copyright © 2018 Project Galen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedBlackTrees.h"

/**
 * This function will return a random number between 0.0 and 1.0 inclusive.
 *
 * @return a random floating point number.
 */
double drand() {
    return (((double)rand()) / ((double)RAND_MAX));
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        NSLog(@"Arguments:");
        for(int i = 0; i < argc; i++) {
            NSLog(@"%2d> \"%s\"", i, argv[i]);
        }

        NSString     *filePath  = [[[NSString stringWithUTF8String:argv[1]] stringByExpandingTildeInPath] stringByAppendingString:@"/PostInsert-%03lu.png"];
        NSString     *chs       = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        NSString     *t         = chs;
        NSUInteger   cnt        = chs.length;
        NSUInteger   inum       = 0;
        NSComparator comparator = ^NSComparisonResult(id obj1, id obj2) { return [(NSString *)obj1 compare:(NSString *)obj2]; };

        PGRBTMap<NSString *, PGRBTDrawData<NSString *> *> *map = [[PGRBTMap alloc] initWithComparator:comparator];

        srand((unsigned int)time(0));

        while(t.length) {
            if(t.length == 1) {
                [map insertValue:[[PGRBTDrawData alloc] initWithData:t] forKey:t];
                t = @"";
            }
            else {
                NSUInteger idx = (NSUInteger)floor(drand() * t.length);
                NSString   *s  = [t substringWithRange:NSMakeRange(idx, 1)];
                t = [NSString stringWithFormat:@"%@%@", [t substringToIndex:idx], [t substringFromIndex:(idx + 1)]];
                [map insertValue:[[PGRBTDrawData alloc] initWithData:s] forKey:s];
            }
        }

        NSError  *error    = nil;
        NSString *filename = [NSString stringWithFormat:filePath, ++inum];
        [[[PGRBTDrawParams alloc] init] drawNodes:map.root filename:filename error:&error];
        if(error) NSLog(@"ERROR: %@", [error description]);
    }

    return 0;
}
