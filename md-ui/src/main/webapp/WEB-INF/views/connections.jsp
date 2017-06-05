<%@ taglib prefix="security"
       uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
     pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>
    <title><spring:message code="common.page.title_bdre_2"/></title>
    <style>
        					div.jtable-main-container>table.jtable>tbody>tr.jtable-data-row>td:nth-child(2){
        						color: #F75C17;
        						font-size: 24px;
        						font-weight: 500;
        					}
        					div.jtable-main-container>table.jtable>tbody>tr.jtable-data-row>td img {
        						width: 15px;
        						height: 15px;
        					}


        					.glyphicon-arrow-right {
        						color: #606161 !important;
        					}
        					.btn-primary {
        						background-color: #ADAFAF !important;
        						border: 1px solid #828283 !important;
        						padding-top: 7.5px !important;
        						padding-bottom: 7.5px !important;
        						border-radius: 1px !important;
        					}

        					.input-box-button-filter {
        						background: #4A4B4B;
        						background: -webkit-linear-gradient(#4A4B4B 50%, #3A3B3B 50%);
        						background: -o-linear-gradient(#4A4B4B 50%, #3A3B3B 50%);
        						background: -moz-linear-gradient(#4A4B4B 50%, #3A3B3B 50%);
        						background: -ms-linear-gradient(#4A4B4B 50%, #3A3B3B 50%);
        						background: linear-gradient(#4A4B4B 50%, #3A3B3B 50%);
        						position: absolute;
        						top: 0;
        						right: 134px;
        						color: white;
        						padding: 5px;
        						cursor: pointer
        					}

        					.filter-icon {
        						background-image: url('../css/images/filter_icon.png');
        						background-size: 100%;
        						background-repeat: no-repeat;
        						display: inline-block;
        						margin: 2px;
        						vertical-align: middle;
        						width: 16px;
        						height: 16px;
        					}

        					.filter-text {
        						display: inline-block;
        						margin: 2px;
        						vertical-align: middle;
        						font-size: 0.9em;
        						font-family: 'Segoe UI Semilight', 'Open Sans', Verdana, Arial,
        							Helvetica, sans-serif;
        						font-weight: 300;
        					}



        					.subprocess-arrow-down {
        						-ms-transform: rotate(90deg); /* IE 9 */
        						-webkit-transform: rotate(90deg); /* Chrome, Safari, Opera */
        						transform: rotate(90deg);
        					}
ul{
  display:flex;
  list-style:none;
  }

  .btn-primary1 {
      background-color: #23C9A4 !important;
      color: #404040 !important;
      padding: 0.25em 3.05em !important;
      border-radius: 4px !important;
      border-color: transparent;
      font-size: 18px;
  }

 #buttondiv li + li{
      margin-left:20px;
  }

}





    </style>
	<script>
	  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
	  //Please replace with your own analytics id
	  ga('create', 'UA-72345517-1', 'auto');
	  ga('send', 'pageview');
	</script>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script src="../js/jquery.min.js"></script>
    <link href="../css/jquery-ui-1.10.3.custom.css" rel="stylesheet">
    <link href="../css/css/bootstrap.min.css" rel="stylesheet" />
    <script src="../js/jquery-ui-1.10.3.custom.js"></script>
    <script src="../js/jquery.steps.min.js"></script>

    <link rel="stylesheet" href="../css/jquery.steps.css" />

    <script src="../js/bootstrap.js" type="text/javascript"></script>
    <script src="../js/jquery.jtable.js" type="text/javascript"></script>
    <link href="../css/jtables-bdre.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../css/jquery.steps.custom.css" />
    <link href="../css/bootstrap.custom.css" rel="stylesheet" type="text/css" />
	<script src="../js/angular.min.js" type="text/javascript"></script>



   <script type="text/javascript">

    var map = new Object();
    var selectedSourceType = '';
    var selectedEmitterType = '';
    var selectedPersistentStoreType = '';
    var createJobResult;
    var getGenConfigMap = function(cfgGrp){
        var map = new Object();
        $.ajax({
            type: "GET",
            url: "/mdrest/genconfig/"+cfgGrp+"/?required=2",
            dataType: 'json',
            async: false,
            success: function(data) {

                var root = 'Records';
                $.each(data[root], function(i, v) {
                    map[v.key] = v;
                });

            },
            error : function(data){
                console.log(data);
            }

        });
    return map;

    };

</script>
<script>
function source()
      {
       console.log("function call is happening ");
       document.getElementById('source-tab').style.display='block';
       document.getElementById('emitter-tab').style.display='none';
       document.getElementById('persistent-stores-tab').style.display='none';
       document.getElementById('saved-connections').style.display='none';
      }

      function emitter()
            {
             console.log("function call is happening ");
             document.getElementById('source-tab').style.display='none';
             document.getElementById('emitter-tab').style.display='block';
             document.getElementById('persistent-stores-tab').style.display='none';
             document.getElementById('saved-connections').style.display='none';
            }


       function persistance()
          {
           console.log("function call is happening ");
           document.getElementById('source-tab').style.display='none';
           document.getElementById('emitter-tab').style.display='none';
           document.getElementById('persistent-stores-tab').style.display='block';
           document.getElementById('saved-connections').style.display='none';
          }

        function saved()
            {
             console.log("function call is happening ");
             document.getElementById('source-tab').style.display='none';
             document.getElementById('emitter-tab').style.display='none';
             document.getElementById('persistent-stores-tab').style.display='none';
             document.getElementById('saved-connections').style.display='block';
            }
</script>
</head>
<body ng-app="myApp" ng-controller="myCtrl">

   <div id="tabs" style="background:transparent" width="1000px">
     <ul id="buttondiv">
       <li><button type="button" class=" btn-primary1" onclick="source()">Source Configuration</button></li>
       <li><button type="button" class=" btn-primary1" onclick="emitter()">Emitter Configuration</button></li>
       <li><button type="button"  class=" btn-primary1" onclick="persistance()">PersistentStore Configuration</button></li>
       <li><button type="button" class=" btn-primary1" onclick="saved()">Saved Configuration</button></li>
     </ul>
     <div id="source-tab">

            <form class="form-horizontal" role="form" id="sourceConnectionForm">

                    <div id="sourceConnectionFields" class="form-group">
                        <label class="control-label col-sm-3">Source Configuration Type</label>
                        <div id="dropdownSource" class="btn-group" >
                            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="false" aria-expanded="true" id="srcDropdown">
                                <span>Select Source</span><span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu" aria-labelledby="srcDropdown">
                                <li>
                                    <a href="#"></a>
                                </li>
                            </ul>
                         </div>
                      </div>



                    <div class="form-group">
                        <label class="control-label col-sm-3">Source Connection Name</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" name="sourceConnectionName">
                        </div>
                    </div>


                    <div class="clearfix"></div>

          </form>

      </div>


      <div id="emitter-tab" style="display:none;">
             <section >
             <form class="form-horizontal" role="form" id="emitterConnectionForm">
                 <div id="emitterConnectionDetails">
                     <!-- btn-group -->
                     <div id="emitterConnectionFields">
                     <div class="form-group">
                         <label class="control-label col-sm-3">Emitter Configuration Type</label>
                         <div id="dropdownEmitter">
                         <div class="btn-group" >
                             <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="false" aria-expanded="true" id="emitterDropdown">
                                 <span>Select Emitter</span><span class="caret"></span>
                             </button>
                             <ul class="dropdown-menu" aria-labelledby="emitterDropdown">
                                 <li>
                                     <a href="#"></a>
                                 </li>
                             </ul>
                          </div>
                        </div>
                     </div>


                     <div class="form-group">
                         <label class="control-label col-sm-3">Emitter Configuration Name</label>
                         <div class="col-sm-9">
                             <input type="text" class="form-control" name="emitterConnectionName">
                         </div>
                     </div>


                     <div class="clearfix"></div>

                 </div>
                     <!-- /btn-group -->
             </div>
         </form>
         </section>
        </div>


         <div id="persistent-stores-tab" style="display:none;">
               <section >
               <form class="form-horizontal" role="form" id="persistentStoresConnectionForm">
                   <div id="persistentStoresConnectionDetails">
                       <!-- btn-group -->
                       <div id="persistentStoresConnectionFields">
                       <div class="form-group">
                           <label class="control-label col-sm-3">PersistentStore Configuration Type</label>
                           <div id="dropdownPersistentStores">
                           <div class="btn-group" >
                               <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="false" aria-expanded="true" id="persistentStoresDropdown">
                                   <span>Select PersistentStore</span><span class="caret"></span>
                               </button>
                               <ul class="dropdown-menu" aria-labelledby="persistentStoresDropdown">
                                   <li>
                                       <a href="#"></a>
                                   </li>
                               </ul>
                            </div>
                          </div>
                       </div>


                       <div class="form-group">
                           <label class="control-label col-sm-3">PersistentStore Configuration Name</label>
                           <div class="col-sm-9">
                               <input type="text" class="form-control" name="persistentStoresConnectionName">
                           </div>
                       </div>


                       <div class="clearfix"></div>

                   </div>
                       <!-- /btn-group -->
               </div>
           </form>
           </section>
         </div>

      <div id="saved-connections" style="display:none;">
        <section style="width:100%;text-align:center;">
        <div id="Container"></div>
        </section>
       </div>

    </div>



     <script>

     $( function() {
       $( "#tabs" ).tabs();
     });


     function createConnectionFunction(connectionType){
                                     console.log("inside create connection function")
                                     formIntoMap(connectionType+'_', connectionType+'ConnectionForm');
                                     if(connectionType=="source"){
                                         map['type_source'] = selectedSourceType;
                                     }
                                     if(connectionType=="emitter"){
                                         map['type_emitter'] = selectedEmitterType;
                                     }
                                     if(connectionType=="persistentStores"){
                                         map['type_persistentStores'] = selectedPersistentStoreType;
                                     }
                                     $.ajax({
                                         type: "POST",
                                         url: "/mdrest/connections/createconnection",
                                         data: jQuery.param(map),
                                         success: function(data) {
                                             if(data.Result == "OK") {
                                                 created = 1;
                                                 $("#div-dialog-warning").dialog({
                                                     title: "",
                                                     resizable: false,
                                                     height: 'auto',
                                                     modal: true,
                                                     buttons: {
                                                         "Ok": function() {
                                                             $('#Container').jtable('load');
                                                             $(this).dialog("close");
                                                         }
                                                     }
                                                 }).html('<p><span class=\"jtable-confirm-message\">Connection saved</span></p>');

                                             }

                                         }

                                     });
                                 }
     </script>

	<script>
            $('#dropdownSource').on('show.bs.dropdown', function() {
            		$.ajax({
            			type: "GET",
            			url: "/mdrest/genconfig/Source_Connection_Type/?required=2",
            			dataType: 'json',
            			success: function(data) {
            				var root = 'Records';
            				var ul = $('#srcDropdown').parent().find($("ul"));
            				$(ul).empty();
            				$.each(data[root], function(i, v) {
            					$(ul).append('<li><a href="#">' + v.value + '</a></li>');
            					var li = $(ul).children()[i];
            					$(li).data(v);
            				});
            			},
            		});

            	});

                $('#dropdownEmitter').on('show.bs.dropdown', function() {
                        $.ajax({
                            type: "GET",
                            url: "/mdrest/genconfig/Emitter_Connection_Type/?required=2",
                            dataType: 'json',
                            success: function(data) {
                                var root = 'Records';
                                var ul = $('#emitterDropdown').parent().find($("ul"));
                                $(ul).empty();
                                $.each(data[root], function(i, v) {
                                    $(ul).append('<li><a href="#">' + v.value + '</a></li>');
                                    var li = $(ul).children()[i];
                                    $(li).data(v);
                                });
                            },
                        });

                    });

                    $('#dropdownPersistentStores').on('show.bs.dropdown', function() {
                            $.ajax({
                                type: "GET",
                                url: "/mdrest/genconfig/PersistentStores_Connection_Type/?required=2",
                                dataType: 'json',
                                success: function(data) {
                                    var root = 'Records';
                                    var ul = $('#persistentStoresDropdown').parent().find($("ul"));
                                    $(ul).empty();
                                    $.each(data[root], function(i, v) {
                                        $(ul).append('<li><a href="#">' + v.value + '</a></li>');
                                        var li = $(ul).children()[i];
                                        $(li).data(v);
                                    });
                                },
                            });

                        });

          	$('#dropdownSource').on('click', 'a', function() {

          		var car = $(this).parent();
          		console.log($(car));
          		var cardata = $(car).data();
          		console.log($(cardata));
          		$('#srcDropdown').html(cardata.value + '<span class="caret"></span>');

          		selectedSourceType = cardata.key;
          		buildForm(selectedSourceType + "_Source_Connection", 'sourceConnectionForm');
          		console.log(selectedSourceType);
          	});

            $('#dropdownEmitter').on('click', 'a', function() {

                var car = $(this).parent();
                console.log($(car));
                var cardata = $(car).data();
                console.log($(cardata));
                $('#emitterDropdown').html(cardata.value + '<span class="caret"></span>');

                selectedEmitterType = cardata.key;
                buildForm(selectedEmitterType + "_Emitter_Connection", 'emitterConnectionForm');
                console.log(selectedEmitterType);
            });

            $('#dropdownPersistentStores').on('click', 'a', function() {

                var car = $(this).parent();
                console.log($(car));
                var cardata = $(car).data();
                console.log($(cardata));
                $('#persistentStoresDropdown').html(cardata.value + '<span class="caret"></span>');

                selectedPersistentStoreType = cardata.key;
                buildForm(selectedPersistentStoreType + "_PersistentStores_Connection", 'persistentStoresConnectionForm');
                console.log(selectedPersistentStoreType);
            });



    	    $('#Container').jtable({
    	    title: 'Connections List',
    		    paging: true,
    		    pageSize: 10,
    		    sorting: true,
    		    actions: {
    		    listAction: function (postData, jtParams) {
    		    console.log(postData);
    			    return $.Deferred(function ($dfd) {
    			    $.ajax({
    			    url: '/mdrest/connections?page=' + jtParams.jtStartIndex + '&size='+jtParams.jtPageSize,
    				    type: 'GET',
    				    data: postData,
    				    dataType: 'json',
    				    success: function (data) {
    				    $dfd.resolve(data);
    				    },
    				    error: function () {
    				    $dfd.reject();
    				    }
    			    });
    			    });
    			    }
    		    },
    		    fields: {

			 	Properties: {
					width: '1%',
					sorting: false,
					edit: false,
					create: false,
					title: 'Properties',
					listClass: 'bdre-jtable-button',
					display: function(item) {
                    var $img = $('<img class="subprocess-arrow" src="../css/images/subprocess-rarrow.png" title=<spring:message code="process.page.img_sub_process_info"/> />');//Open child table when user clicks the image
						$img.click(function() {
							$('.subprocess-arrow').removeClass('subprocess-arrow-down');
							$(this).addClass('subprocess-arrow-down');

                            $('#Container').jtable('openChildTable',
                                $img.closest('tr'), {
                                    title: 'Properties_of'+' ' + item.record.connectionName,
                                    paging: true,
                                    pageSize: 10,
                                    actions: {
                                        listAction: function(postData,jtParams) {
                                            return $.Deferred(function($dfd) {
                                                console.log(item);
                                                $.ajax({
                                                    url: '/mdrest/connections/' + item.record.connectionName+'?page=' + jtParams.jtStartIndex + '&size='+jtParams.jtPageSize,
                                                    type: 'GET',
                                                    data: item,
                                                    dataType: 'json',
                                                    success: function(data) {
                                                       if(data.Result == "OK") {

                                                           $dfd.resolve(data);

                                                       }
                                                       else
                                                       {
                                                        $dfd.resolve(data);
                                                       }
                                                   },
                                                    error: function() {
                                                        $dfd.reject();
                                                    }
                                                }); ;
                                            });
                                        }
                                    },
                                    fields: {

                                        propKey: {
                                            key: true,
                                            list: true,
                                            create: true,
                                            edit: true,
                                            title: 'Property Key',
                                            defaultValue: item.record.propKey,
                                        },
                                        propValue: {
                                                key: true,
                                                list: true,
                                                create: true,
                                                edit: true,
                                                title: 'Property Value',
                                                defaultValue: item.record.propValue,
                                            }

                                    }
                                },
                                function(data) { //opened handler

                                    data.childTable.jtable('load');
                                });
                        }); //Return image to show on the person row

                        return $img;
                    }
                },
                connectionName: {
                    width: '5%',
                    key : true,
                    list: true,
                    create:false,
                    edit: true,
                    title: 'Connection Name'
                },
                connectionType: {
                    width: '5%',
                      key : true,
                      list: true,
                      create:false,
                      edit: true,
                      title: 'Connection Type'
                  }
    		    }
    	    });
    		    $('#Container').jtable('load');

    </script>

    <script>
        function formIntoMap(typeProp, typeOf) {
            var x = '';
            x = document.getElementById(typeOf);
            console.log(x);
            var text = "";
            var i;
            for(i = 0; i < x.length; i++) {

                if(x.elements[i].name.endsWith("ConnectionName")){
                    map["connectionName"] = x.elements[i].value;
                }
                else{
                    map[typeProp + x.elements[i].name] = x.elements[i].value;
                    console.log(map[typeProp + x.elements[i].name]);
                    console.log(x.elements[i].value);
                    }
            }

        }

   </script>

    <script>
        function buildForm(typeOf, typeDiv) {
            console.log('inside the build form function');
            var connectionType = typeDiv.replace("ConnectionForm", "");
            $.ajax({
                type: "GET",
                url: "/mdrest/genconfig/" + typeOf + "/?required=1",
                dataType: 'json',
                success: function(data) {
                    var root = 'Records';
                    var div = document.getElementById(typeDiv);

                    console.log(data[root]);
                    $('.buildForm').hide();

                    $.each(data[root], function(i, v) {
                         var inputHTML = '';
                         inputHTML = inputHTML + '<div class="form-group buildForm">';
                            inputHTML = inputHTML +  '<label class="control-label col-sm-3 for="' + v.key + '">' + v.value + '</label>';
                            inputHTML = inputHTML + '<div class="col-sm-9"> <input name="' + v.key + '" value="' + v.defaultVal + '" placeholder="' + v.description + '" type="' + v.type + '" class="form-control" id="' + v.key + '"></div>';
                            inputHTML = inputHTML + '</div>';
                           $('#'+typeDiv).append(inputHTML);
                      });

                      buttonHTML = '';
                      buttonHTML = buttonHTML + '<div class="actions text-center pull-right buildForm">';
                      buttonHTML = buttonHTML + '<button onclick="createConnectionFunction(\''+connectionType+ '\');" type="button" id="createConnectionButton" class="btn btn-primary">Create Connection</button> </div>';
                     $('#'+typeDiv).append(buttonHTML);
                    console.log(div);
                }
            });
            return true;
        }

         </script>





<div id="div-dialog-warning"/>
</body>

</html>

