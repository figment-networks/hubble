$(document).ready(function name(params) {
  const sidebar = document.querySelector('.sidebar');
  const menuButton = document.querySelector('.header__btn');

  menuButton.addEventListener('click', function() {
    sidebar.classList.toggle('active');
    menuButton.classList.toggle('active');
  });
});
