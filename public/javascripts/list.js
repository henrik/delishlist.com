List = (function() {
  return {
    init: function() {
      initFancyDrilldowns();
      mendAnchors();
      relativizeNoteDates();
      editInFacebox();
      setImageInFacebox();      
      List.setupImages('.thumbnail img');
    },
    
    setupImages: function(selector) {
      var $images = $(selector);
      thumbsInFacebox($images);
      removeBrokenThumbnails($images);
      removeTinyThumbnails($images);
    }
    
  };
  
  function thumbsInFacebox($images) {
    $images.css({cursor: '-moz-zoom-in' }).hover(function() {
      if (stickyFaceboxIsOpen()) return;
      $.facebox.closeImmediately();
      $.facebox('<img src="'+this.src+'" alt="" />', 'imagebox hoverbox');
    }, function() {
      if (stickyFaceboxIsOpen()) return;
      $.facebox.close();
    }).click(function() {
      $.facebox('<a href="'+this.src+'" target="_blank"><img src="'+this.src+'" alt=""></a>', 'imagebox');
    });
    
    function stickyFaceboxIsOpen() { return $("#facebox:not(.hoverbox):visible").length };
  }
  
  function removeBrokenThumbnails($images) {
    $images.error(function() { $(this).remove() });
  }
  
  // E.g. Amazon will return tiny blank images on failure.
  function removeTinyThumbnails($images) {
    $images.load(function() {
      var size = getNaturalSize(this);
      if (size.width < 10 || size.height < 10) {
        $(this).remove();
      }
    });
  }
  
  function setImageInFacebox() {
   $('.actions .image').facebox();
  }
  
  function editInFacebox() {
    $('.actions .edit').facebox(null, {
      reveal_callback: function() {
        $('#facebox iframe').load(function() {
          if (this.delishlist_hasLoaded) {
            // Not first load event = navigated in iframe = probably edited or deleted. Expire cache!
            $.post('/expire_cache', { user: Delishlist.user });
          }
          this.delishlist_hasLoaded = true;
        });
      },
      caption: "The ”Delete” link is in the top right. Focus a text field (not ”Notes”) and press Enter/Return to submit an edit."
    });
  }
  
  // TODO: Leap days?
  function relativizeNoteDates() {

    var note = $('#note');
    if (!note.length) return;

    var months = "January February March April May June July August September October November December".split(' ');
    var shorts = $.map(months, function(m) { return m.substring(0,3) });
    months = months.concat(shorts).concat(["Sept"]);
    var months_re = '(?:'+months.join('|')+ ')';
    var re = new RegExp('(\\b\\d{1,2}\\s+'+months_re+'\\b|\\b'+months_re+'\\s+\\d{1,2}\\b)', 'ig');

    // DEBUG
    // note.html("July 20, July 19, 21 Jul, Jul 25, Jul 26, Jul 27, Jul 28 and Aug 3, Aug 20.");

    var now = new Date(), today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    note.html(note.html().replace(re, function(_, date) {
      var distance, target_date = new Date(date + " " + today.getFullYear());
      if (target_date < today)
        target_date.setFullYear(target_date.getFullYear() + 1);
      distance = distanceOfTimeInWords(today, target_date);
      return date + " ("+distance+")";
    }));

  }
  
  function distanceOfTimeInWords(from, unto) {
    var days = Math.ceil((unto-from)/1000/24/60/60);
    if (days == 0)
      return '<strong class="today">today!</strong>';
    else if (days == 1)
      return '<strong class="tomorrow">tomorrow!</strong>';
    else if (days <= 14)
      return "in <strong>" + days + " day" + (days==1 ? "" : "s") + "</strong>";
    else if (days <= 7*3+3)
      return "in "+Math.round(days/7.0)+" weeks";
    else if (days <= 31*11+5) {
      var months = Math.round(days/31.0);
      return "in " +months+ " month" + (months==1 ? "" : "s");
    } else
      return "in a year";
  }


  function mendAnchors() {
    var m = location.hash.match(/(__[a-z0-9]{6})$/);
    if (m && !$(location.hash).length) {
      var a = $("dt[id$="+m[1]+"]");
      location.hash = '#' + (a.length ? a.eq(0).attr('id') : 'no-such-item');
    }
  }
  

  function initFancyDrilldowns() {
    $(".drilldown").css({position: 'absolute'}).
      parent().mouseover(showDrilldown).mouseout(hideDrilldown);
  }
  
  function showDrilldown() {
    clearTimeout(this.timer);
    var tag = $(this).children(':first');
    var offset = tag.offset();
    var x = offset.left;
    var y = tag.height() + offset.top;
    $(".drilldown").hide();
    $(this).children('.drilldown').show().css({left: x+'px', top: y+'px'});
  }

  function hideDrilldown() {
    var dd = $(this).children('.drilldown');
    this.timer = setTimeout(function() { dd.hide() }, 300);
  }
  
})();


$(List.init);
