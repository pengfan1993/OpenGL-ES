#version 300 es 

precision mediump float;

in vec4 vPosition;
in vec2 textCoord;

out vec2 oTextCoord;

void main() {
    oTextCoord = textCoord;
    gl_Position = vPosition;
}
