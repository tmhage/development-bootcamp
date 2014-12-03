module SpeakersHelper
  def cache_key_for_speakers
    count          = Speaker.count
    max_updated_at = Speaker.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "speakers/all-#{count}-#{max_updated_at}"
  end
end

