;menu Increment Selected
x:=Studio(),sc:=x.sc(),sc.2078()
loop,% sc.2570
{
	text:=sc.textrange(start:=sc.2585(a_index-1),end:=sc.2587(a_index-1))
	if(a_index=1)
		RegExMatch(text,"OU)(\d+)",number),num:=number.1
	else
		sc.2686(start,end),new:=RegExReplace(text,"(\d+)",++num),sc.2194(strlen(new),[new])
}
sc.2079()
ExitApp
return
