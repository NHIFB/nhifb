<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
     <link href="css/custom.css" rel="stylesheet"/>
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyContentPlaceHolder" Runat="Server">
    <div class="content-inner">
              <!-- Page Header-->
              <header class="page-header">
                <div class="container-fluid">
                  <h4 class="no-margin-bottom">首頁</h4>
                </div>
              </header>
              <!-- Section Content-->
              <section class="dashboard-content no-padding-bottom " >
                  <div class="container-fluid ">
                        <div class="post-module"> 
                            <!-- Thumbnail-->
                            <div class="thumbnail">
                              <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/169963/photo-1429043794791-eb8f26f44081.jpeg" class="img-responsive" alt=""> </div>
                            <!-- Post Content-->
                            <div class="post-content">
                              <h1 class="title">歡迎</h1>
                              <h2 class="sub_title">湯姆漢克你好!</h2>
                              <p class="description">點擊左側按鈕可查詢保費計算等資訊!</p>
                              <div class="post-meta"><span class="timestamp"><i class="fa fa-globe-asia"></i> 更多諮詢請洽https://www.nhi.gov.tw/</span></div>
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

