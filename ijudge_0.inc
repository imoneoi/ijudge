{ KOL MCK } // Do not remove this line!
{ ijudge_0.inc
  Do not edit this file manually - it is generated automatically.
  You can only modify ijudge_1.inc and ijudge_3.inc
  files. }

{$IFDEF Pcode}
 InstallCollapse;
{$ENDIF Pcode}
  NewMainForm( MainForm, nil );
{$I ijudge_1.inc}

{$I ijudge_2.inc}

{$I ijudge_3.inc}

  Run( MainForm.Form );

{$I ijudge_4.inc}

