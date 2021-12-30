//
//  Mesh.m
//  Load Model
//
//  Created by pengfan on 2021/12/27.
//

#import "Mesh.h"
#import <UIKit/UIKit.h>
#import "ModelLoader.h"
#include <vector>
#include <OpenGLES/ES3/gl.h>
using namespace::std;
unsigned int TextureFromFile(const char *path, const string &directory);
@interface Mesh() {
    vector<Vertex> vertices;
    vector<GLuint> indices;
    vector<Texture> textures;
    vector<Texture> textures_loaded;
    unsigned int VAO, VBO, EBO;
}

@end

@implementation Mesh

- (void)parseWithMesh:(aiMesh *)mesh andAIScnene:(const aiScene *)scene {
    for (unsigned int i = 0; i < mesh->mNumVertices; i++) {
        Vertex vertex;
        Vector3 vector;
        
        //position
        vector.x = mesh->mVertices[i].x;
        vector.y = mesh->mVertices[i].y;
        vector.z = mesh->mVertices[i].z;
        vertex.position = vector;
        
        //normals
        if (mesh->HasNormals()) {
            vector.x = mesh->mNormals[i].x;
            vector.y = mesh->mNormals[i].y;
            vector.z = mesh->mNormals[i].z;
            vertex.normal = vector;
        }
        
        //texture coordinates
        if (mesh->mTextureCoords[0]) {
            Vector2 vec;
            vec.x = mesh->mTextureCoords[0][i].x;
            vec.y = mesh->mTextureCoords[0][i].y;
            vertex.textCoord = vec;
            
        }
        else {
            vertex.textCoord = {{0.0f,0.0f}};
        }
        vertices.push_back(vertex);
    }
    
    // now wak through each of the mesh's faces (a face is a mesh its triangle) and retrieve the corresponding vertex indices.
    for(unsigned int i = 0; i < mesh->mNumFaces; i++)
    {
        aiFace face = mesh->mFaces[i];
        // retrieve all indices of the face and store them in the indices vector
        for(unsigned int j = 0; j < face.mNumIndices; j++)
            indices.push_back(face.mIndices[j]);
    }
    // process materials
    aiMaterial* material = scene->mMaterials[mesh->mMaterialIndex];
    // we assume a convention for sampler names in the shaders. Each diffuse texture should be named
    // as 'texture_diffuseN' where N is a sequential number ranging from 1 to MAX_SAMPLER_NUMBER.
    // Same applies to other texture as the following list summarizes:
    // diffuse: texture_diffuseN
    // specular: texture_specularN
    // normal: texture_normalN

    // 1. diffuse maps
    vector<Texture> diffuseMaps = [self loadMaterialTexturesWithMaterial:material andTextureType:aiTextureType_DIFFUSE andTypeName:"texture_diffuse"];
    
    textures.insert(textures.end(), diffuseMaps.begin(), diffuseMaps.end());
    
    
    // 2. specular maps
    vector<Texture> specularMaps = [self loadMaterialTexturesWithMaterial:material andTextureType:aiTextureType_SPECULAR andTypeName:"texture_specular"];
    textures.insert(textures.end(), specularMaps.begin(), specularMaps.end());
    
    // 3. normal maps
    vector<Texture> normalMaps = [self loadMaterialTexturesWithMaterial:material andTextureType:aiTextureType_NORMALS andTypeName:"texture_normal"];
    
    textures.insert(textures.end(), normalMaps.begin(), normalMaps.end());
    
    // 4. height maps
    std::vector<Texture> heightMaps = [self loadMaterialTexturesWithMaterial:material andTextureType:aiTextureType_HEIGHT andTypeName:"texture_height"];
    textures.insert(textures.end(), heightMaps.begin(), heightMaps.end());
    [self setupMesh];
}

- (vector<Texture>)loadMaterialTexturesWithMaterial:(aiMaterial *)mat andTextureType:(aiTextureType)type andTypeName:(string)typeName {
    {
        vector<Texture> textures;
        for(unsigned int i = 0; i < mat->GetTextureCount(type); i++)
        {
            aiString str;
            mat->GetTexture(type, i, &str);
            // check if texture was loaded before and if so, continue to next iteration: skip loading a new texture
            bool skip = false;
            for(unsigned int j = 0; j < textures_loaded.size(); j++)
            {
                char *texturePath = textures_loaded[j].path.data();
                if(std::strcmp(texturePath, str.C_Str()) == 0)
                {
                    textures.push_back(textures_loaded[j]);
                    skip = true; // a texture with the same filepath has already been loaded, continue to next one. (optimization)
                    break;
                }
            }
            if(!skip)
            {   // if texture hasn't been loaded already, load it
                Texture texture;
                texture.id = TextureFromFile(str.C_Str(), self.directory);
                texture.type = typeName;
                texture.path = str.C_Str();
                textures.push_back(texture);
                textures_loaded.push_back(texture);  // store it as texture loaded for entire model, to ensure we won't unnecesery load duplicate textures.
            }
        }
        return textures;
    }
}

unsigned int TextureFromFile(const char *path, const string &directory)
{
    string filename = string(path);
    filename = directory + '/' + filename;
    
    unsigned int textureID;
    glGenTextures(1, &textureID);

    int width, height, nrComponents;

    UIImage *img = [UIImage imageWithContentsOfFile:[[NSString alloc] initWithCString:filename.data() encoding:NSUTF8StringEncoding]];
    CGImageRef imageref = [img CGImage];

     width = CGImageGetWidth(imageref);
     height = CGImageGetHeight(imageref);

    GLubyte *textureData = (GLubyte *)malloc(width * height * 4);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    //每个像素点四个字节RGBA
    NSUInteger bytesperPixel = 4;
    NSUInteger bytesperRow = bytesperPixel * width;
    NSUInteger bitsperComponent = 8;

    CGContextRef context = CGBitmapContextCreate(textureData, width, height, bitsperComponent, bytesperRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);



    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageref);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    NSData  *_imageData = [NSData dataWithBytes:textureData length:(width * height * 4)];
    
    if (_imageData)
    {

        glBindTexture(GL_TEXTURE_2D, textureID);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, (unsigned char *)_imageData.bytes);
        glGenerateMipmap(GL_TEXTURE_2D);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    }
    else
    {
        printf("Texture failed to load at path: %s",path);
    }

    return textureID;
}

- (void)setupMesh {
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    glGenBuffers(1, &EBO);

    glBindVertexArray(VAO);

    glBindBuffer(GL_ARRAY_BUFFER, VBO);

    glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(Vertex), &vertices[0], GL_STATIC_DRAW);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.size() * sizeof(unsigned int), &indices[0], GL_STATIC_DRAW);
    /**
     layout (location = 0) in vec3 aPos;
     layout (location = 1) in vec3 aNormal;
     layout (location = 2) in vec2 aTexCoords;
     */
    
    GLuint positionIndex = glGetAttribLocation(_eglContext->program, "aPos");
    GLuint texCoordIndex = glGetAttribLocation(_eglContext->program, "aTexCoords");
    GLuint normalIndex = glGetAttribLocation(_eglContext->program, "aNormal");
   
    
    // vertex Positions
    glEnableVertexAttribArray(positionIndex);
    glVertexAttribPointer(positionIndex, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)0);
    // vertex normals
    glEnableVertexAttribArray(normalIndex);
    glVertexAttribPointer(normalIndex, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, normal));
    // vertex texture coords
    glEnableVertexAttribArray(texCoordIndex);
    glVertexAttribPointer(texCoordIndex, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, textCoord));

    glBindVertexArray(0);

}

-(void)draw {
    unsigned int diffuseNr = 1;
    unsigned int specularNr = 1;
    unsigned int normalNr = 1;
    unsigned int heightNr = 1;
    for (unsigned int i = 0; i < textures.size(); i++)
    {
        glActiveTexture(GL_TEXTURE0 + i); // active proper texture unit before binding
        // retrieve texture number (the N in diffuse_textureN)
        string number;
        string name = textures[i].type;
        if (name == "texture_diffuse")
            number = std::to_string(diffuseNr++);
        else if (name == "texture_specular")
            number = std::to_string(specularNr++); // transfer unsigned int to stream
        else if (name == "texture_normal")
            number = std::to_string(normalNr++); // transfer unsigned int to stream
        else if (name == "texture_height")
            number = std::to_string(heightNr++); // transfer unsigned int to stream

        const char * one = (name + number).c_str();
        GLuint index = glGetUniformLocation(_eglContext->program, one);
        glUniform1i(index, i);
        glBindTexture(GL_TEXTURE_2D, textures[i].id);
    }
    glActiveTexture(GL_TEXTURE0);

    glBindVertexArray(VAO);
    glDrawElements(GL_TRIANGLES, indices.size(), GL_UNSIGNED_INT, 0);
    glBindVertexArray(0);
}
@end
