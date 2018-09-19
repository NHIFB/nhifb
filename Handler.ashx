<%@ WebHandler Language="VB" Class="Handler" %>

Imports System
Imports System.Web
Imports System.Web.SessionState
Imports D03001
Imports D03001.WS
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports System.Reflection
Imports DataType.DataType

Public Class Handler : Implements IHttpHandler, IRequiresSessionState
    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Const flags As BindingFlags = BindingFlags.Public + BindingFlags.IgnoreCase + BindingFlags.Instance + BindingFlags.NonPublic
        Dim _Type As String
        
        '去掉特殊ID
        Dim formCollection As NameValueCollection
        Dim new_formCollection As New NameValueCollection
        context.Response.ContentType = "text/plain"
        _Type = context.Request.Form("_Type")
        formCollection = context.Request.Form
        formCollection.GetType().GetProperty("IsReadOnly", System.Reflection.BindingFlags.Instance Or System.Reflection.BindingFlags.NonPublic).SetValue(formCollection, False, Nothing)
        For Each key As String In formCollection.AllKeys
            Dim value = formCollection(key)
            formCollection.Remove(key)
            Dim newKey = key.Substring(key.LastIndexOf("$") + 1)
            formCollection.Add(newKey, value)
        Next

        '依照type尋找可用的method
        If (Not IsNothing(_Type)) Then
            Dim methodinf = Me.GetType().GetMethod(_Type, flags)
            Dim obj(0) As Object
            obj(0) = context
            
            Dim callback As String = context.Request.QueryString("callback")
            context.Response.Write(String.Format("{0}({1});", callback, methodinf.Invoke(Me, obj)))
        End If
    End Sub
    
    Protected Function setSessQueryId(ByVal context As HttpContext) As String
        Try
            Dim NHI_ID As String
            NHI_ID = context.Request.Form("queryId")
            Dim NHI_ID_encrypt As String = GET_NHI_ID(NHI_ID)
            context.Session.Add("EncryptQueryId", NHI_ID_encrypt)
            context.Session.Add("QueryId", NHI_ID)
            Return "{""status"":""success""}"
        Catch ex As Exception
            Return ex.ToString
        End Try
    End Function
    
    Protected Function read_U02T_ASBAS(ByVal context As HttpContext) As String
        Dim NHI_ID_encrypt As String = context.Session("EncryptQueryId")
        Dim service1 As New Service("http://192.168.1.239:8080/D03/services/D03001", "Bob", "poipoipoipoi")
        Dim col_fams() As String = {"cf1"}
        Dim data1 As d03TData = service1.getD03TData(NHI_ID_encrypt, col_fams) '自D03取資料
        Return "{""ASBAS"":" + data1.u02T_ASBAS + ",""NAME"":""" + data1.NAME + """}"
    End Function
    
    Protected Function readdata_u03T_BILL(ByVal context As HttpContext) As String
        'Dim NHI_ID As String
        'NHI_ID = context.Request.Form("_nhi_id")
        ' Dim Conten As String = Convert.ToString(context.Request.Params("TextConten"))
        '这里解码 Conten 
        Dim NHI_ID_encrypt As String = context.Session("EncryptQueryId")
        
        Dim service1 As New Service("http://192.168.1.239:8080/D03/services/D03001", "Bob", "poipoipoipoi")
        Dim col_fams() As String = {"cf1", "cf2", "cf3"}
        Dim data1 As d03TData = service1.getD03TData(NHI_ID_encrypt, col_fams) '自D03取資料
        
        If data1.MSG = "ERROR" Then
            'TODO: 錯誤處理
        End If
        Dim self_name As String = data1.NAME
        Dim self_table As List(Of jsongogo) = JsonConvert.DeserializeObject(Of List(Of jsongogo))(data1.u03T_BILL)
        Dim family_table_temp As New List(Of jsongogo)
        If Not data1.FAMILY Is Nothing Then
            family_table_temp = JsonConvert.DeserializeObject(Of List(Of jsongogo))(data1.FAMILY)
        End If
        Dim family_table As New List(Of jsongogo)
        Dim self_table_mul, family_table_mul As combine_json_date
        
        'family_table中，將EAS及EINS相同的數據刪除
        For Each row As jsongogo In family_table_temp
            If row.RELATION <> "" Then
                family_table.Add(row)
            End If
        Next
        family_table_temp = Nothing
        
        '將name加到JSON字串中
        self_table = add_name(self_table, self_name, True, NHI_ID_encrypt)
        family_table = add_name(family_table, self_name, False, NHI_ID_encrypt)
        
        '將JSON字串照時間順序排
        self_table_mul = sort_by_time(self_table)
        family_table_mul = sort_by_time(family_table)
        
        '組出units的內容
        Dim units As List(Of units) = classify_by_unit_id(self_table_mul, family_table_mul, NHI_ID_encrypt)
        
        '將main,family,units組起來
        Dim json_in_class As New return_json
        json_in_class.main = self_table_mul.json
        json_in_class.family = family_table_mul.json
        json_in_class.units = units
        
        '將Class中的東西轉成JSON字串
        Dim jsonreturn As String = JsonConvert.SerializeObject(json_in_class)
        Return jsonreturn
    End Function
    
    Protected Function enc_NHI_ID_GET_NAME(ByVal encrypt_NHI_ID As String) As String
        Dim service1 As New Service("http://192.168.1.239:8080/D03/services/D03001", "Bob", "poipoipoipoi")
        Dim col_fams() As String = {"cf1"}
        Dim data1 As d03TData = service1.getD03TData(encrypt_NHI_ID, col_fams)
        Return data1.NAME
    End Function
    
    Protected Function add_name(ByVal data_list As List(Of jsongogo), ByVal self_name As String, ByVal isT_BILL As Boolean, ByVal NHI_ID As String) As List(Of jsongogo)
        For Each subdata In data_list
            If isT_BILL Then
                If subdata.EINS_NHI_ID = NHI_ID Then
                    subdata.NAME = self_name
                Else
                    subdata.NAME = enc_NHI_ID_GET_NAME(subdata.EINS_NHI_ID)
                End If
            Else
                If subdata.EAS_NHI_ID = NHI_ID Then
                    subdata.NAME = self_name
                Else
                    subdata.NAME = enc_NHI_ID_GET_NAME(subdata.EAS_NHI_ID)
                End If
            End If
        Next
        Return data_list
    End Function
    
    Protected Function GET_NHI_ID(ByVal NHI_ID As String) As String
        Dim NHI_FBNoTran As New comNHI_FB.NHI_FBNoTran
        Dim vResp As New Resp
        Try
            vResp = NHI_FBNoTran.GET_NHI_ID(NHI_ID)
            
        Catch ex As Exception
            
        Finally
            If Not NHI_FBNoTran Is Nothing Then NHI_FBNoTran.Dispose()
        End Try
        GET_NHI_ID = vResp.Rst.Tables(0).Rows(0)("AS_ID")
    End Function
    
    Protected Function sort_by_time(ByVal jsonlist As List(Of jsongogo)) As combine_json_date
        Dim date_list_str(jsonlist.Count - 1) As String
        Dim twodata(jsonlist.Count) As Integer
        For i As Integer = 0 To jsonlist.Count - 1
            If jsonlist(i).IN_DAY <> "00" And jsonlist(i).OUT_DAY <> "00" Then
                twodata(i) = 1
                date_list_str(i) = jsonlist(i).STATUS_YM & jsonlist(i).IN_DAY
            ElseIf jsonlist(i).IN_DAY <> "00" Then
                date_list_str(i) = jsonlist(i).STATUS_YM & jsonlist(i).IN_DAY
            ElseIf jsonlist(i).OUT_DAY <> "00" Then
                date_list_str(i) = jsonlist(i).STATUS_YM & jsonlist(i).OUT_DAY
            Else
                date_list_str(i) = jsonlist(i).STATUS_YM & "01"
            End If
        Next
        Dim date_list_int() As Integer = Array.ConvertAll(date_list_str, Function(str) CInt(str))
        Dim date_list_sorted As combine_json_date = selection_sort(date_list_int, True, jsonlist)
        If Not date_list_int Is Nothing Then date_list_int = Nothing
        Return date_list_sorted
    End Function
    
    Protected Function selection_sort(ByVal ori_arr() As Integer, ByVal isIncrease As Boolean, ByVal jsonlist As List(Of jsongogo)) As combine_json_date
        Dim jsonarray(ori_arr.Length - 1) As jsongogo
        jsonlist.CopyTo(jsonarray)
        Dim arr() As Integer = ori_arr.Clone
        Dim len As Integer = arr.Length
        Dim i As Integer = 0
        Do While (i < (len - 1))
            Dim temp As Integer = i
            Dim k As Integer = (i + 1)
            Do While (k < len)
                If ((isIncrease AndAlso (arr(temp) > arr(k))) OrElse (Not isIncrease AndAlso (arr(temp) < arr(k)))) Then
                    temp = k
                End If
                k = (k + 1)
            Loop

            If (i <> temp) Then
                Dim buffer As Integer = arr(i)
                Dim jsonbuffer As jsongogo = jsonarray(i)
                arr(i) = arr(temp)
                jsonarray(i) = jsonarray(temp)
                arr(temp) = buffer
                jsonarray(temp) = jsonbuffer
            End If
            i = (i + 1)
        Loop
        
        Dim newjsonlist As List(Of jsongogo) = jsonarray.ToList
        
        Dim returnobj As New combine_json_date

        returnobj.inoutdate = arr.Clone
        returnobj.json = newjsonlist
        
        If Not jsonarray Is Nothing Then jsonarray = Nothing
        If Not arr Is Nothing Then arr = Nothing
        If Not newjsonlist Is Nothing Then newjsonlist = Nothing
        Return returnobj
    End Function
    
    Function classify_by_unit_id(ByVal self_list As combine_json_date, ByVal family_list As combine_json_date, ByVal self_AS_ID As String) As List(Of units)
        Dim unit_st_end As New List(Of List(Of Integer))
        Dim i_unit_st_end As Integer = 0
        Dim units_list As New List(Of units)
        Dim units As units
        Dim family_in_units As New List(Of List(Of List(Of Integer)))
        'Dim family_classify As New List(Of List(Of Integer))
        'family_classify.Add(New List(Of Integer))
        Dim family_cla_by_unit As New List(Of List(Of Integer)) '依據公司分類
        Dim family_cla_by_unit_eas As New List(Of List(Of List(Of Integer)))
        Dim is_include_in_fam_cla_by_unit_eas As Boolean = False
        'Dim fam_cla_is_include As Boolean = False
        'Dim i_family_classify As Integer = 0

        '將加保進出的資料納入unit_st_end的各攔第0和1中，0為開始加保的位置，1為結束加保的位置
        For i = 0 To self_list.json.Count - 1
            If self_list.json(i).IN_TYPE = "01" Or self_list.json(i).IN_TYPE = "02" Or self_list.json(i).IN_TYPE = "05" Then
                unit_st_end.Add(New List(Of Integer))
                unit_st_end(unit_st_end.Count - 1).Add(i)
            End If
            If self_list.json(i).OUT_TYPE = "04" Or self_list.json(i).OUT_TYPE = "07" Or self_list.json(i).OUT_TYPE = "08" Then
                For j = 0 To unit_st_end.Count - 1
                    If unit_st_end(j).Count = 1 Then
                        If self_list.json(unit_st_end(j)(0)).UNIT_ID = self_list.json(i).UNIT_ID Then
                            unit_st_end(j).Add(i)
                            Exit For
                        End If
                    End If
                Next
            End If
        Next

        'unit_st_end中如果只有加保無退保，補上self_list的長度，也代表最新的現在
        For j = 0 To unit_st_end.Count - 1
            If unit_st_end(j).Count = 1 Then
                unit_st_end(j).Add(self_list.json.Count)
            End If
        Next

        '將self_list的資料捕到unit_st_end，資料型態為0:起始，1:結束，2.3.4.....:其餘薪調等非加退保資料
        For k = 0 To self_list.json.Count - 1
            For l = 0 To unit_st_end.Count - 1
                If self_list.json(k).UNIT_ID = self_list.json(unit_st_end(l)(0)).UNIT_ID And k > unit_st_end(l)(0) And k < unit_st_end(l)(1) Then
                    unit_st_end(l).Add(k)
                End If
            Next
        Next

        'family_cla_by_unit及family_cla_by_unit_eas的第一維度的大小與unit_st_end相同，皆用unit_id先做資料整理
        For i = 0 To unit_st_end.Count - 1
            family_cla_by_unit.Add(New List(Of Integer))
            family_cla_by_unit_eas.Add(New List(Of List(Of Integer)))
        Next

        '將family_list的資料依各公司分類
        For i = 0 To family_list.json.Count - 1
            For j = 0 To unit_st_end.Count - 1
                If unit_st_end(j)(1) = self_list.json.Count Then '轉出資料為到現在仍在加保的
                    If family_list.json(i).IN_DAY <> "00" Then
                        If family_list.json(i).UNIT_ID = self_list.json(unit_st_end(j)(0)).UNIT_ID _
                            & Convert.ToInt32(family_list.json(i).STATUS_YM & family_list.json(i).IN_DAY) >= Convert.ToInt32(self_list.json(unit_st_end(j)(0)).IN_DAY) _
                            & Convert.ToInt32(family_list.json(i).STATUS_YM & family_list.json(i).IN_DAY) <= Convert.ToInt32(Format(Now(), "yyyyMMdd")) Then

                            family_cla_by_unit(j).Add(i)
                            Exit For
                        End If
                    ElseIf family_list.json(i).OUT_DAY <> "00" Then
                        If family_list.json(i).UNIT_ID = self_list.json(unit_st_end(j)(0)).UNIT_ID _
                            & Convert.ToInt32(family_list.json(i).STATUS_YM & family_list.json(i).OUT_DAY) >= Convert.ToInt32(self_list.json(unit_st_end(j)(0)).IN_DAY) _
                            & Convert.ToInt32(family_list.json(i).STATUS_YM & family_list.json(i).OUT_DAY) <= Convert.ToInt32(Format(Now(), "yyyyMMdd")) Then

                            family_cla_by_unit(j).Add(i)
                            Exit For
                        End If
                    End If
                Else
                    If family_list.json(i).IN_DAY <> "00" Then
                        If family_list.json(i).UNIT_ID = self_list.json(unit_st_end(j)(0)).UNIT_ID _
                            & Convert.ToInt32(family_list.json(i).STATUS_YM & family_list.json(i).IN_DAY) >= Convert.ToInt32(self_list.json(unit_st_end(j)(0)).IN_DAY) _
                            & Convert.ToInt32(family_list.json(i).STATUS_YM & family_list.json(i).IN_DAY) <= Convert.ToInt32(self_list.json(unit_st_end(j)(1)).OUT_DAY) Then

                            family_cla_by_unit(j).Add(i)
                            Exit For
                        End If
                    ElseIf family_list.json(i).OUT_DAY <> "00" Then
                        If family_list.json(i).UNIT_ID = self_list.json(unit_st_end(j)(0)).UNIT_ID _
                            & Convert.ToInt32(family_list.json(i).STATUS_YM & family_list.json(i).OUT_DAY) >= Convert.ToInt32(self_list.json(unit_st_end(j)(0)).IN_DAY) _
                            & Convert.ToInt32(family_list.json(i).STATUS_YM & family_list.json(i).OUT_DAY) <= Convert.ToInt32(self_list.json(unit_st_end(j)(1)).OUT_DAY) Then

                            family_cla_by_unit(j).Add(i)
                            Exit For
                        End If
                    End If
                End If
            Next
        Next

        'family_cla_by_unit的資料進一步將保險對象區分開並將資料填入family_cla_by_unit_eas，一維:分開unit_id，二維:以eas_nhi_id區分
        For i = 0 To family_cla_by_unit_eas.Count - 1 '第一維的大小為跟unit_st_end大小相同
            If family_cla_by_unit(i).Count > 0 Then '判斷是否在第i個unit_id分類內有無眷屬
                For j = 0 To family_cla_by_unit(i).Count - 1
                    If family_cla_by_unit_eas(i).Count > 0 Then '如果在family_cla_by_unit_eas中如果已經有資料筆數，則先判斷裡面是否有相同EAS_NHI_ID的，放在同一組
                        For k = 0 To family_cla_by_unit_eas(i).Count - 1
                            If family_list.json(family_cla_by_unit_eas(i)(k)(0)).EAS_NHI_ID = family_list.json(family_cla_by_unit(i)(j)).EAS_NHI_ID Then
                                family_cla_by_unit_eas(i)(k).Add(family_cla_by_unit(i)(j))
                                is_include_in_fam_cla_by_unit_eas = True
                                Exit For
                            End If
                        Next
                    End If
                    If is_include_in_fam_cla_by_unit_eas = False Then '如在其他的EAS_NHI_ID分組內無找到，便新增一條
                        family_cla_by_unit_eas(i).Add(New List(Of Integer))
                        family_cla_by_unit_eas(i)(family_cla_by_unit_eas(i).Count - 1).Add(family_cla_by_unit(i)(j))
                    Else '將是否找到初始化
                        is_include_in_fam_cla_by_unit_eas = False
                    End If
                Next
            End If
        Next


        ''將family_list的資料依每個人 
        'For Each family_case In family_list.json
        '    If family_classify.Count > 0 Then
        '        For l = 0 To family_classify.Count - 1
        '            If family_classify(l).Count > 0 Then
        '                If family_case.EAS_NHI_ID = family_list.json(family_classify(l)(0)).EAS_NHI_ID Then
        '                    family_classify(l).Add(i_family_classify)
        '                    fam_cla_is_include = True
        '                    Exit For

        '                End If
        '            End If
        '        Next
        '    End If

        '    If fam_cla_is_include = False Then
        '        family_classify.Add(New List(Of Integer))
        '        family_classify(family_classify.Count - 1).Add(i_family_classify)
        '    End If
        '    fam_cla_is_include = False
        '    i_family_classify += 1
        'Next
        'For m = 0 To unit_st_end.Count - 1

        'Next
        ''
        'For Each units_count In unit_st_end
        '    family_in_units.Add(New List(Of List(Of Integer)))
        'Next
        'For m = 0 To family_classify.Count
        '    For n = 0 To unit_st_end.Count - 1
        '        If family_list.json(m).UNIT_ID = self_list.json(unit_st_end(n)(0)).UNIT_ID Then
        '            If family_list.json(m).IN_DAY <> "00" Then
        '                If unit_st_end(n)(1) = self_list.json.Count Then
        '                    If Convert.ToInt32(family_list.json(m).STATUS_YM & family_list.json(m).IN_DAY) >= Convert.ToInt32(self_list.json(unit_st_end(n)(0)).STATUS_YM & self_list.json(unit_st_end(n)(0)).IN_DAY) _
        '                        And Convert.ToInt32(family_list.json(m).STATUS_YM & family_list.json(m).IN_DAY) <= Convert.ToInt32(Format(Now(), "yyyyMMdd")) Then
        '                        'family_in_units(n)(
        '                    End If
        '                Else
        '                    If Convert.ToInt32(family_list.json(m).STATUS_YM & family_list.json(m).IN_DAY) >= Convert.ToInt32(self_list.json(unit_st_end(n)(0)).STATUS_YM & self_list.json(unit_st_end(n)(0)).IN_DAY) _
        '                        And Convert.ToInt32(family_list.json(m).STATUS_YM & family_list.json(m).IN_DAY) <= Convert.ToInt32(self_list.json(unit_st_end(n)(1)).STATUS_YM & self_list.json(unit_st_end(n)(1)).OUT_DAY) Then
        '                        'family_in_units(n)(
        '                    End If
        '                End If
        '            ElseIf family_list.json(m).OUT_DAY <> "00" Then
        '                If Convert.ToInt32(family_list.json(m).STATUS_YM & family_list.json(m).OUT_DAY) >= Convert.ToInt32(self_list.json(unit_st_end(n)(0)).STATUS_YM & self_list.json(unit_st_end(n)(0)).IN_DAY) _
        '                    And Convert.ToInt32(family_list.json(m).STATUS_YM & family_list.json(m).OUT_DAY) <= Convert.ToInt32(self_list.json(unit_st_end(n)(1)).STATUS_YM & self_list.json(unit_st_end(n)(1)).OUT_DAY) Then
        '                    'family_in_units(n).Add(m)
        '                End If
        '            End If
        '        End If
        '    Next
        'Next

        For o = 0 To unit_st_end.Count - 1 '將資料填入units
            units = New units
            units.UNIT_ID = self_list.json(unit_st_end(o)(0)).UNIT_ID
            units.START_DATE = self_list.json(unit_st_end(o)(0)).STATUS_YM.Insert(4, "-") & "-" & self_list.json(unit_st_end(o)(0)).IN_DAY
            If unit_st_end(o)(1) <> self_list.json.Count Then
                units.END_DATE = self_list.json(unit_st_end(o)(1)).STATUS_YM.Insert(4, "-") & "-" & self_list.json(unit_st_end(o)(1)).OUT_DAY
            Else
                units.END_DATE = ""
                unit_st_end(o).Remove(1)
            End If
            For Each self_index In unit_st_end(o)
                units.MAP_ROW.Add(self_index)
            Next
            units.MAP_ROW.Sort()
            For Each depend In family_cla_by_unit_eas(o)
                units.DEPENDENTS.Add(depend)
            Next

            If self_list.json(unit_st_end(o)(0)).EINS_NHI_ID <> self_AS_ID Then
                units.PARENT_FLAG = 1
            End If
            units_list.Add(units)
        Next
        If Not unit_st_end Is Nothing Then unit_st_end = Nothing
        If Not units Is Nothing Then units = Nothing
        If Not family_in_units Is Nothing Then family_in_units = Nothing
        Return units_list
    End Function
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

    Public Class combine_json_date
        Public Property json As List(Of jsongogo)
        Public Property inoutdate() As Integer()
    End Class
End Class
Public Class return_json
    Public Property main As List(Of jsongogo)
    Public Property family As List(Of jsongogo)
    Public Property units As List(Of units)
End Class
Public Class units
    Public Property UNIT_ID As String
    Public Property START_DATE As String
    Public Property END_DATE As String
    Public Property MAP_ROW As New List(Of Integer)
    Public Property DEPENDENTS As New List(Of List(Of Integer))
    Public Property PARENT_FLAG As Integer = 0
End Class
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
    Public Property EAS_NHI_ID As String
    Public Property EINS_NHI_ID As String
    Public Property NAME As String
End Class

