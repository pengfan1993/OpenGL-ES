#version 300 es 

precision mediump float;


in vec4 vPosition;

void main() {
    gl_Position = vPosition;
}
