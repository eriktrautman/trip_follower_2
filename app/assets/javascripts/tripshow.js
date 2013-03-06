TF.TripShow = (function(){

  var feedItems = [];
  var feedItemDivs = [];
  var navSeeds = [];
  var headInfoHeight;
  var helpTextTop;

  var getItems = function(callback){
    // Do some AJAXing to get the feed items
    var items = [ "thing1", "thing2", "thing3", "thing4", "thing5",
                  "thing6", "thingN", "thingN", "thingN", "thingN",
                  "thingN", "thingN", "thingN", "thingN", "thingN"];
    if(callback){
      callback(items);
    }
  }

  // *** Configuration Data ***************************************
  var cfg = {
    winX: $(window).width(),
    winY: $(window).height(),
    navHeight: 40,
    scroll: {
      toMid: 500,
      midRest: 500,
      inc: 1000
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
      height: cfg.winY - cfg.navHeight,
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
      top: cfg.navHeight,
      left: cfg.winX/2 - size.b.width/2,
      bot: 0,
    },
    // archive
    c: {
      top: size.c.height,
      left: cfg.winX - size.c.width*2,
      bot: cfg.winY - size.c.height*2 - cfg.navHeight,
    }
  }

  var nav = {
    rad: 8,
    height: 300,
    right: 100,
    numSeeds: 10,
    mult: 2 // size multiplier for active seeds
  }


  // *** Build Items ***************************************
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

  var placeNav = function(parent){
    var navSeed;
    var inc = nav.height / nav.numSeeds;
    var startTop = cfg.winY/2 - nav.height/2 + cfg.navHeight;

    for(var i=0; i<nav.numSeeds; i++){

      navSeed = $("<div></div>")
          .addClass("circle")
          .addClass("nav-seed")
          .attr("data-nav-pct", i / nav.numSeeds)
          .attr("data-nav-i", i);

      resizeNavSeed(navSeed);
      navSeeds.push(navSeed);
      parent.append(navSeed);
    }
  }

  var placeHelpText = function(parent){
    var div = $("<div>Scroll Down to View</div>")
        .attr("id","help-text")
        .css("top", cfg.winY + 100)
        .css("left", cfg.winX/2 - 300)
        .css("width", 600)

    parent.append(div);
    // div.show("slide",{direction: "up"});
    div.animate({
      top: cfg.winY - 100
    }, 2000);

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

  // *** Increment Items ***************************************
  // Increment the position of the feed item div
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

    } else if(scroll <= rst){
      console.log("featured resting");
      pct = (scroll - feat) / (rst - feat);
      console.log(pct);
      move(element, 1, pos.b, pos.b, size.b, size.b, true)
      return;

    } else {
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
      var szMod = Math.pow(pct, 1/4); // needs to decrease from bottom left corner!
    }

    if(true){
      element
          .css("bottom", "")

      element.stop().animate({
          width: szMod*(sNext.width - sPrev.width) + sPrev.width,
          height: szMod*(sNext.height - sPrev.height) + sPrev.height,
          opacity: szMod*(sNext.opacity - sPrev.opacity) + sPrev.opacity,
          top: mvMod*(next.top - prev.top) + prev.top,
          left: mvMod*(next.left - prev.left) + prev.left
      }, 100);
    }else{
      element
          .css("top","")

      element.stop().animate({
          width: szMod*(sNext.width - sPrev.width) + sPrev.width,
          height: szMod*(sNext.height - sPrev.height) + sPrev.height,
          opacity: szMod*(sNext.opacity - sPrev.opacity) + sPrev.opacity,
          bottom: mvMod*(next.bot - prev.bot) + prev.bot,
          left: mvMod*(next.left - prev.left) + prev.left
      }, 100);
    }
  }

  var resizeNavSeed = function(seed){
    var scroll = $(window).scrollTop();
    var pct = scroll / cfg.docY;

    var inc = nav.height / nav.numSeeds;
    var seedPct = seed.attr("data-nav-pct");
    var i = seed.attr("data-nav-i");
    var proximity = Math.max(0, (.2 - Math.abs(pct - seedPct))/.2); // 0-1
    var factor = proximity * nav.mult;
    var rad = nav.rad* (factor + 1);
    var startTop = cfg.winY/2 - nav.height/2 + cfg.navHeight;
    var color = "rgb("+ Math.round(255*proximity) +
                  "," + Math.round(255*proximity) +
                  "," + Math.round(255) + ")";

    seed
        .css("width", rad)
        .css("height", rad)
        .css("border-radius", rad/2)
        .css("top", startTop - rad + inc * i)
        .css("right", nav.right - rad/2)
        .css("background-color", color)
  }

  var headerShift = function(element){
    var scroll = $(window).scrollTop();
    var colorVal = Math.max(255 - scroll/2, 64);
    var color = "rgb(" + colorVal + ", " + colorVal + ", " + colorVal + ")";

    element.css("color", color);
  }

  var headInfoShift = function(element){
    var scroll = $(window).scrollTop();
    var colorVal = Math.max(200 - scroll/2, 64);
    var color = "rgb(" + colorVal + ", " + colorVal + ", " + colorVal + ")";
    var height = headInfoHeight - scroll/2;

    element
        .css("color", color);
    if(scroll > 200){
      element.slideUp();
    }else{
      element.slideDown();
    }
  }

  var helpTextShift = function(element){
    var scroll = $(window).scrollTop();
    var opacity = 1-scroll/200;
    if(opacity < 0){
      element.css("opacity",0);
      return;
    }

    element.animate({
        top: cfg.winY - 100 - scroll,
        opacity: opacity
      }, 50)
  }


  var scrollFunctions = function(e){

    target = $(e.target);

    $('div.feed_item').text(target.scrollTop());

    feedItemDivs.forEach(function(item){
      inc(item);
    });

    navSeeds.forEach(function(seed){
      resizeNavSeed(seed);
    });

    headerShift($("h1.head"));
    headInfoShift($("div#info"));
    helpTextShift($("#help-text"))

  }




  // *** Initialize Page ***************************************
  var initializer = function(parent){

    getItems(function(items){
      feedItems = items;
    });

    $(body).height(cfg.scroll.inc * feedItems.length + cfg.scroll.toMid + cfg.navHeight);

    $("div#info").html(
        "<br>Window Height: " + $(window).height() +
        "<br>Window Width: " + $(window).width() +
        "<br>Document Height: " + $(document).height() +
        "<br>Document Width: " + $(document).width() +
        "<br>Screen Height: " + screen.height +
        "<br>Screen Width: " + screen.width
      );
    cfg.docX = $(document).width();
    cfg.docY = $(document).height();
    headInfoHeight = $("#info").height();

    console.log(feedItems);

    feedItems.forEach(function(item, i){
      placeItem(parent, item, i, cfg.winX/2, cfg.winY/2, cfg.h, cfg.w);
    });

    feedItemDivs.forEach(function(item){
      moveToFuture(item);
    })

    placeNav(parent, 10);
    placeHelpText(parent);

    $(window).scroll(function(e){
      scrollFunctions(e);
    });

  }


  return {
    initializer: initializer,
    cfg: cfg
  }
})()