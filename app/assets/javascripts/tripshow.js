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
    h: 300,
    w: 500,
    sH: 100,
    sW: 200,
    pXOff: 200,
    pYOff: 100,
    scroll: {
      toOnDeck: 500,
      toMid: 500,
      midRest: 1000,
      inc: 2000
    }
  }

  var size = {
    // future
    a: {
      width: 80,
      height: 40,
      opacity: .3
    },
    // next
    b: {
      width: 200,
      height: 100,
      opacity: .3
    },
    // featured
    c: {
      width: cfg.winX,
      height: cfg.winY,
      opacity: 1
    },
    // prev
    d: {
      width: 200,
      height: 100,
      opacity: .3
    },
    // archive
    e: {
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
    // next
    b: {
      top: cfg.winY - size.b.height*2,
      left: cfg.winX - size.b.width*2
    },
    // featured
    c: {
      top: cfg.winY/2 - size.c.height/2,
      left: cfg.winX/2 - size.c.width/2
    },
    // prev
    d: {
      top: size.b.height,
      left: cfg.winX - size.b.width*2
    },
    // archive
    e: {
      top: size.a.height,
      left: cfg.winX - size.a.width*2
    }
  }

  // place the item in the document.  Item is now 1 to N
  var placeItem = function(parent, item, num, x, y, h, w){
    var a = cfg.scroll.inc * num;
    var b = a + cfg.scroll.toOnDeck;
    var c = b + cfg.scroll.toMid;
    var d = c + cfg.scroll.midRest;
    var e = d + cfg.scroll.toMid;
    var f = e + cfg.scroll.toOnDeck;
    console.log("A: " + a + " B: " + b + " C: " + c + " D: " + d + " E: " + e)
    var div = $("<div></div>")
        .addClass("feed_item")
        .attr("data-item-id", num)
        .attr("data-item-future", a)
        .attr("data-item-next", b)
        .attr("data-item-featured", c)
        .attr("data-item-rest", d)
        .attr("data-item-prev", e)
        .attr("data-item-archive", f)
        .css("height", h)
        .css("width", w)
        .css("top", y - h/2)
        .css("left", x - w/2)
    parent.append(div);
    feedItemDivs.push(div);
  }

  // moves the JQuery item to new center coordinates
  var moveItem = function(item, x, y){
    item.attr();
  }

  var moveToPrev = function(item){
    item
        .css("top", cfg.pYOff)
        .css("left", cfg.winX - cfg.pXOff - cfg.w/2)
        .css("width", cfg.sW)
        .css("height", cfg.sH)
        .css("opacity", .3)
  }

  var moveToFuture = function(item){
    // item.
    //     .css("top", cfg.winY - cfg.pYOff - cfg.sH)
    //     .css("left", cfg.winX - cfg.pXOff - cfg.w/2)
    //     .css("width", cfg.sW)
    //     .css("height", cfg.sH)
    //     .css("opacity", .3)
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

    // If the scroll is outside the scroll availability window, snap to start
    // or finish position
    a = element.attr("data-item-future");
    if(scroll < a){
      console.log("Before future position")
      move(element, 1, pos.a, pos.a, size.a, size.a)
      return;
    }

    f = element.attr("data-item-archive");
    if(scroll > f){
      move(element, 1, pos.e, pos.e, size.e, size.e);
      return;
    }

    //
    b = element.attr("data-item-next");
    c = element.attr("data-item-featured");
    d = element.attr("data-item-rest");
    e = element.attr("data-item-prev");


    if(scroll >= a && scroll <= b){
      console.log("future>>next");
      pct = (scroll - a) / (b - a);
      console.log("pct: " + pct);
      move(element, pct, pos.a, pos.b, size.a, size.b);
      return;

    }else if(scroll > b && scroll <= c){
      console.log("next>>featured");
      pct = (scroll - b) / (c - b);
      move(element, pct, pos.b, pos.c, size.b, size.c);
      return;

    }else if(scroll > c && scroll <= d){
      console.log("REST");
      pct = 1;
      move(element, pct, pos.c, pos.c, size.c, size.c);
      return;

    }else if(scroll > d && scroll < e){
      console.log("featured>>prev");
      pct = (scroll - d) / (e - d);
      console.log(pct)
      move(element, pct, pos.c, pos.d, size.c, size.d);
      return;

    }else if(scroll > e && scroll <= f){
      console.log("prev>>hist");
      pct = (scroll - e) / (f - e);
      console.log(pct)
      move(element, pct, pos.d, pos.e, size.d, size.e);
      return;
    }else {
      console.log("UNHANDLED CASE!!! FOR ELEMENT:");
      console.log(element);
    }
  }

  var move = function(element, pct, prev, next, sPrev, sNext){
    var mod = Math.sqrt(pct);
    // element
    //     .css("top", mod*(next.top - prev.top) + prev.top)
    //     .css("left", mod*(next.left - prev.left) + prev.left)
    //     .css("width", mod*(sNext.width - sPrev.width) + sPrev.width)
    //     .css("height", mod*(sNext.height - sPrev.height) + sPrev.height)
    //     .css("opacity", mod*(sNext.opacity - sPrev.opacity) + sPrev.opacity)
    element.stop().animate({
        top: mod*(next.top - prev.top) + prev.top,
        left: mod*(next.left - prev.left) + prev.left,
        width: mod*(sNext.width - sPrev.width) + sPrev.width,
        height: mod*(sNext.height - sPrev.height) + sPrev.height,
        opacity: mod*(sNext.opacity - sPrev.opacity) + sPrev.opacity
    }, 20);
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