::============================================================================
:: Copy content of 'en_us' into all langs
:: lang list provided by Minecraft.wiki
:: → https://minecraft.wiki/w/Language
::
:: How to add another langage :
:: add a line into '$_langs.init' like that :
:: → lang_code=Langue Name
::
:: Exemple :
:: → en_us=American English
:: 
:: Script by Wolphwood
::============================================================================

@Echo off
setlocal EnableDelayedExpansion

set "default_lang=en_us"

for /f "tokens=1* delims==" %%A in ('type $_langs.ini') do (
	if /i not "%%~A"=="!default_lang!" (
		echo;^> Updating %%~B
		>"%%~A.json" type !default_lang!.json
	)
)
echo;&echo;Press any key to finish!

pause>nul