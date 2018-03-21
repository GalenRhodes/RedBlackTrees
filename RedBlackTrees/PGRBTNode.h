/*******************************************************************************************************************************************************************************//**
 *     PROJECT: RedBlackTree
 *    FILENAME: PGRBTNode.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 3/12/18
 *  VISIBILITY: Public
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

#ifndef REDBLACKTREE_PGRBTNODE_H
#define REDBLACKTREE_PGRBTNODE_H

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGRBTNode<K, V> : NSObject

    @property(nonatomic) /*                    */ BOOL            isRed;
    @property(nonatomic, copy, readonly) /*    */ K<NSCopying>    key;
    @property(nonatomic, retain) /*            */ V               value;
    @property(nonatomic, readonly) /*          */ NSUInteger      count;
    @property(nonatomic, nullable, retain) /*  */ PGRBTNode<K, V> *parentNode;
    @property(nonatomic, nullable, retain) /*  */ PGRBTNode<K, V> *leftNode;
    @property(nonatomic, nullable, retain) /*  */ PGRBTNode<K, V> *rightNode;
    @property(nonatomic, nullable, readonly) /**/ PGRBTNode<K, V> *rootNode;

    -(instancetype)initWithValue:(V)value forKey:(id<NSCopying>)key;

    -(PGRBTNode<K, V> *)insertValue:(V)value forKey:(id<NSCopying>)key;

    -(PGRBTNode<K, V> *)insertValue:(V)value forKey:(id<NSCopying>)key comparator:(nullable NSComparator)comparator;

    -(nullable PGRBTNode<K, V> *)findNodeWithKey:(K)key;

    -(nullable PGRBTNode<K, V> *)findNodeWithKey:(K)key comparator:(nullable NSComparator)comparator;

    -(nullable PGRBTNode<K, V> *)delete;

@end

NS_ASSUME_NONNULL_END

#endif //REDBLACKTREE_PGRBTNODE_H
