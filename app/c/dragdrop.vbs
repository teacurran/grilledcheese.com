Dim objArgs
Dim TextStream
Dim fso
Dim File
Dim ForReading

ForReading = 1

Set objArgs = WScript.Arguments
Set fso = CreateObject("Scripting.FileSystemObject")

For I = 0 to objArgs.Count - 1
  	WScript.Echo objArgs(I)

	' Read the contents of the file.
	Set ts = fso.OpenTextFile(objArgs(I), ForReading)
	s = ts.ReadLine
	WScript.Echo "File contents = '" & s & "'"
	ts.Close

	Set TextStream = FSO.OpenTextFile(objArgs(I), ForReading)

	' Loop over every line in the file
	Do 	While Not TextStream.AtEndOfStream
		S = TextStream.ReadLine & NewLine

		WScript.Echo s
	Loop
	TextStream.Close
Next