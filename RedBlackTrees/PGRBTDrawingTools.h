/*******************************************************************************************************************************************************************************//**
 *     PROJECT: RedBlackTree
 *    FILENAME: PGRBTDrawingTools.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 3/19/18
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

#ifndef REDBLACKTREE_PGRBTDRAWINGTOOLS_H
#define REDBLACKTREE_PGRBTDRAWINGTOOLS_H

#import "PGRBTNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGRBTDrawData<__covariant T> : NSObject

    @property(nonatomic, retain, readonly) T             data;
    @property(nonatomic, readonly) /*   */ NSRectPointer nodeRect;
    @property(nonatomic, readonly) /*   */ NSRectPointer fullRect;

    -(instancetype)initWithData:(T)data;

@end

@interface PGRBTDrawParams : NSObject

    @property(nonatomic) /*        */ CGFloat   pageMargin;
    @property(nonatomic) /*        */ CGFloat   deltaX;
    @property(nonatomic) /*        */ CGFloat   deltaY;
    @property(nonatomic) /*        */ CGFloat   nodeDiameter;
    @property(nonatomic) /*        */ CGFloat   nodeLineWidth;
    @property(nonatomic) /*        */ CGFloat   branchLineWidth;
    @property(nonatomic) /*        */ CGFloat   shadowBlurRadius;
    @property(nonatomic) /*        */ CGFloat   shadowOffsetX;
    @property(nonatomic) /*        */ CGFloat   shadowOffsetY;
    @property(nonatomic) /*        */ NSInteger fontSize;
    @property(nonatomic) /*        */ CGFloat   fontYAdjust;
    @property(nonatomic, copy) /*  */ NSString  *fontName;
    @property(nonatomic, retain) /**/ NSColor   *fontColor;
    @property(nonatomic, retain) /**/ NSColor   *redLineColor;
    @property(nonatomic, retain) /**/ NSColor   *redFillColor;
    @property(nonatomic, retain) /**/ NSColor   *blackLineColor;
    @property(nonatomic, retain) /**/ NSColor   *blackFillColor;
    @property(nonatomic, retain) /**/ NSColor   *branchColor;
    @property(nonatomic, retain) /**/ NSColor   *shadowColor;
    @property(nonatomic, retain) /**/ NSColor   *pageColor;

    -(instancetype)init;

    -(void)drawNodes:(PGRBTNode<id, PGRBTDrawData *> *)rootNode filename:(NSString *const)filename error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END

#endif // REDBLACKTREE_PGRBTDRAWINGTOOLS_H
