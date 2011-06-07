$(function(){
    console.log('start');
    $('input#source').keyup(check_source);
    $('input#source').keydown(check_source);
    $('#content').click(check_source);
    $('div.button#make_btn').click(function(){
        var message = $('input#source').val();
        if(message.length < 1) return
        location.href = app_root+'/t/'+message;
    });
    $('a#info').click(function(){
        var detail = $('div#detail');
        if(detail.css('visibility') == 'hidden') detail.css('visibility', 'visible');
        else detail.css('visibility', 'hidden');
    });
});

var check_source = function(e){
    var message = $('input#source').val();
    var make_btn = $('div.button#make_btn');
    console.log(message);
    if(message.length < 1){
        make_btn.addClass('button_disable');
        return;
    }
    else{
        make_btn.removeClass('button_disable');
        make_btn.html("make "+message+" button");
    }
};

var log = function(msg){
    $('div#log').html($('<p>').html(msg));
};

