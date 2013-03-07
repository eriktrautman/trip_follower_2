// Contains feed item partials as generated using Javascript

TF.Feed = (function(){

  // populates an element with a flickr object
  var popFlickr = function(item, div, metaDiv, captionDiv){

    var content = $("<div></div>")
        .addClass("inner-img")
    var innerContent = $("<a></a>")
        .attr("href", item["url"]);
    var innerPic = $("<img>")
        .attr({
          src: item["url"],
          alt: "flickr image from " + item["blog_name"]
        })
        .css({
          "max-height": TF.TripShow.cfg.winY,
          "max-width": TF.TripShow.cfg.winX,
          "height": "100%"
        })

    innerContent.append(innerPic);
    metaDiv.find("strong").text(item["title"]);
    metaDiv.find("p").text("From " + item["owner"]);
    captionDiv.html(item["caption"]);

    content.append(innerContent);
    div.append(content);
    div.append(metaDiv);
  }

  // populates an element with a Tumble object
  var popTumble = function(item, div, metaDiv, captionDiv){
    if(item["title"] == null){
      item["title"] = "untitled";
    }
    var content = $("<div></div>")
        .addClass("inner")
        .css("width", TF.TripShow.cfg.winX)
        .css("height", TF.TripShow.cfg.winY)
        .css("margin-left", -TF.TripShow.cfg.winX/2)
        .css("margin-top", -TF.TripShow.cfg.winY/6)

    var type = item["type"];
    switch(type){
      case "photo":
        var innerContent = $("<a></a>")
            .attr("href", item["url"]);
        var innerPic = $("<img>")
            .addClass("inner")
            .attr({
              src: item["image_url"],
              alt: "tumble image from " + item["blog_name"]
            })
            .css({
              "max-height": TF.TripShow.cfg.winY,
              "max-width": TF.TripShow.cfg.winX,
              "height": "100%"
            })

        innerContent.append(innerPic);
        metaDiv.find("strong").text("");
        metaDiv.find("p").text("From " + item["blog_name"]);
        captionDiv.html(item["caption"]);

      break;
      case "text":
        var innerContent = $("<div></div>")
            .addClass("tumble-text")
            .css("width", "50%")
            .css("max-height", TF.TripShow.cfg.winY/2.5)
            .html(item["body"]);
        console.log("removing ");
        console.log(captionDiv);
        captionDiv = $("");
        metaDiv.find("strong").text(item["title"]);
        metaDiv.find("p").text("From " + item["blog_name"]);
      break;
      case "quote":

      break;
      case "video":

      break;
      default:

    }
    console.log(item["text"]);
    content.append(innerContent);
    div.append(content);
    div.append(metaDiv);
    div.append(captionDiv);
  }

  var popInstagram = function(element, obj){

  }

  var popTweet = function(item, div, metaDiv, captionDiv){
    console.log(item["oembed"]);

    var content = $("<div></div>")
        .addClass("inner-tweet")
        .css("margin-top", TF.TripShow.cfg.winY/2 - 150);
    var innerTweet = $("<div></div>")
        .html(item["oembed"]);
    metaDiv.find("strong").text("");
    metaDiv.find("p").text("From " + item["username"]);
    content.append(innerTweet);
    div.append(metaDiv);
    div.append(content);
  }

  return {
    popFlickr: popFlickr,
    popTumble: popTumble,
    popInstagram: popInstagram,
    popTweet: popTweet
  }
})()