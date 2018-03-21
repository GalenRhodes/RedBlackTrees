/*******************************************************************************************************************************************************************************//**
 *     PROJECT: RedBlackTree
 *    FILENAME: PGRBTInternal.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 3/21/18
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

#import "PGRBTInternal.h"
#import "PGRBTNode.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCDFAInspection"

NSComparisonResult PGCompareObjects(id object1, id object2) {
    /*
     * Get the easy stuff out of the way.
     */
    if(object1 == object2) return NSOrderedSame;
    if(object2 == nil) return NSOrderedDescending;
    if(object1 == nil) return NSOrderedAscending;

    if([object1 isEqual:object2]) {
        return NSOrderedSame;
    }
    if([object2 isKindOfClass:[object1 class]] && [object1 respondsToSelector:@selector(compare:)]) {
        return [object1 compare:object2];
    }
    if([object1 isKindOfClass:[object2 class]] && [object2 respondsToSelector:@selector(compare:)]) {
        return PGInverseCompare([object2 compare:object1]);
    }

    /*
     * Look for a parent/base class that both keys might have in common starting with themselves. If
     * found and this base class responds to the "compare:" message then use that to do the comparison.
     */
    Class sKeyClass = [object1 class];
    Class oKeyClass = [object2 class];

    for(Class ca = sKeyClass; ca != nil; ca = class_getSuperclass(ca)) {
        for(Class cb = oKeyClass; cb != nil; cb = class_getSuperclass(cb)) {
            if((ca == cb) && class_respondsToSelector(ca, @selector(compare:))) {
                return [object1 compare:object2];
            }
        }
    }

    /*
     * There is no "common" base class that the two objects share or
     * there is one and it doesn't respond to the "compare:" message.
     */
    NSString *skcName = NSStringFromClass(sKeyClass);
    NSString *okcName = NSStringFromClass(oKeyClass);
    NSString *format  = @"Unable to compare objects of types %1$@ and %2$@.";
    NSString *reason  = [NSString stringWithFormat:format, skcName, okcName];

    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
}

void decendInto(NSMutableArray<PGRBTNode *> *stack, PGRBTNode *node, BOOL forward) {
    if(node) {
        [stack addObject:node];
        decendInto(stack, (forward ? node.leftNode : node.rightNode), forward);
    }
}

#pragma clang diagnostic pop
