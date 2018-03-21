/*******************************************************************************************************************************************************************************//**
 *     PROJECT: RedBlackTree
 *    FILENAME: PGRBTNode.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 3/12/18
 * * Copyright © 2018 Project Galen. All rights reserved.
 * * Permission to use, copy, modify, and distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this
 * permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
 * AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 **********************************************************************************************************************************************************************************/

#import "PGRBTNode.h"
#import "PGRBTInternal.h"
#import "PGRBTDrawingTools.h"

@implementation PGRBTNode {
    }

    @synthesize key = _key;
    @synthesize value = _value;
    @synthesize count = _count;
    @synthesize parentNode = _parentNode;
    @synthesize leftNode = _leftNode;
    @synthesize rightNode = _rightNode;
    @synthesize isRed = _isRed;
#ifdef DEBUG
    @synthesize rect = _rect;
    @synthesize frect = _frect;
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"

    -(instancetype)initWithValue:(id)value forKey:(id<NSCopying>)key {
        self = [super init];

        if(self) {
            if(key == nil) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Key is null." userInfo:nil];
            if(value == nil) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Value is null." userInfo:nil];

            _value      = value;
            _key        = [(NSObject *)key copy];
            _count      = 1;
            _parentNode = nil;
            _leftNode   = nil;
            _rightNode  = nil;
            _isRed      = YES;
#ifdef DEBUG
            _rect  = (NSRect *)calloc(1, sizeof(NSRect));
            _frect = (NSRect *)calloc(1, sizeof(NSRect));
            _rect->size.width = _rect->size.height = _frect->size.width = _frect->size.height = NODE_DIAM;
#endif
        }

        return self;
    }

#ifdef DEBUG

    -(void)dealloc {
        if(_rect) free(_rect);
        if(_frect) free(_frect);
    }

#endif

    -(PGRBTNode *)_findNodeWithKey:(id)key comparator:(NSComparator)comparator {
        switch(comparator(self.key, key)) {
            case NSOrderedAscending: return [self.rightNode _findNodeWithKey:key comparator:comparator];
            case NSOrderedDescending: return [self.leftNode _findNodeWithKey:key comparator:comparator];
            default: return self;
        }
    }

    -(PGRBTNode *)_insertValue:(id)value forKey:(id<NSCopying>)key comparator:(NSComparator)comparator {
        if((self.key == nil) ? (key == nil) : [(NSObject *)self.key isEqual:key]) {
            self.value = value;
            return self;
        }
        switch(comparator(self.key, key)) {
            case NSOrderedAscending: {
                if(self.rightNode) return [self.rightNode _insertValue:value forKey:key comparator:comparator];
                PGRBTNode *node = self.rightNode = [(PGRBTNode *)[[self class] alloc] initWithValue:value forKey:key];
                [node insertRebalance];
                return node;
            }
            case NSOrderedDescending: {
                if(self.leftNode) return [self.leftNode _insertValue:value forKey:key comparator:comparator];
                PGRBTNode *node = self.leftNode = [(PGRBTNode *)[[self class] alloc] initWithValue:value forKey:key];
                [node insertRebalance];
                return node;
            }
            default: {
                /*
                 * I don't know how two objects can be the same but not be equal
                 * but we'll play the game and assume the implementor knows what
                 * they're doing.
                 */
                self.value = value;
                return self;
            }
        }
    }

    -(PGRBTNode *)findNodeWithKey:(id)key comparator:(NSComparator)comparator {
        if(comparator == nil) {
            comparator = ^NSComparisonResult(id obj1, id obj2) {
                return PGCompareObjects(obj1, obj2);
            };
        }
        return (key ? [self _findNodeWithKey:key comparator:comparator] : nil);
    }

    -(PGRBTNode *)findNodeWithKey:(id)key {
        return [self findNodeWithKey:key comparator:nil];
    }

    -(PGRBTNode *)insertValue:(id)value forKey:(id<NSCopying>)key comparator:(NSComparator)comparator {
        if(key == nil) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Key is null." userInfo:nil];
        if(value == nil) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Value is null." userInfo:nil];
        if(comparator == nil) {
            comparator = ^NSComparisonResult(id obj1, id obj2) {
                return PGCompareObjects(obj1, obj2);
            };
        }
        return [self _insertValue:value forKey:key comparator:comparator];
    }

    -(PGRBTNode *)insertValue:(id)value forKey:(id<NSCopying>)key {
        return [self insertValue:value forKey:key comparator:nil];
    }

#pragma clang diagnostic pop

    -(void)updateCount {
        _count = (1 + self.leftNode.count + self.rightNode.count);
        [self.parentNode updateCount];
    }

    -(PGRBTNode *)rootNode {
        return (self.parentNode ? self.parentNode.rootNode : self);
    }

    -(void)setLeftNode:(PGRBTNode *)leftNode {
        if(_leftNode != leftNode) {
            [leftNode makeOrphan];
            _leftNode.parentNode = nil;
            _leftNode = leftNode;
            _leftNode.parentNode = self;
            [self updateCount];
        }
    }

    -(void)setRightNode:(PGRBTNode *)rightNode {
        if(_rightNode != rightNode) {
            [rightNode makeOrphan];
            _rightNode.parentNode = nil;
            _rightNode = rightNode;
            _rightNode.parentNode = self;
            [self updateCount];
        }
    }

    -(void)makeOrphan {
        PGRBTNode *pnode = self.parentNode;
        if(pnode) { if(self == pnode.leftNode) pnode.leftNode = nil; else pnode.rightNode = nil; }
    }

    -(void)swapParentWith:(PGRBTNode *)node {
        PGRBTNode *pnode = self.parentNode;
        if(pnode && (node != pnode) && (self != node)) { if(self == pnode.leftNode) pnode.leftNode = node; else pnode.rightNode = node; }
    }

    -(void)rotateLeft {
        PGRBTNode *rnode = self.rightNode;
        [self rotateLeft:rnode];
        BOOL r = self.isRed;
        self.isRed  = rnode.isRed;
        rnode.isRed = r;
    }

    -(void)rotateLeftNoColorSwap {
        [self rotateLeft:self.rightNode];
    }

    -(NSException *)rotateException:(NSString *)keyA keyB:(NSString *)keyB {
        return [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Cannot rotate %1$@ - no %2$@ child node.", keyA, keyB] userInfo:nil];
    }

    -(void)rotateLeft:(PGRBTNode *)rnode {
        if(rnode) {
            PGRBTNode *pnode = self.parentNode;
            if(self == pnode.leftNode) pnode.leftNode = rnode; else pnode.rightNode = rnode;
            self.rightNode = rnode.leftNode;
            rnode.leftNode = self;
        }
        else {
            @throw [self rotateException:@"left" keyB:@"right"];
        }
    }

    -(void)rotateRight {
        PGRBTNode *lnode = self.leftNode;
        [self rotateRight:lnode];
        BOOL r = self.isRed;
        self.isRed  = lnode.isRed;
        lnode.isRed = r;
    }

    -(void)rotateRightNoColorSwap {
        [self rotateRight:self.leftNode];
    }

    -(void)rotateRight:(PGRBTNode *)lnode {
        if(lnode) {
            PGRBTNode *pnode = self.parentNode;
            if(self == pnode.leftNode) pnode.leftNode = lnode; else pnode.rightNode = lnode;
            self.leftNode   = lnode.rightNode;
            lnode.rightNode = self;
        }
        else {
            @throw [self rotateException:@"right" keyB:@"left"];
        }
    }

    -(void)insertRebalance {
        PGRBTNode *pnode = self.parentNode;

        if(pnode) {
            if(pnode.isRed) {
                PGRBTNode *gnode = pnode.parentNode;
                PGRBTNode *unode = ((pnode == gnode.leftNode) ? gnode.rightNode : gnode.leftNode);

                if(unode.isRed) {
                    pnode.isRed = NO;
                    unode.isRed = NO;
                    gnode.isRed = YES;
                    [gnode insertRebalance];
                }
                else if(self == gnode.leftNode.rightNode) {
                    [pnode rotateLeft];
                    [gnode rotateRight];
                }
                else if(self == gnode.rightNode.leftNode) {
                    [pnode rotateRight];
                    [gnode rotateLeft];
                }
                else if(self == pnode.leftNode) {
                    [gnode rotateRight];
                }
                else {
                    [gnode rotateLeft];
                }
            }
        }
        else {
            self.isRed = NO;
        }
    }

    -(void)deleteRebalance {
        PGRBTNode *pnode = self.parentNode;

        if(pnode) {
            BOOL      slfLeft = (self == pnode.leftNode);
            PGRBTNode *snode  = (slfLeft ? pnode.rightNode : pnode.leftNode);

            if(snode.isRed) {
                if(slfLeft) {
                    [pnode rotateLeft];
                    snode = pnode.rightNode;
                }
                else {
                    [pnode rotateRight];
                    snode = pnode.leftNode;
                }
            }

            PGRBTNode *slnode = snode.leftNode;
            PGRBTNode *srnode = snode.rightNode;

            if(snode.isRed || slnode.isRed || srnode.isRed) {
                if(!snode.isRed) {
                    if(slfLeft && slnode.isRed && !srnode.isRed) {
                        [snode rotateRight];
                        snode  = snode.parentNode;
                        srnode = snode.rightNode;
                    }
                    else if(!slfLeft && srnode.isRed && !slnode.isRed) {
                        [snode rotateLeft];
                        snode  = snode.parentNode;
                        slnode = snode.leftNode;
                    }
                }

                snode.isRed = pnode.isRed;
                pnode.isRed = NO;

                if(slfLeft) {
                    srnode.isRed = NO;
                    [pnode rotateLeftNoColorSwap];
                }
                else {
                    slnode.isRed = NO;
                    [pnode rotateRightNoColorSwap];
                }
            }
            else {
                snode.isRed = YES;
                if(pnode.isRed) pnode.isRed = NO; else [pnode deleteRebalance];
            }
        }
    }

    -(PGRBTNode *)delete:(PGRBTNode *)cnode {
        PGRBTNode *pnode = self.parentNode;

        if(pnode || cnode) {
            if(self.isRed) {
                [self makeOrphan];
                [self clear];
                return pnode.rootNode;
            }
            else {
                if(cnode.isRed) {
                    cnode.isRed = NO;
                    [self swapParentWith:cnode];
                    [self clear];
                    return cnode.rootNode;
                }

                [self deleteRebalance];
                [self makeOrphan];
                [self clear];
                return pnode.rootNode;
            }
        }

        /*
         * We don't have a parent or any children so we're the only
         * node left. We can just go away.
         */
        [self clearFields];
        return nil;
    }

    -(PGRBTNode *)delete:(PGRBTNode *)leftChild rightChild:(PGRBTNode *)rightChild {
        if(leftChild && rightChild) {
            while(rightChild.leftNode) rightChild = rightChild.leftNode;
            _key   = rightChild.key;
            _value = rightChild.value;
            return [rightChild delete:rightChild.rightNode];
        }
        else {
            return [self delete:(leftChild ?: rightChild)];
        }
    }

    -(PGRBTNode *)delete {
        return [self delete:self.leftNode rightChild:self.rightNode];
    }

    /**
     * CAUTION: This will wipe out the entire node tree quickly!!!!!!
     */
    -(void)clear {
        [self.leftNode clear];
        [self.rightNode clear];
        [self clearFields];
    }

    -(void)clearFields {
        _parentNode = nil;
        _leftNode   = nil;
        _rightNode  = nil;
        _value      = nil;
        _key        = nil;
        _isRed      = NO;
    }

@end

