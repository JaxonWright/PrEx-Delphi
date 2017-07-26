program PrEx;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Process Explorer';
  TStyleManager.TrySetStyle('Metropolis UI Black');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
