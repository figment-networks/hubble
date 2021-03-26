$(document).ready(function() {
  const buttonsList = document.querySelectorAll('.dropdown__btn');
  const optionsList = document.querySelectorAll('.dropdown__option');

  buttonsList.forEach(function(button) {
    button.addEventListener('click', function() {
      button.classList.toggle('expanded');
    });
  });

  optionsList.forEach(function(option) {
    option.addEventListener('click', function() {
      const selectedItem = option.parentNode;
      const list = selectedItem.parentNode;
      const dropdownButton = list.parentNode.previousSibling.previousElementSibling;

      list.querySelectorAll('.dropdown__item').forEach(function(item) {
        item.classList.remove('hidden');
      });
      selectedItem.classList.add('hidden');

      dropdownButton.innerHTML = '';
      dropdownButton.insertAdjacentHTML('afterbegin', option.innerHTML);
      dropdownButton.classList.toggle('expanded');
    });
  });
});
