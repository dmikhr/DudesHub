require 'open-uri'

class DownloadService
  def self.call(url, mode = :default)
    begin
      mode == :read_by_line ? open(url).readlines : open(url).read
    rescue OpenURI::HTTPError
    end
  end
end
