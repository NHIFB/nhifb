<%@ Page Title="我的資料" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="U02T_ASBAS.aspx.vb" Inherits="firstpage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="css/profilecard.css" rel="stylesheet">
<script>
    $(function () {
        var _nhi_id = "<%=Session("EncryptQueryID")%>";
        if (_nhi_id === '') {
            document.location.href = 'Default.aspx';
            return;
        }
        var json_obj = [];
        $.ajax({
            type: 'post',
            url: 'Handler.ashx' + '?callback=?',
            async: false,
            data: '_Type=read_u02T_ASBAS',
            dataType: 'jsonp',
            success: function (_result) {
                json_obj = _result;
                alert(JSON.stringify(json_obj));
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert('Ajax error!');
                alert(textStatus);
            }
        }); //end ajax
        if (json_obj !== undefined) {
            if (json_obj.ASBAS.length > 0) {
                var name = json_obj.NAME;
                $('#asbas_name').text(name);
                var asbas = json_obj.ASBAS[0];
                var sex_tmp = (asbas.SEX === 'M') ? '男' : '女';
                $('#asbas_sex').text(sex_tmp);
                var birthday_tmp = asbas.BIRTHDAY.slice(0, 4) + '/' + asbas.BIRTHDAY.slice(4, 6) + '/' + asbas.BIRTHDAY.slice(6, 8);
                $('#asbas_birthday').text(birthday_tmp);
                $('#asbas_tel').text(asbas.TEL);
                $('#asbas_mobile').text(asbas.MOBIL_PHONE);
                $('#asbas_zipCode').text(asbas.ZIP_CODE);
                if (asbas.SW_ADDR === 'Y') {
                    $('#validAddr').prop('checked', true);
                    $('#invalidAddr').prop('checked', false);
                }
                else {
                    $('#validAddr').prop('checked', false);
                    $('#invalidAddr').prop('checked', true);
                }
                $('#asbas_addr').text(asbas.ADDR1 + asbas.ADDR2 + asbas.ADDR3 + asbas.ADDR4 + asbas.ADDR5);
            }
            else alert('ASBAS為空！');
        }
        else {
            alert('json_obj undefined！');
        }
    })
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyContentPlaceHolder" Runat="Server">
    <div class="content-inner">
              <!-- Page Header-->
              <header class="page-header">
                <div class="container-fluid">
                  <h4 class="no-margin-bottom">基本資料</h4>
                </div>
              </header>
              <!-- Section Content-->
              <section class="dashboard-content no-padding-bottom" >
                  <div class="container-fluid">
	                     <div class="row ml-1 bg-white has-shadow">
                             <div class="prog-page">
		                        <div class="header-title header-btn">
		                            <div class="header-info">
		                                <h2><i class="fa fa-info-circle"></i>Profile Information</h2>
		                            </div>
		                            <div class="header-btn-edit">
		                                <a href="#" type="button"><i class="fa fa-edit"></i>Edit Profile</a>
		                            </div>
		                        </div>
		
		                        <div class="prof-page-info">
		                            <div class="row">		
		                                <div class="col-md-3">
		                                    <div class="prof-img">
		                                        <img src="img/pic.jpg"></img>
		                                        <div class="img-title">
		                                            <h2 id="H1"></h2>
		                                        </div>
		                                    </div>
		                                </div>
		                                <div class="col-md-9">
		                                    <div class="prof-info">
		                                        <div class="info-no"><span>基本資訊</span></div>
                                                <div class="row">
                                                    <div class="col-md-5">
                                                        <div class="info"><span><i class="fa fa-user"></i> 性別：<span id="asbas_sex"></span></span></div>
                                                    </div>
                                                    <div class="col-md-5">
                                                        <div class="info"><span><i class="fa fa-calendar"></i> 生日：<span id="asbas_birthday"></span></span></div>
                                                    </div>
                                                    <div class="w-100"></div>
                                                    <div class="col-md-5">
                                                        <div class="info"><span><i class="fa fa-phone"></i> 電話：<span id="asbas_tel"></span></span></div>
                                                    </div>
                                                    <div class="col-md-5">
                                                        <div class="info"><span><i class="fa fa-phone"></i> 行動電話：<span id="asbas_mobile"></span></span></div>
                                                    </div>
                                                    <div class="w-100"></div>
                                                    <div class="col-md-12">
                                                        <div class="info-no">
                                                            <span>通訊地址</span>
                                                        </div>
                                                    </div>
                                                    <div class="w-100"></div>
                                                    <div class="col-md-5">
                                                        <div class="info"><span><i class="fa fa-envelope"></i>郵遞區號：<span id="asbas_zipCode"></span></span></div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="info"><span><i class="fa fa-info-circle"></i>是否為有效地址? </span>
                               
                                                        <label class="checkbox-inline">
                                                        <input type="checkbox" id="validAddr" value="是" disabled="disabled"> 是
                                                        </label>
                                                        <label class="checkbox-inline">
                                   
                                                        <input type="checkbox" id="invalidAddr"  value="否" disabled="disabled" > 否
                                                        </label></div>
                               
                                                    </div>
                                                    <!--<div class="col-md-4">
                                                        <div class="info"><span><i class="fa fa-male"></i> 修改人員:u14002b	</span></div>
                                                    </div>-->
                                                    <div class="w-100"></div>
                                                    <div class="col-md-10">
                                                        <div class="info"><span><i class="fa fa-map-pin fa-2"></i>通訊地址：<span id="asbas_addr"></span></span></div>
                                                    </div>
                                                    <!--<div class="col-md-6">
                                                        <div class="info"><span><i class="fa fa-male"></i> 處理日期:20041118 </span></div>
                                                    </div>-->
                                                    <div class="w-100"></div>

                                                    <!--<div class="col-md-4">
                                                        <div class="info"><span><i class="fa fa-map-marker"></i>是否轉分局</span>

                                                    </div>
                                                    <div class="w-100"></div>
                                                    </div>-->
         
                                                    <!--<div class="form-check">
                                                        <input type="checkbox" class="form-check-input" id="SW_BRANCH" disabled>
                                                        <span class="form-check-label" for="SW_BRANCH">是</span>
                                                    </div>
     
                                                    <div class="form-check">
                                                        <input type="checkbox" class="form-check-input" id="SW_BRANCH_1" checked="checked2" disabled>
                                                        <span class="form-check-label" for="SW_BRANCH">否</span>
                                                    </div>-->
                                                </div>
		                                    </div>	             
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
