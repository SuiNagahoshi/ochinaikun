;落ちない君 r01
;MPASMかpic-asあたりで書いてる気がする。NASMが良かった。
;アドレスやバイトオーダーはきっとおそらく多分もしかしたらmaybeリトルエンディアンかもしれない可能性が無きにしも非ず
	LIST		P=PIC16F1827								;使用するPICを指定
	INCLUDE		"PIC16F1827.INC"							;.INCファイルをインクルード
	__CONFIG	_CONFIG1._FOSC_HS & _WDTE_OFF & _PWRTE_ON & _CP_OFF & _PCD_OFF	;コンフィグ
	__CONFIG	_CONFIG2._WRT_OFF
;変数(ラベル)の定義
	DATA1		EQU	20H										;ラベル名 EQU 汎用レジスタの番地
	PATTERNA	EQU	21H
	PATTERNB	EQU	22H
	PATTERNC	EQU	23H
	PATTERND	EQU	24H
;初期設定・入力ポート・出力ポートの設定
	ORG		H'00'											;プログラムを格納する先頭位置のアドレス
	MOVLB	H'01'											;バンク設定
	MOVLW	B'00000000'										;00000000BをWレジスタに格納
	MOVWF	TRISA											;ポートAをすべて出力モードに設定
	MOVLW	B'11111111'										;00011111BをWレジスタに格納
	MOVWF	TRISB											;ポートBを全て入力モードに設定
	MOVLB	H'03'											;バンク設定
	MOVLW	B'00000000'										;00000000BをWレジスタに格納
	MOVWF	ANSELA											;アナログ入力を無効化
	MOVLW	B'00000000'										;00000000BをWレジスタに格納
	MOVWF	ANSELB											;アナログ入力を無効化
	MOVLB	H'00'											;バンク設定
	BCF		STATUS,Z										;ゼロフラグをクリア
	CLRF	PORTB											;ポートBをクリア
	CLRF	PORTA											;ポートAをクリア
;
;モーター動作パターンの設定
	MOVLW	B'00000101'										;モーターの出力信号0101(00000101B)をWレジスタに格納
	MOVWF	PATTERNA										;WレジスタのデータをPATTERNAへ格納
;
	MOVLW	B'00000110'										;モーターの出力信号0101(00000101B)をWレジスタに格納
	MOVWF	PATTERNB										;WレジスタのデータをPATTERNBへ格納
;
	MOVLW	B'00000010'										;モーターの出力信号0101(00000101B)をWレジスタに格納
	MOVWF	PATTERNC										;WレジスタのデータをPATTERNCへ格納
;
	MOVLW	B'00001001'										;モーターの出力信号0101(00000101B)をWレジスタに格納
	MOVWF	PATTERND										;WレジスタのデータをPATTERNDへ格納
;
	MOVLW	B'00001000'										;モーターの出力信号0101(00000101B)をWレジスタに格納
	MOVWF	PATTERNE										;WレジスタのデータをPATTERNDへ格納
;
;スタートスイッチの確認
START_SW
	BTFSS	PORTB,0											;RB0スタートSWが1なら次をスキップ
	GOTO	START_SW										;START_SWへ行く
;
;色センサーの確認
COLOR_SENSOR
	BTFSS	PORTB,1											;RB1色センサーが1なら次をスキップ
	GOTO	S000											;S000へ
	CLRF	PORTA											;ポートAをクリア(モーター停止)
;
;S(左,中,右)
S000
	CLRW													;Wレジスタをクリア
	BCF		STATUS,Z										;ゼロフラグをクリア
	CLRF	DATA1											;DATA1をクリア
	MOVF	PORTB,W											;PORTBをWレジスタへ格納
	MOVWF	DATA1											;WレジスタのデータをDATA1へ格納
	MOVLW	B'00000000'										;00000000BをWレジスタへ格納
	SUBWF	DATA1,W											;(DATA1 - W)の値をWレジスタへ格納(演算結果が0ならZ=0)
	BTFSS	STATUS,Z										;STATUSのゼロフラグが1なら次をスキップ
	GOTO	S001											;S001へ行く
	MOVF	PATTERNA,W										;PATTERNAのデータをWレジスタへ格納
	MOVWF	PORTA											;Wレジスタの値をPORTAに出力
	GOTO	COLOR_SENSOR									;COLOR_SENSORへ
;
S001
	CLRW													;Wレジスタをクリア
	BCF		STATUS,Z										;ゼロフラグをクリア
	CLRF	DATA1											;DATA1をクリア
	MOVF	PORTB,W											;PORTBをWレジスタへ格納
	MOVWF	DATA1											;WレジスタのデータをDATA1へ格納
	MOVLW	B'00000100'										;00000000BをWレジスタへ格納
	SUBWF	DATA1,W											;(DATA1 - W)の値をWレジスタへ格納(演算結果が0ならZ=0)
	BTFSS	STATUS,Z										;STATUSのゼロフラグが1なら次をスキップ
	GOTO	S001											;S001へ行く
	MOVF	PATTERNA,W										;PATTERNAのデータをWレジスタへ格納
	MOVWF	PORTA											;Wレジスタの値をPORTAに出力
	GOTO	COLOR_SENSOR									;COLOR_SENSORへ
;
S010
	CLRW													;Wレジスタをクリア
	BCF		STATUS,Z										;ゼロフラグをクリア
	CLRF	DATA1											;DATA1をクリア
	MOVF	PORTB,W											;PORTBをWレジスタへ格納
	MOVWF	DATA1											;WレジスタのデータをDATA1へ格納
	MOVLW	B'00001000'										;00000000BをWレジスタへ格納
	SUBWF	DATA1,W											;(DATA1 - W)の値をWレジスタへ格納(演算結果が0ならZ=0)
	BTFSS	STATUS,Z										;STATUSのゼロフラグが1なら次をスキップ
	GOTO	S001											;S001へ行く
	MOVF	PATTERNA,W										;PATTERNAのデータをWレジスタへ格納
	MOVWF	PORTA											;Wレジスタの値をPORTAに出力
	GOTO	COLOR_SENSOR									;COLOR_SENSORへ
;
S011
	CLRW													;Wレジスタをクリア
	BCF		STATUS,Z										;ゼロフラグをクリア
	CLRF	DATA1											;DATA1をクリア
	MOVF	PORTB,W											;PORTBをWレジスタへ格納
	MOVWF	DATA1											;WレジスタのデータをDATA1へ格納
	MOVLW	B'00001100'										;00000000BをWレジスタへ格納
	SUBWF	DATA1,W											;(DATA1 - W)の値をWレジスタへ格納(演算結果が0ならZ=0)
	BTFSS	STATUS,Z										;STATUSのゼロフラグが1なら次をスキップ
	GOTO	S001											;S001へ行く
	MOVF	PATTERNA,W										;PATTERNAのデータをWレジスタへ格納
	MOVWF	PORTA											;Wレジスタの値をPORTAに出力
	GOTO	COLOR_SENSOR									;COLOR_SENSORへ
;
S100
	CLRW													;Wレジスタをクリア
	BCF		STATUS,Z										;ゼロフラグをクリア
	CLRF	DATA1											;DATA1をクリア
	MOVF	PORTB,W											;PORTBをWレジスタへ格納
	MOVWF	DATA1											;WレジスタのデータをDATA1へ格納
	MOVLW	B'00010000'										;00000000BをWレジスタへ格納
	SUBWF	DATA1,W											;(DATA1 - W)の値をWレジスタへ格納(演算結果が0ならZ=0)
	BTFSS	STATUS,Z										;STATUSのゼロフラグが1なら次をスキップ
	GOTO	S001											;S001へ行く
	MOVF	PATTERNA,W										;PATTERNAのデータをWレジスタへ格納
	MOVWF	PORTA											;Wレジスタの値をPORTAに出力
	GOTO	COLOR_SENSOR									;COLOR_SENSORへ
;
S101
	CLRW													;Wレジスタをクリア
	BCF		STATUS,Z										;ゼロフラグをクリア
	CLRF	DATA1											;DATA1をクリア
	MOVF	PORTB,W											;PORTBをWレジスタへ格納
	MOVWF	DATA1											;WレジスタのデータをDATA1へ格納
	MOVLW	B'00010100'										;00000000BをWレジスタへ格納
	SUBWF	DATA1,W											;(DATA1 - W)の値をWレジスタへ格納(演算結果が0ならZ=0)
	BTFSS	STATUS,Z										;STATUSのゼロフラグが1なら次をスキップ
	GOTO	S001											;S001へ行く
	MOVF	PATTERNA,W										;PATTERNAのデータをWレジスタへ格納
	MOVWF	PORTA											;Wレジスタの値をPORTAに出力
	GOTO	COLOR_SENSOR									;COLOR_SENSORへ
;
S110
	CLRW													;Wレジスタをクリア
	BCF		STATUS,Z										;ゼロフラグをクリア
	CLRF	DATA1											;DATA1をクリア
	MOVF	PORTB,W											;PORTBをWレジスタへ格納
	MOVWF	DATA1											;WレジスタのデータをDATA1へ格納
	MOVLW	B'00011000'										;00000000BをWレジスタへ格納
	SUBWF	DATA1,W											;(DATA1 - W)の値をWレジスタへ格納(演算結果が0ならZ=0)
	BTFSS	STATUS,Z										;STATUSのゼロフラグが1なら次をスキップ
	GOTO	S001											;S001へ行く
	MOVF	PATTERNA,W										;PATTERNAのデータをWレジスタへ格納
	MOVWF	PORTA											;Wレジスタの値をPORTAに出力
	GOTO	COLOR_SENSOR									;COLOR_SENSORへ
;
S111
	CLRW													;Wレジスタをクリア
	BCF		STATUS,Z										;ゼロフラグをクリア
	CLRF	DATA1											;DATA1をクリア
	MOVF	PORTB,W											;PORTBをWレジスタへ格納
	MOVWF	DATA1											;WレジスタのデータをDATA1へ格納
	MOVLW	B'00011100'										;00000000BをWレジスタへ格納
	SUBWF	DATA1,W											;(DATA1 - W)の値をWレジスタへ格納(演算結果が0ならZ=0)
	BTFSS	STATUS,Z										;STATUSのゼロフラグが1なら次をスキップ
	GOTO	S001											;S001へ行く
	MOVF	PATTERNA,W										;PATTERNAのデータをWレジスタへ格納
	MOVWF	PORTA											;Wレジスタの値をPORTAに出力
	GOTO	COLOR_SENSOR									;COLOR_SENSORへ
;

	END