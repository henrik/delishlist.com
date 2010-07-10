// Based on http://www.hedgerwow.com/360/dhtml/dom-get-natural-width.html
function getNaturalSize(dImg) {
  var naturalWidth = -1, naturalHeight = -1;
  if (dImg.naturalWidth != null) {
    naturalWidth = dImg.naturalWidth;
    naturalHeight = dImg.naturalHeight;
  } else if (dImg.runtimeStyle) {
    dImg.runtimeStyle.width = 'auto';
    dImg.runtimeStyle.height = 'auto';
    dImg.runtimeStyle.borderWidth = '0';
    dImg.runtimeStyle.padding = '0';

    naturalWidth  = dImg.offsetWidth;
    naturalHeight = dImg.offsetHeight;

    dImg.runtimeStyle.width = '';
    dImg.runtimeStyle.height = '';
    dImg.runtimeStyle.borderWidth = '';
    dImg.runtimeStyle.padding = '';
  } else {
    var dImgBk = dImg.cloneNode(true);
    dImg.className = '';
    dImg.style.width = 'auto !important';
    dImg.style.height = 'auto !important';
    dImg.style.borderWidth = '0 !important';
    dImg.style.padding = '0 !important';
    dImg.removeAttribute('width');
    dImg.removeAttribute('height');

    naturalWidth =  dImg.width;
    naturalHeight =  dImg.height;

    dImg.setAttribute('width' , dImgBk.getAttribute('width') );
    dImg.setAttribute('height', dImgBk.getAttribute('height') );
    dImg.style.width = dImgBk.style.width;
    dImg.style.height = dImgBk.style.height;
    dImg.style.padding = dImgBk.style.padding;
    dImg.style.borderWidth =  dImgBk.style.borderWidth;
    dImg.style.className = dImgBk.style.className;
  };

  return {width: naturalWidth, height: naturalHeight};
}
