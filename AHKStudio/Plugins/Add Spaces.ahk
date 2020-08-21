#SingleInstance,Force
;menu Add Space Before And After Commas,baa
;menu Add Space After Commas,ac
;menu Add Space Before Commas,bc
;menu RemoveSpacesFromAroundCommas,rsfac
x:=Studio(),sc:=x.sc()
info=%1%
if(!sel:=sc.getseltext())
	sc.2160(sc.2128(line:=sc.2166(sc.2008)),sc.2136(line)),sel:=sc.getseltext()
replace:={ac:[["U),(\S)",", $1"]],bc:[["U)(\S),","$1 ,"]],baa:[["U),(\S)",", $1"],["U)(\S),","$1 ,"]]}
if(replace[info])
	x.ReplaceSelected(ProcessText(sel,replace[info]))
else
	x.ReplaceSelected(RegExReplace(sel,"\s*,\s*",","))
ExitApp
ProcessText(text,process){
	for c,d in process{
		while,text:=RegExReplace(text,d.1,d.2,count){
			if(!count)
				break
		}
	}
	return text
}