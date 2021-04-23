$( document ).ready(function() {
  console.log( "ready!" );
  document.onkeydown = checkKey;
});

function checkKey(e) {
  e = e || window.event;
  switch (event.key) {
    case "ArrowLeft":
      Shiny.setInputValue('map-move_direction', 'left');
      break;
    case "ArrowRight":
      Shiny.setInputValue('map-move_direction', 'right');
      break;
    case "ArrowUp":
      Shiny.setInputValue('map-move_direction', 'up');
      break;
    case "ArrowDown":
      Shiny.setInputValue('map-move_direction', 'down');
      break;
  }
}

function cleanKey() {
  Shiny.setInputValue('map-move_direction', 'clean');
}
