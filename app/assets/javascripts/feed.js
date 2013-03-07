// Contains feed item partials as generated using Javascript

TF.Feed = (function(){

  // populates an element with a flickr object
  var popFlickr = function(element, obj){

  }

  // populates an element with a Tumble object
  var popTumble = function(item, div, metaDiv, captionDiv){
    if(item["title"] == null){
      item["title"] = "untitled";
    }
    var content = $("<div></div>")
        .addClass("inner")

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
            .addClass("inner tumble-text")
            .css("width", "50%")
            .css("max-height", TF.TripShow.cfg.winY - 250)
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

  var popTweet = function(element, obj){

  }

  return {
    popFlickr: popFlickr,
    popTumble: popTumble,
    popInstagram: popInstagram,
    popTweet: popTweet
  }
})()