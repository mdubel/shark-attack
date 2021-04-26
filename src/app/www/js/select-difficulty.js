$( document ).ready(function() {
  // TODO refactor for something more reliable
  setTimeout(function() {
    document.getElementsByClassName("level-icon--easy")[0].addEventListener("click", function(e) { setLevel('easy') });
    document.getElementsByClassName("level-icon--medium")[0].addEventListener("click", function(e) { setLevel('medium') });
    document.getElementsByClassName("level-icon--hard")[0].addEventListener("click", function(e) { setLevel('hard') });
  }, 2000);
});

function setLevel(level) {
  Shiny.setInputValue("map-level", level);
}
