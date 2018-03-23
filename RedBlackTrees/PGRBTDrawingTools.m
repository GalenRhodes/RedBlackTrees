/*******************************************************************************************************************************************************************************//**
 *     PROJECT: RedBlackTree
 *    FILENAME: PGRBTDrawingTools.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 3/19/18
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

#import "PGRBTDrawingTools.h"

/*
 * Definitions for standard 32-bit ARGB color model.
 */
#define PGBitsPerField   (8)
#define PGFieldsPerPixel (4)
#define PGBitsPerPixel   (PGBitsPerField * PGFieldsPerPixel)

NS_INLINE NSRect NSMakeRectOfSize(NSSize sz) {
    NSRect r = NSZeroRect;
    r.size = sz;
    return r;
}

NS_INLINE NSRect NSMakeSquare(CGFloat sz) {
    return NSMakeRectOfSize(NSMakeSize(sz, sz));
}

NS_INLINE CGFloat findCenterBetween(CGFloat a, CGFloat b) {
    CGFloat a1 = MIN(a, b);
    CGFloat b1 = MAX(a, b);
    return (a1 + ((b1 - a1) * 0.5));
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"

@implementation PGRBTDrawData {
    }

    @synthesize data = _data;
    @synthesize nodeRect = _nodeRect;
    @synthesize fullRect = _fullRect;

    -(instancetype)initWithData:(id)data {
        self = [super init];

        if(self) {
            _data     = data;
            _nodeRect = (NSRectPointer)calloc(1, sizeof(NSRect));
            _fullRect = (NSRectPointer)calloc(1, sizeof(NSRect));
        }

        return self;
    }

    -(void)dealloc {
        if(_nodeRect) free(_nodeRect);
        if(_fullRect) free(_fullRect);
        _nodeRect = nil;
        _fullRect = nil;
        _data     = nil;
    }

    -(BOOL)isEqual:(id)other {
        return (other && ((other == self) || ([other isKindOfClass:[self class]] && [self isEqualToData:other])));
    }

    -(BOOL)isEqualToData:(PGRBTDrawData *)drawData {
        return (drawData && ((self == drawData) || ((self.data == nil) ? (drawData.data == nil) : [self.data isEqual:drawData.data])));
    }

    -(NSUInteger)hash {
        return (31u + [self.data hash]);
    }

@end

#pragma clang diagnostic pop

@interface PGRBTDrawParams()

    @property(nonatomic, readonly) CGFloat doubleMargin;
    @property(nonatomic, readonly) CGFloat halfDiameter;
    @property(nonatomic, readonly) CGFloat nodeDiameterWithMargin;

@end

@implementation PGRBTDrawParams {
        NSShadow     *_nodeShadow;
        NSDictionary *_fontAttributes;
    }

    @synthesize pageMargin = _pageMargin;
    @synthesize deltaX = _deltaX;
    @synthesize deltaY = _deltaY;
    @synthesize nodeDiameter = _nodeDiameter;
    @synthesize nodeLineWidth = _nodeLineWidth;
    @synthesize branchLineWidth = _branchLineWidth;
    @synthesize fontSize = _fontSize;
    @synthesize fontYAdjust = _fontYAdjust;
    @synthesize fontName = _fontName;
    @synthesize fontColor = _fontColor;
    @synthesize redLineColor = _redLineColor;
    @synthesize redFillColor = _redFillColor;
    @synthesize blackLineColor = _blackLineColor;
    @synthesize blackFillColor = _blackFillColor;
    @synthesize branchColor = _branchColor;
    @synthesize shadowColor = _shadowColor;
    @synthesize pageColor = _pageColor;
    @synthesize shadowBlurRadius = _shadowBlurRadius;
    @synthesize shadowOffsetX = _shadowOffsetX;
    @synthesize shadowOffsetY = _shadowOffsetY;

    -(instancetype)init {
        self = [super init];

        if(self) {
            _branchColor      = [NSColor colorWithCalibratedRed:0.32 green:0.8 blue:0.616 alpha:1];
            _redFillColor     = NSColor.redColor;
            _redLineColor     = NSColor.blackColor;
            _blackFillColor   = NSColor.blackColor;
            _blackLineColor   = NSColor.yellowColor;
            _shadowColor      = NSColor.blackColor;
            _pageColor        = NSColor.whiteColor;
            _fontColor        = NSColor.whiteColor;
            _fontName         = @"AmericanTypewriter";
            _fontSize         = 50;
            _fontYAdjust      = 9.0;
            _shadowBlurRadius = 4.0;
            _shadowOffsetX    = 2.1;
            _shadowOffsetY    = -2.1;
            _nodeDiameter     = 75.0;
            _nodeLineWidth    = 2.0;
            _deltaX           = 94.0;
            _deltaY           = 75.0;
            _branchLineWidth  = 2.0;
            _pageMargin       = 10.0;
        }

        return self;
    }

    -(CGFloat)halfDiameter {
        return (self.nodeDiameter * 0.5);
    }

    -(CGFloat)doubleMargin {
        return (self.pageMargin * 2.0);
    }

    -(CGFloat)nodeDiameterWithMargin {
        return (self.nodeDiameter + self.doubleMargin);
    }

    -(void)nodeShadow {
        if(_nodeShadow == nil) {
            @synchronized(self) {
                if(_nodeShadow == nil) {
                    _nodeShadow = [[NSShadow alloc] init];
                    [_nodeShadow setShadowColor:self.shadowColor];
                    [_nodeShadow setShadowOffset:NSMakeSize(self.shadowOffsetX, self.shadowOffsetY)];
                    [_nodeShadow setShadowBlurRadius:self.shadowBlurRadius];
                }
            }
        }
        [_nodeShadow set];
    }

    -(void)drawNodeText:(PGRBTNode<id, PGRBTDrawData *> *)node {
        if(_fontAttributes == nil) {
            @synchronized(self) {
                if(_fontAttributes == nil) {
                    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
                    style.alignment = NSTextAlignmentCenter;
                    _fontAttributes = @{
                            NSFontAttributeName           : [NSFont fontWithName:self.fontName size:self.fontSize], // Font Face
                            NSForegroundColorAttributeName: self.fontColor, //                                         Font Color
                            NSParagraphStyleAttributeName : style //                                                   Font Style
                    };
                }
            }
        }

        NSRect            rect         = *(node.value.nodeRect);
        NSString          *textContent = [(NSObject *)node.key description];
        NSAffineTransform *tx          = [NSAffineTransform transform];
        CGFloat           h            = NSHeight(rect);

        rect.size.height = NSHeight([textContent boundingRectWithSize:rect.size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:_fontAttributes]);
        rect.origin.y += ((h - NSHeight(rect)) * 0.5);

        [NSGraphicsContext saveGraphicsState];
        [tx translateXBy:NSMinX(rect) yBy:NSMinY(rect) + self.nodeDiameter - self.fontYAdjust];
        [tx rotateByDegrees:180];
        [tx scaleXBy:-1.0 yBy:1.0];
        [tx concat];
        [textContent drawInRect:NSMakeRectOfSize(rect.size) withAttributes:_fontAttributes];
        [NSGraphicsContext restoreGraphicsState];
    }

    -(void)drawNodeBody:(PGRBTNode<id, PGRBTDrawData *> *)node {
        NSRect       nodeRect    = *(node.value.nodeRect);
        NSBezierPath *circlePath = [NSBezierPath bezierPathWithOvalInRect:nodeRect];

        [NSGraphicsContext saveGraphicsState];
        [self nodeShadow];
        [(node.isRed ? self.redFillColor : self.blackFillColor) setFill];
        [(node.isRed ? self.redLineColor : self.blackLineColor) setStroke];
        [circlePath setLineWidth:self.nodeLineWidth];
        [circlePath fill];
        [circlePath stroke];
        [NSGraphicsContext restoreGraphicsState];
    }

    -(void)drawNodeParentLine:(PGRBTNode<id, PGRBTDrawData *> *)node {
        if(node.parentNode) {
            CGFloat      hd          = self.halfDiameter;
            NSRect       childRect   = *(node.value.nodeRect);
            NSRect       parentRect  = *(node.parentNode.value.nodeRect);
            NSPoint      parentPoint = NSMakePoint(NSMinX(parentRect) + hd, NSMinY(parentRect) + hd);
            NSPoint      childPoint  = NSMakePoint(NSMinX(childRect) + hd, NSMinY(childRect) + hd);
            NSPoint      ctrlPoint   = NSMakePoint(childPoint.x, findCenterBetween(childPoint.y, parentPoint.y));
            NSBezierPath *linePath   = [NSBezierPath bezierPath];

            [NSGraphicsContext saveGraphicsState];
            [self nodeShadow];
            [self.branchColor setStroke];
            [linePath moveToPoint:parentPoint];
            [linePath curveToPoint:childPoint controlPoint1:ctrlPoint controlPoint2:childPoint];
            [linePath setLineWidth:self.branchLineWidth];
            [linePath stroke];
            [NSGraphicsContext restoreGraphicsState];
        }
    }

    -(void)drawNode:(PGRBTNode<id, PGRBTDrawData *> *)node {
        if(node) {
            [self drawNodeParentLine:node];
            [self drawNode:node.leftNode];
            [self drawNode:node.rightNode];
            [self drawNodeBody:node];
            [self drawNodeText:node];
        }
    }

    -(void)fillRect:(NSRect)rect withColor:(NSColor *)color {
        [NSGraphicsContext saveGraphicsState];
        NSBezierPath *clr = [NSBezierPath bezierPathWithRect:rect];
        [color setFill];
        [clr fill];
        [NSGraphicsContext restoreGraphicsState];
    }

    -(NSRect)setNodeRectValues:(PGRBTNode<id, PGRBTDrawData *> *)node point:(NSPoint)nodePoint {
        if(node) {
            CGFloat d        = self.nodeDiameter;
            NSRect  nodeRect = NSMakeRect(nodePoint.x, nodePoint.y, d, d);
            NSRect  fullRect = nodeRect;

            nodePoint.y += self.deltaY;

            if(node.leftNode) {
                NSRect fullRectLeft = [self setNodeRectValues:node.leftNode point:nodePoint];

                nodeRect.origin.x    = MAX(NSMaxX(fullRectLeft), NSMinX(fullRectLeft) + self.deltaX);
                fullRect.size.width  = (NSMaxX(nodeRect) - NSMinX(fullRect));
                fullRect.size.height = (NSMaxY(fullRectLeft) - NSMinY(fullRect));
            }

            if(node.rightNode) {
                nodePoint.x = (NSMinX(nodeRect) + self.deltaX);

                NSRect fullRectRight = [self setNodeRectValues:node.rightNode point:nodePoint];

                fullRect.size.width = (MAX(NSMaxX(fullRect), NSMaxX(fullRectRight)) - NSMinX(fullRect));
                fullRect.size.height = (MAX(NSMaxY(fullRect), NSMaxY(fullRectRight)) - NSMinY(fullRect));
            }

            *(node.value.nodeRect) = nodeRect;
            *(node.value.fullRect) = fullRect;
            return fullRect;
        }

        return NSZeroRect;
    }

    -(NSBitmapImageRep *)createARGBImage:(NSSize)size {
        NSInteger iWidth  = (NSInteger)ceil(size.width);
        NSInteger iHeight = (NSInteger)ceil(size.height);

        NSLog(@"Creating an image: %lu x %lu", iWidth, iHeight);

        return [[NSBitmapImageRep alloc]
                                  initWithBitmapDataPlanes:NULL
                                                pixelsWide:iWidth
                                                pixelsHigh:iHeight
                                             bitsPerSample:PGBitsPerField
                                           samplesPerPixel:PGFieldsPerPixel
                                                  hasAlpha:YES
                                                  isPlanar:NO
                                            colorSpaceName:NSDeviceRGBColorSpace
                                              bitmapFormat:NSAlphaFirstBitmapFormat
                                               bytesPerRow:(iWidth * PGFieldsPerPixel)
                                              bitsPerPixel:PGBitsPerPixel];
    }

    -(BOOL)saveImage:(NSBitmapImageRep *)img filename:(NSString *const)filename error:(NSError **)error {
        NSError *err   = nil;
        BOOL    result = [[img representationUsingType:NSPNGFileType properties:@{}] writeToFile:filename options:0 error:&err];
        if(err) NSLog(@"ERROR: writing %@: %@", filename, err.description); else NSLog(@"SUCCESS: %@", filename);
        if(*error) *error = err;
        return result;
    }

    -(NSRect)imageRectForRootNode:(PGRBTNode<id, PGRBTDrawData *> *)node {
        NSRect rect = [self setNodeRectValues:node point:NSZeroPoint];
        rect.size.width += self.doubleMargin;
        rect.size.height += self.doubleMargin;
        NSLog(@"Bounds: { x = %0.3f; y = %0.3f; w = %0.3f; h = %0.3f; }", NSMinX(rect), NSMinY(rect), NSWidth(rect), NSHeight(rect));
        return rect;
    }

    -(void)setPageTransform:(NSRect)rect {
        NSAffineTransform *tx = [NSAffineTransform transform];
        [tx translateXBy:self.pageMargin yBy:(NSHeight(rect) - self.pageMargin)];
        [tx scaleXBy:1.0 yBy:-1.0];
        [tx concat];
    }

    -(void)drawNodes:(PGRBTNode<id, PGRBTDrawData *> *)rootNode filename:(NSString *const)filename error:(NSError **)error {
        NSGraphicsContext *otx        = [NSGraphicsContext currentContext];
        BOOL              doSomething = (rootNode != nil);
        NSRect            rect        = (doSomething ? [self imageRectForRootNode:rootNode] : NSMakeSquare(self.nodeDiameterWithMargin));
        NSBitmapImageRep  *img        = [self createARGBImage:rect.size];
        NSGraphicsContext *ctx        = [NSGraphicsContext graphicsContextWithBitmapImageRep:img];

        [NSGraphicsContext setCurrentContext:ctx];
        [self fillRect:rect withColor:self.pageColor];

        if(rootNode) {
            [ctx setShouldAntialias:YES];
            [self setPageTransform:rect];
            [self drawNode:rootNode];
        }

        [ctx flushGraphics];
        [self saveImage:img filename:filename error:error];
        [NSGraphicsContext setCurrentContext:otx];
    }

@end

