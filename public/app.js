$(function(){

  var pulse = Pulsar.createClient();
  var chan = pulse.channel('main');

  var content = document.getElementById('content');
  var ctx = content.getContext('2d');

  var content2 = document.getElementById('content2');
  var ctx2 = content2.getContext('2d');

  chan.on('frame', function(frame){
    var img = new Image();
    img.onload = function(){
      ctx.drawImage(img,0,0);
    }
    img.src = 'data:image/png;base64,' + frame;
  });

  chan.on('frame2', function(frame){
    var img = new Image();
    img.onload = function(){
      ctx2.drawImage(img,0,0);
    }
    img.src = 'data:image/png;base64,' + frame;
  });

});