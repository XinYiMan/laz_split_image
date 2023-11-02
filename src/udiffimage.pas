unit uDiffImage;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, uTypeJpeg, Graphics;

type

  { TDiffImage }

  TDiffImage = class

  private
        function DifferenceThresholdExceeded(pixel1 : TRGBTriple; pixel2 : TRGBTriple): boolean;
  public
        constructor Create;
        destructor Free;
        function GetDifference(image_source: TJPEGImage; image_destination: TJPEGImage;
          out image_diff: TJPEGImage; var error: string): boolean;
  end;

implementation

{ TDiffImage }

function TDiffImage.DifferenceThresholdExceeded(pixel1: TRGBTriple;
  pixel2: TRGBTriple): boolean;
var
   ret : boolean;
begin
     ret := false;

     if ((pixel1.B - pixel2.B) > 5) then
     begin
          ret := true;
     end;

     if (ret = false) and ((pixel1.G - pixel2.G) > 5) then
     begin
          ret := true;
     end;

     if (ret = false) and ((pixel1.R - pixel2.R) > 5) then
     begin
          ret := true;
     end;

     result := ret;
end;

constructor TDiffImage.Create;
begin

end;

destructor TDiffImage.Free;
begin

end;

function TDiffImage.GetDifference(image_source: TJPEGImage;
  image_destination: TJPEGImage; out image_diff: TJPEGImage; var error: string
  ): boolean;
var
   ret      : boolean;
   LineS    : PRGBTripleArr;
   LineD    : PRGBTripleArr;
   Line3    : PRGBTripleArr;
   y        : Integer;
   x        : Integer;
   rowS     : integer;
   idxarr   : integer;
   rowEdit  : integer;
begin
     ret := false;
     error := '';

     if (image_source.Height <> image_destination.Height) or (image_source.Width <> image_destination.Width) then
     begin
          error := 'Dimensioni non corrispondenti';
     end else begin
       try
          try

             if (not Assigned(image_diff)) then
             begin
                  image_diff := TJPEGImage.Create;
                  image_diff.SetSize(image_source.Width, image_source.Height);
                  image_diff.PixelFormat := image_source.PixelFormat;
                  image_diff.BeginUpdate();
             end;

             for y := 0 to image_source.Height - 1 do
             begin
               LineS := image_source.ScanLine[y];
               LineD := image_destination.ScanLine[y];
               Line3 := image_diff.ScanLine[y];
               for x := 0 to image_source.Width - 1 do
               begin
                 with LineS^[x] do
                 begin


                      if DifferenceThresholdExceeded(LineS^[x], LineD^[x]) then
                      begin
                          Line3^[x].B := LineD^[x].B;
                          Line3^[x].G := LineD^[x].G;
                          Line3^[x].R := LineD^[x].R;
                          Line3^[x].A := LineD^[x].A;
                      end else begin
                        Line3^[x].B := 255;
                        Line3^[x].G := 255;
                        Line3^[x].R := 255;
                        Line3^[x].A := 255;
                      end;

                 end;
               end;
             end;

             ret := true;
          finally
             image_diff.EndUpdate();
         end;
       except
             on E: Exception do
             begin

                  error := '';

             end;
       end;
     end;


     result := ret;
end;

end.

