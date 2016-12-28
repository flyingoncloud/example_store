<script>
function random(min_random, max_random) {

  var range = max_random - min_random + 1;
  return Math.floor(Math.random()*range) + min_random;

}

function parseIntPlus( st ) {
// "-4" -> -4, "+5" -> 5
  var str = st;
  if ( str.charAt( 0 ) == "+" ) { str = str.substr(1); }
  if ( str.charAt( 0 ) == "−" ) { str = "-" + str.substr(1); }
  var value = parseInt( str );
  return( value );
}

function StringPlus( x, Flag ) {
// -4 -> "-4", 5 -> "+5"
  var flag = ( Flag !== undefined ) ? Flag : false;
  var value = String( x );
  if ( x >= 0 && !flag ) { value = "+" + value; }
  return value;
}

var a = random(-9,0),
  b = random(0,9);

function formulaCodeGeneric( a, b ) {

  var valueInt = b*b*b-a*a*a;
  var formulaCode = " \\int_{ \\cssId{a}{\\class{dynamic}{" + StringPlus( a, true )
    + "}}}^{ \\cssId{b}{\\class{dynamic}{" + StringPlus( b, true )
    + "}}} x^2 dx = " + String( valueInt ) + " ";
  formulaCode = a
  return formulaCode;

}

function formulaLatex( array, length ) {
  var i = 0;
  var output = "\\begin{align}"
  while (i < length) {
    if (array[i] != undefined) {
      output = output + " & " + array[i] + " \\\\"
    } else {
      output = output + " & \\\\"
    }
    i = i + 1
  }
  output = output + " \\end{align}"

  return output

}



$( function() {
	var n = 1;
  var array = [];

  //
  //  Make the current step be visible, and increment the step.
  //  If it is the last step, disable the step button.
  //  Once a step is taken, the reset button is made available.
  //
  window.ShowStep = function () {
    document.getElementById("Step"+n).style.visibility = "visible"; n++;
    if (!document.getElementById("Step"+n)) {document.getElementById("step").disabled = true}
    document.getElementById("reset").disabled = false;
  }

  //
  //  Enable the step button and disable the reset button.
  //  Hide the steps.
  //
  window.ResetSteps = function () {
    document.getElementById("step").disabled = false;
    document.getElementById("reset").disabled = true;
    var i = 1, step; n = 1;
    while (step = document.getElementById("Step"+i)) {step.style.visibility = "hidden"; i++}
  }

  MathJax.Hub.Queue( function () { addEvents();  } );


  function addEvents() {

    var elems = document.getElementsByClassName("steps"), newInput;

    for (var i=0; i<elems.length; i++) {
    	var el = elems[i];
    	el.addEventListener('mouseover', function() {
    			this.style.cursor = 'pointer';
    			this.style.backgroundColor = "#F6CEF5";
    		}, false);
    	el.addEventListener('mouseout', function() {
    			this.style.cursor = 'auto';
    			this.style.backgroundColor = "#FFFFFF";
    		}, false);
    }


    for (var i=0; i<elems.length; i++) {
        var el = elems[i];

        $( el ).on( "click", function() {
          var index = ("" + this.id).substr(4,5)
          array[index - 1] = formulaCodeGeneric( index, index )

          //pass the data to UI dialog. it will be returned back for calculating the formula
          dialog.data("myArray", array).data("rowIndex", index).data("totalRows", 5).dialog( "open" );
        });
    	};

    }

    var dialog, form,

      // From http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#e-mail-state-%28type=email%29
      emailRegex = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/,
      name = $( "#name" ),
      email = $( "#email" ),
      password = $( "#password" ),
      kpSelection = $("#kpSelection").find(":selected").text(),
      allFields = $( [] ).add(kpSelection), //add( name ).add( email ).add( password ),
      tips = $( ".validateTips" );

    function updateTips( t ) {
      tips
        .text( t )
        .addClass( "ui-state-highlight" );
      setTimeout(function() {
        tips.removeClass( "ui-state-highlight", 1500 );
      }, 500 );
    }

    function checkLength( o, n, min, max ) {
      if ( o.val().length > max || o.val().length < min ) {
        o.addClass( "ui-state-error" );
        updateTips( "Length of " + n + " must be between " +
          min + " and " + max + "." );
        return false;
      } else {
        return true;
      }
    }

    function checkRegexp( o, regexp, n ) {
      if ( !( regexp.test( o.val() ) ) ) {
        o.addClass( "ui-state-error" );
        updateTips( n );
        return false;
      } else {
        return true;
      }
    }

    function addUser() {
      var valid = true;
      allFields.removeClass( "ui-state-error" );

      //pass back data
      var data = $(this).data("myArray");
      var rowIndex = $(this).data("rowIndex")
      var totalRows = $(this).data("totalRows")

      if ( valid ) {
        var kp = $("#kpSelection").find(":selected").val()

        data[rowIndex-1] = kp;

        $("#myTarget h1").append("<p>" + formulaLatex(data, totalRows) + "</p>" );

        //how to replace the content of "#myDiv"?
        $("#myDiv").html(formulaLatex(data, totalRows));
        MathJax.Hub.Queue(["Typeset",MathJax.Hub,document.getElementById("myDiv")], function () {

         });

        dialog.dialog( "close" );
      }


      return valid;
    }

    dialog = $( "#dialog-form" ).dialog({
      autoOpen: false,
      height: 400,
      width: 350,
      modal: true,
      buttons: {
        "Choose": addUser,
        Cancel: function() {
          dialog.dialog( "close" );
        }
      },
      close: function() {
        // form[ 0 ].reset();
        allFields.removeClass( "ui-state-error" );
      }
    });

    form = dialog.find( "form" ).on( "submit", function( event ) {
      event.preventDefault();
      addUser();
    });

    $( "#create-user" ).button().on( "click", function() {
      dialog.dialog( "open" );
    });

    $('#kpSelection').on("change", function(){
      var value = $("#kpSelection option:selected" ).val();
      alert("selected: " + value)
      // alert("changed value:" + value)
      // if (value == "") return;
      //
      // $.ajax({
      //     type:'GET',
      //     dataType:"json",
      //     url:'/knowledge_points/'+ value + '/all_children' ,
      //
      //     success:function(data){
      //       //I assume you want to do something on controller action execution success?
      //       // alert("data:" + JSON.stringify(data))
      //       populate_second_KP_form(data)
      //     }
      //   });
    });

  } );
</script>
