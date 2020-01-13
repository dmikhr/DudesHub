require 'open-uri'

class DownloadService
  def self.call(url)
    open(url).read
  end
end
