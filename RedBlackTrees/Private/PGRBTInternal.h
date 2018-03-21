/*******************************************************************************************************************************************************************************//**
 *     PROJECT: RedBlackTree
 *    FILENAME: PGRBTInternal.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 3/13/18
 *  VISIBILITY: Private
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

#ifndef _RedBlackTree_PGRBTInternal_H_
#define _RedBlackTree_PGRBTInternal_H_

#import <Cocoa/Cocoa.h>
#import <objc/runtime.h>

@class PGRBTNode;

NS_ASSUME_NONNULL_BEGIN

NSComparisonResult PGCompareObjects(id object1, id object2);

void decendInto(NSMutableArray<PGRBTNode *> *stack, PGRBTNode *_Nullable node, BOOL forward);

/**
 * This function is used to try to determine the most efficient stack size for enumerating over a reasonably well balanced
 * tree without having to allocate too much memory or having the amount of memory expanded.
 *
 * @param count the number of items in the stack.
 * @return the approximate size of stack needed.
 */
NS_INLINE NSUInteger estimateStackSize(NSUInteger count) {
    NSUInteger bits = 1, match = 1;

    while(match < count) {
        match = (match << 1);
        bits++;
    }

    return (bits + 2);
}

NS_INLINE NSComparisonResult PGInverseCompare(NSComparisonResult c) {
    return ((c == NSOrderedSame) ? c : ((c == NSOrderedDescending) ? NSOrderedAscending : NSOrderedDescending));
}

NS_ASSUME_NONNULL_END

#endif //_RedBlackTree_PGRBTInternal_H_
