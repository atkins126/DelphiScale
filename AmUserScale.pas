unit AmUserScale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,AmUserType;

//type
  type
  AmScale = class
    private
      class procedure SetScaleAppCustom(New,Old:integer);
    public
     //������ ��������  ������� �� ���������
     //  AppScaleDesing ��������� ��������� � 100 ��� �������� ����� � �� �����
     //  WinScaleDPIDesing ��������� ��������� � 96 ��� �������� ����� ��� ����� WinApi.Windows.USER_DEFAULT_SCREEN_DPI  � �� �����
     //���� �� �������������� ����� � � ��� �� ����� ���������� ������ 120 �� ��� � ���������� �� ��������� � WinScaleDPIDesing
     // ���� � ��� ������ ���������� ������ 96 �� ������ ������������� �� ����� �� initialization

      class var AppScaleDesing:Integer; //  ����� ������ ��� �� ����� ����������
      class var AppScaleNow:Integer;    //����� ������ ������ � ����������
      class var WinScaleDPIDesing:Integer; //����� ���������� ������ ������� ���  �� ����� ����������
      class var WinScaleDPINow:Integer; //����� ���������� ������ ������� ������ � ����������

      // ��� �������� ������� ����� ��������� Init
      // ����� �������� �������� ������������ ������� ���������� �������� � ����� �� ���� ������
      // ��� ������� �� 30 �� 200 ������ ��� 100 ��������� �� ������� ���������� �� ����� ����������
      class procedure Init(ASavedProcent:Integer=100);

      // � �������� FormShow ��������� Show
      class procedure Show;
      //  ��������� � ������� ������� ����� FormAfterMonitorDpiChanged
      // ��������� ����� � ������� ��������� �������� ������
      class procedure ChangeDPI(NewDPI,OldDPI:integer);

      // �������� ����� �������� ������� ��� ����� val �������� ���� ��������
      // ���� ������ ��  P:=Tpanel.create(self); P.height:=  AmScale.Value(88);
      class function Value(val:integer):integer; static;

      // ���� ����� �������� ������ ����� ����������  SetScaleApp(120,100) ���������� �� 20%
      class procedure SetScaleApp(New,Old:integer);

      // �������� ������ ��� ����� ��������� �������� ����������
      class procedure GetAppToList(L:TStrings);

      // � ��� ���� �������� �� �� ������ ����� ��� � ������  = �������
      class function GetIndexFromList(L:TStrings;value:integer=0):integer;

      // �������� �������� � ������ ������� ����  �������� � GetAppToList
      class function GetValueFromStr(S:String):integer;
      // �������� ������ ����� ���� ������ ����� �������� �� ������
      class procedure SetAppFromListInt(New:Integer);
      //�������� ���� ����� �� ������ ����������� � GetAppToList
      class procedure SetAppFromList(S:String);
  end;

  function UserMainScale(val:integer):integer;

{
  ��� ������ �������� ����� ��� �� ������ ����� �������� ��������

  �������� ������ ������ � ������������ �� ���� create ������� �������� � UserMainScaleGetConst

 ���
 Width_now ��� ������ ����� ����� ������ �����������
 Width_debag ��� ������ ����� �� ����� ����������
 � ����� �������� ������� ��������� , �.� ������
USER_MAIN_SCALE_CREATE:= UserMainScaleGetConst(MyForm.Width,500);
USER_MAIN_SCALE_CREATE ������ ������� ������ ������� 125.67 �� ������ 100

����� ���� ������� ���������� ������������ �� ��������� ������ � ������ � ������� ���
P:=Tpanel.create(self);
P.parent:=self;
P.height:=  UserMainScale(88);  //���� ������ �� ������ ���  P.height:=  88;
P.font.size:=  UserMainScale(10);


  ��������� ��������� �� ������������� �������� ��������
  ����� TWinControl.Create
  � �� ���������� Parent
  ����� ������� �������� ����� ������ �.�
  P.height:=  88;
  P.parent:=self;
  ����� ���������  Parent
  P.height:=  UserMainScale(88);
}

implementation



{ AmScale }
function UserMainScale(val:integer):integer;
begin
   Result:=AmScale.Value(val);
end;
class procedure AmScale.GetAppToList(L: TStrings);
begin
    L.Clear;
    L.Add('70 %');
    L.Add('80 %');
    L.Add('90 %');
    L.Add('95 %');
    L.Add('100 % (������������)');
    L.Add('110 %');
    L.Add('120 %');
    L.Add('130 %');
    L.Add('140 %');
    L.Add('150 %');
    L.Add('175 %');
    L.Add('200 %');
end;
class function AmScale.GetIndexFromList(L: TStrings; value: integer=0): integer;
begin
    if value<30 then
    value:= AppScaleNow;
    for Result := 0 to L.Count-1 do
    if GetValueFromStr(L[Result]) = value then exit;
    Result:=-1;
end;

class function AmScale.GetValueFromStr(S: String): integer;
var tok:integer;
begin
    Result:=0;
    tok:=  pos(' ',S);
    if (tok<>1) and (tok<>0) then
    begin
       S:=s.Split([' '])[0];
       TryStrToInt(S,Result);
    end;
end;

class procedure AmScale.SetAppFromList(S: String);
begin
    SetAppFromListInt(GetValueFromStr(S));
end;
class procedure AmScale.SetAppFromListInt(New: Integer);
begin
   SetScaleApp(New,AppScaleNow);
end;

class procedure AmScale.SetScaleApp(New,Old:integer);
begin
   if New<30 then exit;
   if Old<30 then
   Old:= AppScaleNow;
   if Old<30 then exit;

   if New<>AppScaleNow then
   begin
       SetScaleAppCustom(New,AppScaleNow);
       AppScaleNow:= New;
   end;
end;
class procedure AmScale.SetScaleAppCustom(New, Old: integer);
var i:integer;
begin
     for  I := 0 to Screen.FormCount-1 do
     Screen.Forms[i].ScaleBy(New,Old);
end;

class procedure AmScale.Show;
begin
    SetScaleAppCustom(AppScaleNow,AppScaleDesing);
end;

class procedure AmScale.ChangeDPI(NewDPI,OldDPI:integer);
begin
  WinScaleDPINow:= NewDPI;
end;
class procedure AmScale.Init(ASavedProcent:Integer=100);
var LMonitor:TMonitor;
    LForm: TForm;
    LPlacement: TWindowPlacement;
begin
      if ASavedProcent<=0 then
      ASavedProcent:=100;
      if ASavedProcent<30 then  ASavedProcent:=30;
      if ASavedProcent>300 then  ASavedProcent:=300;

      AppScaleDesing:=100;
      AppScaleNow:=ASavedProcent;



      WinScaleDPINow:=USER_DEFAULT_SCREEN_DPI;
      WinScaleDPIDesing:=USER_DEFAULT_SCREEN_DPI;

      if (Application<>nil) and (Screen<>nil) then
      begin
        LMonitor := Screen.MonitorFromWindow(Application.Handle);
        if LMonitor <> nil then
          WinScaleDPINow := LMonitor.PixelsPerInch
        else
         WinScaleDPINow := Screen.PixelsPerInch;

        LForm := Application.MainForm;
        if (LForm <> nil)  then
        WinScaleDPIDesing := LForm.PixelsPerInch;


      end
      else if (Screen<>nil) and (Mouse<>nil) then
      begin
        LMonitor := Screen.MonitorFromPoint(Mouse.CursorPos);
        if LMonitor <> nil then
          WinScaleDPINow := LMonitor.PixelsPerInch
        else
         WinScaleDPINow := Screen.PixelsPerInch;

        LForm := Application.MainForm;
        if (LForm <> nil)  then
        WinScaleDPIDesing := LForm.PixelsPerInch;
      end;
           



      //ScaleForPPI(GetParentCurrentDpi);

end;

class function AmScale.Value(val: integer): integer;
begin
  // result:=Round( Value(Real(val)) );
    // ������� ������ ������� ����� ������ ����������
    result:=MulDiv(val, WinScaleDPINow, WinScaleDPIDesing);
    result:=MulDiv(result, AppScaleNow, AppScaleDesing);
end;

 {
class procedure AmScale.Start(Width_now, Width_debag: real);
begin

     USER_SCALE:=100;
   if Width_debag=0 then exit;
   USER_SCALE:=(Width_now/Width_debag)*100;

 c:=TMonitor.Create;
 c.PixelsPerInch

end;}
initialization
begin
   AmScale.AppScaleDesing:=100;
   AmScale.AppScaleNow:=100;
   AmScale.WinScaleDPIDesing:= WinApi.Windows.USER_DEFAULT_SCREEN_DPI;
   AmScale.WinScaleDPINow:=    WinApi.Windows.USER_DEFAULT_SCREEN_DPI;
end;
end.