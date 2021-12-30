//
//  Mesh.h
//  Load Model
//
//  Created by pengfan on 2021/12/27.
//

#import <Foundation/Foundation.h>
#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>
#include <string>
#import "MatrixTransform.h"
NS_ASSUME_NONNULL_BEGIN
union Vector3
{
    struct { float x, y, z; };
    struct { float r, g, b; };
    struct { float s, t, p; };
    float v[3];
};
typedef union Vector3 Vector3;

union Vector2
{
    struct { float x, y; };
    float v[2];
};
typedef union Vector2 Vector2;

struct Vertex {
    Vector3 position;
    Vector2 textCoord;
    Vector3 normal;
};

struct Texture {
    std::string type;
    std::string path;
    unsigned int id;
};

typedef struct  Vertex  Vertex;
typedef struct Texture Texture;
@interface Mesh : NSObject
- (void)parseWithMesh:(aiMesh *)mesh andAIScnene:(const aiScene *)scene;
- (void)draw;
- (void)setupMesh;
@property(nonatomic,assign)std::string directory;
@property(nonatomic,assign)ESContext *eglContext;

@end

NS_ASSUME_NONNULL_END
