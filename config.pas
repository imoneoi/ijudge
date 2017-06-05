{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}

unit config;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, KOL {$IF Defined(KOL_MCK)}{$ELSE}, mirror, Classes, Controls, mckCtrls, mckObjs, Graphics {$IFEND (place your units here->)};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mirror;
{$ENDIF}

type
  {$IF Defined(KOL_MCK)}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} {$I TFormCfgclass.inc} {$ELSE OBJECTS} PFormCfg = ^TFormCfg; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TFormCfg.inc}{$ELSE} TFormCfg = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TFormCfg = class(TForm)
  {$IFEND KOL_MCK}
    KOLForm: TKOLForm;
    ListView1: TKOLListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCfg {$IFDEF KOL_MCK} : PFormCfg {$ELSE} : TFormCfg {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewFormCfg( var Result: PFormCfg; AParent: PControl );
{$ENDIF}

implementation

{$IF Defined(KOL_MCK)}{$ELSE}{$R *.DFM}{$IFEND}

{$IFDEF KOL_MCK}
{$I config_1.inc}
{$ENDIF}

end.
