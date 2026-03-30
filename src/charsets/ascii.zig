pub const ascii = @import("CharacterSet.zig").fromRanges("ASCII", &.{
    .{ 0x0020, 0x0020 }, // Space
    .{ 0x0021, 0x002F }, // ! " # $ % & ' ( ) * + , - . /
    .{ 0x0030, 0x0039 }, // 0–9
    .{ 0x003A, 0x0040 }, // : ; < = > ? @
    .{ 0x0041, 0x005A }, // A–Z
    .{ 0x005B, 0x0060 }, // [ \ ] ^ _ `
    .{ 0x0061, 0x007A }, // a–z
    .{ 0x007B, 0x007E }, // { | } ~
});
