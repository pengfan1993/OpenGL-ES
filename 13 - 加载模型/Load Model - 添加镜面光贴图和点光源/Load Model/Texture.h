//
//  Texture.h
//  Load Model
//
//  Created by pengfan on 2021/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Texture : NSObject
@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,copy)NSString *path;
@property(nonatomic,assign)unsigned int textureId;

@end

NS_ASSUME_NONNULL_END
