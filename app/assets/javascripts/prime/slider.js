$(document).ready(function() {
  const button = document.getElementById('slideForward');
  button.onclick = function() {
    const slider = document.querySelector('.slider');
    sideScroll(slider, 'right', 5, 300, 10);
  };

  const back = document.getElementById('slideBack');
  back.onclick = function() {
    const slider = document.querySelector('.slider');
    sideScroll(slider, 'left', 5, 300, 10);
  };

  function sideScroll(element, direction, speed, distance, step) {
    scrollAmount = 0;
    const slideTimer = setInterval(function() {
      if (direction == 'left') {
        element.scrollLeft -= step;
      } else {
        element.scrollLeft += step;
      }
      scrollAmount += step;
      if (scrollAmount >= distance) {
        window.clearInterval(slideTimer);
      }
    }, speed);
  }
});
