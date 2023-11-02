unit uSplitImage;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, uTypeJpeg;

  type

      { TSplitImage }

      TSplitImage = class

         private
                MyImg            : TJPEGImage;
                ListOfSplitImage : TJPEGImages;
         public
               constructor Create(pMyImg : TJPEGImage);
               destructor Free;
               function Split(qty : integer; var error : string) : boolean;
               function GetSplittedImage(idx : integer) : TMemoryStream;
               procedure Merge(images : TJPEGImages);
               function GetImageMerged : TJPEGImage;
      end;

implementation

{ TSplitImage }

constructor TSplitImage.Create(pMyImg: TJPEGImage);
begin
     SetLength(ListOfSplitImage, 0);
     MyImg := pMyImg;
end;

destructor TSplitImage.Free;
begin
     if Assigned(MyImg) then
     begin
          MyImg.Free;
          MyImg:=nil;
     end;
     SetLength(ListOfSplitImage, 0);
end;

function TSplitImage.Split(qty: integer; var error: string): boolean;
var
   ret      : boolean;
   LineS    : PRGBTripleArr;
   LineD    : PRGBTripleArr;
   y        : Integer;
   x        : Integer;
   rowS     : integer;
   idxarr   : integer;
   rowEdit  : integer;
begin
     ret := false;
     error := '';
     try
        try

           SetLength(ListOfSplitImage, qty);
           idxarr := 0;

           rowS := Trunc(MyImg.Height / qty);

           for y := 0 to MyImg.Height - 1 do
           begin
             LineS := MyImg.ScanLine[y];
             for x := 0 to MyImg.Width - 1 do
             begin
               with LineS^[x] do
               begin
                    if (not Assigned(Self.ListOfSplitImage[idxarr])) then
                    begin
                         Self.ListOfSplitImage[idxarr] := TJPEGImage.Create;
                         if (idxarr = qty-1) then
                         begin
                              rowS := MyImg.Height - (rowS * (qty-1));
                         end;
                         Self.ListOfSplitImage[idxarr].BeginUpdate();
                         Self.ListOfSplitImage[idxarr].SetSize(MyImg.Width, rowS);
                         Self.ListOfSplitImage[idxarr].PixelFormat := MyImg.PixelFormat;
                         rowEdit := 0;
                    end;
                    LineD := Self.ListOfSplitImage[idxarr].ScanLine[rowEdit];
                    LineD^[x].B := B;
                    LineD^[x].G := G;
                    LineD^[x].R := R;
                    LineD^[x].A := A;
               end;
             end;
             Inc(rowEdit);
             if (rowEdit >= rowS) then
             begin
                 Self.ListOfSplitImage[idxarr].EndUpdate();
                 Inc(idxarr);
             end;
           end;

           ret := true;
        finally

       end;
     except
           on E: Exception do
           begin

                error := '';

           end;
     end;

     result := ret;
end;

function TSplitImage.GetSplittedImage(idx: integer): TMemoryStream;
var
   ret : TMemoryStream;
begin
     if (Length(Self.ListOfSplitImage)>0) then
     begin
         ret := TMemoryStream.Create;
         if (idx<=0) then
            idx := 0;
         if (idx>=Length(Self.ListOfSplitImage)-1) then
            idx := Length(Self.ListOfSplitImage)-1;

         Self.ListOfSplitImage[idx].SaveToStream(ret);
         ret.Position := 0;
     end else begin
       ret := nil;
     end;
     result := ret;
end;

procedure TSplitImage.Merge(images: TJPEGImages);
var
   TotHeight : integer;
   ImgWidth  : integer;
   i         : integer;
   LineS     : PRGBTripleArr;
   LineD     : PRGBTripleArr;
   y         : Integer;
   x         : Integer;
   rowEdit   : integer;
begin
     TotHeight := 0;
     ImgWidth  := 0;
     for i := 0 to Length(images)-1 do
     begin
          TotHeight := TotHeight + images[i].Height;
          if (images[i].Width > ImgWidth) then
             ImgWidth := images[i].Width;
     end;
     if (not Assigned(MyImg)) then
     begin
          MyImg := TJPEGImage.Create;
     end;
     MyImg.BeginUpdate();
     MyImg.SetSize(ImgWidth, TotHeight);
     MyImg.PixelFormat := images[0].PixelFormat;
     rowEdit := 0;
     for i := 0 to Length(images)-1 do
     begin
           for y := 0 to images[i].Height - 1 do
           begin
             LineS := images[i].ScanLine[y];
             for x := 0 to images[i].Width - 1 do
             begin
               with LineS^[x] do
               begin
                 LineD := MyImg.ScanLine[rowEdit];
                 LineD^[x].B := B;
                 LineD^[x].G := G;
                 LineD^[x].R := R;
                 LineD^[x].A := A;
               end;
             end;
             Inc(rowEdit);
           end;
     end;
     MyImg.EndUpdate();
end;

function TSplitImage.GetImageMerged: TJPEGImage;
begin
     result := Self.MyImg;
end;

end.

