
$(document).ready(function(){

  // Move the page to a particular div 
  var loc=$(window.location)[0].hash.replace("#","")
  if (loc){
    scrollToElement('.'+loc);
  }
  // Activate bootstrap elements
  $('#myModal').modal();
  if(open=="1")
    $('#userModal').modal();
  $('.typeahead').typeahead();
  $('.carousel').carousel({
     interval: 3000
  })
  

  $('.ttip').tooltip('show',{ placement: 'top'})
  
  // Csrf verification
  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': jQuery("meta[name='csrf-token']").attr('content')
    }
  });

  // Share
  $("#ShareTweet").click(function(e) {
      e.preventDefault()
      var self = this
      var turl = "https://twitter.com/intent/tweet?text=Team up for good @cfcodesprint&url=http://contributingcode.cloudfoundry.com&related=cloudfoundry"
      var width  = 575,
        height = 400,
        left   = ($(window).width()  - width)  / 2,
        top    = ($(window).height() - height) / 2,
        url    = this.href,
        opts   = 'status=1' +
                 ',width='  + width  +
                 ',height=' + height +
                 ',top='    + top    +
                 ',left='   + left

      window.open(turl, 'twitterpop', opts)
      return false;
    })

    $("#ShareFacebook").click(function(e) {
      e.preventDefault()
      var self = this
      var fburl = "http://www.facebook.com/sharer.php?u=" + "contributingcode.cloudfoundry.com"
      var width  = 575,
        height = 400,
        left   = ($(window).width()  - width)  / 2,
        top    = ($(window).height() - height) / 2,
        url    = this.href,
        opts   = 'status=1' +
                 ',width='  + width  +
                 ',height=' + height +
                 ',top='    + top    +
                 ',left='   + left

      window.open(fburl, 'facebookpop', opts)
      return false;
    })

  // User profile init
  if(typeof(tee) != "undefined"){
  if(tee)
    $('#tee_'+tee)[0].checked = true;
  else 
     $('#tee_M')[0].checked = true;
  if(gender)
    $('#gender_'+gender)[0].checked = true;
  else 
    $('#gender_M')[0].checked = true;
  if(transport)
    $('#transport_'+transport)[0].checked = true;
  else 
    $('#transport_2')[0].checked = true;
}
  // My team js hide and show
  $(".team_btn").click(function(){
    event.preventDefault();
    var choice = $(this).attr('id')
    $(".general").addClass("hide")
    if(choice=="b2")
       $("#a2").removeClass("hide")
    else
      $("#a3").removeClass("hide")
  })

  $("#b1").click(function(){
    event.preventDefault();
    $.ajax({
        url     : "/api_members"
      , success : function (response) {
          if(response.err){
            window.location = "/"
          }else{
            $("#a1").removeClass("hide")
            $("#a1").html(response.data)
          }
        }
      });
    return false
  })



  // Join  a team
  $(".selectTeam").click(function(e){
    e.preventDefault();
    var $this = $(this)
    bootbox.confirm("Are you sure ?", function(result) {
      if (!result) {
        return false
      }
      $.ajax({
        url     : $this.attr("href")
      , success : function (response) {

        $this.parent().parent().remove()
        $("#join_message").html(response.data)
        $('#joinModal').modal('toggle')

        }
      });
    });
    return false
  })

  // User delclines team request 
   $(".acceptTeamReq").click(function(e){
    e.preventDefault();
    var $this = $(this)
      $.ajax({
        url     : $this.attr("href")
      , success : function (response) {
          window.location = "/"
        }
      });
    return false
  })

  // User declines team request 
  $(".declineTeamReq").click(function(e){
    e.preventDefault();
    var $this = $(this)
      $.ajax({
        url     : $this.attr("href")
      , success : function (response) {
          $this.parent().parent().remove()
        }
      });
    return false
  })

  // Owner adds members via type ahead 
  $("#add2_form").submit(function(e){
      e.preventDefault();
      if($("#add2_form").find(".error").length > 0 )
          return false
      var $form = $(this)
     // Run Ajax
      $.ajax({
          url     : $form.attr("action")
        , data    : $form.serializeArray()
        , type    : "POST"
        , success : function ( response ) {
            if (response.err) {
              $('#add2_form').find(".help-block").html(response.data)
               $('#add2_form').find('.control-group').addClass("error")
            } else {
              $('#add2_form').find(".help-block").html(response.data)
            }
          }
      })
      return false
    });

  // Owner adds a user to team  request
  $(".addReq").click(function(e){
    e.preventDefault();
    var $this = $(this)
      $.ajax({
        url     : $this.attr("href")
      , success : function (response) {
          $this.parent().parent().next().html(response.data)
          $this.parent().html("")
        }
      });
    return false
  })


  // Decide join request
  $(".owner_decides").click(function(e){
    e.preventDefault();
    var $this = $(this)
      $.ajax({
        url     : $this.attr("href")
      , success : function (response) {
        if(response.err){
          window.location = "/"
        }
        else{
          $this.parent().parent().remove()
        }
        }
      });
    return false
  })

  // On close after owner decides join request page refresh
  $('#pendingJoinReqModal').on('hide', function () {
    window.location = "/"
  })

  // Leave team
  $(".leaveTeam").click(function(e){
    e.preventDefault();
    var self = $(this)
    bootbox.confirm("Are you sure you want to leave the team ?", function(result) {
      if (!result) {
        return false
      }
      $.ajax({
        url     : self.attr("href")
      , data    : {}
      , type    : "get"
      , success : function (response) {
          window.location = "/"
        }
      });
     return false
    });
  })




  // Delete team
  $("#delete_team").click(function(e){
    e.preventDefault();
    bootbox.confirm("Are you sure you want to delete the team ?", function(result) {
      if (!result) {
        return false
      }
      $.ajax({
        url     : $("#delete_team").attr("href")
      , data    : {}
      , type    : "DELETE"
      , success : function (response) {
          window.location = "/"
        }
      });
     return false
    });
  })



  // Create team form
  $("#team_form").submit(function(e){
      e.preventDefault();
      if($("#team_form").find(".error").length > 0 )
          return false
      var infile = document.getElementById('image')
      var inform = document.getElementById('team_form')
      var formData = new FormData(inform)
      formData.append('image', infile.files[0])
      var xhr = new XMLHttpRequest()
      xhr.open($("#team_form").attr('method'), $("#team_form").attr('action'), true)
      xhr.setRequestHeader('X-CSRF-Token' , $("meta[name='csrf-token']").attr('content'))
        xhr.onreadystatechange = function (e) {
          if (xhr.readyState === 4) {
            if (xhr.status === 200) {
              var response = JSON.parse(xhr.responseText)
            if(response.err){
              $('#team_form').find(".help-block").last().html(response.data)
              $('.backend').last().addClass("error")
            }
            else{
              window.location = "/"
            }
          }
        }
      }
        // XHR
        xhr.send(formData)

    return false;
  });


  // Remove member
  $(".removeMember").click(function(e){
    e.preventDefault();
    var $this = $(this)
    bootbox.confirm("Are you sure you want to delete the team member ?", function(result) {
      if (!result) {
        return false
      }
      $.ajax({
          url: $this.attr('href'),
          type: "DELETE",
          data: {},
          success: function(response) {
                window.location = "/"
          }
      });
    });
  return false;
  });

  // faq 
  $(".q1").click(function(e){
    e.preventDefault();
    var $this = $(this)
    if ($this.html()=='-'){
     $this.next().addClass('hide')
     $this.html('+')
    }else{
      $this.next().removeClass('hide')
      $this.html('-')
    }
  })

  // For page scrolling
  function scrollToElement(selector, callback){
    var animation = {scrollTop: $(selector).offset().top};
    $('html,body').animate(animation, 'slow', 'swing', function() {
        if (typeof callback == 'function') {
            callback();
        }
        callback = null;
    });
  }

  // On hover animation
  $(function() {
      $(".nav_hover")
          .mouseover(function() {
             if ($(this).hasClass('clicked1')) {
              return false
          }else{
              var newName = $(this).attr("alt_src");
              var src = $(this).attr("src").replace($(this).attr("src"), newName);
              $(this).attr("src", src);
            }
          })
          .mouseout(function() {
            if ($(this).hasClass('clicked1')) {
              return false
            }else {
              var src = $(this).attr("src").replace("_hover", "");
              $(this).attr("src", src);
            }
          });
  });

  //On click animation
  $(function() {
      $(".nav_hover")
          .click(function() {
            var self = $(this)
            var els = $(".nav_hover")
            $.each(els, function (index, el) {
              $(el).removeClass("clicked1")
              var src = $(el).attr("src").replace("_hover", "");
              $(el).attr("src", src);
            })
          var newName = self.attr("alt_src");
          var src = self.attr("src").replace($(this).attr("src"), newName);
          self.attr("src", src);
          self.addClass("clicked1");
          })
  });

  $(".h").click(function(){
    scrollToElement('.home');
  })

  $(".b").click(function(){
    scrollToElement('.bootcamp');
  })


  $(".p").click(function(){
    scrollToElement('.prizes');
  })

  $(".v").click(function(){
    scrollToElement('.venue');
  })


  $(".s").click(function(){
    scrollToElement('.schedule');
  })

  $(".r").click(function(){
    scrollToElement('.rules');
  })


  $(".m").click(function(){
    scrollToElement('.myteam');
  })



});