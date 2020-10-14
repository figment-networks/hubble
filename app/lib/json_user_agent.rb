class JsonUserAgent
  def initialize(string = nil)
    if string.present?
      @ua = UserAgent.parse(string)
    end
  end

  def as_json
    return {} if @ua.nil?

    {
      browser: @ua.browser,
      version: @ua.version.to_s,
      platform: @ua.platform,
      mobile: @ua.mobile?,
      os: @ua.os
    }
  end
end
