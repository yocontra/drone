$(function(){

  var pulse = Pulsar.createClient();
  var chan = pulse.channel('main');

  var content = document.getElementById('content');
  var ctx = content.getContext('2d');

  chan.on('frame', function(frame){
    var img = new Image();
    img.onload = function(){
      ctx.drawImage(img,0,0);
    };
    img.src = frame;
  });

});