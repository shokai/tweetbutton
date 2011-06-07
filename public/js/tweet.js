$(function(){
    if(auth) $('div.button#tweet').click(tweet);
    $('a#info').click(function(){
        var detail = $('div#detail');
        if(detail.css('visibility') == 'hidden') detail.css('visibility', 'visible');
        else detail.css('visibility', 'hidden');
    });
});

var tweet = function(){
    return if !message or message.length < 1
    log('');
    var post_data = {message : message};
    $('div#tweet').unbind().addClass('button_disable').html('waiting twitter...');;
    $.post(app_root+'/tweet', post_data, function(res){
        if(res.error != null){
            if(res.response.match("duplicate")) log('tweet failed - your tweet is a duplicate.');
            else log('tweet failed.');
        }
        else{
            log($('<p>').
                append($('<p>').html('success!')).
                append($('<p>').html($('<a>').attr('href','http://twitter.com/'+res.response.user.screen_name+'/status/'+res.response.id_str).html(res.response.user.screen_name+'/status/'+res.response.id_str))).
                append($('<p>').html(res.response.text))
               );
            $('textarea#source').val('');
        }
        $('div#tweet').click(tweet).removeClass('button_disable').html('tweet');
    }, 'json');
};

var log = function(msg){
    $('div#log').html($('<p>').html(msg));
};
