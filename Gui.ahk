#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%  ;
Gui, Add, Edit, x2 y0 w460 h70 vinputText,
Gui, Add, Button, x2 y70 w90 h30 gdeposit, 分割存款明细
Gui, Add, Button, x92 y70 w90 h30 gwithdraw, 分割提款明细
Gui, Add, Button, x182 y70 w90 h30 gdldeposit, 分割代充明细
Gui, Add, Button, x272 y70 w90 h30 gvalidFlow, 有效流水统计
Gui, Add, Button, x362 y70 w90 h30 gbetFlow, 投注流水统计
Gui, Add, Button, x2 y100 w90 h30 gRecord, 额度记录格式
Gui, Add, Button, x152 y100 w60 h30 gcopy, 复制
Gui, Add, Button, x222 y100 w60 h30 gclean, 清除
;;Gui, Add, Button, x92 y100 w90 h30 gbetFlow, 这是新的按钮
Gui, Add, Text, x320 y108 w90 h20 ,用户名: 
Gui, Add, Edit, x362 y105 w90 h20 vuserName,
Gui, Add, Edit, x2 y130 w460 h70 voutputText,
; Generated using SmartGUI Creator 4.0
Gui, Show, x127 y117 h202 w462, 转换
Return

GuiClose:
ExitApp

copy:
GuiControlGet,outputText
if (outputText){
	clipboard := outputText
	MsgBox, ,, 复制成功, 0.4

}

deposit:
GuiControlGet,inputText
if(inputText){
	text = 
	Loop, parse, inputText, `n, `r
	{
		if !(A_LoopField=""){
			StringSplit, word_array, A_LoopField,"	", .
			line_text = %word_array1%  %word_array5%  %word_array6%
			result = %line_text%
			text = %text%`n%result%
		}
	}
	StringReplace, out_text, text, `n,,
	GuiControl,,outputText,% out_text
}
Return

withdraw:
GuiControlGet,inputText
if(inputText){
	text = 
	Loop, parse, inputText, `n, `r
	{
		if !(A_LoopField=""){
			StringSplit, word_array, A_LoopField,"	", .
			usdt_method := "ST支付"
			IfInString,word_array6,%usdt_method%
			{
				line_text = %word_array1%  %word_array5%  %word_array7%
			}
			else{
				line_text = %word_array1%  %word_array5%  银行卡提现
			}
			result = %line_text%
			text = %text%`n%result%
		}
	}
	StringReplace, out_text, text, `n,,
	GuiControl,,outputText,% out_text
}
Return

dldeposit:
GuiControlGet,inputText
if(inputText){
	text = 
	Loop, parse, inputText, `n, `r
	{
		if !(A_LoopField=""){
			StringSplit, word_array, A_LoopField,"	", .
			line_text = %word_array6%  %word_array7%
			result = %line_text%
			text = %text%`n%result%
		}
	}
	StringReplace, out_text, text, `n,,
	GuiControl,,outputText,% out_text
}
Return

clean:
GuiControl,,inputText,
GuiControl,,outputText,
return

validFlow:
GuiControlGet,inputText
if(inputText){
	sport_True = 0
	sport_False = 0
	StringSplit, FlowLine, inputText, "`n", .
	Loop, %FlowLine0%
	{
		each_line := FlowLine%A_Index%
		StringSplit, Flow, each_line, "	", 
		flow_name := Flow1
		StringReplace, float_Flow, Flow3, `,,, All
		flow_number := float_Flow
		Needle := "体育"
		ENeedle := "电竞"
		If (InStr(flow_name, Needle)) || (InStr(flow_name, ENeedle)){
			sport_True += flow_number
			;;MsgBox, 体育 %flow_name% is %sport_True%
		}else if (flow_name="汇总") || (flow_name="平台"){
			continue
		}else{
			sport_False += flow_number
			;;MsgBox, 非体育 %flow_name% is %sport_False%
			}
	}
	sport_True := GetNumberFormatEx(Round(sport_True,2))
	sport_False := GetNumberFormatEx(Round(sport_False,2))
	text = 体育流水：%sport_True%`n娱乐流水：%sport_False%
	GuiControl,,outputText,% text
}
Return

betFlow:
GuiControlGet,inputText
if(inputText){
	GuiControl,,Subject
	sport_True = 0
	sport_False = 0
	StringSplit, FlowLine, inputText, "`n", .
	Loop, %FlowLine0%
	{
		each_line := FlowLine%A_Index%
		StringSplit, Flow, each_line, "	", 
		flow_name := Flow1
		StringReplace, float_Flow, Flow2, `,,, All
		flow_number := float_Flow
		Needle := "体育"
		ENeedle := "电竞"
		If (InStr(flow_name, Needle)) || (InStr(flow_name, ENeedle)){
			sport_True += flow_number
			;;MsgBox, 体育 %flow_name% is %sport_True%
		}else if (flow_name="汇总") || (flow_name="平台"){
			continue
		}else{
			sport_False += flow_number
			;;MsgBox, 非体育 %flow_name% is %sport_False%
			}
	}
	sport_True := GetNumberFormatEx(Round(sport_True,2))
	sport_False := GetNumberFormatEx(Round(sport_False,2))
	text = 体育流水：%sport_True%`n娱乐流水：%sport_False%
	GuiControl,,outputText,% text
}
Return

Record:
GuiControlGet,inputText
GuiControlGet,userName
if (inputText) and (userName){
	out_text = 
	StringSplit, recordLine, inputText, "`n", .
	Loop, %recordLine0%
	{
		each_line := recordLine%A_Index%
		if (each_line=""){
			continue
			}
		StringSplit, Flow, each_line, "	", 
		if Instr(Flow5,"代理转账"){
			if Instr(Flow6,"转出"){
				remark := StrReplace(Flow7,"（","")
				remark := StrReplace(remark,"）","")
				word_array := StrSplit(remark, ",", ".") 
				remark := word_array[1]",金额:"Flow10
				acc_amount := Flow3 "" Flow10
				end_text = %Flow3%	%Flow10%		%Flow15%	额度转让	%Flow16%	%userName%	%remark%
			}else{
				remark := StrReplace(Flow7,"（","")
				remark := StrReplace(remark,"）","")
				word_array := StrSplit(remark, ",", ".")
				remark := word_array[1]",金额:"Flow10
				end_text = %Flow3%		%Flow10%	%Flow15%	额度转让	%Flow16%	%userName%	%remark%
			}
			out_text = %out_text%`n%end_text%
			}
		else if Instr(Flow5,"加币"){
			if Instr(Flow6,"人工充值"){
				end_text = %Flow3%		%Flow10%	%Flow15%	银行汇款	%Flow16%	%userName%	%Flow8%
			}
			else if Instr(Flow6,"佣金调整"){
				end_text = %Flow3%		%Flow10%	%Flow15%	佣金调整	%Flow16%	%userName%	%Flow8%
			}
			else if Instr(Flow6,"代充返利调整"){
				end_text = %Flow3%		%Flow10%	%Flow15%	上分返利	%Flow16%	%userName%	%Flow8%
			}
			out_text = %out_text%`n%end_text%
			
		}
		else if Instr(Flow5,"减币"){
			if Instr(Flow6,"代理提现"){
				end_text = %Flow3%	%Flow10%		%Flow15%	代理提款	%Flow16%	%userName%	%Flow8%
			}
			else if Instr(Flow6,"佣金调整"){
				end_text = %Flow3%	%Flow10%		%Flow15%	佣金调整	%Flow16%	%userName%	%Flow8%
			}
			out_text = %out_text%`n%end_text%
		}
	}
	StringReplace, out_text, out_text, `n,,
	GuiControl,,outputText,% out_text
}else{
	if !(userName)
		MsgBox, 填写用户名
	}
return

;; Fuctions


Time_unix2human(time)
{
	human=19700101000000
	time-=((A_NowUTC-A_Now)//10000)*3600	;时差
	human+=%time%,Seconds
	return human
	}

GetNumberFormatEx(Value, LocaleName := "!x-sys-default-locale")
{
	if (Size := DllCall("GetNumberFormatEx", "str", LocaleName, "uint", 0, "str", Value, "ptr", 0, "ptr", 0, "int", 0)) {
		VarSetCapacity(NumberStr, Size << !!A_IsUnicode, 0)
		if (DllCall("GetNumberFormatEx", "str", LocaleName, "uint", 0, "str", Value, "ptr", 0, "str", NumberStr, "int", Size))
			return NumberStr
	}
	return false
}


!^Numpad8::Run %A_AhkPath% /r %A_ScriptFullPath%
