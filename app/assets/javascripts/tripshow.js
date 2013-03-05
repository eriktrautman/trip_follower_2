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
    pYOff: 100
  }

  // place the item in the document
  var placeItem = function(parent, item, x, y, h, w){
    var div = $("<div>asdfas</div>")
        .addClass("feed_item")
        .attr("data-item-id", item)
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
  }

  var moveToNext = function(item){
    item
        .css("top", cfg.winY - cfg.pYOff - cfg.sH)
        .css("left", cfg.winX - cfg.pXOff - cfg.w/2)
        .css("width", cfg.sW)
        .css("height", cfg.sH)
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

    feedItems.forEach(function(item){
      console.log(item);
      placeItem(parent, item, cfg.winX/2, cfg.winY/2, cfg.h, cfg.w);
    });

    $('div.navbar-inner').click(function(){
      moveToPrev(feedItemDivs[0]);
    });

    $('h1').click(function(){
      moveToNext(feedItemDivs[1]);
    });

  }


  return {
    initializer: initializer
  }
})()