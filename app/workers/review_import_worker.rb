class ReviewImportWorker
  ENPOINT_URL = "https://api.springest.nl/institutes/14360/reviews.json"

  def self.sync!
    stats = {
      updated: 0,
      created: 0,
      synced: 0,
      errored: 0
    }

    results = execute

    if results['reviews']
      results['reviews'].each do |review|
        begin
          review = OpenStruct.new(review)
          if review_exists?(review)
            update(review)
            stats[:updated] += 1
          else
            create(review)
            stats[:created] += 1
          end
        rescue => e
          stats[:errored] += 1
          raise e
        ensure
          stats[:synced] += 1
        end
      end
    end

    puts "Synced #{stats[:synced]} reviews: #{stats[:updated]} updated and #{stats[:created]} newly created."
  end

  def self.update(review)
    current = Review.where(springest_id: review.id).first
    current.update(review_attributes(review))
  end

  def self.create(review)
    Review.create(review_attributes(review))
  end

  def self.review_attributes(review)
    attributes = {
      springest_id: review.id,
      rating: review.rating.to_f,
      body: review.description,
      original_date: review.created_at,
      springest_author: review.author_name
    }

    if student = match_student(review)
      attributes[:student_id] = student.id
    end

    attributes
  end

  def self.review_exists?(review)
    Review.where(springest_id: review.id).count > 0
  end

  def self.match_student(review)
    return if review['author_name'].blank?
    Student.where("UPPER(CONCAT(first_name, ' ', last_name)) = ?", review.author_name.upcase).last
  end

  def self.execute(options = {})
    options = default_options.deep_merge(options)
    puts options
    result = RestClient::Request.execute(options)
    JSON.parse(result)
  end

  private

  def self.default_options
    {
      method: :get,
      url: ENPOINT_URL,
      headers: {
        params: {
          api_key: ENV['SPRINGEST_API_KEY'],
          size: 100
        }
      }
    }
  end

  def self.base_url
    "https://api.springest.nl"
  end

  def method_missing(method_sym, *arguments, &block)
    @attributes.send(method_sym)
  rescue
    super
  end
end
