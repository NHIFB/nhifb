Imports D03001
Imports D03001.WS
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Partial Class firstpage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        'Context.Response.ContentType = "text/plain"
        'Dim service1 As New Service("http://192.168.1.239:8080/D03/services/D03001", "Bob", "poipoipoipoi")
        'Dim string1() As String = {"cf1", "cf2", "cf3"}
        'Dim data1 As d03TData = service1.getD03TData("67440F523DBBE79CDFD9098A0CE3E8A7", string1)
        ''Dim split1() As String = data1.u03T_BILL.Split("{")
        'Dim temp As List(Of jsongogo)
        ''Dim DataList As New List() '根據之前先轉換好的類別宣告List
        'temp = JsonConvert.DeserializeObject(Of List(Of jsongogo))(data1.u03T_BILL)
        'Context.Response.Write(temp.Count & "          " & temp(0).EINS_NHI_ID)

    End Sub


    Public Class jsongogo
        Public Property STATUS_YM As String
        Public Property BRANCH_ID As String
        Public Property UNIT_ID As String
        Public Property IN_TYPE As String
        Public Property OUT_TYPE As String
        Public Property IN_DAY As String
        Public Property OUT_DAY As String
        Public Property TX_CODE As String
        Public Property INS_TYPE As String
        Public Property ID_TYPE As String
        Public Property INS_AMT As String
        Public Property INS_STATUS As String
        Public Property SW_BILL As String
        Public Property BELONG_CITY As String
        Public Property IN_RSN As String
        Public Property OUT_RSN As String
        Public Property RELATION As String
        Public Property EINS_NHI_ID As String
    End Class

    'Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
    'Dim strScript As String
    'strScript = String.Format("alert('{0}');", tbAlert.Text)     '==請註意大小寫，不可以寫成Alert，會出現錯誤=='
    'ScriptManager.RegisterStartupScript(Page, Page.GetType(), "alert", strScript, True)
    'End Sub
End Class
