//
//  BXImageProgress.m
//  BXiOSExtensionDemo
//
//  Created by 彬潇 on 15/4/3.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import "BXImageProgress.h"
@implementation BXImageProgress

- (UIImage *)processImage:(UIImage *)image
{
    CIImage *inputImage = image.CIImage;//CIDetectorTypeFace
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorSmile  context:nil options:nil];
    NSArray *faces = [detector featuresInImage:inputImage];
    CIImage *mask;
    if (faces.count > 0) {
        UIImage *filteredImage;
        for ( CIFeature *face in faces) {
            CGFloat centerX = face.bounds.origin.x + face.bounds.size.width / 2.0;
            CGFloat centerY = face.bounds.origin.y + face.bounds.size.height / 2.0;
            CGFloat radius = (face.bounds.size.width < face.bounds.size.height ? face.bounds.size.width : face.bounds.size.height) / 1.5;
            CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient"];
            [radialGradient setValuesForKeysWithDictionary:@{@"inputRadius0":@(radius),@"inputRadius1":@(radius + 1.0),@"inputColor0":[UIColor colorWithRed:0 green:1 blue:0 alpha:1],@"inputColor1":[UIColor colorWithRed:0 green:0 blue:0 alpha:1],kCIInputCenterKey:[CIVector vectorWithCGPoint:CGPointMake(centerX, centerY)]}];
            CIImage *circle = radialGradient.outputImage;
            if (mask != nil) {
                CIFilter *imageFilter = [CIFilter filterWithName:@"CIAdditionCompositing"];
                [imageFilter setValuesForKeysWithDictionary:@{kCIInputImageKey : circle,kCIInputBackgroundImageKey :mask}];
                mask = imageFilter.outputImage;
                
            } else {
                mask = circle;
            }
            
            CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
            [filter setValuesForKeysWithDictionary:@{kCIInputImageKey:inputImage,@"inputScale":@(10.0)}];
            CIImage *pixelImage = filter.outputImage;
            CIFilter *outputFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
            [outputFilter setValuesForKeysWithDictionary:@{kCIInputImageKey:pixelImage,kCIInputBackgroundImageKey : inputImage,kCIInputMaskImageKey: mask}];
            CIImage *outputImage = outputFilter.outputImage;
            CIContext *context = [CIContext contextWithOptions:nil];
            CGImageRef imageRef = [context createCGImage:outputImage fromRect:[outputImage extent]];

            filteredImage = [UIImage imageWithCGImage:imageRef];
        }
        return filteredImage;
    } else {
        return image;
    }
}

@end
/*
 public func processImage(image: UIImage) -> UIImage {
 var inputImage: CIImage = CIImage(image: image)
 
 var detector: CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: nil)
 
 var faces = detector.featuresInImage(inputImage)
 
 var mask: CIImage!
 
 if faces.count > 0 {
 var filteredImage: UIImage!
 
 for face in faces {
 let centerX = face.bounds.origin.x + face.bounds.size.width / 2.0
 let centerY = face.bounds.origin.y + face.bounds.size.height / 2.0
 let radius = min(face.bounds.size.width, face.bounds.size.height) / 1.5
 
 var radialGradient = CIFilter(name: "CIRadialGradient")
 radialGradient.setValuesForKeysWithDictionary(["inputRadius0": radius,
 "inputRadius1": radius + 1.0,
 "inputColor0": CIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0),
 "inputColor1": CIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
 kCIInputCenterKey: CIVector(x: centerX, y: centerY)])
 
 var circle = radialGradient.outputImage
 
 if mask != nil {
 var imageFilter = CIFilter(name: "CIAdditionCompositing")
 imageFilter.setValuesForKeysWithDictionary([kCIInputImageKey: circle, kCIInputBackgroundImageKey:mask])
 mask = imageFilter.outputImage
 
 } else {
 mask = circle
 }
 
 var filter = CIFilter(name: "CIPixellate")
 filter.setValuesForKeysWithDictionary([kCIInputImageKey: inputImage, "inputScale":10.0])
 var pixelImage = filter.outputImage
 var outputFilter = CIFilter(name: "CIBlendWithMask")
 outputFilter.setValuesForKeysWithDictionary([kCIInputImageKey: pixelImage, kCIInputBackgroundImageKey: inputImage, kCIInputMaskImageKey: mask])
 
 let outputImage = outputFilter.outputImage
 let context = CIContext(options: nil)
 let imageRef = context.createCGImage(outputImage, fromRect: outputImage.extent())
 filteredImage = UIImage(CGImage: imageRef)
 }
 return filteredImage
 } else {
 return image
 }
 }

 */