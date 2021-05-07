function runTimer(time_in_sec) {
  timeIntervalId = setInterval(function() {
    time_in_sec = time_in_sec - 1;
    updateTimer(time_in_sec);
    if(time_in_sec === 0) {
      Shiny.setInputValue("stop_game", true);
      clearInterval(timeIntervalId);
    }
  }, 1000);
}

function updateTimer(time_in_sec) {
    minutes_left = Math.floor(time_in_sec/60);
    seconds_left = time_in_sec - 60 * minutes_left;
    if(seconds_left < 10) {
      seconds_left = "0" + seconds_left;
      $('#grid').css('border', '4px solid red');
      $('.ms-Persona-primaryText').css('color', 'red');
      $('.ms-Persona-primaryText').css('font-weight', 'bolder');
    } else {
      $('#grid').css('border', 'none');
      $('.ms-Persona-primaryText').css('color', 'black');
      $('.ms-Persona-primaryText').css('font-weight', 'normal');
    }
    $('.ms-Persona-primaryText').text(minutes_left + ":" + seconds_left);
}

function updateScore(score) {
  $('.ms-Persona-initials > span').text(score);
}
