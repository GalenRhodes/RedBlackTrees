/*******************************************************************************************************************************************************************************//**
 *     PROJECT: RedBlackTree
 *    FILENAME: PGRBTMap.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 3/13/18
 *
 * Copyright © 2018 Project Galen. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this
 * permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
 * AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 **********************************************************************************************************************************************************************************/

#import "PGRBTMap.h"
#import "PGRBTNode.h"
#import "PGRBTEnumerator.h"
#import "PGRBTInternal.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"

@interface PGRBTNode()

    -(void)clear;

@end

@interface PGRBTMap()

    @property(nonatomic, retain) PGRBTNode *root;

@end

@implementation PGRBTMap {
    }

    @synthesize comparator = _comparator;
    @synthesize root = _root;

    -(instancetype)init {
        return (self = [self initWithComparator:nil]);
    }

    -(instancetype)initWithComparator:(NSComparator)comparator {
        self = [super init];

        if(self) {
            self.root       = nil;
            self.comparator = comparator;
        }

        return self;
    }

    -(instancetype)initWithNSDictionary:(NSDictionary *)dictionary {
        return (self = [self initWithNSDictionary:dictionary comparator:nil]);
    }

    -(instancetype)initWithNSDictionary:(NSDictionary *)dictionary comparator:(NSComparator)comparator {
        self = [self initWithComparator:comparator];
        if(self) [self addAllObjectsFromNSDictionary:dictionary];
        return self;
    }

    -(void)addAllObjectsFromNSDictionary:(NSDictionary *)dictionary {
        return [self addAllObjectsFromNSDictionary:dictionary comparator:self.comparator];
    }

    -(void)addAllObjectsFromNSDictionary:(NSDictionary *)dictionary comparator:(NSComparator)comparator {
        NSEnumerator *keys = dictionary.keyEnumerator;
        id           key   = keys.nextObject;

        if(key) {
            if(self.root == nil) {
                (self.root = [[PGRBTNode alloc] initWithValue:dictionary[key] forKey:key]).isRed = NO;
                key = keys.nextObject;
            }

            if(comparator == nil) comparator = self.comparator;

            while(key) {
                self.root = [[self.root insertValue:dictionary[key] forKey:key comparator:comparator] rootNode];
                key = keys.nextObject;
            }
        }
    }

    -(void)setComparator:(NSComparator)comparator {
        if(comparator == nil) comparator = ^NSComparisonResult(id obj1, id obj2) { return PGCompareObjects(obj1, obj2); };
        _comparator = [comparator copy];
    }

    -(NSUInteger)count {
        return self.root.count;
    }

    -(id)valueForKey:(id)key {
        return [self valueForKey:key comparator:self.comparator];
    }

    -(id)valueForKey:(id)key comparator:(NSComparator)comparator {
        return [self.root findNodeWithKey:key comparator:comparator ?: self.comparator].value;
    }

    -(void)insertValue:(id)value forKey:(id<NSCopying>)key {
        [self insertValue:value forKey:key comparator:self.comparator];
    }

    -(void)insertValue:(id)value forKey:(id<NSCopying>)key comparator:(NSComparator)comparator {
        if(self.root) {
            self.root = [[self.root insertValue:value forKey:key comparator:comparator ?: self.comparator] rootNode];
        }
        else {
            (self.root = [[PGRBTNode alloc] initWithValue:value forKey:key]).isRed = NO;
        }
    }

    -(void)removeValueForKey:(id)key {
        [self removeValueForKey:key comparator:self.comparator];
    }

    -(void)removeValueForKey:(id)key comparator:(NSComparator)comparator {
        PGRBTNode *node = [self.root findNodeWithKey:key comparator:comparator ?: self.comparator];
        if(node) self.root = [node delete];
    }

    -(void)removeAllValues {
        [self.root clear];
        self.root = nil;
    }

    -(id)objectForKeyedSubscript:(id)key {
        return [self.root findNodeWithKey:key].value;
    }

    -(void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
        [self insertValue:object forKey:key comparator:self.comparator];
    }

    -(NSEnumerator *)valueEnumerator {
        return [[PGRBTEnumerator alloc] initWithMap:self root:self.root options:(EnumerateValues | EnumerateForward)];
    }

    -(NSEnumerator *)keyEnumerator {
        return [[PGRBTEnumerator alloc] initWithMap:self root:self.root options:EnumerateForward];
    }

    -(NSEnumerator *)reverseValueEnumerator {
        return [[PGRBTEnumerator alloc] initWithMap:self root:self.root options:EnumerateValues];
    }

    -(NSEnumerator *)reverseKeyEnumerator {
        return [[PGRBTEnumerator alloc] initWithMap:self root:self.root options:0];
    }

    -(void)dealloc {
        [self.root clear];
        self.root       = nil;
        self.comparator = nil;
    }

    -(NSString *)description {
        BOOL            isNotFirst   = NO;
        NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];

        [description appendFormat:@"count=%lu ", self.count];
        [description appendString:@"@{"];

        for(id key in self.keyEnumerator) {
            if(isNotFirst) {
                [description appendFormat:@", \"%@\": \"%@\"", key, self[key]];
            }
            else {
                [description appendFormat:@" \"%@\": \"%@\"", key, self[key]];
                isNotFirst = YES;
            }
        }

        [description appendString:@" }>"];
        return description;
    }


@end

#pragma clang diagnostic pop
