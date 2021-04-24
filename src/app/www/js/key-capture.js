$( document ).ready(function() {
  document.onkeydown = checkKey;
});

function checkKey(e) {
  e = e || window.event;
  var input_id = "map-diver_direction";
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

function randomMove(object_name) {
  var directions = ['left', 'right', 'up', 'down'];
  var input_id = 'map-' + object_name + '_direction';
  setInterval(function() {
    var random_direction = Math.floor((Math.random()*directions.length));
    Shiny.setInputValue(input_id, directions[random_direction]);
  }, 500);
}

function cleanObject(object_name) {
  Shiny.setInputValue('map-' + object_name + '_direction', 'clean');
}
