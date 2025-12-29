' *****************************************************************
' Module: ExcelToSqlConnector
' Author: Murat Göcmen (@excelphpbridge)
' Purpose: Sends Excel Row Data to a Remote PHP/SQL Bridge
' Version: 1.0.0 (2025)
' *****************************************************************

Option Explicit

Public Sub SendDataToBridge()
    Dim http As Object
    Dim url As String
    Dim payload As String
    Dim response As String
    Dim selectedRow As Long

    ' Konfiguration der Bridge-URL (deine Domain)
    url = "https://your-domain.com/bridge/DatabaseBridge.php"

    ' Beispiel: Daten aus der aktuellen Zeile nehmen
    selectedRow = ActiveCell.Row
    
    ' JSON-ähnlicher Payload erstellen (Sicher für PHP)
    payload = "field1=" & Application.EncodeURL(Cells(selectedRow, 1).Value) & _
              "&field2=" & Application.EncodeURL(Cells(selectedRow, 2).Value)

    On Error GoTo ErrorHandler
    Set http = CreateObject("MSXML2.XMLHTTP")

    ' HTTP POST Anfrage an die PHP-Schnittstelle
    With http
        .Open "POST", url, False
        .SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
        .Send payload
        response = .ResponseText
    End With

    ' Rückmeldung an den User
    If http.Status = 200 Then
        MsgBox "Success: Data transferred to SQL Database!", vbInformation, "ExcelPHPBridge"
    Else
        MsgBox "Server Error: " & http.Status, vbCritical, "Bridge Failed"
    End If

    Set http = Nothing
    Exit Sub

ErrorHandler:
    MsgBox "Connection Error: " & Err.Description, vbCritical, "Network Error"
    Set http = Nothing
End Sub

' Hilfsfunktion zur URL-Kodierung (verhindert Fehler bei Sonderzeichen)
Function EncodeURL(str As String) As String
    ' In modernen Excel-Versionen verfügbar oder via WorksheetFunction
    EncodeURL = Application.WorksheetFunction.EncodeURL(str)
End Function
