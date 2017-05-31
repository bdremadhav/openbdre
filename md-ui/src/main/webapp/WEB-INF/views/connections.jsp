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

</head>
<body ng-app="myApp" ng-controller="myCtrl">

   <div id="tabs" style="background:transparent ">
     <ul>
       <li><a href="#source-tab">Source Connection</a></li>
       <li><a href="#emitter-tab">Emitter Connection</a></li>
       <li><a href="#persistent-stores-tab">PersistentStore Connection</a></li>
       <li><a href="#saved-connections">Saved Connections</a></li>
     </ul>
     <div id="source-tab">

            <form class="form-horizontal" role="form" id="sourceConnectionForm">

                    <div id="sourceConnectionFields" class="form-group">
                        <label class="control-label col-sm-3">Source Connection Type</label>
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


      <div id="emitter-tab">
             <section >
             <form class="form-horizontal" role="form" id="emitterConnectionForm">
                 <div id="emitterConnectionDetails">
                     <!-- btn-group -->
                     <div id="emitterConnectionFields">
                     <div class="form-group">
                         <label class="control-label col-sm-3">Emitter Connection Type</label>
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
                         <label class="control-label col-sm-3">Emitter Connection Name</label>
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


         <div id="persistent-stores-tab">
               <section >
               <form class="form-horizontal" role="form" id="persistentStoresConnectionForm">
                   <div id="persistentStoresConnectionDetails">
                       <!-- btn-group -->
                       <div id="persistentStoresConnectionFields">
                       <div class="form-group">
                           <label class="control-label col-sm-3">PersistentStore Connection Type</label>
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
                           <label class="control-label col-sm-3">PersistentStore Connection Name</label>
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

      <div id="saved-connections">
            <section >
            <form class="form-horizontal" role="form" id="sourceConnection">
                <div id="sourceConnectionDetails">
                    <!-- btn-group -->
                    <div id="sourceConnectionFields">
                    <div class="form-group">
                        <label class="control-label col-sm-3">Source Connection Type</label>
                        <div id="dropdownSource">
                        <div class="btn-group" >
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
                    </div>


                    <div class="form-group">
                        <label class="control-label col-sm-3">Source Connection Name</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" name="sourceConnectionName">
                        </div>
                    </div>


                    <div class="clearfix"></div>

                </div>
                    <!-- /btn-group -->
            </div>
        </form>
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
        $(document).ready(function() {

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


        });

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

