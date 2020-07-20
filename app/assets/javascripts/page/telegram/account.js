$(document).ready(function() {
  if ($("#waiting-for-telegram-chat-id").length > 0) {
    var poller = new TelegramPoller
    poller.start()
  }
})
