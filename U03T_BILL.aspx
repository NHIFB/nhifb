<%@ Page Title="我的保費" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="U03T_BILL.aspx.vb" Inherits="firstpage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script>
    $(function () {
        var id_type_map = { "1": "雇主", "2": "一般", "3": "專技1", "4": "專技2" };
        var branch_id_map = { "0": "署本部", "1": "台北", "2": "北區", "3": "中區", "4": "南區", "5": "高屏", "6": "花東" };
        var relation_map = { "0": "配偶", "1": "(外)曾孫子女", "2": "(外)孫子女", "3": "兄弟姊妹", "4": "子女", "5": "父母", "6": "(外)祖父母", "7": "(外)曾祖父母", "8": "寄養家庭扶養人", "9": "寄養家庭被扶養人" };
        
            var _nhi_id = "<%=Session("EncryptQueryID")%>";
            
            var json_obj;
            
            $.ajax({
                type: 'post',
                url: 'Handler.ashx' + '?callback=?',
                async: false,
                data: '_Type=' + 'readdata_u03T_BILL' + '&_nhi_id=' + _nhi_id,
                dataType: 'jsonp',
                success: function (_result) {
                    json_obj = _result;
                    alert(JSON.stringify(json_obj));
                }
            });
            /*json_obj = {
                "main": [
                    { "STATUS_YM": "199601", "BRANCH_ID": "1", "UNIT_ID": "135487568", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "01", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "12H", "ID_TYPE": "2", "INS_AMT": "46000", "INS_STATUS": "1", "SW_BILL": "Y", "BELONG_CITY": "01", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "5", "EAS_NHI_ID": null, "EINS_NHI_ID": "845E2D83920BC03FCEC0AE0A2C32F6C7", "INS_NHI_ID": null },
                    { "STATUS_YM": "200603", "BRANCH_ID": "1", "UNIT_ID": "135487568", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "15", "TX_CODE": "07", "INS_TYPE": "12H", "ID_TYPE": "2", "INS_AMT": "46000", "INS_STATUS": "1", "SW_BILL": "Y", "BELONG_CITY": "01", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "5", "EAS_NHI_ID": null, "EINS_NHI_ID": "845E2D83920BC03FCEC0AE0A2C32F6C7", "INS_NHI_ID": null },
                    { "STATUS_YM": "200603", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "16", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "12H", "ID_TYPE": "2", "INS_AMT": "23000", "INS_STATUS": "1", "SW_BILL": "Y", "BELONG_CITY": "01", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "", "EAS_NHI_ID": null, "EINS_NHI_ID": "4591DD04F9DF3DC1E9EA3F12583B208D", "INS_NHI_ID": null },
                    { "STATUS_YM": "200710", "BRANCH_ID": "1", "UNIT_ID": "651584957", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "01", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "12H", "ID_TYPE": "2", "INS_AMT": "1258", "INS_STATUS": "1", "SW_BILL": "Y", "BELONG_CITY": "01", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "", "EAS_NHI_ID": null, "EINS_NHI_ID": "4591DD04F9DF3DC1E9EA3F12583B208D", "INS_NHI_ID": null },
                    { "STATUS_YM": "200803", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "03", "OUT_TYPE": "", "IN_DAY": "01", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "12H", "ID_TYPE": "2", "INS_AMT": "25000", "INS_STATUS": "1", "SW_BILL": "Y", "BELONG_CITY": "01", "IN_RSN": "C", "OUT_RSN": "", "RELATION": "", "EAS_NHI_ID": null, "EINS_NHI_ID": "4591DD04F9DF3DC1E9EA3F12583B208D", "INS_NHI_ID": null },
                    { "STATUS_YM": "200804", "BRANCH_ID": "1", "UNIT_ID": "651584957", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "01", "TX_CODE": "07", "INS_TYPE": "12H", "ID_TYPE": "2", "INS_AMT": "1258", "INS_STATUS": "3", "SW_BILL": "Y", "BELONG_CITY": "01", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "", "EAS_NHI_ID": null, "EINS_NHI_ID": "4591DD04F9DF3DC1E9EA3F12583B208D", "INS_NHI_ID": null },
                    { "STATUS_YM": "201406", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "01", "TX_CODE": "07", "INS_TYPE": "12H", "ID_TYPE": "2", "INS_AMT": "25000", "INS_STATUS": "3", "SW_BILL": "Y", "BELONG_CITY": "01", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "", "EAS_NHI_ID": null, "EINS_NHI_ID": "4591DD04F9DF3DC1E9EA3F12583B208D", "INS_NHI_ID": null },
                    { "STATUS_YM": "201407", "BRANCH_ID": "1", "UNIT_ID": "458651325", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "17", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "12H", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "1", "SW_BILL": "N", "BELONG_CITY": "01", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "", "EAS_NHI_ID": null, "EINS_NHI_ID": "4591DD04F9DF3DC1E9EA3F12583B208D", "INS_NHI_ID": null },
                    { "STATUS_YM": "201410", "BRANCH_ID": "1", "UNIT_ID": "458651325", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "15", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "12H", "ID_TYPE": "2", "INS_AMT": "35125", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "01", "IN_RSN": "C", "OUT_RSN": "", "RELATION": "", "EAS_NHI_ID": null, "EINS_NHI_ID": "4591DD04F9DF3DC1E9EA3F12583B208D", "INS_NHI_ID": null },
                    { "STATUS_YM": "201507", "BRANCH_ID": "1", "UNIT_ID": "458651325", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "09", "TX_CODE": "07", "INS_TYPE": "12H", "ID_TYPE": "2", "INS_AMT": "35125", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "01", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "", "EAS_NHI_ID": null, "EINS_NHI_ID": "4591DD04F9DF3DC1E9EA3F12583B208D", "INS_NHI_ID": null },
                    { "STATUS_YM": "201608", "BRANCH_ID": "1", "UNIT_ID": "127548887", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "18", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "12H", "ID_TYPE": "2", "INS_AMT": "81000", "INS_STATUS": "1", "SW_BILL": "Y", "BELONG_CITY": "01", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "", "EAS_NHI_ID": null, "EINS_NHI_ID": "4591DD04F9DF3DC1E9EA3F12583B208D", "INS_NHI_ID": null },
                    { "STATUS_YM": "201701", "BRANCH_ID": "1", "UNIT_ID": "131796548", "IN_TYPE": "02", "OUT_TYPE": "07", "IN_DAY": "18", "OUT_DAY": "18", "TX_CODE": "07", "INS_TYPE": "12H", "ID_TYPE": "2", "INS_AMT": "42000", "INS_STATUS": "1", "SW_BILL": "Y", "BELONG_CITY": "01", "IN_RSN": "A", "OUT_RSN": "B", "RELATION": "", "EAS_NHI_ID": null, "EINS_NHI_ID": "4591DD04F9DF3DC1E9EA3F12583B208D", "INS_NHI_ID": null }
                ],
                "family": [
                    { "STATUS_YM": "200603", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "16", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "4", "EAS_NHI_ID": "F86EC4CE4B7F99B028325B690D5E33EB", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "200603", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "16", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "4", "EAS_NHI_ID": "5G1DF32GFG48D6G2SD1F5ZD6FA78F65F", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "200603", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "16", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "4", "EAS_NHI_ID": "D5G486QW1A32S1CXZ23C8SD646Z2V1Z3", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "200603", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "16", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "4", "EAS_NHI_ID": "5F48WQ65132CB0XW0VCXV1D586V5AD15", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "200603", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "16", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "4", "EAS_NHI_ID": "A5SF8WQ9765DS1DC2BGJYU8LK498YK4G", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "200603", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "16", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "4", "EAS_NHI_ID": "DG878TR6A2D10XZV11XB8FGJ8F945SDS", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "200603", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "16", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "4", "EAS_NHI_ID": "5DF48QWR456WG1G32N0BSD1FSA5D15SA", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "200603", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "16", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "4", "EAS_NHI_ID": "8SAF8E8R8E4GF3CX521F3J18IP88G4F8", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "200603", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "16", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "4", "EAS_NHI_ID": "887888EG5FH5F4G65JDF5HS5H4S5G4DS", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "200603", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "16", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "4", "EAS_NHI_ID": "A8S7Q89WR5D1G2FB2VCB0F0BDF348DSF", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201406", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "01", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "4", "EAS_NHI_ID": "F86EC4CE4B7F99B028325B690D5E33EB", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201406", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "01", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "4", "EAS_NHI_ID": "5G1DF32GFG48D6G2SD1F5ZD6FA78F65F", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201406", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "01", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "4", "EAS_NHI_ID": "D5G486QW1A32S1CXZ23C8SD646Z2V1Z3", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201406", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "01", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "4", "EAS_NHI_ID": "5F48WQ65132CB0XW0VCXV1D586V5AD15", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201406", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "01", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "4", "EAS_NHI_ID": "A5SF8WQ9765DS1DC2BGJYU8LK498YK4G", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201406", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "01", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "4", "EAS_NHI_ID": "DG878TR6A2D10XZV11XB8FGJ8F945SDS", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201406", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "01", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "4", "EAS_NHI_ID": "5DF48QWR456WG1G32N0BSD1FSA5D15SA", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201406", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "01", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "4", "EAS_NHI_ID": "8SAF8E8R8E4GF3CX521F3J18IP88G4F8", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201406", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "01", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "4", "EAS_NHI_ID": "887888EG5FH5F4G65JDF5HS5H4S5G4DS", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201406", "BRANCH_ID": "1", "UNIT_ID": "126251634", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "01", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "4", "EAS_NHI_ID": "A8S7Q89WR5D1G2FB2VCB0F0BDF348DSF", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201407", "BRANCH_ID": "1", "UNIT_ID": "458651325", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "17", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "33625", "INS_STATUS": "3", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "4", "EAS_NHI_ID": "F86EC4CE4B7F99B028325B690D5E33EB", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201507", "BRANCH_ID": "1", "UNIT_ID": "458651325", "IN_TYPE": "", "OUT_TYPE": "07", "IN_DAY": "00", "OUT_DAY": "09", "TX_CODE": "07", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "35125", "INS_STATUS": "1", "SW_BILL": "N", "BELONG_CITY": "55", "IN_RSN": "", "OUT_RSN": "B", "RELATION": "4", "EAS_NHI_ID": "F86EC4CE4B7F99B028325B690D5E33EB", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201701", "BRANCH_ID": "1", "UNIT_ID": "131796548", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "18", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "81000", "INS_STATUS": "1", "SW_BILL": "Y", "BELONG_CITY": "55", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "4", "EAS_NHI_ID": "F86EC4CE4B7F99B028325B690D5E33EB", "EINS_NHI_ID": null, "INS_NHI_ID": null },
                    { "STATUS_YM": "201701", "BRANCH_ID": "1", "UNIT_ID": "131796548", "IN_TYPE": "02", "OUT_TYPE": "", "IN_DAY": "18", "OUT_DAY": "00", "TX_CODE": "02", "INS_TYPE": "62", "ID_TYPE": "2", "INS_AMT": "81000", "INS_STATUS": "1", "SW_BILL": "Y", "BELONG_CITY": "55", "IN_RSN": "A", "OUT_RSN": "", "RELATION": "4", "EAS_NHI_ID": "AS5D165ASF78651AS5D48ASF4A6S5D1A", "EINS_NHI_ID": null, "INS_NHI_ID": null }
                ],
                "units": [
                    { "unit_id": "135487568", "startDate": "1996-01-01", "endDate": "2006-03-15", "map_row": [0, 1], "dependents": [], "parent_flag": 1 },
                    { "unit_id": "126251634", "startDate": "2006-03-16", "endDate": "2014-06-01", "map_row": [2, 4, 6], "dependents": [[0, 10], [1, 11], [2, 12], [3, 13], [4, 14], [5, 15], [6, 16], [7, 17], [8, 18], [9, 19]], "parent_flag": 0 },
                    { "unit_id": "651584957", "startDate": "2007-10-01", "endDate": "2008-04-01", "map_row": [3, 5], "dependents": [], "parent_flag": 0 },
                    { "unit_id": "458651325", "startDate": "2014-07-17", "endDate": "2015-07-09", "map_row": [7, 8, 9], "dependents": [[20, 21]], "parent_flag": 0 },
                    { "unit_id": "127548887", "startDate": "2016-08-18", "endDate": "2016-08-18", "map_row": [10], "dependents": [], "parent_flag": 0 },
                    { "unit_id": "131796548", "startDate": "2017-01-18", "endDate": "", "map_row": [11], "dependents": [[22], [23]], "parent_flag": 0 }
                ]
            }*/
            // 從json_obj.units建立用來畫圖的json
            var data = [];
            for (var i in json_obj.units) {
                var data_obj = {};
                var unit = json_obj.units[i];
                var startDate = new Date(unit.START_DATE);
                var endDate = new Date(unit.END_DATE);
                data_obj.start = startDate;
                if (unit.END_DATE === '') { //還在持續加保未結束
                    data_obj.type = 'floatingRange';
                }
                else if (endDate.getTime() - startDate.getTime() > 31 * 24 * 60 * 60 * 1000) { //超過一個月用floatingRange
                    data_obj.end = endDate;
                    data_obj.type = 'floatingRange';
                }
                else data_obj.type = 'box'; //不滿一個月用box
                var data_title = (unit.START_DATE + '~' + unit.END_DATE).replace(/-/g, '/');
                var text_tmp = parseInt(i) + 1;
                data_obj.content = '<div class="timeline-contnet tooltips" title="' + data_title + '" style="width:100%" data-toggle="tooltip" data-placement="top">' + text_tmp + '</div>';
                if (unit.parent_flag) data_obj.className = ' parent-style';

                data.push(data_obj);
            }

            $("#timeline").empty();
            // Timeline options
            var nowDate = new Date();
            //var maxDate = nowDate.setFullYear(nowDate.getFullYear() + 5); //現在往後五年
            var options = {
                'width': '100%',
                'height': '350px',
                'editable': false,   // enable dragging and editing events
                'axisOnTop': false,
                'locale': 'zh',
                'showCurrentTime': false,
                'showNavigation': true,
                //'zoomMin': 47304000000, 
                'max': nowDate,
                'min': new Date("1995-01-01"),
                'selectable': true
            };       
            var timeline = new links.Timeline(document.getElementById('timeline'), options);
            links.events.addListener(timeline, 'select', showBillDetail);
            timeline.draw(data);
            $('.tooltips').tooltip();

            function showBillDetail() {
                var sel = timeline.getSelection();
                if (sel.length) {
                    if (sel[0].row != undefined) {
                        $('#billDetails').empty;
                        var row = sel[0].row; //點擊的那一條
                        var mapRows = json_obj.units[row].MAP_ROW;
                        var dependents = json_obj.units[row].DEPENDENTS;

                        var ins_container = '',
                            as_container = '',
                            dep_container = '';
                        // build ins_container
                        {
                            var obj = json_obj.main[mapRows[0]],
                                unit_id = obj.UNIT_ID,
                                branch_id = obj.BRANCH_ID,
                                belong_city = obj.BELONG_CITY,
                                ins_id = obj.EINS_NHI_ID,
                                relation = (obj.RELATION == '') ? '本人' : obj.RELATION + '-' + relation_map[obj.RELATION],
                                id_type = obj.ID_TYPE;
                            ins_container += '<div class="container"><div class="row insinfo_table">';
                            ins_container += '<div class="col-4"><div class="insInfo">';
                            ins_container += '<span>投保單位代號：' + unit_id + '</span>';
                            ins_container += '</div></div>';
                            ins_container += '<div class="col-4"><div class="insInfo">';
                            ins_container += '<span>分局別：' + branch_id + '-' + branch_id_map[branch_id] + '</span>';
                            ins_container += '</div></div>';
                            ins_container += '<div class="col-4"><div class="insInfo">';
                            ins_container += '<span>所屬縣市代碼：' + belong_city + '</span>';
                            ins_container += '</div></div>';
                            ins_container += '<div class="col-4"><div class="insInfo">';
                            ins_container += '<span>被保險人：' + ins_id + '</span>';
                            ins_container += '</div></div>';
                            ins_container += '<div class="col-4"><div class="insInfo">';
                            ins_container += '<span>關係：' + relation + '</span>';
                            ins_container += '</div></div>';
                            ins_container += '<div class="col-4"><div class="insInfo">';
                            ins_container += '<span>身分別：' + id_type + '-' + id_type_map[id_type];
                            //ins_container += '<button class="btn_info btn-xs" data-toggle="popover" data-trigger="hover" data-placement="right" data-content="' + id_type_map[id_type] + '">';
                            //ins_container += '<i class="fa fa-info"></i></button>';
                            ins_container += '</span>';
                            ins_container += '</div></div>';
                            ins_container += '</div></div>'; //end div.container and div.row
                            $('#tab_all, #tab_self, #tab_dependents').html(ins_container);
                            ins_container = '';
                        }
                        // build as_container
                        {
                            as_container += '<div class="container">';
                            as_container += '<p style="margin-top:30px">保險對象：' + _nhi_id + '</p>';
                            as_container += '<table class="table table-striped">';
                            as_container += '<thead>';
                            as_container += '<tr>';
                            as_container += '<th>異動時間</th>';
                            as_container += '<th>異動類型</th>';
                            as_container += '<th>投保金額</th>';
                            as_container += '<th>是否計費</th>';
                            as_container += '<th>異動原因</th>';
                            as_container += '<th>類目屬性</th>';
                            as_container += '</tr>';
                            as_container += '</thead>';
                            as_container += '<tbody>';
                            for (var i in mapRows) {
                                var obj = json_obj.main[mapRows[i]];
                                var tx_date = obj.STATUS_YM;
                                tx_date += (obj.IN_DAY === '00') ? obj.OUT_DAY : obj.IN_DAY;
                                var tx_type = (obj.IN_TYPE === '') ? obj.OUT_TYPE : obj.IN_TYPE;
                                var tx_rsn = (obj.IN_RSN === '') ? obj.OUT_RSN : obj.IN_RSN;
                                as_container += '<tr>';
                                as_container += '<td>' + tx_date + '</td>';
                                as_container += '<td>' + tx_type + '</td>';
                                as_container += '<td>' + obj.INS_AMT + '</td>';
                                as_container += '<td>' + obj.SW_BILL + '</td>';
                                as_container += '<td>' + tx_rsn + '</td>';
                                as_container += '<td>' + obj.INS_TYPE + '</td>';
                                as_container += '</tr>';
                            }
                            as_container += '</tbody>';
                            as_container += '</table>';
                            as_container += '</div>'; //end div.container
                            $('#tab_all, #tab_self').append(as_container);
                            as_container = '';
                        }
                        // build dep_container
                        {
                            $('#three-tab').text('眷屬(' + dependents.length + ')');
                            for (var i in dependents) { //dependents二維陣列：全部眷屬
                                var depRows = dependents[i]; //depRows一維陣列：一名眷屬
                                var dep_id = json_obj.family[depRows[0]].EAS_NHI_ID;
                                var relation = json_obj.family[depRows[0]].RELATION;
                                dep_container += '<div class="container">';
                                dep_container += '<div class="row">';
                                dep_container += '<div class="col-5">';
                                dep_container += '<p style="margin-top:30px">眷屬：' + dep_id + '</p>';
                                dep_container += '</div>';
                                dep_container += '<div class="col-4">';
                                dep_container += '<p style="margin-top:30px">關係：' + relation + '-' + relation_map[relation] + '</p>';
                                dep_container += '</div>';
                                dep_container += '<div class="w-100"></div>';
                                dep_container += '</div>'; //end div.row
                                dep_container += '<table class="table table-striped">';
                                dep_container += '<thead>';
                                dep_container += '<tr>';
                                dep_container += '<th>異動時間</th>';
                                dep_container += '<th>異動類型</th>';
                                dep_container += '<th>投保金額</th>';
                                dep_container += '<th>是否計費</th>';
                                dep_container += '<th>異動原因</th>';
                                dep_container += '<th>類目屬性</th>';
                                dep_container += '</tr>';
                                dep_container += '</thead>';
                                dep_container += '<tbody>';
                                for (var j in depRows) {
                                    var obj = json_obj.family[depRows[j]];
                                    var tx_date = obj.STATUS_YM;
                                    tx_date += (obj.IN_DAY === '00') ? obj.OUT_DAY : obj.IN_DAY;
                                    var tx_type = (obj.IN_TYPE === '') ? obj.OUT_TYPE : obj.IN_TYPE;
                                    var tx_rsn = (obj.IN_RSN === '') ? obj.OUT_RSN : obj.IN_RSN;
                                    dep_container += '<tr>';
                                    dep_container += '<td>' + tx_date + '</td>';
                                    dep_container += '<td>' + tx_type + '</td>';
                                    dep_container += '<td>' + obj.INS_AMT + '</td>';
                                    dep_container += '<td>' + obj.SW_BILL + '</td>';
                                    dep_container += '<td>' + tx_rsn + '</td>';
                                    dep_container += '<td>' + obj.INS_TYPE + '</td>';
                                    dep_container += '</tr>';
                                }
                                dep_container += '</tbody>';
                                dep_container += '</table>';
                                dep_container += '</div>'; //end div.container
                                console.log(dep_container);
                                $('#tab_all, #tab_dependents').append(dep_container);
                                dep_container = '';
                            }
                        } // end build dep_container
                        $('#billDetails').show();
                        $('[data-toggle="popover"]').popover();
                    }
                }
            } //end function showBillDetail()
        
    })
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyContentPlaceHolder" Runat="Server">
    <div class="content-inner">
             <header class="page-header">
                <div class="container-fluid">
                  <h4 class="no-margin-bottom">保費異動紀錄</h4>
                </div>
              </header>
              <!-- Section Content-->
              <section class="dashboard-content no-padding-bottom" id="PageContent">
                  <div class="container-fluid">
	                <div class="row bg-white has-shadow">         
                       <div class="col-md-12">
 
	                    <div id="timeline" ></div>
                        <div class="col-md-11 hidden" id="billDetails">
                          <div class="card-header tab-card-header">
	                        <ul class="nav nav-tabs card-header-tabs" id="myTab" role="tablist">
	                          <li class="nav-item">
		                        <a class="nav-link" id="one-tab" data-toggle="tab" href="#tab_all" role="tab" aria-controls="One" aria-selected="true">全部</a>
	                          </li>
	                          <li class="nav-item">
		                        <a class="nav-link" id="two-tab" data-toggle="tab" href="#tab_self" role="tab" aria-controls="Two" aria-selected="false">本人</a>
	                          </li>
	                          <li class="nav-item">
		                        <a class="nav-link" id="three-tab" data-toggle="tab" href="#tab_dependents" role="tab" aria-controls="Three" aria-selected="false">眷屬</a>
	                          </li>
	                        </ul>
                          </div>
                          <!--頁籤內容-->
                          <div class="tab-content" id="myTabContent">
	                        <div class="tab-pane fade show active p-3" id="tab_all" role="tabpanel" aria-labelledby="one-tab">
	                        </div>
	                        <div class="tab-pane fade p-3" id="tab_self" role="tabpanel" aria-labelledby="two-tab">
	                        </div>
	                        <div class="tab-pane fade p-3" id="tab_dependents" role="tabpanel" aria-labelledby="three-tab">
	                        </div>
                          </div>
                        </div>
			    
                
			   </div>  
               
			        
		        </div>
	              </div>
              </section>
              
              <!-- Page Footer-->
              <footer class="main-footer">
                <div class="container-fluid">
                  <div class="row">
                    <div class="col-sm-6">
                      <p> &copy; 2018</p>
                    </div>
                    <div class="col-sm-6 text-right">
                      
                    </div>
                  </div>
                </div>
              </footer>
            </div>
</asp:Content>
