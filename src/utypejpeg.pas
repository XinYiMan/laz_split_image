unit uTypeJpeg;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

type
  TRGBTriple = packed record
    B, G, R, A: UInt8;
  end;

type
  PRGBTripleArr = ^TRGBTripleArr;
  TRGBTripleArr = packed array [0 .. MaxInt div SizeOf(TRGBTriple) - 1] of TRGBTriple;

type
    TJPEGImages = array of TJPEGImage;

implementation

end.

