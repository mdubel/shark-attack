$( document ).ready(function() {
  document.onkeydown = checkKey;
});

function checkKey(e) {
  e = e || window.event;
  var input_id = "map-diver_direction";
  if(diverMove) {
    switch (event.key) {
      case "ArrowLeft":
        Shiny.setInputValue(input_id, 'left');
        break;
      case "ArrowRight":
        Shiny.setInputValue(input_id, 'right');
        break;
      case "ArrowUp":
        Shiny.setInputValue(input_id, 'up');
        break;
      case "ArrowDown":
        Shiny.setInputValue(input_id, 'down');
        break;
    }
  }
}

function randomMove(object_name, object_count) {
  var directions = ['left', 'right', 'up', 'down'];
  var input_id = 'map-' + object_name + '_direction';
  
  diverMove = true;
  sharkIntervalId = setInterval(function() {
    var final_directions = [];
    var random_direction = 0;
    for(i = 0; i < object_count; i++) {
      random_direction = Math.floor((Math.random()*directions.length));
      final_directions[i] = directions[random_direction];
    }
    Shiny.setInputValue(input_id, final_directions);
  }, 500);
}

function stopMove() {
  clearInterval(sharkIntervalId);
  diverMove = false;
}

function cleanObject(object_name) {
  Shiny.setInputValue('map-' + object_name, 'clean');
}
