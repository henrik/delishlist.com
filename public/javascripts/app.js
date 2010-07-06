List = (function() {
  return {
    init: function() {
      initFancyDrilldowns();
      mendAnchors();
    }
  };

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
