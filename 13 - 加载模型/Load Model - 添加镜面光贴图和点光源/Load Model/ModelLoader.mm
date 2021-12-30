//
//  ModelLoader.m
//  Load Model
//
//  Created by pengfan on 2021/12/27.
//

#import "ModelLoader.h"
#import "Mesh.h"
#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>
#include <vector>
#include <string>
#include <stdlib.h>
#include <map>

using namespace::std;

@interface ModelLoader()
@property(nonatomic,strong)NSString *filePath;
@property(nonatomic,assign)const aiScene *scene;
@property(nonatomic,strong)NSMutableArray *meshes;
@property (nonatomic,assign)ESContext *eglContext;
@end

@implementation ModelLoader
- (instancetype)initWithFilePath:(NSString *)filepath andContext:(nonnull ESContext *)eglContext {
    if (self = [super init]) {
        self.filePath = filepath;
        self.meshes = [NSMutableArray new];
        self.eglContext = eglContext;
        [self setup];
    }
    return self;
}

- (void)setup {
    Assimp::Importer importer;
    const aiScene *scene = importer.ReadFile(_filePath.cString, aiProcess_FlipUVs | aiProcess_Triangulate);
    if (!scene || (scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE) || !scene->mRootNode) {
        NSLog(@"Error: Assimp failed to open obj file: %@",_filePath);
        return;
    }
    
    NSString *directory = [_filePath stringByDeletingLastPathComponent];
    self.filePath = directory;
    self.scene = scene;
    [self processNode:self.scene->mRootNode];
    
}
- (void)processNode:(aiNode *)node {
    for (unsigned int i = 0; i < node->mNumMeshes; i++) {
        aiMesh *mesh = self.scene->mMeshes[node->mMeshes[i]];
        Mesh *oneMesh = [self processMesh:mesh];
        if (oneMesh != nil) {
            [self.meshes addObject:oneMesh];
        }
    }
    
    //递归调用
    for (unsigned int i = 0; i < node->mNumChildren; i++) {
        [self processNode:node->mChildren[i]];
    }
}

- (Mesh *)processMesh:(aiMesh *)mesh {
    Mesh *one = [Mesh new];
    one.eglContext  = self.eglContext;
    one.directory = string([self.filePath cStringUsingEncoding:NSUTF8StringEncoding]);
    [one parseWithMesh:mesh andAIScnene:self.scene];
    return one;
}

- (void)draw {
    for (Mesh *one in self.meshes) {
        [one draw];
    }
}
@end
