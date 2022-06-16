program InfoTeste;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {frmPrincipal},
  uClasses in 'uClasses.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
