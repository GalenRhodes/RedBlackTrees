/*******************************************************************************************************************************************************************************//**
 *     PROJECT: RedBlackTree
 *    FILENAME: PGRBTMap.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 3/13/18
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

#ifndef REDBLACKTREE_PGRBTMAP_H
#define REDBLACKTREE_PGRBTMAP_H

#import <Cocoa/Cocoa.h>

@class PGRBTNode;

NS_ASSUME_NONNULL_BEGIN

@interface PGRBTMap<K, V> : NSObject

    @property(nonatomic, readonly) /* */ NSUInteger   count;
    @property(nonatomic, copy, nullable) NSComparator comparator;
#ifdef DEBUG
    @property(nonatomic, readonly) /* */ PGRBTNode *root;
#endif

    -(instancetype)init;

    -(instancetype)initWithComparator:(nullable NSComparator)comparator;

    -(instancetype)initWithNSDictionary:(NSDictionary<K, V> *)dictionary;

    -(instancetype)initWithNSDictionary:(NSDictionary<K, V> *)dictionary comparator:(nullable NSComparator)comparator;

    -(void)addAllObjectsFromNSDictionary:(NSDictionary<K, V> *)dictionary comparator:(NSComparator)comparator;

    -(void)addAllObjectsFromNSDictionary:(NSDictionary<K, V> *)dictionary;

    -(V)valueForKey:(K)key;

    -(V)valueForKey:(K)key comparator:(nullable NSComparator)comparator;

    -(void)insertValue:(V)value forKey:(id<NSCopying>)key;

    -(void)insertValue:(V)value forKey:(id<NSCopying>)key comparator:(nullable NSComparator)comparator;

    -(void)removeValueForKey:(K)key;

    -(void)removeValueForKey:(K)key comparator:(nullable NSComparator)comparator;

    -(void)removeAllValues;

    -(V)objectForKeyedSubscript:(K)key;

    -(void)setObject:(V)object forKeyedSubscript:(id<NSCopying>)key;

    -(NSEnumerator<V> *)valueEnumerator;

    -(NSEnumerator<K> *)keyEnumerator;

    -(NSEnumerator<V> *)reverseValueEnumerator;

    -(NSEnumerator<K> *)reverseKeyEnumerator;

@end

NS_ASSUME_NONNULL_END

#endif //REDBLACKTREE_PGRBTMAP_H
