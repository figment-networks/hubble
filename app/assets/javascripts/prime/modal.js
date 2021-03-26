$(document).ready(function() {
  const openModalButton = document.querySelectorAll('button[data-target]');
  const buttonsClose = document.querySelectorAll('.modal__close');
  const overlay = document.querySelector('.modal-overlay');
  let activeModalId;

  function onClose(modalId) {
    hidePreviousModal(modalId);
    overlay.classList.add('hidden');
  }

  function hidePreviousModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.classList.add('hidden');
  }

  function showNextModal(modalId) {
    const nextModal = document.getElementById(modalId);

    if (activeModalId) hidePreviousModal(activeModalId);
    activeModalId = modalId;
    console.log(activeModalId);
    nextModal.classList.remove('hidden');
    overlay.classList.remove('hidden');
  }

  openModalButton.forEach(function(button) {
    button.addEventListener('click', function() {
      showNextModal(button.dataset.target);
    });
  });

  buttonsClose.forEach(function(button) {
    button.addEventListener('click', function() {
      onClose(activeModalId);
    });
  });

  overlay.addEventListener('click', function() {
    onClose(activeModalId);
  });
});
