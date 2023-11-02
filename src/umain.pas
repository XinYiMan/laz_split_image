unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  uSplitImage;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Edit1: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
         app      : TSplitImage;
         selected : integer;
         imgs     : array of TMemoryStream;
         procedure RunMyCode();
  public

  end;

var
  Form1: TForm1;

implementation
uses
    usecond, uTypeJpeg;
{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
     OpenDialog1.Filter := 'JPEG|*.jpeg;*.JPEG;JPG|*.jpg;*.JPG;BMP|*.bmp;*.BMP;';
     if OpenDialog1.Execute then
     begin
          Self.Edit1.Text:=OpenDialog1.Filename;
          RunMyCode;
     end else begin
       Self.Edit1.Clear;
     end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     if (selected>0) then
     begin
          Dec(selected);
     end;
     imgs[selected].Position := 0;
     Label1.Caption := IntToStr(selected);
     Self.Image2.Picture.Jpeg.LoadFromStream(imgs[selected]);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     if (selected<Length(imgs)-1) then
     begin
          Inc(selected);
     end;
     imgs[selected].Position := 0;
     Label1.Caption := IntToStr(selected);
     Self.Image2.Picture.Jpeg.LoadFromStream(imgs[selected]);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  imgs_merge : TJPEGImages;
begin
     SetLength(imgs_merge, 4);
     imgs_merge[0] := TJPEGImage.Create;
     imgs[0].Position:=0;
     imgs_merge[0].LoadFromStream(imgs[0]);

     imgs_merge[1] := TJPEGImage.Create;
     imgs[1].Position:=0;
     imgs_merge[1].LoadFromStream(imgs[1]);

     imgs_merge[2] := TJPEGImage.Create;
     imgs[2].Position:=0;
     imgs_merge[2].LoadFromStream(imgs[2]);

     imgs_merge[3] := TJPEGImage.Create;
     imgs[3].Position:=0;
     imgs_merge[3].LoadFromStream(imgs[3]);

     app.Merge(imgs_merge);

     imgs_merge[0].Free;
     imgs_merge[0]:=nil;

     imgs_merge[1].Free;
     imgs_merge[1]:=nil;

     imgs_merge[2].Free;
     imgs_merge[2]:=nil;

     imgs_merge[3].Free;
     imgs_merge[3]:=nil;

     SetLength(imgs_merge, 0);

     Self.Image3.Picture.Jpeg := app.GetImageMerged;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     Form2.showmodal;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     SetLength(imgs, 4);
     imgs[0]     := TMemoryStream.Create;
     imgs[1]     := TMemoryStream.Create;
     imgs[2]     := TMemoryStream.Create;
     imgs[3]     := TMemoryStream.Create;
end;

procedure TForm1.RunMyCode;
var
   error : string;
begin
     selected := 0;
     Self.Image1.Picture.Jpeg.LoadFromFile(Self.Edit1.Text);
     app := TSplitImage.Create(Self.Image1.Picture.Jpeg);
     if app.Split(4, error) then
     begin
          imgs[0] := app.GetSplittedImage(0);
          imgs[1] := app.GetSplittedImage(1);
          imgs[2] := app.GetSplittedImage(2);
          imgs[3] := app.GetSplittedImage(3);

          Label1.Caption := IntToStr(selected);
          Self.Image2.Picture.Jpeg.LoadFromStream(imgs[selected]);
     end else begin
         ShowMessage(error);
     end;

end;

end.

