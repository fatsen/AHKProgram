;含日文字符时，需要把本文件保存为UCS-2 Little Endian格式，原因未知
SwitchJpToEn(byref V_ToBeReplaced)
{
	; msgbox % V_ToBeReplaced
	; V_ToBeReplaced:="１５"
	 ; msgbox % V_ToBeReplaced
	 ; msgbox 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ０ ,0 , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, １ ,1 , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ２ ,2 , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ３ ,3 , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ４ ,4 , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ５ ,5 , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ６ ,6 , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ７ ,7 , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ８ ,8 , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ９ ,9 , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ＋ ,+ , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ー ,- , 1
	; stringReplace , V_ToBeReplaced, V_ToBeReplaced, ー ,- , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ＊ ,* , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ・ ,/ , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ． ,. , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, （ ,( , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ） ,) , 1
	
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ａ ,a , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｂ ,b , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｃ ,c , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｄ ,d , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｅ ,e , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｆ ,f , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｇ ,g , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｈ ,h , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｉ ,i , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｊ ,j , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｋ ,k , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｌ ,l , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｍ ,m , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｎ ,n , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｏ ,o , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｐ ,p , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｑ ,q , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｒ ,r , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｓ ,s , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｔ ,t , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｕ ,u , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｖ ,v , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｗ ,w , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｘ ,x , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｙ ,y , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, ｚ ,z , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ａ ,A , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｂ ,B , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｃ ,C , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｄ ,D , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｅ ,E , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｆ ,F , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｇ ,G , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｈ ,H , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｉ ,I , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｊ ,J , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｋ ,K , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｌ ,L , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｍ ,M , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｎ ,N , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｏ ,O , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｐ ,P , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｑ ,Q , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｒ ,R , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｓ ,S , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｔ ,T , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｕ ,U , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｖ ,V , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｗ ,W , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｘ ,X , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｙ ,Y , 1
	stringReplace , V_ToBeReplaced, V_ToBeReplaced, Ｚ ,Z , 1
	
	; msgbox % V_ToBeReplaced
}