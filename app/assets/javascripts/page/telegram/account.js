$(document).ready(function() {
  if ($('#waiting-for-telegram-chat-id').length > 0) {
    const poller = new TelegramPoller;
    poller.start();
  }
});
