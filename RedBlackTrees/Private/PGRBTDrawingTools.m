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
#import "PGRBTNode.h"

#ifdef DEBUG

/*
 * Definitions for standard 32-bit RGBA color model.
 */
#define PGBitsPerField   (8)
#define PGFieldsPerPixel (4)

static NSUInteger zzz = 0;

NS_INLINE NSSize getRootNodeSize(PGRBTNode *rootNode) {
    double  mrgn = (MARGIN * 2.0);
    NSRect  bnds = *(rootNode.frect);
    CGFloat x    = NSMinX(bnds);
    CGFloat y    = NSMinY(bnds);
    CGFloat w    = (NSWidth(bnds) + mrgn);
    CGFloat h    = (NSHeight(bnds) + mrgn);

    NSLog(@"Bounds: { x = %f; y = %f; w = %f; h = %f; }", x, y, w, h);
    return NSMakeSize(w, h);
}

NS_INLINE NSRect centerInside(NSRect r, NSSize s) {
    return NSMakeRect(NSMinX(r) + ((NSWidth(r) - s.width) * 0.5), NSMinY(r) + ((NSHeight(r) - s.height) * 0.5), s.width, s.height);
    // return NSMakeRect(NSMinX(r) + ((NSWidth(r) - s.width) * 0.5), NSMinY(r) - ((NSHeight(r) - s.height) * 0.5), s.width, s.height);
}

NS_INLINE BOOL saveImage(NSBitmapImageRep *img, NSString *const filename) {
    NSError  *error     = nil;
    NSString *sFilename = [NSString stringWithFormat:filename, ++zzz];
    BOOL     result     = [[img representationUsingType:NSPNGFileType properties:@{}] writeToFile:sFilename options:0 error:&error];
    if(error) NSLog(@"ERROR: writing %@: %@", sFilename, error.description); else NSLog(@"SUCCESS: %@", sFilename);
    return result;
}

NSShadow *nodeShadow() {
    static NSShadow *shadow = nil;

    if(shadow == nil) {
        shadow = [[NSShadow alloc] init];
        [shadow setShadowColor:NSColor.blackColor];
        [shadow setShadowOffset:NSMakeSize(2.1, -2.1)];
        [shadow setShadowBlurRadius:4];
    }

    return shadow;
}

void drawNodeText(NSString *const textContent, NSRect rect) {
    static NSDictionary *attrs = nil;

    if(attrs == nil) {
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        // style.alignment = NSCenterTextAlignment;
        style.alignment = NSTextAlignmentCenter;
        attrs = @{
                NSFontAttributeName           : [NSFont fontWithName:@"AmericanTypewriter" size:50], // Font Face
                NSForegroundColorAttributeName: NSColor.whiteColor, //                                  Font Color
                NSParagraphStyleAttributeName : style //                                                Font Style
        };
    }

    CGFloat height  = NSHeight([textContent boundingRectWithSize:rect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs]);
    NSRect  keyRect = NSMakeRect(NSMinX(rect), NSMinY(rect) + (NSHeight(rect) - height) / 2, NSWidth(rect), height);

    [NSGraphicsContext saveGraphicsState];
    NSAffineTransform *tx = [NSAffineTransform transform];
    [tx translateXBy:NSMinX(keyRect) yBy:NSMinY(keyRect) + NODE_DIAM - 9];
    [tx rotateByDegrees:180];
    [tx scaleXBy:-1.0 yBy:1.0];
    [tx concat];
    [textContent drawInRect:NSMakeRect(0, 0, NSWidth(keyRect), NSHeight(keyRect)) withAttributes:attrs];
    [NSGraphicsContext restoreGraphicsState];
}

void drawNodeBody(BOOL isRed, NSString *const textContent, NSRect nodeRect) {
    NSBezierPath *circlePath = [NSBezierPath bezierPathWithOvalInRect:nodeRect];

    [NSGraphicsContext saveGraphicsState];
    [nodeShadow() set];
    [(isRed ? NSColor.redColor : NSColor.blackColor) setFill];
    [circlePath fill];
    [NSGraphicsContext restoreGraphicsState];

    [NSGraphicsContext saveGraphicsState];
    [(isRed ? NSColor.blackColor : NSColor.yellowColor) setStroke];
    [circlePath setLineWidth:2];
    [circlePath stroke];
    [NSGraphicsContext restoreGraphicsState];

    drawNodeText(textContent, nodeRect);
}

void drawNodeParentLine(NSRect parentRect, NSRect childRect) {
    static NSColor *lineColor = nil;

    if(lineColor == nil) {
        lineColor = [NSColor colorWithCalibratedRed:0.32 green:0.8 blue:0.616 alpha:1];
    }

    NSBezierPath *linePath = [NSBezierPath bezierPath];

    NSPoint parentPoint = NSMakePoint(parentRect.origin.x + NODE_HALFDIAM, parentRect.origin.y + NODE_HALFDIAM);
    NSPoint childPoint  = NSMakePoint(childRect.origin.x + NODE_HALFDIAM, childRect.origin.y + NODE_HALFDIAM);
    NSPoint ctrlPoint   = NSMakePoint(childPoint.x, childPoint.y + (((parentPoint.y - childPoint.y) + 1) / 2));

    [linePath moveToPoint:parentPoint];
    [linePath curveToPoint:childPoint controlPoint1:ctrlPoint controlPoint2:childPoint];

    [NSGraphicsContext saveGraphicsState];
    [nodeShadow() set];
    [lineColor setStroke];
    [linePath setLineWidth:2];
    [linePath stroke];
    [NSGraphicsContext restoreGraphicsState];
}

NSRect setNodeRect(PGRBTNode *node, CGFloat x, CGFloat y) {
    if(node) {
        double  z     = (NODE_DIAM + (MARGIN * 2.0));
        NSRect  frect = NSMakeRect(x, y, z, z);
        NSRect  rect  = centerInside(frect, NSMakeSize(NODE_DIAM, NODE_DIAM));
        CGFloat cy1   = (NSMinY(rect) + DELTA_Y);

        if(node.leftNode) {
            NSRect rectLeft = setNodeRect(node.leftNode, x, cy1);

            rect.origin.x     = NSMaxX(rectLeft);
            frect.size.width  = (NSMaxX(rect) - NSMinX(frect) + MARGIN);
            frect.size.height = (NSMaxY(rectLeft) - NSMinY(frect));
        }

        if(node.rightNode) {
            NSRect rectRight = setNodeRect(node.rightNode, (NSMinX(rect) + DELTA_X), cy1);

            frect.size.width = (MAX(NSMaxX(frect), NSMaxX(rectRight)) - NSMinX(frect));
            frect.size.height = (MAX(NSMaxY(frect), NSMaxY(rectRight)) - NSMinY(frect));
        }

        *(node.rect)  = rect;
        *(node.frect) = frect;
        return frect;
    }

    return NSMakeRect(0, 0, 0, 0);
}

NSBitmapImageRep *createARGBImage(CGFloat width, CGFloat height) {
    NSInteger iWidth  = (NSInteger)ceil(width);
    NSInteger iHeight = (NSInteger)ceil(height);

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
                                          bitsPerPixel:(PGBitsPerField * PGFieldsPerPixel)];
}

void drawNodes(PGRBTNode *node) {
    if(node) {
        if(node.parentNode) drawNodeParentLine(*(node.parentNode.rect), *(node.rect));
        drawNodes(node.leftNode);
        drawNodes(node.rightNode);
        drawNodeBody(node.isRed, (NSString *)node.key, *(node.rect));
    }
}

void drawMyNodes(PGRBTNode *rootNode, NSString *const filename) {
    setNodeRect(rootNode, 0, 0);

    NSSize            imgSize = getRootNodeSize(rootNode);
    NSBitmapImageRep  *img    = createARGBImage(imgSize.width, imgSize.height);
    NSGraphicsContext *ctx    = [NSGraphicsContext graphicsContextWithBitmapImageRep:img];
    NSGraphicsContext *dctx   = [NSGraphicsContext currentContext];

    [NSGraphicsContext setCurrentContext:ctx];
    [ctx saveGraphicsState];
    [ctx setShouldAntialias:YES];

    NSBezierPath *clr = [NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, imgSize.width, imgSize.height)];
    [NSColor.whiteColor setFill];
    [clr fill];

    NSAffineTransform *tx = [NSAffineTransform transform];
    [tx translateXBy:MARGIN yBy:imgSize.height - MARGIN];
    [tx scaleXBy:1.0 yBy:-1.0];
    [tx concat];

    drawNodes(rootNode);

    [ctx flushGraphics];
    [ctx restoreGraphicsState];
    [NSGraphicsContext setCurrentContext:dctx];

    saveImage(img, filename);
}

#endif
