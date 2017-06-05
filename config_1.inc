{ KOL MCK } // Do not remove this line!

procedure NewFormCfg( var Result: PFormCfg; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PFormCfg.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, '∏ﬂº∂…Ë÷√' ).SetPosition( 8, 8 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.SetClientSize( 317, 253 );
    Result.Form.Font.FontHeight := -11;
    Result.Form.Font.FontName := 'Microsoft Sans Serif';
    Result.ListView1 := NewListView( Result.Form, lvsIcon, [  ], nil, nil, nil ).SetPosition( 8, 8 ).SetSize( 301, 237 );
    Result.ListView1.Color := TColor(clWindow);

end;

