{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}

program ijudge;

uses
KOL,
  main in 'main.pas' {MainForm};

{$R *.res}
//{$R ijudge.res}
//{$R WinXP.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IF Defined(KOL_MCK)} {$I ijudge_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

{$IFEND}

end.
