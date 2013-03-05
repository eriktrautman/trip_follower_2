TF.TripShow = (function(){

  var feedItems = [];
  var feedItemDivs = [];

  var getItems = function(callback){
    // Do some AJAXing to get the feed items
    var items = ["thing1", "thing2", "thing3", "thing4", "thing5"];
    if(callback){
      callback(items);
    }
  }

  // Used to initially create the divs that contain feed items
  var cfg = {
    winX: $(window).width(),
    winY: $(window).height(),
    navHeight: 50,
    scroll: {
      toMid: 500,
      midRest: 500,
      inc: 1250
    }
  }

  var size = {
    // future
    a: {
      width: 80,
      height: 40,
      opacity: .3
    },
    // featured
    b: {
      width: cfg.winX,
      height: cfg.winY,
      opacity: 1
    },
    // archive
    c: {
      width: 80,
      height: 40,
      opacity: .3
    }
  }

  var pos = {
    // future
    a: {
      top: cfg.winY - size.a.height*2,
      left: cfg.winX - size.a.width*2
    },
    // featured
    b: {
      top: cfg.winY/2 - size.b.height/2,
      left: cfg.winX/2 - size.b.width/2,
      bot: cfg.winY/2 - size.b.height/2,
    },
    // archive
    c: {
      top: size.c.height,
      left: cfg.winX - size.c.width*2,
      bot: cfg.winY - size.c.height*2 - cfg.navHeight,
    }
  }

  // place the item in the document.  Item is now 1 to N
  var placeItem = function(parent, item, num, x, y, h, w){
    var a = cfg.scroll.inc * num;
    var b = a + cfg.scroll.toMid;
    var c = b + cfg.scroll.midRest;
    var d = c + cfg.scroll.toMid;
    console.log("A: " + a + " B: " + b + " C: " + c + " D: " + d)
    var div = $("<div></div>")
        .addClass("feed_item")
        .attr("data-item-id", num)
        .attr("data-item-future", a)
        .attr("data-item-featured", b)
        .attr("data-item-rest", c)
        .attr("data-item-archive", d)
        .css("height", h)
        .css("width", w)
        .css("top", y - h/2)
        .css("left", x - w/2)
    parent.append(div);
    feedItemDivs.push(div);
  }

  var moveToFuture = function(item){
    item.animate({
      top: pos.a.top,
      left: pos.a.left,
      width: size.a.width,
      height: size.a.height,
      opacity: size.a.opacity
    })
  }

  // Increment the position of the div item
  var inc = function(element){
    var scroll = $(window).scrollTop();
    var pct;

    fut = element.attr("data-item-future");
    arc = element.attr("data-item-archive");
    feat = element.attr("data-item-featured");
    rst = element.attr("data-item-rest");


    if(scroll < fut){
      console.log("Before future position")
      move(element, 1, pos.a, pos.a, size.a, size.a, true)
      return;

    } else if(scroll <= feat){
      console.log("future>>featured");
      pct = (scroll - fut) / (feat - fut);
      move(element, pct, pos.a, pos.b, size.a, size.b, true);
      return;

    }else if(scroll <= rst){
      console.log("featured resting");
      pct = (scroll - feat) / (rst - feat);
      console.log(pct);
      move(element, 1, pos.b, pos.b, size.b, size.b, true)
      return;

    }else {
      console.log("featured>>archive and beyond");
      pct = Math.min(1, (scroll - rst) / (arc - rst));
      console.log(pct);
      move(element, pct, pos.b, pos.c, size.b, size.c, false);
      return;
    }
  }

  var move = function(element, pct, prev, next, sPrev, sNext, fwd){
    if(fwd){ //If we're moving down the page
      var mvMod = Math.pow(pct, 2);
      var szMod = Math.pow(pct, 3);
    }else{
      var mvMod = Math.pow(pct, .5);
      var szMod = Math.pow(pct, 1/3); // needs to decrease from bottom left corner!
    }

    if(fwd){
      element
          .css("bottom", "")

      element.stop().animate({
          top: mvMod*(next.top - prev.top) + prev.top,
          left: mvMod*(next.left - prev.left) + prev.left,
          width: szMod*(sNext.width - sPrev.width) + sPrev.width,
          height: szMod*(sNext.height - sPrev.height) + sPrev.height,
          opacity: szMod*(sNext.opacity - sPrev.opacity) + sPrev.opacity
      }, 100);
    }else{
      element
          .css("top","")

      element.stop().animate({
          bottom: mvMod*(next.bot - prev.bot) + prev.bot,
          left: mvMod*(next.left - prev.left) + prev.left,
          width: szMod*(sNext.width - sPrev.width) + sPrev.width,
          height: szMod*(sNext.height - sPrev.height) + sPrev.height,
          opacity: szMod*(sNext.opacity - sPrev.opacity) + sPrev.opacity
      }, 100);
    }
  }

  // Returns the coordinates of the window center
  var windowCenter = function(){
    return {
      x: $(window).width()/2,
      y: $(window).height()/2
    }
  }

  var initializer = function(parent){
    $("div#info").html(
        "<br>Window Height: " + $(window).height() +
        "<br>Window Width: " + $(window).width() +
        "<br>Document Height: " + $(document).height() +
        "<br>Document Width: " + $(document).width() +
        "<br>Screen Height: " + screen.height +
        "<br>Screen Width: " + screen.width
      );

    getItems(function(items){
      feedItems = items;
    });

    console.log(feedItems);

    feedItems.forEach(function(item, i){
      placeItem(parent, item, i, cfg.winX/2, cfg.winY/2, cfg.h, cfg.w);
    });

    feedItemDivs.forEach(function(item){
      moveToFuture(item);
    })

    $('div.navbar-inner').click(function(){
      moveToPrev(feedItemDivs[0]);
    });

    $('h1').click(function(){
      moveToNext(feedItemDivs[1]);
    });
    $(window).scroll(function(e){
      console.log("scrolling..............");
      target = $(e.target);
      $('div.feed_item').text(target.scrollTop())
      feedItemDivs.forEach(function(item){
        inc(item);
      });
    });

  }


  return {
    initializer: initializer,
    cfg: cfg
  }
})()