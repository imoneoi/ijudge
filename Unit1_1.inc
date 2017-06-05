{ KOL MCK } // Do not remove this line!

procedure NewMainForm( var Result: PMainForm; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PMainForm.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'iJudge 智能评测' ).SetPosition( 8, 8 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
    Result.Form.SetClientSize( 334, 527 );
    Result.Form.Font.FontHeight := -11;
    Result.Form.Font.FontName := 'Microsoft Sans Serif';
      Result.Form.OnClose := Result.KOLFormClose;
      Result.Form.OnDestroy := Result.KOLFormDestroy;

    Result.iml := NewImageList( Result.Form );
    Result.iml.Colors := ilcColorDDB;
    Result.iml.Masked := FALSE;
    Result.iml.BkColor := clWindow;
      Result.iml.ImgWidth := 16;
      Result.iml.ImgHeight := 16;
      {$R MainForm_iml.res}
    Result.iml.Add( LoadBmp( hInstance, 'MAINFORM_IML', Result.iml ), 0 );
    Result.Label1 := NewLabel( Result.Form, '程序代码：' ).SetPosition( 16, 18 ).SetSize( 58, 17 );
    Result.Label2 := NewLabel( Result.Form, '数据目录：' ).SetPosition( 16, 44 ).SetSize( 58, 17 );
    Result.Label3 := NewLabel( Result.Form, '时间(ms)：' ).SetPosition( 16, 70 ).SetSize( 58, 17 );
    Result.Label4 := NewLabel( Result.Form, '内存(MB)：' ).SetPosition( 16, 98 ).SetSize( 58, 17 );
    Result.edata := NewEditBox( Result.Form, [  ] ).SetPosition( 80, 42 ).SetSize( 246, 0 );
    Result.emem := NewEditBox( Result.Form, [ eoNumber ] ).SetPosition( 80, 96 ).SetSize( 176, 0 );
    Result.emem.Text := '128';
    Result.esrc := NewEditBox( Result.Form, [  ] ).SetPosition( 80, 16 ).SetSize( 246, 0 );
    Result.etime := NewEditBox( Result.Form, [ eoNumber ] ).SetPosition( 80, 68 ).SetSize( 246, 0 );
    Result.etime.Text := '1000';
    Result.tvres := NewTreeView( Result.Form, [ tvoLinesRoot, tvoSingleExpand, tvoFullRowSelect ], nil, Result.iml ).SetPosition( 16, 124 ).SetSize( 310, 364 );
    Result.tvres.Color := TColor(clWindow);
    Result.btnJudge := NewButton( Result.Form, '智能评测' ).SetPosition( 16, 494 ).SetSize( 73, 25 ).LikeSpeedButton;
    Result.cbTop := NewCheckBox( Result.Form, '窗口置顶' ).SetPosition( 254, 497 ).LikeSpeedButton;
    Result.cbTop.Checked := TRUE;
    Result.pgb := NewProgressBarEx( Result.Form, [ pboSmooth ] ).SetPosition( 98, 495 ).SetSize( 150, 24 );
    Result.pgb.Visible := False;
    Result.mres := NewEditBox( Result.Form, [ eoMultiline, eoNoHScroll, eoReadonly ] ).SetPosition( 16, 428 ).SetSize( 310, 60 );
    Result.mres.Font.Color := TColor(clWhite);
    Result.mres.Visible := False;
    Result.mres.Text := 'Memo1'+#13+#10;
    Result.bCfg := NewButton( Result.Form, '配置 >>' ).SetPosition( 262, 96 ).LikeSpeedButton;
    Result.pCfg := NewPanel( Result.Form, esLowered ).SetPosition( 16, 124 ).SetSize( 310, 364 );
    Result.pCfg.Visible := False;
      Result.Label5 := NewLabel( Result.pCfg, '编译时间(ms)：' ).SetPosition( 14, 102 ).SetSize( 75, 17 );
      Result.ecmptime := NewEditBox( Result.pCfg, [ eoNumber ] ).SetPosition( 95, 99 ).SetSize( 184, 0 );
      Result.ecmptime.Text := '20000';
      Result.GroupBox1 := NewGroupBox( Result.pCfg, '编译器路径' ).SetPosition( 14, 127 ).SetSize( 282, 114 );
    Result.GroupBox1.TabStop := FALSE;
        Result.Label6 := NewLabel( Result.GroupBox1, 'gcc.exe：' ).SetPosition( 12, 34 ).SetSize( 42, 14 );
        Result.Label7 := NewLabel( Result.GroupBox1, 'g++.exe：' ).SetPosition( 12, 58 ).SetSize( 42, 14 );
        Result.Label8 := NewLabel( Result.GroupBox1, 'fpc.exe：' ).SetPosition( 11, 83 ).SetSize( 43, 14 );
        Result.efpc := NewEditBox( Result.GroupBox1, [  ] ).SetPosition( 60, 80 ).SetSize( 213, 0 );
        Result.egcc := NewEditBox( Result.GroupBox1, [  ] ).SetPosition( 60, 30 ).SetSize( 212, 0 );
        Result.egpp := NewEditBox( Result.GroupBox1, [  ] ).SetPosition( 60, 55 ).SetSize( 213, 0 );
    Result.esrc.Color := TColor(clWindow);
    Result.edata.Color := TColor(clWindow);
    Result.etime.Color := TColor(clWindow);
      Result.btnJudge.OnClick := Result.btnJudgeClick;
    Result.btnJudge.DefaultBtn := TRUE;
      Result.cbTop.OnClick := Result.cbTopClick;
      Result.tvres.OnChange := Result.tvresChange;
    Result.emem.Color := TColor(clWindow);
    Result.mres.Color := TColor(clNone);
    Result.ecmptime.Color := TColor(clWindow);
    Result.egcc.Color := TColor(clWindow);
    Result.egpp.Color := TColor(clWindow);
    Result.efpc.Color := TColor(clWindow);
      Result.bCfg.OnClick := Result.bCfgClick;
    Result.Form.CenterOnCurrentScreen.CanResize := False;
    Result.Form.Perform( WM_INITMENU, 0, 0 );
    Result.KOLFormCreate( Result );

end;

