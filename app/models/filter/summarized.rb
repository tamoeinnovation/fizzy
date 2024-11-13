module Filter::Summarized
  def summary
    [ index_summary, tag_summary, assignee_summary, assigner_summary, terms_summary ].compact.to_sentence + " #{bucket_summary}"
  end

  def plain_summary
    summary.remove(/<\/?mark>/)
  end

  private
    def index_summary
      "<mark>#{indexed_by.humanize}</mark>"
    end

    def tag_summary
      if tags.any?
        "tagged <mark>#{tags.map(&:hashtag).to_choice_sentence}</mark>"
      end
    end

    def assignee_summary
      if assignees.any?
        "assigned to <mark>#{assignees.pluck(:name).to_choice_sentence}</mark>"
      elsif assignments.unassigned?
        "assigned to no one"
      end
    end

    def assigner_summary
      if assigners.any?
        "assigned by <mark>#{assigners.pluck(:name).to_choice_sentence}</mark>"
      end
    end

    def bucket_summary
      if buckets.any?
        "in <mark>#{buckets.pluck(:name).to_choice_sentence}</mark>"
      else
        "in <mark>all projects</mark>"
      end
    end

    def terms_summary
      if terms.any?
        "matching <mark>#{terms.map { |term| %Q("#{term}") }.to_sentence}</mark>"
      end
    end
end
