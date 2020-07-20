class TelegramPoller {
  start() {
    this.getAccountDetails()
    this.startRefreshing()
  }

  getAccountDetails() {
    var poller = this;
    $.ajax({
      url: "/telegram/account.json",
      dataType: "JSON",
      success: function(data) {
        if (data.chat_id) {
          poller.stopRefreshing()
          $("#waiting-for-telegram-chat-id").addClass("d-none")
          $("#connected-to-telegram").removeClass("d-none")
        }
      }
    })
  }

  startRefreshing() {
    this.refreshTimer = setInterval(() => {
      this.getAccountDetails()
    }, 3000)
  }

  stopRefreshing() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }
}
