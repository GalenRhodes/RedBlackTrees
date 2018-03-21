/*******************************************************************************************************************************************************************************//**
 *     PROJECT: RedBlackTree
 *    FILENAME: PGRBTEnumerator.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 3/15/18
 * * Copyright © 2018 Project Galen. All rights reserved.
 * * Permission to use, copy, modify, and distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this
 * permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
 * AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 **********************************************************************************************************************************************************************************/

#import "PGRBTEnumerator.h"
#import "PGRBTNode.h"
#import "PGRBTInternal.h"
#import "PGRBTMap.h"

@implementation PGRBTEnumerator {
        NSMutableArray<PGRBTNode *> *_stack;
        uint8_t                     _flags;
    }

    @synthesize map = _map;

    -(instancetype)initWithMap:(PGRBTMap *)map root:(PGRBTNode *)root options:(PGRBTEnumeratorOptions)options {
        self = [super init];

        if(self) {
            _map   = map;
            _flags = options;
            _stack = [NSMutableArray arrayWithCapacity:estimateStackSize(_map.count)];
            decendInto(_stack, root, self.enumForward);
        }

        return self;
    }

    -(BOOL)enumForward {
        return ((_flags & EnumerateForward) == EnumerateForward);
    }

    -(BOOL)enumValues {
        return ((_flags & EnumerateValues) == EnumerateValues);
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"

    -(id)nextObject {
        if(_stack.count) {
            PGRBTNode *node       = [_stack lastObject];
            BOOL      enumForward = self.enumForward;

            [_stack removeLastObject];
            decendInto(_stack, (enumForward ? node.rightNode : node.leftNode), enumForward);
            return (self.enumValues ? node.value : node.key);
        }

        return nil;
    }

#pragma clang diagnostic pop

@end

