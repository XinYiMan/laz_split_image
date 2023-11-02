unit usecond;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation
uses
    uDiffImage;

{$R *.lfm}

{ TForm2 }

procedure TForm2.Button1Click(Sender: TObject);
begin
  //OpenDialog1.Filter := 'JPEG|*.jpeg;*.JPEG;JPG|*.jpg;*.JPG;';
  if OpenDialog1.Execute then
  begin
       Self.Image1.Picture.Jpeg.LoadFromFile(OpenDialog1.Filename);
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  //OpenDialog1.Filter := 'JPEG|*.jpeg;*.JPEG;JPG|*.jpg;*.JPG;';
  if OpenDialog1.Execute then
  begin
       Self.Image2.Picture.Jpeg.LoadFromFile(OpenDialog1.Filename);
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
   app    : TDiffImage;
   error  : string;
   img    : TJPEGImage;
begin
     app := TDiffImage.Create;

     if not app.GetDifference(Self.Image1.Picture.Jpeg, Self.Image2.Picture.Jpeg, img, error) then
     begin
          ShowMessage(error);
     end else begin
         Self.Image3.Picture.Jpeg := img;
     end;

     app.Free;
     app:=nil;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
     if SaveDialog1.Execute then
     begin
          Self.Image3.Picture.Jpeg.SaveToFile(SaveDialog1.FileName);
     end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin

end;

end.

