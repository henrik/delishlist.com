SetImage = (function() {
  return {
    
    init: function() {
      $('#preview').length ? SetImage.initSelecting() : SetImage.initSelected();
    },

    initSelecting: function() {
      scrape(window.Delishlist.url, 'found_on_site');
      scrape(window.Delishlist.title, 'giigle');
      makeImagesPreviewable();
      $('#previously .images img').load(showSizeAndRemoveTiny);
    },
    
    initSelected: function() {
      if (window.top == window) return;
      $top = window.top.jQuery;
      var $thumb = $top("#"+Delishlist.id+"_thumb");
      $thumb.html(Delishlist.url ? '<img src="'+Delishlist.url+'" alt="">' : '');
      window.top.List.setupImages($thumb.find('img'));
      $top.facebox.close();
    }

  };
    
  function makeImagesPreviewable() {
    $(".suggestions .images a").live('click', function() {
      $('#url').val(this.href);
      $("#preview .container").html('<img src="'+this.href+'" alt="">');
      return false;
    });
  }
  
  function scrape(url, id) {
    if (!url) return;
    $.getJSON("/scrape_images?url="+encodeURIComponent(url), function(urls) {
      if (urls.length) {
        var images = $.map(urls, function(u) {
          return '<a href="'+u+'"><img src="'+u+'" alt="" title="Use this image"></a>';
        });
        $("#"+id+" .images").html(images.join(" ")).
          find("img").load(showSizeAndRemoveTiny).error(function() {
            $(this).parent().remove();
          });
      } else {
        $("#"+id).slideUp(1000);          
      }
    });
  }
  
  function showSizeAndRemoveTiny() {
    var size = getNaturalSize(this);
    if (size.width < 10 || size.height < 10) {
      $(this).parent().remove();
    } else {
      this.title += " ("+size.width+"x"+size.height+" px)";
    }
  }
  
})();


$(SetImage.init);
