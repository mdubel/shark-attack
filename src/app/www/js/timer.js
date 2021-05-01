function runTimer(time_in_sec) {
  timeIntervalId = setInterval(function() {
    time_in_sec = time_in_sec - 1;
    console.log(time_in_sec);
    if(time_in_sec === 0) {
      Shiny.setInputValue("map-stop_game", true);
      clearInterval(timeIntervalId);
    }
  }, 1000);
}
